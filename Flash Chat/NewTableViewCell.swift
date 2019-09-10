//
//  NewTableViewCell.swift
//  Flash Chat
//
//  Created by Giulio Gola on 11.04.19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class NewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageBackground: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellView()
    }
    
    func setupCellView() {
        avatarView.layer.cornerRadius = avatarView.frame.height / 2
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.layer.borderWidth = 1
        avatarView.backgroundColor = UIColor.flatGray()?.withAlphaComponent(0.2)
        
        senderLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 11)
        
        messageTextLabel.font = UIFont(name: "ArialNarrow", size: 12)
        
        messageBackground.backgroundColor = UIColor.white
        messageBackground.layer.borderWidth = 1
        messageBackground.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        messageBackground.layer.cornerRadius = 12
    }
}
