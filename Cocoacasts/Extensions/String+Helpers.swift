//
//  String+Helpers.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 16/12/23.
//

import Foundation

extension String {

    private static let emailPredicate: NSPredicate = {
        let username = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let domain = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}[A-Za-z]{2,8}"
        return NSPredicate(format: "SELF MATCHES %@", username + "@" + domain)
    }()

    var isEmail: Bool {
        Self.emailPredicate.evaluate(with: self)
    }
}
