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
            print("Button tapped!")
        }).subscribe(onNext: { [unowned self] in
            if self.loginViewModel.validateCredentials() {
                self.loginViewModel.loginUser()
                self.credentialLabel.text = "Attempted login with\n\nEmail: \(self.loginViewModel.model.email)\nPassword: \(self.loginViewModel.model.password)"
                UIView.animate(withDuration: 2, animations: {
                    self.credentialLabel.alpha = 1
                })
            } else {
                self.credentialLabel.text = ""
                UIView.animate(withDuration: 2, animations: {
                    self.credentialLabel.alpha = 0
                })
            }
        }).disposed(by: disposeBag)
    }
    
    private func createCallbacks() {
        // Case success
        self.loginViewModel.isSuccess.asObservable()
            .bind { (value) in
                print("Callbacks when success")
        }.disposed(by: disposeBag)
        
        // Case failed
        self.loginViewModel.errorMessage.asObservable()
            .bind { (errorMessage) in
                print("Error with: \(errorMessage ?? "no error")")
        }.disposed(by: disposeBag)
    }
    
    private func setupElements() {
        self.credentialLabel.alpha = 0
    }
}

