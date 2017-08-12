//
//  MessageCell.swift
//  iMonoChat
//
//  Created by Alisher Abdukarimov on 8/12/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var userImage: CircleImage!
    
    @IBOutlet weak var messageBodyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(message: Message) {
        messageBodyLabel.text = message.message
        userNameLabel.text = message.userName
        userImage.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        userImage.image = UIImage(named: message.userAvatar)
    }

}
