//
// Copyright 2022 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import GRDB

// NOTE: This file is generated by /Scripts/sds_codegen/sds_generate.py.
// Do not manually edit it, instead run `sds_codegen.sh`.

// MARK: - Typed Convenience Methods

@objc
public extension OWSGroupCallMessage {
    // NOTE: This method will fail if the object has unexpected type.
    class func anyFetchGroupCallMessage(
        uniqueId: String,
        transaction: SDSAnyReadTransaction
    ) -> OWSGroupCallMessage? {
        assert(!uniqueId.isEmpty)

        guard let object = anyFetch(uniqueId: uniqueId,
                                    transaction: transaction) else {
                                        return nil
        }
        guard let instance = object as? OWSGroupCallMessage else {
            owsFailDebug("Object has unexpected type: \(type(of: object))")
            return nil
        }
        return instance
    }

    // NOTE: This method will fail if the object has unexpected type.
    func anyUpdateGroupCallMessage(transaction: SDSAnyWriteTransaction, block: (OWSGroupCallMessage) -> Void) {
        anyUpdate(transaction: transaction) { (object) in
            guard let instance = object as? OWSGroupCallMessage else {
                owsFailDebug("Object has unexpected type: \(type(of: object))")
                return
            }
            block(instance)
        }
    }
}

// MARK: - SDSSerializer

// The SDSSerializer protocol specifies how to insert and update the
// row that corresponds to this model.
class OWSGroupCallMessageSerializer: SDSSerializer {

    private let model: OWSGroupCallMessage
    public init(model: OWSGroupCallMessage) {
        self.model = model
    }

    // MARK: - Record

