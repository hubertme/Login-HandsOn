//
//  EmailViewModel.swift
//  Login-HandsOn
//
//  Created by Hubert Wang on 04/04/2019.
//  Copyright © 2019 Hubert Wang. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class EmailViewModel: ValidationProtocol {
    
    // MARK: - Attributes
    var errorMessage: String {
        get {
            return "Please enter a valid email format"
        }
    }
    var data: Variable<String> = Variable("")
    var errorValue: Variable<String?> = Variable(nil)
    
    // MARK: - Methods
    func validateCredentials() -> Bool {
        guard validatePattern(email: data.value) else {
            errorValue.value = errorMessage
            return false
        }
        
        errorValue.value = nil
        return true
    }
    
    private func validatePattern(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format: "SELF MATCEHS %@", emailRegEx)
        return emailTest.evaluate(with: emailTest)
    }
}
