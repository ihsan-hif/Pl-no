//
//  LandingVC.swift
//  Plano
//
//  Created by Rayhan Martiza Faluda on 07/04/20.
//  Copyright © 2020 Mini Challenge 1 - Group 7. All rights reserved.
//

import UIKit
import AuthenticationServices

class LandingVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Check if user is signed in or not
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier ?? "") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                /* DispatchQueue.main.async {
                    self.pushTo(viewController: .home)
                } */
                
                break // The Apple ID credential is valid.
            case .revoked, .notFound:
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                DispatchQueue.main.async {
                    self.pushTo(viewController: .welcome)
                }
            default:
                break
            }
        }
    }
    
    //MARK: Push to relevant ViewController
    func pushTo(viewController: ViewControllerType)  {
        switch viewController {
        case .home:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        case .welcome:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "onboardVC") as! OnboardVC
            vc.modalPresentationStyle = .formSheet
            vc.isModalInPresentation = true
            self.present(vc, animated: true, completion: nil)
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
