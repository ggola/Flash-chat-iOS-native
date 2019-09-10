//
//  LogInViewController.swift
//  Flash Chat
//

import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil {
                SVProgressHUD.dismiss()
                let alert = Alerts.showProblemAlert(withTitle: error?.localizedDescription)
                if alert != nil {
                    self.present(alert!, animated: true, completion: nil)
                }
            }
            else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
    
}  
