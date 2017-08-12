//
//  AddChannelVC.swift
//  iMonoChat
//
//  Created by Alisher Abdukarimov on 8/12/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    
    
    // Outlets
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }

    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        guard let channelName = nameTxtField.text , nameTxtField.text != "" else {
            return
        }
        guard let channelDescription = descriptionTextField.text else { return }
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDescription) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setupView() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
        nameTxtField.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor : monoPurplePlaceholder])
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor : monoPurplePlaceholder])
    }
    
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
