import Flutter
import Foundation
import TwilioChatClient

public class MemberMethods {
    public static func getUserDescriptor(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let channelSid = arguments["channelSid"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelSid' parameter", details: nil))
        }

        guard let identity = arguments["identity"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'identity' parameter", details: nil))
        }

        let flutterResult = result
        SwiftTwilioProgrammableChatPlugin.chatListener?.chatClient?.channelsList()?.channel(
            withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHChannel?) in
                if result.isSuccessful(), let channel = channel {
                    SwiftTwilioProgrammableChatPlugin.debug("MemberMethods.getUserDescriptor => onSuccess")
                    if let member = channel.member(withIdentity: identity) {
                        member.userDescriptor { (result: TCHResult, user: TCHUserDescriptor?) in
                            if result.isSuccessful(), let user = user {
                                flutterResult(Mapper.userDescriptorToDict(user))
                            } else {
                                flutterResult(FlutterError(
                                    code: "ERROR",
                                    message: "Error retrieving userDescriptor for member (identity: " +
                                    "'\(identity)') from channel (sid: \(channelSid)", details: nil))
                            }
                        }
                    } else {
                        flutterResult(FlutterError(code: "ERROR",
                                                   message: "Error retrieving member with identity '\(identity)'",
                            details: nil))
                    }
                } else {
                    SwiftTwilioProgrammableChatPlugin.debug(
                        "MemberMethods.getUserDescriptor => onError: \(String(describing: result.error))")
                    flutterResult(FlutterError(
                        code: "ERROR", message: "Error retrieving channel with sid '\(channelSid)'", details: nil))
                }
        })
    }

    public static func getAndSubscribeUser(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let channelSid = arguments["channelSid"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelSid' parameter", details: nil))
        }

        guard let memberSid = arguments["memberSid"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'memberSid' parameter", details: nil))
        }

        let flutterResult = result
        SwiftTwilioProgrammableChatPlugin.chatListener?.chatClient?.channelsList()?.channel(
            withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHChannel?) in
                if result.isSuccessful(), let channel = channel {
                    SwiftTwilioProgrammableChatPlugin.debug("MemberMethods.getAndSubscribeUser => onSuccess")
                    if let member = channel.member(withIdentity: memberSid) {
                        member.userDescriptor { (result: TCHResult, user: TCHUserDescriptor?) in
                            if result.isSuccessful(), let user = user {
                                user.subscribe { (result: TCHResult, user: TCHUser?) in
                                    if result.isSuccessful(), let user = user {
                                        flutterResult(Mapper.userToDict(user))
                                    } else {
                                        flutterResult(FlutterError(code: "ERROR",
                                            message: "Error subscribing to user with sid '\(memberSid)'",
                                            details: nil))
                                    }
                                }
                            } else {
                                flutterResult(FlutterError(code: "ERROR",
                                    message: "Error retrieving userDescriptor for member sid '\(memberSid)'",
                                    details: nil))
                            }
                        }
                    } else {
                        flutterResult(FlutterError(code: "ERROR",
                            message: "Error retrieving member with sid '\(memberSid)' " +
                            "from channel with sid \(channelSid)",
                            details: nil))
                    }
                } else {
                    if let error = result.error as NSError? {
                        SwiftTwilioProgrammableChatPlugin.debug(
                            "MemberMethods.getAndSubscribeUser => onError: \(error)")
                        flutterResult(FlutterError(code: "ERROR",
                            message: "Error retrieving channel with sid or uniqueName '\(channelSid)'",
                            details: nil))
                    }
                }
        })
    }

    public static func setAttributes(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }

        guard let channelSid = arguments["channelSid"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelSid' parameter", details: nil))
        }

        guard let memberSid = arguments["memberSid"] as? String else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'memberSid' parameter", details: nil))
        }

        guard let attributesDict = arguments["attributes"] as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'attributes' parameter", details: nil))
        }

        let attributes = TCHJsonAttributes.init(dictionary: attributesDict as [AnyHashable: Any])

        let flutterResult = result
        SwiftTwilioProgrammableChatPlugin.chatListener?.chatClient?.channelsList()?.channel(
            withSidOrUniqueName: channelSid, completion: { (result: TCHResult, channel: TCHChannel?) in
                if result.isSuccessful(), let channel = channel {
                    SwiftTwilioProgrammableChatPlugin.debug("MemberMethods.setAttributes => onSuccess")
                    if let member = channel.member(withIdentity: memberSid) {
                        member.setAttributes(attributes) { (result: TCHResult) in
                            if result.isSuccessful() {
                                SwiftTwilioProgrammableChatPlugin.debug(
                                    "MemberMethods.setAttributes (Member.setAttributes) => onSuccess")
                                flutterResult(Mapper.attributesToDict(attributes))
                            } else {
                                SwiftTwilioProgrammableChatPlugin.debug(
                                    "MemberMethods.setAttributes (Member.setAttributes) => " +
                                    "onError: \(String(describing: result.error))")
                                flutterResult(FlutterError(code: "ERROR",
                                    message: "Error setting attributes for member with sid " +
                                    "'\(memberSid)'", details: nil))
                            }
                        }
                    }
                    flutterResult(Mapper.channelToDict(channel))
                } else {
                    if let error = result.error as NSError? {
                        SwiftTwilioProgrammableChatPlugin.debug("MemberMethods.setAttributes => onError: \(error)")
                        flutterResult(FlutterError(code: "ERROR",
                            message: "Error retrieving channel with sid or uniqueName '\(channelSid)'", details: nil))
                    }
                }
        })
    }
}
