//
//  StatusCode+Helpers.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 18/12/23.
//

import Foundation

extension StatusCode {
    
    var isSuccess: Bool {
        (200..<300).contains(self)
    }
}
