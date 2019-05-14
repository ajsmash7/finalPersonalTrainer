//
//  AlertViewController.swift
//  iOSPersonalTrainer
//
//  Created by AJMac on 5/7/19.
//  Copyright © 2019 AJMac. All rights reserved.
//
// Borrowed From Clara

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message:String) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        let alertOKAction = UIAlertAction(title: "OK", style: .default, handler:nil)
        alert.addAction(alertOKAction)
        present(alert, animated: true)
    }
}
