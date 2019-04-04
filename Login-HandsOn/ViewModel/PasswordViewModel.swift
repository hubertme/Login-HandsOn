//
//  PasswordViewModel.swift
//  Login-HandsOn
//
//  Created by Hubert Wang on 04/04/2019.
//  Copyright © 2019 Hubert Wang. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class PasswordViewModel: ValidationProtocol {
    
    // MARK: - Attributes
    var errorMessage: String {
        get {
            return "Please enter a valid password of length 6 until 20"
        }
    }
    var data: Variable<String> = Variable("")
    var errorValue: Variable<String?> = Variable(nil)
    
    // MARK: - Methods
    func validateCredentials() -> Bool {
        guard validateLength(text: data.value, size: (6, 20)) else {
            errorValue.value = errorMessage
            return false
        }
        
        errorValue.value = nil
        return true
    }
    
    private func validateLength(text: String, size: (min: Int, max: Int)) -> Bool {
        return (size.min ... size.max).contains(text.count)
    }
}
