//
//  ProfileVC.swift
//  Plano
//
//  Created by Rayhan Martiza Faluda on 08/04/20.
//  Copyright © 2020 Mini Challenge 1 - Group 7. All rights reserved.
//

import UIKit
import AuthenticationServices

class ProfileVC: UIViewController {

    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var signInSignOutButtonOutlet: UIButton!
    @IBOutlet weak var signInSignOutLabelOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if KeychainItem.currentUserIdentifier != nil {
            profileName.text = KeychainItem.currentUserGivenName ?? "Your Name"
            signInSignOutButtonOutlet.isHidden = true
            signInSignOutLabelOutlet.isHidden = true
        }
        else {
            profileName.text = "Your Name"
            self.signInSignOutLabelOutlet.text = "Sign In"
            self.signInSignOutLabelOutlet.textColor = .systemBlue
        }
    }
    
    
    // MARK: - IBAction
    
    @IBAction func teamMemberButton(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "teamMembersVC") as! UITableViewController
        self.show(vc, sender: nil)
    }
    
    @IBAction func signInSignOutButtonAction(_ sender: UIButton) {
        KeychainItem.currentUserIdentifier = nil
        KeychainItem.currentUserGivenName = nil
        KeychainItem.currentUserBirthName = nil
        KeychainItem.currentUserEmail = nil
        // Display the login controller again.
        DispatchQueue.main.async {
            self.showLoginViewController()
            self.signInSignOutLabelOutlet.text = "Sign In"
            self.signInSignOutLabelOutlet.textColor = .systemBlue
        }
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
