//
//  SocketService.swift
//  iMonoChat
//
//  Created by Alisher Abdukarimov on 8/12/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    // Create socket
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!)
    
    // MARK: Establish conncetion - called in Appdelegate
    
    func establishConnection() {
        socket.connect()
    }
    
    // MARK: Close Connection - called in Appdelegate
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, comletion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription)
        comletion(true)
    }
    
    // Listening for the event
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(title: channelName, description: channelDesc, id: channelId)
            MessageService.instace.channels.append(newChannel)
            completion(true)
        }
    }
    
    // MARK: Send Message
    
    func sendMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    // MARK: Listen to
    
    func getChatMessage(completion: @escaping (_ typingUsers: Message) -> Void) {
        socket.on("messageCreated") { (dataArray, ack) in
            guard let messageBody = dataArray[0] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let userName = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
            guard let messageId = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            
            let newMessage = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: messageId, timeStamp: timeStamp)
            completion(newMessage)
        }
    }
    
    func getUsersTyping(_ completionHandler: @escaping (_ typingUsers: [String:String]) -> Void) {
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String:String] else { return }
            completionHandler(typingUsers)
        }
    }
}

