//
//  Colors.swift
//  MyFlow
//  Created by Nate Tedesco on 10/20/21.
//

import SwiftUI

extension Color {
    static func rgb(r: Double, g: Double, b: Double ) -> Color {
        return Color(red: r / 255, green: g / 255, blue: b / 255)
    }
    
//    static let backGround = Color(#colorLiteral(red: 0.08312948793, green: 0.1055833921, blue: 0.1202623174, alpha: 1))
    static let darkBackground = Color(#colorLiteral(red: 0.05882352941, green: 0.07058823529, blue: 0.08235294118, alpha: 1))

    
    static let myBlue = Color(#colorLiteral(red: 0, green: 0.8217858727, blue: 1, alpha: 1))
    
    static let myWhite = Color(#colorLiteral(red: 0.9805082071, green: 0.9805082071, blue: 0.9805082071, alpha: 1))
    static let lightGray = Color(#colorLiteral(red: 0.6688070893, green: 0.6787589192, blue: 0.6785841584, alpha: 1))
//    static let darkGray = Color(#colorLiteral(red: 0.2666666667, green: 0.2745098039, blue: 0.2784313725, alpha: 1))

}
