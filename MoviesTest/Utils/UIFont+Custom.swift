//
//  UIFont+Custom.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 15/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import UIKit

enum CustomFont: String {
    case openSansRegular = "OpenSans-Regular"
    case openSansBold = "OpenSans-Bold"
    case openSansSemiBoldItalic = "OpenSans-SemiBoldItalic"
    case openSansExtraBoldItalic = "OpenSans-ExtraBoldItalic"
    case openSansLightItalic = "OpenSans-LightItalic"
    case openSansBoldItalic = "OpenSans-BoldItalic"
    case openSansLight = "OpenSans-Light"
    case openSansSemiBold = "OpenSans-SemiBold"
    case openSansItalic = "OpenSans-Italic"
    case openSansExtraBold = "OpenSans-ExtraBold"
    case pacificoRegular = "Pacifico-Regular"
}

extension UIFont {
    convenience init(customFont: CustomFont, size: CGFloat) {
        self.init(name: customFont.rawValue, size: size)!
    }
    
    static func printAllFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
}
