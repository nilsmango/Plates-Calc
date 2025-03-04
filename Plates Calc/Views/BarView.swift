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
    
    private var barWidth: CGFloat {
        screenWidth * widthRatioDumbbell
    }
    
    private var plateSpacing: CGFloat {
        2
    }
    
    private func plateWidth(for weight: Double) -> CGFloat {
        // Scale plate width based on weight
//        let baseWidth = screenWidth * 0.03
//        return baseWidth * (weight / 2.5) // 2.5 as baseline weight
        return screenWidth * 0.03
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
                            ForEach(0..<((config.weights[plate] ?? 0) / 2), id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(plate.color)
                                    .stroke(plate.color == .black || plate.color == .white ? makeContrastColor(for: plate.color) : .clear, lineWidth: 1)
                                    .frame(width: screenWidth * 0.3, height: plateWidth(for: plate.weight))
                            }
                        }
                    }
                }
            } else {
                // Bar
                Rectangle()
                    .fill(config.color)
                    .stroke(config.color == .black || config.color == .white ? makeContrastColor(for: config.color) : .clear, lineWidth: 1)
                    .frame(width: barWidth, height: screenWidth * heightRatio)
                
                // Plates
                HStack(spacing: plateSpacing * 2) {
                    // Left plates
                    HStack(spacing: plateSpacing) {
                        ForEach(Array(config.weights.keys), id: \.id) { plate in
                            ForEach(0..<((config.weights[plate] ?? 0) / 2), id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 4)
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
                                RoundedRectangle(cornerRadius: 4)
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
    BarView(config: Bar(id: UUID(), kind: .barbell, name: "Ironmaster", weight: 3.2, unit: .kg, color: .gray, weights: [Plate(id: UUID(), weight: 5, unit: .lb, color: .black) : 6, Plate(id: UUID(), weight: 2, unit: .lb, color: .black) : 4]))
}
