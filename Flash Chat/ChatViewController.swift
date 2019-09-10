//
//  ViewController.swift
//  Flash Chat
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var messageArray : [Message] = [Message]()
    var senderPic : String = ""

    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self
        
        messageTableView.separatorStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        messageTableView.register(UINib(nibName: "NewTableViewCell", bundle: nil), forCellReuseIdentifier: "newMessageCell")
        configureTableView()
        
        retrieveMessages()
    }

    //MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newMessageCell", for: indexPath) as! NewTableViewCell
        
        cell.messageTextLabel.text = messageArray[indexPath.row].messageBody
        cell.senderLabel.text = messageArray[indexPath.row].sender
        // Set cell avatar based on message sent by currently logged in user or other users
        cell.avatarView.image = UIImage(named: (Auth.auth().currentUser?.email as String? == messageArray[indexPath.row].sender) ? "AvatarMe" : "AvatarOthers")
        
        return cell
    }
    
    //MARK: - Done editing text
    @objc func tableViewTapped() {
        // Resigns first responder and resets heightConstraint
        messageTextfield.endEditing(true)
    }
    
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    //MARK:- TextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.21) {
            self.heightConstraint.constant = 280
            self.view.layoutIfNeeded()
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.21) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }

    //MARK: - Send & Recieve from Firebase
    //Send the message to Firebase and save it in our database
    @IBAction func sendPressed(_ sender: AnyObject) {
        // Resigns first responder
        messageTextfield.endEditing(true)
        // Prevents from editing the message field and press the send button
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        // Save message in DB
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text!]
        messagesDB.childByAutoId().setValue(messageDictionary) { (error, reference) in
            if error != nil {
                let alert = Alerts.showProblemAlert(withTitle: error!.localizedDescription)
                self.present(alert!, animated: true, completion: nil)
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
            } else {
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
    }
    
    func retrieveMessages() {
        // Reference to messages in DB
        let messageDB = Database.database().reference().child("Messages")
        // Listener for new message added, returns a snapshot of all the messages
        // The block is called for each message stored and for every new message added
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            // Create a new message object
            var message = Message()
            message.messageBody = text
            message.sender = sender
            // Append message and reload table view
            self.messageArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    
    //MARK:- Log out
    @IBAction func logOutPressed(_ sender: AnyObject) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch let error {
            let alert = Alerts.showProblemAlert(withTitle: error.localizedDescription)
            self.present(alert!, animated: true, completion: nil)
        }
    }
}
