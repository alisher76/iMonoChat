//
//  ChannelCell.swift
//  iMonoChat
//
//  Created by Alisher Abdukarimov on 8/11/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var channelLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    
    func configureCell(channel: Channel) {
        let title = channel.title ?? ""
        channelLabel.text = "#\(title)"
        channelLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        for id in MessageService.instace.unreadChannels {
            if id == channel.id {
                channelLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            }
        }
        
    }

}
