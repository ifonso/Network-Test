//
//  MockAccessTokenProvider.swift
//  CocoacastsTests
//
//  Created by Afonso Lucas on 17/12/23.
//

import Foundation
@testable import Cocoacasts

struct MockAccessTokenProvider: AccessTokenProvider {
    
    let accessToken: String?
}
