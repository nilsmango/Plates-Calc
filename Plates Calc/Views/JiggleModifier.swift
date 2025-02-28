//
//  JiggleModifier.swift
//  Plates Calc
//
//  Created by Simon Lang on 25.02.2025.
//

import SwiftUI

struct JiggleModifier: ViewModifier {
    let isActive: Bool
    let jiggleSpeed: Double = Double.random(in: 0.08...0.15)
    @State private var animating = false
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: animating ? 2 : 0))
            .animation(
                isActive ?
                    .easeInOut(duration: jiggleSpeed)
                    .repeatForever(autoreverses: true) :
                    .default,
                value: animating
            )
            .onAppear {
                if isActive {
                    animating.toggle()
                }
            }
            .onChange(of: isActive) {
                animating.toggle()
            }
    }
}
