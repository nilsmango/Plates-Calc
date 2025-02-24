//
//  ConfigView.swift
//  Plates Calc
//
//  Created by Simon Lang on 24.02.2025.
//

import SwiftUI

struct ConfigView: View {
    let config: Bar?
    let screenWidth = UIScreen.main.bounds.width
    let widthRatioBarbell = 0.9
    let widthRatioDumbbell = 0.6
    let heightRatio = 0.05
    
    private var barWidth: CGFloat {
        screenWidth * widthRatioDumbbell
    }
    
    private var plateSpacing: CGFloat {
        screenWidth * 0.01
    }
    
    private func plateWidth(for weight: Double) -> CGFloat {
        // Scale plate width based on weight
        let baseWidth = screenWidth * 0.03
        return baseWidth * (weight / 2.5) // 2.5 as baseline weight
    }
    
    var body: some View {
        if let config = config {
            ZStack {
                if config.kind == .kettlebell {
                    // Kettlebell implementation
                    VStack(spacing: -screenWidth * 0.1) {
                        // Handle
                        RoundedRectangle(cornerRadius: screenWidth * 0.02)
                            .fill(config.color)
                            .frame(width: screenWidth * 0.2, height: screenWidth * 0.1)
                        
                        // Bell
                        Circle()
                            .fill(config.color)
                            .frame(width: screenWidth * 0.3, height: screenWidth * 0.3)
                    }
                } else {
                    // Bar
                    Rectangle()
                        .fill(config.color)
                        .frame(width: barWidth, height: screenWidth * heightRatio)
                    
                    // Plates
                    HStack(spacing: plateSpacing) {
                        // Left plates
                        HStack(spacing: plateSpacing) {
                            ForEach(Array(config.weights.keys), id: \.id) { plate in
                                ForEach(0..<((config.weights[plate] ?? 0) / 2)) { _ in
                                    Rectangle()
                                        .fill(plate.color)
                                        .frame(width: plateWidth(for: plate.weight), height: screenWidth * 0.15)
                                }
                            }
                        }
                        
                        Spacer()
                            .frame(width: barWidth)
                        
                        // Right plates (mirrored)
                        HStack(spacing: plateSpacing) {
                            ForEach(Array(config.weights.keys), id: \.id) { plate in
                                ForEach(0..<((config.weights[plate] ?? 0) / 2)) { _ in
                                    Rectangle()
                                        .fill(plate.color)
                                        .frame(width: plateWidth(for: plate.weight), height: screenWidth * 0.15)
                                }
                            }
                        }
                        .rotationEffect(Angle(degrees: 180), anchor: .center)
                    }
                }
            }
        } else {
            Text("Add a Bar to see it here.")
        }
    }
}

#Preview {
    ConfigView(config: Bar(id: UUID(), kind: .bar, name: "Ironmaster", weight: 3.2, unit: .kg, color: .gray, weights: [Plate(id: UUID(), weight: 5, unit: .lb, color: .black) : 2, Plate(id: UUID(), weight: 2, unit: .lb, color: .black) : 2]))
}
