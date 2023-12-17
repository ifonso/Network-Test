//
//  VideoDurationFormatter.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 17/12/23.
//

import Foundation

final class VideoDurationFormatter: DateComponentsFormatter {

    override init() {
        super.init()

        unitsStyle = .positional
        allowedUnits = [.minute, .second]
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        unitsStyle = .positional
        allowedUnits = [.minute, .second]
    }
}
