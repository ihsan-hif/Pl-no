//
//  ProfileVC.swift
//  Plano
//
//  Created by Rayhan Martiza Faluda on 08/04/20.
//  Copyright © 2020 Mini Challenge 1 - Group 7. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func teamMemberButton(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "teamMembersVC") as! UITableViewController
        self.show(vc, sender: nil)
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
