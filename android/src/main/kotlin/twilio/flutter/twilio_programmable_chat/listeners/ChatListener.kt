package twilio.flutter.twilio_programmable_chat.listeners

import com.twilio.conversations.*
import io.flutter.plugin.common.EventChannel
import twilio.flutter.twilio_programmable_chat.Mapper
import twilio.flutter.twilio_programmable_chat.TwilioProgrammableChatPlugin

class ChatListener(val properties: ConversationsClient.Properties) : ConversationsClientListener {
    var events: EventChannel.EventSink? = null

//    override fun onAddedToChannelNotification(channelSid: String) {
//        TwilioProgrammableChatPlugin.debug("ChatListener.onAddedToChannelNotification => channelSid = $channelSid")
//        sendEvent("addedToChannelNotification", mapOf("channelSid" to channelSid))
//    }
//
//    override fun onChannelAdded(channel: Conversation) {
//        TwilioProgrammableChatPlugin.debug("ChatListener.onChannelAdded => sid = ${channel.sid}")
//        sendEvent("channelAdded", mapOf("channel" to Mapper.channelToMap(channel)))
//    }
//
//    override fun onChannelDeleted(channel: Conversation) {
//        TwilioProgrammableChatPlugin.debug("ChatListener.onChannelDeleted => sid = ${channel.sid}")
//        sendEvent("channelDeleted", mapOf("channel" to Mapper.channelToMap(channel)))
//    }
//
//    override fun onChannelInvited(channel: Conversation) {
//        TwilioProgrammableChatPlugin.debug("ChatListener.onChannelInvited => sid = ${channel.sid}")
//        sendEvent("channelInvited", mapOf("channel" to Mapper.channelToMap(channel)))
//    }
//
//    override fun onChannelJoined(channel: Conversation) {
//        TwilioProgrammableChatPlugin.debug("ChatListener.onChannelJoined => sid = ${channel.sid}")
//        sendEvent("channelJoined", mapOf("channel" to Mapper.channelToMap(channel)))
//    }
//
//    override fun onChannelSynchronizationChange(channel: Conversation) {
//        TwilioProgrammableChatPlugin.debug("ChatListener.onChannelSynchronizationChange => sid = ${channel.sid}")
//        sendEvent("channelSynchronizationChange", mapOf("channel" to Mapper.channelToMap(channel)))
//    }
//
//    override fun onChannelUpdated(channel: Conversation, reason: Conversation.UpdateReason) {
//        TwilioProgrammableChatPlugin.debug("ChatListener.onChannelUpdated => channel '${channel.sid}' updated, $reason")
//        sendEvent("channelUpdated", mapOf(
//                "channel" to Mapper.channelToMap(channel),
//                "reason" to mapOf(
//                    "type" to "channel",
//                    "value" to reason.toString()
//                )
//        ))
//    }

    override fun onClientSynchronization(synchronizationStatus: ConversationsClient.SynchronizationStatus) {
        TwilioProgrammableChatPlugin.debug("ChatListener.onClientSynchronization => status = $synchronizationStatus")
        sendEvent("clientSynchronization", mapOf("synchronizationStatus" to synchronizationStatus.toString()))
    }

    override fun onConversationSynchronizationChange(conversation: Conversation?) {
        TODO("Not yet implemented")
    }

    override fun onConnectionStateChange(connectionState: ConversationsClient.ConnectionState) {
        TwilioProgrammableChatPlugin.debug("ChatListener.onConnectionStateChange => status = $connectionState")
        sendEvent("connectionStateChange", mapOf("connectionState" to connectionState.toString()))
    }

    override fun onError(errorInfo: ErrorInfo) {
        sendEvent("error", null, errorInfo)
    }

//    override fun onInvitedToChannelNotification(channelSid: String) {
//        TwilioProgrammableChatPlugin.debug("ChatListener.onInvitedToChannelNotification => channelSid = $channelSid")
//        sendEvent("invitedToChannelNotification", mapOf("channelSid" to channelSid))
//    }

    override fun onNewMessageNotification(channelSid: String?, messageSid: String?, messageIndex: Long) {
        TwilioProgrammableChatPlugin.debug("ChatListener.onNewMessageNotification => channelSid = $channelSid, messageSid = $messageSid, messageIndex = $messageIndex")
        sendEvent("newMessageNotification", mapOf(
                "channelSid" to channelSid,
                "messageSid" to messageSid,
                "messageIndex" to messageIndex
        ))
    }

    override fun onAddedToConversationNotification(conversationSid: String?) {
        TODO("Not yet implemented")
    }

    override fun onNotificationSubscribed() {
        TwilioProgrammableChatPlugin.debug("ChatListener.onNotificationSubscribed")
        sendEvent("notificationSubscribed", null)
    }

    override fun onNotificationFailed(errorInfo: ErrorInfo) {
        sendEvent("notificationFailed", null, errorInfo)
    }

//    override fun onRemovedFromChannelNotification(channelSid: String) {
//        TwilioProgrammableChatPlugin.debug("ChatListener.onRemovedFromChannelNotification => channelSid = $channelSid")
//        sendEvent("removedFromChannelNotification", mapOf("channelSid" to channelSid))
//    }

    override fun onTokenAboutToExpire() {
        TwilioProgrammableChatPlugin.debug("ChatListener.onTokenAboutToExpire")
        sendEvent("tokenAboutToExpire", null)
    }

    override fun onTokenExpired() {
        TwilioProgrammableChatPlugin.debug("ChatListener.onTokenExpired")
        sendEvent("tokenExpired", null)
    }

    override fun onUserSubscribed(user: User) {
        TwilioProgrammableChatPlugin.debug("ChatListener.onUserSubscribed => user '${user.friendlyName}'")
        sendEvent("userSubscribed", mapOf("user" to Mapper.userToMap(user)))
    }

    override fun onUserUnsubscribed(user: User) {
        TwilioProgrammableChatPlugin.debug("ChatListener.onUserUnsubscribed => user '${user.friendlyName}'")
        sendEvent("userUnsubscribed", mapOf("user" to Mapper.userToMap(user)))
    }

    override fun onConversationUpdated(conversation: Conversation?, reason: Conversation.UpdateReason?) {
        TODO("Not yet implemented")
    }

    override fun onConversationAdded(conversation: Conversation?) {
        TODO("Not yet implemented")
    }

    override fun onUserUpdated(user: User, reason: User.UpdateReason) {
        TwilioProgrammableChatPlugin.debug("ChatListener.onUserUpdated => user '${user.friendlyName}' updated, $reason")
        sendEvent("userUpdated", mapOf(
                "user" to Mapper.userToMap(user),
                "reason" to mapOf(
                        "type" to "user",
                        "value" to reason.toString()
                )
        ))
    }

    override fun onConversationDeleted(conversation: Conversation?) {
        TODO("Not yet implemented")
    }

    override fun onRemovedFromConversationNotification(conversationSid: String?) {
        TODO("Not yet implemented")
    }

    private fun sendEvent(name: String, data: Any?, e: ErrorInfo? = null) {
        val eventData = mapOf("name" to name, "data" to data, "error" to Mapper.errorInfoToMap(e))
        events?.success(eventData)
    }
}
