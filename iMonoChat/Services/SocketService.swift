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
    
}

