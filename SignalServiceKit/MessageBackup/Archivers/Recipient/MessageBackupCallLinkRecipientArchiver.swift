//
// Copyright 2024 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

import SignalRingRTC

public class MessageBackupCallLinkRecipientArchiver: MessageBackupProtoArchiver {
    typealias RecipientAppId = MessageBackup.RecipientArchivingContext.Address
    typealias ArchiveMultiFrameResult = MessageBackup.ArchiveMultiFrameResult<RecipientAppId>
    private typealias ArchiveFrameError = MessageBackup.ArchiveFrameError<RecipientAppId>
    typealias RecipientId = MessageBackup.RecipientId
    typealias RestoreFrameResult = MessageBackup.RestoreFrameResult<RecipientId>
    private typealias RestoreFrameError = MessageBackup.RestoreFrameError<RecipientId>

    private let callLinkStore: CallLinkRecordStore

    init(
        callLinkStore: CallLinkRecordStore
    ) {
        self.callLinkStore = callLinkStore
    }

    func archiveAllCallLinkRecipients(
        stream: MessageBackupProtoOutputStream,
        context: MessageBackup.RecipientArchivingContext
    ) -> ArchiveMultiFrameResult {
        var errors = [ArchiveFrameError]()
        do {
            let callLinkRecords = try self.callLinkStore.fetchAll(tx: context.tx)
            callLinkRecords.forEach { record in
                var callLink = BackupProto_CallLink()
                callLink.rootKey = record.rootKey.bytes
                if let adminPasskey = record.adminPasskey {
                    // If there is no adminPasskey on the record, then the
                    // local user is not the call admin, and we leave this
                    // field blank on the proto.
                    callLink.adminKey = adminPasskey
                }
                if let name = record.name {
                    // If the default name is being used, just leave the field blank.
                    callLink.name = name
                }
                callLink.restrictions = { () -> BackupProto_CallLink.Restrictions in
                    if let restrictions = record.restrictions {
                        switch restrictions {
                        case .none: return .none
                        case .adminApproval: return .adminApproval
                        }
                    } else {
                        return .unknown
                    }
                }()

                let callLinkAppId: RecipientAppId = .callLink(record.id)
                if let expiration = record.expiration {
                    // Lacking an expiration is a valid state. It can occur 1) if we hadn't
                    // yet fetched the expiration from the server at the time of backup, or
                    // 2) if someone deletes a call link before we're able to fetch the
                    // expiration.
                    callLink.expirationMs = UInt64(expiration)
                }

                let recipientId = context.assignRecipientId(to: callLinkAppId)
                Self.writeFrameToStream(
                    stream,
                    objectId: .callLink(record.id)
                ) {
                    var recipient = BackupProto_Recipient()
                    recipient.id = recipientId.value
                    recipient.destination = .callLink(callLink)
                    var frame = BackupProto_Frame()
                    frame.item = .recipient(recipient)
                    return frame
                }.map { errors.append($0) }
            }
        } catch {
            return .completeFailure(.fatalArchiveError(.callLinkRecordIteratorError(error)))
        }

        if errors.isEmpty {
            return .success
        } else {
            return .partialSuccess(errors)
        }
    }

    func restoreCallLinkRecipientProto(
        _ callLinkProto: BackupProto_CallLink,
        recipient: BackupProto_Recipient,
        context: MessageBackup.RecipientRestoringContext
    ) -> RestoreFrameResult {
        func restoreFrameError(
            _ error: RestoreFrameError.ErrorType,
            line: UInt = #line
        ) -> RestoreFrameResult {
            return .failure([.restoreFrameError(error, recipient.recipientId, line: line)])
        }

        let rootKey: CallLinkRootKey
        do {
            rootKey = try CallLinkRootKey(callLinkProto.rootKey)
        } catch {
            return .failure([.restoreFrameError(.invalidProtoData(.callLinkInvalidRootKey), recipient.recipientId)])
        }

        let adminKey: Data?
        if callLinkProto.hasAdminKey {
            adminKey = callLinkProto.adminKey
        } else {
            // If the proto lacks an admin key, it means the local user
            // is not the admin of the call link.
            adminKey = nil
        }

        var partialErrors = [MessageBackup.RestoreFrameError<RecipientId>]()

        let restrictions: CallLinkRecord.Restrictions
        switch callLinkProto.restrictions {
        case .adminApproval:
            restrictions = .adminApproval
        case .none:
            restrictions = .none
        case .unknown:
            partialErrors.append(.restoreFrameError(.invalidProtoData(.callLinkRestrictionsUnknownType), recipient.recipientId))
            restrictions = .adminApproval
        case .UNRECOGNIZED:
            partialErrors.append(.restoreFrameError(.invalidProtoData(.callLinkRestrictionsUnrecognizedType), recipient.recipientId))
            restrictions = .adminApproval
        }

        do {
            _ = try callLinkStore.insertFromBackup(
                rootKey: rootKey,
                adminPasskey: adminKey,
                name: callLinkProto.name,
                restrictions: restrictions,
                expiration: callLinkProto.expirationMs,
                tx: context.tx
            )
        } catch {
            return .failure([.restoreFrameError(.databaseInsertionFailed(error), recipient.recipientId)])
        }

        if partialErrors.isEmpty {
            return .success
        } else {
            return .partialRestore(partialErrors)
        }
    }
}