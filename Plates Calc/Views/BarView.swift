//
//  BarView.swift
//  Plates Calc
//
//  Created by Simon Lang on 25.02.2025.
//

import SwiftUI

struct BarView: View {
    let config: Bar
    let screenWidth = UIScreen.main.bounds.width / 2
    let widthRatioBarbell = 0.9
    let widthRatioDumbbell = 0.2
    let heightRatio = 0.05
    let plateCornerRadius: Double
    
    @State private var scaleRatio = 1.0
    
    private var barWidth: CGFloat {
        screenWidth * widthRatioDumbbell
    }
    
    private var plateSpacing: CGFloat {
        2
    }
    
    private func plateWidth(for weight: Double) -> CGFloat {
        // Get all unique weights and sort them
        let allWeights = config.weights.filter { $0.value > 0 }.map { $0.key.weight }.sorted()
        
        guard !allWeights.isEmpty else { return screenWidth * 0.03 }
        
        // Find the index of the current weight
        guard let weightIndex = allWeights.firstIndex(of: weight) else {
            return screenWidth * 0.03
        }
        
        let minWidth = screenWidth * 0.03
        let maxSideWidth = screenWidth - (barWidth * 2)
        
        // Calculate total plates width for one side (including spacing)
        var totalPlatesWidth: CGFloat = 0
        for plate in config.weights.keys {
            let plateCount = (config.weights[plate] ?? 0) / 2  // Plates per side
            if plateCount > 0 {
                totalPlatesWidth += CGFloat(plateCount) * minWidth + CGFloat(plateCount - 1) * plateSpacing
            }
        }
        
        // If we have only one weight type, use more of the available space
        if allWeights.count == 1 {
            let maxWidth = max(minWidth, maxSideWidth / CGFloat(config.weights.values.first! / 2))
            return min(maxWidth, minWidth * 1.5)
        }
        
        // Calculate scaling factor based on available space
        let availableWidth = maxSideWidth
        let scalingFactor = min(1.3, availableWidth / totalPlatesWidth)
        
        // Create width multiplier based on weight index (lightest = 1x, each heavier = up to 2x)
        let multiplier = 1.0 + (Double(weightIndex) / Double(allWeights.count - 1))
        
        // Apply scaling while respecting constraints
        let scaledWidth = minWidth * CGFloat(multiplier) * scalingFactor
        
        return max(scaledWidth, minWidth)
    }
    
    var body: some View {
        ZStack {
            if config.kind == .kettlebell {
                // Kettlebell implementation
                VStack(spacing: plateSpacing * 2) {
                    // Handle
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(config.color)
                            .stroke(config.color == .black || config.color == .white ? makeContrastColor(for: config.color) : .clear, lineWidth: 1)
                                    .frame(width: screenWidth * 0.17, height: screenWidth * 0.19)
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.background)
                            .stroke(config.color == .black || config.color == .white ? makeContrastColor(for: config.color) : .clear, lineWidth: 1)
                                    .frame(width: screenWidth * 0.11, height: screenWidth * 0.13)
                    }
                    
                    
                    // Bell
                    VStack(spacing: plateSpacing) {
                        ForEach(Array(config.weights.keys), id: \.id) { plate in
                            ForEach(0..<((config.weights[plate] ?? 0)), id: \.self) { _ in
                                RoundedRectangle(cornerRadius: plateCornerRadius)
                                    .fill(plate.color)
                                    .stroke(plate.color == .black || plate.color == .white ? makeContrastColor(for: plate.color) : .clear, lineWidth: 1)
                                    .frame(width: screenWidth * 0.3, height: plateWidth(for: plate.weight))
                            }
                        }
                    }
                }
            } else {
                Group {
                    // Bar
                    RoundedRectangle(cornerRadius: plateCornerRadius/2)
                        .fill(config.color)
                        .stroke(config.color == .black || config.color == .white ? makeContrastColor(for: config.color) : .clear, lineWidth: 1)
                        .frame(width: barWidth, height: screenWidth * heightRatio)
                    
                    // Plates
                    HStack(spacing: plateSpacing * 2) {
                        // Left plates
                        HStack(spacing: plateSpacing) {
                            ForEach(Array(config.weights.keys), id: \.id) { plate in
                                ForEach(0..<((config.weights[plate] ?? 0) / 2), id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: plateCornerRadius)
                                        .fill(plate.color)
                                        .stroke(plate.color == .black || plate.color == .white ? makeContrastColor(for: plate.color) : .clear, lineWidth: 1)
                                        .frame(width: plateWidth(for: plate.weight), height: screenWidth * 0.3)
                                }
                            }
                        }
                        
                        Spacer()
                            .frame(width: barWidth)
                        
                        // Right plates (mirrored)
                        HStack(spacing: plateSpacing) {
                            ForEach(Array(config.weights.keys), id: \.id) { plate in
                                ForEach(0..<((config.weights[plate] ?? 0) / 2), id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: plateCornerRadius)
                                        .fill(plate.color)
                                        .stroke(plate.color == .black || plate.color == .white ? makeContrastColor(for: plate.color) : .clear, lineWidth: 1)
                                        .frame(width: plateWidth(for: plate.weight), height: screenWidth * 0.3)
                                }
                            }
                        }
                        .rotationEffect(Angle(degrees: 180), anchor: .center)
                    }
                    .frame(height: screenWidth * 0.3)
                }
                .scaleEffect(x: scaleRatio, y: 1, anchor: .center)
                .background {
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(.clear)
                            .onAppear {
                                if geometry.size.width > screenWidth * 2.0 * 0.9 {
                                    scaleRatio = (screenWidth * 2.0 * 0.9) / geometry.size.width
                                }
                            }
                            .onChange(of: geometry.size.width) {
                                if geometry.size.width > screenWidth * 2.0 * 0.9 {
                                    scaleRatio = (screenWidth * 2.0 * 0.9) / geometry.size.width
                                }
                            }
                    }
                }
                
            }
        }
    }
}

struct KettlebellHandle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Outer shape
        path.move(to: CGPoint(x: width * 0.1, y: height * 0.7))
        path.addQuadCurve(to: CGPoint(x: width * 0.5, y: height * 0.1), control: CGPoint(x: 0, y: 0))
        path.addQuadCurve(to: CGPoint(x: width * 0.9, y: height * 0.7), control: CGPoint(x: width, y: 0))
        path.addQuadCurve(to: CGPoint(x: width * 0.1, y: height * 0.7), control: CGPoint(x: width * 0.5, y: height * 0.9))

        return path
    }
}

#Preview {
    BarView(config: Bar(id: UUID(), kind: .dumbbell, name: "Ironmaster", weight: 3.2, unit: .kg, color: .gray, weights: [Plate(id: UUID(), weight: 5, unit: .lb, color: .black) : 6, Plate(id: UUID(), weight: 2, unit: .lb, color: .black) : 4]), plateCornerRadius: 2.0)
}
