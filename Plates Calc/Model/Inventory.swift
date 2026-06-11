//
//  FreeWeights.swift
//  Plates Calc
//
//  Created by Simon Lang on 23.02.2025.
//

import Foundation
import SwiftUI

/// Complete inventory of bars, plates and the configurations
struct Inventory: Codable {
    var plates: [Plate]
    var configurations: [Bar]
    var appUnit: Unit
    
    init() {
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
struct Bar: Hashable, Codable {
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
    case dumbbell, barbell, kettlebell
    
    var displayName: String {
        switch self {
        case .dumbbell:
            return "Dumbbell"
        case .barbell:
            return "Barbell"
        case .kettlebell:
            return "Kettlebell (one weight only)"
        }
    }
}

enum Unit: String, Codable, CaseIterable {
    case kg, lb
}

extension Double {
    var cleanWeight: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 10
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? "\(self)"
    }
}
