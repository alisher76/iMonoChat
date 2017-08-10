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
    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)) , for: .touchUpInside)
        // slide to open
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // tap to close 
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
        
        MessageService.instace.findAllChannel { (success) in
            if success {
                print("SUCCESS")
            }
        }
        
    }

    
}
