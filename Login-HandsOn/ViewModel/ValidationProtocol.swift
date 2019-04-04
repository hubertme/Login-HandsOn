//
//  ValidationViewModel.swift
//  Login-HandsOn
//
//  Created by Hubert Wang on 04/04/2019.
//  Copyright © 2019 Hubert Wang. All rights reserved.
//

import Foundation
import RxSwift

protocol ValidationProtocol {
    var errorMessage: String { get }
    
    // Observables
    var data: Variable<String> { get set }
    var errorValue: Variable<String?> { get }
    
    // Validation
    func validateCredentials() -> Bool
}
