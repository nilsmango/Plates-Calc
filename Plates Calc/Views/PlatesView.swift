//
//  PlatesView.swift
//  Plates Calc
//
//  Created by Simon Lang on 24.02.2025.
//

import SwiftUI

struct PlatesView: View {
    @ObservedObject var weightWatcher: WeightWatcher
    
    let config: Bar
    
    let plates: [Plate]
    
    let columns = [
        GridItem(.fixed(UIScreen.main.bounds.width / 2.2)),
        GridItem(.fixed(UIScreen.main.bounds.width / 2.2))
    ]
    

    var body: some View {
        if plates.isEmpty {
            VStack {
                Text("Add a Plate to see it here.")
                    .foregroundStyle(.secondary)
                    .padding()
                
                Button {
                    weightWatcher.showAddInventorySheetPlate = true
                } label: {
                    Label("Add Plate", systemImage: "plus.circle.fill")
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            
            
        } else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(plates.sorted {
                        if config.weights.keys.contains($0) != config.weights.keys.contains($1) {
                            return config.weights.keys.contains($0)
                        }
                        return $0.unit == $1.unit ? $0.weight > $1.weight : $0.unit.rawValue < $1.unit.rawValue
                    }, id: \.id) { plate in
                        let amount = config.weights[plate] ?? 0
                        PlateView(weightWatcher: weightWatcher, amount: amount, plate: plate, kind: config.kind)
                    }
                    
                }
                .padding()
            }
        }
    }
}

#Preview {
    let firstID = UUID()
    let secondID = UUID()
    PlatesView(weightWatcher: WeightWatcher(), config: Bar(id: UUID(), kind: .dumbbell, name: "something", weight: 3.4, unit: .kg, color: .black,weights: [Plate(id: firstID, weight: 21.2, unit: .lb, color: .gray) : 3, Plate(id: secondID, weight: 5.5, unit: .kg, color: .black) : 4]), plates: [Plate(id: firstID, weight: 21.2, unit: .lb, color: .gray), Plate(id: UUID(), weight: 123, unit: .lb, color: .green), Plate(id: UUID(), weight: 2.2, unit: .kg, color: .purple), Plate(id: secondID, weight: 5.5, unit: .kg, color: .black)])
}
