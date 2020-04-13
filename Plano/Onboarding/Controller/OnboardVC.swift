//
//  ViewController.swift
//  Plano
//
//  Created by Hafizul Ihsan Fadli on 06/04/20.
//  Copyright © 2020 Mini Challenge 1 - Group 7. All rights reserved.
//

import UIKit
import AuthenticationServices

class OnboardVC: UIViewController {
    
    @IBOutlet weak var signInWithAppleStackView: UIStackView!
    @IBOutlet weak var welcomeToPlanoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProviderLoginView()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performExistingAccountSetupFlows()
    }
    
    
    // MARK: - Customizations
    
    func customWelcomeLabel() {
        let string: String = "Welcome to Pláno"
        let mutableString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: .bold)])
        
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 38.0 / 255.0, green: 176.0 / 255.0, blue: 235.0 / 255.0, alpha: 1), range: NSRange(location:11, length:5))
        welcomeToPlanoLabel.attributedText = mutableString
    }
    
    
    // MARK: - IBAction
    
    @IBAction func skipButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Sign In with Apple Functions
    
    /// - Tag: add_appleid_button
    func setupProviderLoginView() {
        let isDarkTheme = view.traitCollection.userInterfaceStyle == .dark
        let style: ASAuthorizationAppleIDButton.Style = isDarkTheme ? .white : .black
        
        let authorizationButton = ASAuthorizationAppleIDButton(type: .default, style: style)
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        
        let heightConstraint = authorizationButton.heightAnchor.constraint(equalToConstant: 44)
        authorizationButton.addConstraint(heightConstraint)
        
        self.signInWithAppleStackView.addArrangedSubview(authorizationButton)
    }
        
    // - Tag: perform_appleid_password_request
    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
            
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
        
    /// - Tag: perform_appleid_request
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}


// MARK: - Extensions

extension OnboardVC: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        switch authorization.credential {
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//
//            // Create an account in your system.
//            let userIdentifier = appleIDCredential.user
//            let givenName = appleIDCredential.fullName?.givenName
//            let birthName = appleIDCredential.fullName?.familyName
//            let email = appleIDCredential.email
//
//            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
////            self.saveUserInKeychain(userIdentifier)
////            self.saveGivenNameInKeychain(givenName!)
////            self.saveBirthNameInKeychain(birthName!)
////            self.saveEmailInKeychain(email!)
//
//            KeychainItem.currentUserIdentifier = userIdentifier
//            KeychainItem.currentUserGivenName = givenName
//            KeychainItem.currentUserBirthName = birthName
//            KeychainItem.currentUserEmail = email
//
//            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
//            /* self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email) */
//            self.dismiss(animated: true, completion: nil)
//
//        case let passwordCredential as ASPasswordCredential:
//
//            // Sign in using an existing iCloud Keychain credential.
//            let username = passwordCredential.user
//            let password = passwordCredential.password
//
//            // For the purpose of this demo app, show the password credential as an alert.
//            DispatchQueue.main.async {
//                self.showPasswordCredentialAlert(username: username, password: password)
//            }
//
//        default:
//            break
//        }
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                
                // Create an account in your system.
                // For the purpose of this demo app, store the these details in the keychain.
                KeychainItem.currentUserIdentifier = appleIDCredential.user
                KeychainItem.currentUserGivenName = appleIDCredential.fullName?.givenName
                KeychainItem.currentUserBirthName = appleIDCredential.fullName?.familyName
                KeychainItem.currentUserEmail = appleIDCredential.email
                
                print("User Id - \(appleIDCredential.user)")
                print("User Name - \(appleIDCredential.fullName?.description ?? "N/A")")
                print("User Email - \(appleIDCredential.email ?? "N/A")")
                print("Real User Status - \(appleIDCredential.realUserStatus.rawValue)")
                
                if let identityTokenData = appleIDCredential.identityToken,
                    let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                    print("Identity Token \(identityTokenString)")
                }
                
                //Show Home View Controller
                self.dismiss(animated: true, completion: nil)
            } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
                // Sign in using an existing iCloud Keychain credential.
                let username = passwordCredential.user
                let password = passwordCredential.password
                
                // For the purpose of this demo app, show the password credential as an alert.
                DispatchQueue.main.async {
                    let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
                    let alertController = UIAlertController(title: "Keychain Credential Received",
                                                            message: message,
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "MC1-G7.Plano", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    private func saveGivenNameInKeychain(_ givenName: String) {
        do {
            try KeychainItem(service: "MC1-G7.Plano", account: "givenName").saveItem(givenName)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    private func saveBirthNameInKeychain(_ birthName: String) {
        do {
            try KeychainItem(service: "MC1-G7.Plano", account: "birthName").saveItem(birthName)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    private func saveEmailInKeychain(_ email: String) {
        do {
            try KeychainItem(service: "MC1-G7.Plano", account: "email").saveItem(email)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
        
    /* private func showResultViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
        guard (self.presentingViewController as? UITabBarController) != nil
            else { return }
            
        DispatchQueue.main.async {
            viewController.userIdentifierLabel.text = userIdentifier
            if let givenName = fullName?.givenName {
                viewController.givenNameLabel.text = givenName
            }
            if let familyName = fullName?.familyName {
                viewController.familyNameLabel.text = familyName
            }
            if let email = email {
                viewController.emailLabel.text = email
            }
            self.dismiss(animated: true, completion: nil)
        }
    } */
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
        
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        /* let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil) */
    }
}

extension OnboardVC: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension UIViewController {        
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let onboardVC = storyboard.instantiateViewController(withIdentifier: "onboardVC") as? OnboardVC {
            onboardVC.modalPresentationStyle = .formSheet
            onboardVC.isModalInPresentation = true
            self.present(onboardVC, animated: true, completion: nil)
        }
    }
}
