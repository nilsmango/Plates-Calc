//
//  WeightView.swift
//  Plates Calc
//
//  Created by Simon Lang on 24.02.2025.
//

import SwiftUI

struct WeightView: View {
    let weight: Double
    let unit: Unit
    var body: some View {
        Text("\(weight, specifier: "%.2f") \(unit.rawValue)")
            .font(.largeTitle)
            .fontWeight(.bold)
    }
}

#Preview {
    WeightView(weight: 2310.22, unit: .kg)
}