    func asRecord() throws -> SDSRecord {
        let id: Int64? = model.sortId > 0 ? Int64(model.sortId) : model.grdbId?.int64Value

        let recordType: SDSRecordType = .groupCallMessage
        let uniqueId: String = model.uniqueId

        // Properties
        let receivedAtTimestamp: UInt64 = model.receivedAtTimestamp
        let timestamp: UInt64 = model.timestamp
        let threadUniqueId: String = model.uniqueThreadId
        let attachmentIds: Data? = nil
        let authorId: String? = nil
        let authorPhoneNumber: String? = nil
        let authorUUID: String? = nil
        let body: String? = nil
        let callType: RPRecentCallType? = nil
        let configurationDurationSeconds: UInt32? = nil
        let configurationIsEnabled: Bool? = nil
        let contactShare: Data? = nil
        let createdByRemoteName: String? = nil
        let createdInExistingGroup: Bool? = nil
        let customMessage: String? = nil
        let envelopeData: Data? = nil
        let errorType: TSErrorMessageType? = nil
        let expireStartedAt: UInt64? = nil
        let expiresAt: UInt64? = nil
        let expiresInSeconds: UInt32? = nil
        let groupMetaMessage: TSGroupMetaMessage? = nil
        let hasLegacyMessageState: Bool? = nil
        let hasSyncedTranscript: Bool? = nil
        let wasNotCreatedLocally: Bool? = nil
        let isLocalChange: Bool? = nil
        let isViewOnceComplete: Bool? = nil
        let isViewOnceMessage: Bool? = nil
        let isVoiceMessage: Bool? = nil
        let legacyMessageState: TSOutgoingMessageState? = nil
        let legacyWasDelivered: Bool? = nil
        let linkPreview: Data? = nil
        let messageId: String? = nil
        let messageSticker: Data? = nil
        let messageType: TSInfoMessageType? = nil
        let mostRecentFailureText: String? = nil
        let preKeyBundle: Data? = nil
        let protocolVersion: UInt? = nil
        let quotedMessage: Data? = nil
        let read: Bool? = model.wasRead
        let recipientAddress: Data? = nil
        let recipientAddressStates: Data? = nil
        let sender: Data? = nil
        let serverTimestamp: UInt64? = nil
        let deprecated_sourceDeviceId: UInt32? = nil
        let storedMessageState: TSOutgoingMessageState? = nil
        let storedShouldStartExpireTimer: Bool? = nil
        let unregisteredAddress: Data? = nil
        let verificationState: OWSVerificationState? = nil
        let wasReceivedByUD: Bool? = nil
        let infoMessageUserInfo: Data? = nil
        let wasRemotelyDeleted: Bool? = nil
        let bodyRanges: Data? = nil
        let offerType: TSRecentCallOfferType? = nil
        let serverDeliveryTimestamp: UInt64? = nil
        let eraId: String? = model.eraId
        let hasEnded: Bool? = model.hasEnded
        let creatorUuid: String? = model.creatorUuid
        let joinedMemberUuids: Data? = optionalArchive(model.joinedMemberUuids)
        let wasIdentityVerified: Bool? = nil
        let paymentCancellation: Data? = nil
        let paymentNotification: Data? = nil
        let paymentRequest: Data? = nil
        let viewed: Bool? = nil
        let serverGuid: String? = nil
        let storyAuthorUuidString: String? = nil
        let storyTimestamp: UInt64? = nil
        let isGroupStoryReply: Bool? = nil
        let storyReactionEmoji: String? = nil
        let giftBadge: Data? = nil
        let editState: TSEditState? = nil
        let archivedPaymentInfo: Data? = nil

        return InteractionRecord(delegate: model, id: id, recordType: recordType, uniqueId: uniqueId, receivedAtTimestamp: receivedAtTimestamp, timestamp: timestamp, threadUniqueId: threadUniqueId, attachmentIds: attachmentIds, authorId: authorId, authorPhoneNumber: authorPhoneNumber, authorUUID: authorUUID, body: body, callType: callType, configurationDurationSeconds: configurationDurationSeconds, configurationIsEnabled: configurationIsEnabled, contactShare: contactShare, createdByRemoteName: createdByRemoteName, createdInExistingGroup: createdInExistingGroup, customMessage: customMessage, envelopeData: envelopeData, errorType: errorType, expireStartedAt: expireStartedAt, expiresAt: expiresAt, expiresInSeconds: expiresInSeconds, groupMetaMessage: groupMetaMessage, hasLegacyMessageState: hasLegacyMessageState, hasSyncedTranscript: hasSyncedTranscript, wasNotCreatedLocally: wasNotCreatedLocally, isLocalChange: isLocalChange, isViewOnceComplete: isViewOnceComplete, isViewOnceMessage: isViewOnceMessage, isVoiceMessage: isVoiceMessage, legacyMessageState: legacyMessageState, legacyWasDelivered: legacyWasDelivered, linkPreview: linkPreview, messageId: messageId, messageSticker: messageSticker, messageType: messageType, mostRecentFailureText: mostRecentFailureText, preKeyBundle: preKeyBundle, protocolVersion: protocolVersion, quotedMessage: quotedMessage, read: read, recipientAddress: recipientAddress, recipientAddressStates: recipientAddressStates, sender: sender, serverTimestamp: serverTimestamp, deprecated_sourceDeviceId: deprecated_sourceDeviceId, storedMessageState: storedMessageState, storedShouldStartExpireTimer: storedShouldStartExpireTimer, unregisteredAddress: unregisteredAddress, verificationState: verificationState, wasReceivedByUD: wasReceivedByUD, infoMessageUserInfo: infoMessageUserInfo, wasRemotelyDeleted: wasRemotelyDeleted, bodyRanges: bodyRanges, offerType: offerType, serverDeliveryTimestamp: serverDeliveryTimestamp, eraId: eraId, hasEnded: hasEnded, creatorUuid: creatorUuid, joinedMemberUuids: joinedMemberUuids, wasIdentityVerified: wasIdentityVerified, paymentCancellation: paymentCancellation, paymentNotification: paymentNotification, paymentRequest: paymentRequest, viewed: viewed, serverGuid: serverGuid, storyAuthorUuidString: storyAuthorUuidString, storyTimestamp: storyTimestamp, isGroupStoryReply: isGroupStoryReply, storyReactionEmoji: storyReactionEmoji, giftBadge: giftBadge, editState: editState, archivedPaymentInfo: archivedPaymentInfo)
    }
}
