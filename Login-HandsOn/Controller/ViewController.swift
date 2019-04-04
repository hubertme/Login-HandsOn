//
//  ViewController.swift
//  Login-HandsOn
//
//  Created by Hubert Wang on 04/04/2019.
//  Copyright © 2019 Hubert Wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation

class ViewController: UIViewController {
    
    // MARK: - Attributes
    let loginViewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var credentialLabel: UILabel!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupElements()
        self.bindViewModels()
        self.createCallbacks()
    }
    
    // MARK: - Methods
    private func bindViewModels() {
        self.emailTextField.rx.text.orEmpty
            .bind(to: self.loginViewModel.emailViewModel.data)
            .disposed(by: self.disposeBag)
        
        self.passwordTextField.rx.text.orEmpty
            .bind(to: self.loginViewModel.passwordViewModel.data)
            .disposed(by: self.disposeBag)
        
        self.loginButton.rx.tap.do(onNext: { [unowned self] in
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
        }).subscribe(onNext: { [unowned self] in
            if self.loginViewModel.validateCredentials() {
                self.loginViewModel.loginUser()
            } else if !(self.loginViewModel.emailViewModel.validateCredentials()) {
                self.loginViewModel.errorMessage.value = self.loginViewModel.emailViewModel.errorMessage
            } else if !(self.loginViewModel.passwordViewModel.validateCredentials()) {
                self.loginViewModel.errorMessage.value = self.loginViewModel.passwordViewModel.errorMessage
            }
            
            self.createCallbacks()
        }).disposed(by: disposeBag)
    }
    
    private func createCallbacks() {
        // Case success
        self.loginViewModel.isSuccess.asObservable()
            .bind { (value) in
                if value == true {
                    self.credentialLabel.text = "Attempted login with\n\nEmail: \(self.loginViewModel.model.email)\nPassword: \(self.loginViewModel.model.password)"
                    UIView.animate(withDuration: 2, animations: {
                        self.credentialLabel.alpha = 1
                    })
                }
        }.disposed(by: disposeBag)
        
        // Case failed
        self.loginViewModel.errorMessage.asObservable()
            .bind { (errorMessage) in
                print("Error with: \(errorMessage ?? "no error")")
                if let errorMessage = errorMessage {
                    self.credentialLabel.text = ""
                    UIView.animate(withDuration: 2, animations: {
                        self.credentialLabel.alpha = 0
                    })
                    
                    let alertController = UIAlertController(title: "Failed to sign in", message: "\(errorMessage)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok!", style: .cancel, handler: { (_) in
                        
                        if errorMessage == self.loginViewModel.emailViewModel.errorMessage {
                            self.emailTextField.text = ""
                            self.emailTextField.becomeFirstResponder()
                        } else if errorMessage == self.loginViewModel.passwordViewModel.errorMessage {
                            self.passwordTextField.text = ""
                            self.passwordTextField.becomeFirstResponder()
                        }
                        
                        // Reset all
                        self.loginViewModel.model.email = ""
                        self.loginViewModel.model.password = ""
                        self.loginViewModel.isSuccess.value = false
                    })
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
        }.disposed(by: disposeBag)
    }
    
    private func setupElements() {
        self.credentialLabel.alpha = 0
    }
}

