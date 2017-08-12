//
//  ChatVC.swift
//  iMonoChat
//
//  Created by Alisher Abdukarimov on 8/9/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var sendButtonOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    
    
    // Variables
    var isTyping: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        view.bindToKeyboard()
        sendButtonOutlet.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)) , for: .touchUpInside)
        // slide to open
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // tap to close 
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        SocketService.instance.getChatMessage { (success) in
            if success {
                self.tableView.reloadData()
                
                if MessageService.instace.messages.count > 0 {
                    let endexPath = IndexPath(row: MessageService.instace.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: endexPath, at: .bottom, animated: false)
                }
            }
        }
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            channelNameLabel.text = "Please Log In"
            tableView.reloadData()
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instace.selectedChannel?.title ?? ""
        channelNameLabel.text = "#\(channelName)"
        getMessages()
    }
    
    // Send Button
    @IBAction func sendButtonTapped(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instace.selectedChannel?.id else {
                return
            }
            guard let message = messageTextField.text else { return }
            SocketService.instance.sendMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                if success {
                    print("message sent")
                    self.messageTextField.text = ""
                    self.messageTextField.resignFirstResponder()
                }
            })
        }
    }
    
    
    // MARK: Message text field configure
    
    @IBAction func messageBoxTyping(_ sender: Any) {
        if messageTextField.text == "" {
            isTyping = false
            sendButtonOutlet.isHidden = true
        } else {
            if isTyping == false {
                sendButtonOutlet.isHidden = false
            }
            isTyping = true
        }
    }
    
    // MARKD: Get Messages
    func onLoginGetMessages() {
        MessageService.instace.findAllChannel { (success) in
            if success {
                // To Do: Channels
                if MessageService.instace.channels.count > 0 {
                    MessageService.instace.selectedChannel = MessageService.instace.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLabel.text = "no channels yet"
                }
            }
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func getMessages() {
        guard let channelId = MessageService.instace.selectedChannel?.id else {
            return
        }
        MessageService.instace.findAllMessagesForChannel(channelId: channelId) { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instace.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MESSAGE_CELL, for: indexPath) as? MessageCell {
            cell.configureCell(message: MessageService.instace.messages[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
}
