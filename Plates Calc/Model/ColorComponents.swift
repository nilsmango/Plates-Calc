//
//  ColorComponents.swift
//  Plates Calc
//
//  Created by Simon Lang on 24.02.2025.
//import SwiftUI

import SwiftUICore
import UIKit

extension Color: Codable {
    struct Components {
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
        var alpha: CGFloat
    }
    
    enum CodingKeys: String, CodingKey {
        case red
        case green
        case blue
        case alpha
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(CGFloat.self, forKey: .red)
        let green = try container.decode(CGFloat.self, forKey: .green)
        let blue = try container.decode(CGFloat.self, forKey: .blue)
        let alpha = try container.decode(CGFloat.self, forKey: .alpha)
        
        self.init(Components(red: red, green: green, blue: blue, alpha: alpha))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        var components = Components(red: 0, green: 0, blue: 0, alpha: 0)
        UIColor(self).getRed(&components.red,
                            green: &components.green,
                            blue: &components.blue,
                            alpha: &components.alpha)
        
        try container.encode(components.red, forKey: .red)
        try container.encode(components.green, forKey: .green)
        try container.encode(components.blue, forKey: .blue)
        try container.encode(components.alpha, forKey: .alpha)
    }
    
    private init(_ components: Components) {
        self.init(red: components.red,
                 green: components.green,
                 blue: components.blue,
                 opacity: components.alpha)
    }
}
