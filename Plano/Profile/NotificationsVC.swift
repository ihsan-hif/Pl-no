//
//  NotificationsVC.swift
//  Plano
//
//  Created by Hafizul Ihsan Fadli on 13/04/20.
//  Copyright © 2020 Mini Challenge 1 - Group 7. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController {

    @IBOutlet weak var viewListNotifications: UIView!
    @IBOutlet weak var btnOutletNotifications: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewListNotifications.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnActionNotifications(_ sender: Any) {
        switch viewListNotifications.isHidden {
        case true:
            viewListNotifications.isHidden = false
            
            btnOutletNotifications.setTitle("    Disable Notifications", for: .normal)
            btnOutletNotifications.setTitleColor(.systemRed, for: .normal)
        case false:
            viewListNotifications.isHidden = true
            
            btnOutletNotifications.setTitle("    Enable Notifications", for: .normal)
            btnOutletNotifications.setTitleColor(.systemBlue, for: .normal)
        }
        
        viewListNotifications.isHidden = false
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
