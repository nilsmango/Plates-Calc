//
//  ConfigView.swift
//  Plates Calc
//
//  Created by Simon Lang on 24.02.2025.
//

import SwiftUI

struct ConfigView: View {
    @ObservedObject var weightWatcher: WeightWatcher
    
    let config: Bar?
    
    
    var body: some View {
        if let config = config {
            Menu {
                BarSectionMenuButtons(weightWatcher: weightWatcher)
            } label: {
                HStack {
                    Spacer(minLength: 0)
                    
                    BarView(config: config)
                    
                    Spacer(minLength: 0)
                    
                    VStack(alignment: .leading) {
                        Text("\(config.name)")
                        Text("\(config.weight) \(config.unit)")
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .padding(.leading, 8)
                    
                    Spacer(minLength: 0)
                }
                .contentShape(Rectangle())
            }
            .tint(.primary)
            
        } else {
            VStack {
                Text("Add a Bar to see it here.")
                    .foregroundStyle(.secondary)
                    .padding()
                
                Button {
                    weightWatcher.showAddInventorySheetBar = true
                } label: {
                    Label("Add Bar", systemImage: "plus.circle.fill")
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    ConfigView(weightWatcher: WeightWatcher(), config: Bar(id: UUID(), kind: .dumbbell, name: "Ironmaster", weight: 3.2, unit: .kg, color: .gray, weights: [Plate(id: UUID(), weight: 5, unit: .lb, color: .black) : 2, Plate(id: UUID(), weight: 2, unit: .lb, color: .black) : 2]))
}
