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
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            }
        }).disposed(by: disposeBag)
    }
    
    private func createCallbacks() {
        // Case success
        self.loginViewModel.isSuccess.asObservable()
            .bind { (value) in
                print("Value of binding: \(value)")
        }.disposed(by: disposeBag)
        
        // Case failed
        self.loginViewModel.errorMessage.asObservable()
            .bind { (errorMessage) in
                print("Error with: \(errorMessage ?? "no error")")
        }.disposed(by: disposeBag)
    }
}

