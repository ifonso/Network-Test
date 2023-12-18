//
//  HTTPStubsDescriptor+Helpers.swift
//  CocoacastsTests
//
//  Created by Afonso Lucas on 17/12/23.
//

import OHHTTPStubs
import OHHTTPStubsSwift

extension HTTPStubsDescriptor {
    
    func store(in stubsDescriptors: inout [HTTPStubsDescriptor]) {
        stubsDescriptors.append(self)
    }
}
