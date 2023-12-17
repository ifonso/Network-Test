//
//  CloudinaryURLBuilder.swift
//  Cocoacasts
//
//  Created by Afonso Lucas on 17/12/23.
//

import UIKit

final class CloudinaryURLBuilder {

    private let source: URL

    private var width: Int?
    private var height: Int?

    init(source: URL) {
        self.source = source
    }

    // MARK: - Public API

    func width(_ width: Int) -> CloudinaryURLBuilder {
        self.width = width
        return self
    }

    func height(_ height: Int) -> CloudinaryURLBuilder {
        self.height = height
        return self
    }

    func build() -> URL {
        var parameters: [String] = []
        var url = Environment.cloudinaryBaseUrl

        if let width = width {
            parameters.append("w_\(width)")
        }

        if let height = height {
            parameters.append("h_\(height)")
        }

        // Define Format
        parameters.append("f_png")

        // Define Device Pixel Ratio
        let dpr = String(format: "%1.1f", UIScreen.main.scale)
        parameters.append("dpr_\(dpr)")

        // Append Parameters
        if !parameters.isEmpty {
            let parametersAsString = parameters.joined(separator: ",")
            url = url.appendingPathComponent(parametersAsString)
        }

        return url.appendingPathComponent(source.absoluteString)
    }
}

