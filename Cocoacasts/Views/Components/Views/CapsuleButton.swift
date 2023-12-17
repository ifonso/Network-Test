//
//  CapsuleButton.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 17/12/23.
//

import SwiftUI

struct CapsuleButton: View {

    let title: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
        }
        .frame(height: 44.0)
        .buttonBorderShape(.capsule)
        .buttonStyle(.borderedProminent)
        .tint(Color("red"))
    }
}

struct CapsuleButton_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleButton(title: "This is the title.", action: {} )
    }
}
