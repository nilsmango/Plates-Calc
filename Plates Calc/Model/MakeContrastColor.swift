//
//  ContrastColor.swift
//  Plates Calc
//
//  Created by Simon Lang on 04.03.2025.
//

import SwiftUI

func makeContrastColor(for color: Color) -> Color {
    let uiColor = UIColor(color)
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
    uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    // Calculate luminance (perceived brightness)
    let luminance = 0.299 * red + 0.587 * green + 0.114 * blue
    
    return luminance > 0.7 ? .black : .white
}
