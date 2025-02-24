//
//  FreeWeights.swift
//  Plates Calc
//
//  Created by Simon Lang on 23.02.2025.
//

import Foundation
import SwiftUICore

/// Complete inventory of bars, plates and the configurations
struct Inventory: Codable {
    var bars: [Bar]
    var plates: [Plate]
    var configurations: [Bar]
    var appUnit: Unit
    
    init() {
        bars = []
        plates = []
        configurations = []
        appUnit = .kg
    }
}

/// Inventory of plates
struct Plate: Hashable, Codable {
    let id: UUID
    let weight: Double
    let unit: Unit
    var color: Color
    var maxAmount: Int?
}

/// Inventory of bars
struct Bar: Codable {
    let id: UUID
    let kind: ConfigKind
    var name: String
    let weight: Double
    let unit: Unit
    var color: Color
    var maxAmount: Int?
    var weights: [Plate:Int]
}

enum ConfigKind: String, Codable, CaseIterable {
    case bar, kettlebell
    
    var displayName: String {
        switch self {
        case .bar:
            return "Bar (weights on each side)"
        case .kettlebell:
            return "Kettlebell (one weight only)"
        }
    }
}

enum Unit: String, Codable, CaseIterable {
    case kg, lb
}
