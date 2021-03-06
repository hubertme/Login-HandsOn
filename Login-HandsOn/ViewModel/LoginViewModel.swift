//
//  LoginViewModel.swift
//  Login-HandsOn
//
//  Created by Hubert Wang on 04/04/2019.
//  Copyright © 2019 Hubert Wang. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class LoginViewModel {
    
    // MARK: - Attributes
    let model: LoginModel = LoginModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Binding attributes
    let isSuccess: Variable<Bool> = Variable(false)
    let isLoading: Variable<Bool> = Variable(false)
    let errorMessage: Variable<String?> = Variable(nil)
    
    // MARK: - View models
    let emailViewModel = EmailViewModel()
    let passwordViewModel = PasswordViewModel()
    
    // MARK: - Methods
    func validateCredentials() -> Bool {
        return emailViewModel.validateCredentials() && passwordViewModel.validateCredentials()
    }
    
    func loginUser() {
        // Initialised model with loaded value
        model.email = emailViewModel.data.value
        model.password = passwordViewModel.data.value
        
        self.isLoading.value = true
        
        // Do all server request here
        print("Login attempted with email: \(model.email) pass: \(model.password)!")
        self.isSuccess.value = true
        self.errorMessage.value = nil
    }
    
}
