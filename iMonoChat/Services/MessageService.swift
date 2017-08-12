//
//  MessageService.swift
//  iMonoChat
//
//  Created by Alisher Abdukarimov on 8/10/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instace = MessageService()
    
    var channels = [Channel]()
    var selectedChannel: Channel?
    
    var messages = [Message]()
    
    func findAllChannel(completion: @escaping CompletionHandler) {
        request(URL_GET_CHANNEL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (responce) in
            if responce.result.error == nil {
                guard let data = responce.data else { return }
                if let json = JSON(data: data).array {
                    
                    for item in json {
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(title: name, description: channelDescription, id: id)
                        self.channels.append(channel)
                    }
                    
                NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                completion(true)
                }
            } else {
                completion(false)
                debugPrint(responce.result.error as Any)
            }
        }
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
        request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (responce) in
            if responce.result.error == nil {
                self.clearMessages()
                guard let data = responce.data else { return }
                if let json = JSON(data: data).array {
                    for item in json {
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                        self.messages.append(message)
                    }
                    print(self.messages)
                    completion(true)
                }
            } else {
                debugPrint(responce.result.error as Any)
                completion(false)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
}
