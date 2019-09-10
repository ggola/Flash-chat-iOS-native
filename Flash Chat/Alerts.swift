//
//  Alerts.swift
//  Flash Chat
//
//  Created by Giulio Gola on 10/09/2019.
//

import Foundation
import UIKit

class Alerts {
    
    static func showProblemAlert(withTitle title: String?) -> UIAlertController? {
        guard let titleAlert = title else {return nil}
        let alert = UIAlertController(title: titleAlert, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        return alert
    }
    
}
