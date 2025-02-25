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
    let isDumbbell: Bool
    var body: some View {
        VStack {
            Text("\(weight, specifier: "%.1f") \(unit.rawValue)")
                .font(.largeTitle)
                .fontWeight(.bold)
            if isDumbbell {
                Text("Two: \(weight*2, specifier: "%.1f") \(unit.rawValue)")
            }
        }
        
    }
}

#Preview {
    WeightView(weight: 2310.255, unit: .kg, isDumbbell: true)
}
