//
//  AddInventorySheet.swift
//  Plates Calc
//
//  Created by Simon Lang on 24.02.2025.
//

import SwiftUI

struct AddInventorySheet: View {
    let addingBar: Bool
    @Binding var weight: Double
    @Binding var unit: Unit
    @Binding var color: Color
    @Binding var name: String
    @Binding var kind: ConfigKind
    var edit: Bool = false
    
    let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 2
        return f
    }()
    
    var body: some View {
        Form {
            Section(header: Text(addingBar ? "Configure Bar" : "Configure Plate")) {
                if addingBar {
                    TextField("Name", text: $name)
                    Picker("Kind", selection: $kind) {
                        ForEach(ConfigKind.allCases, id: \.self) { kind in
                            Text(kind.displayName).tag(kind)
                        }
                    }
                }
                
                HStack {
                    Text("Weight")
                    Spacer()
                    TextField("Weight", value: $weight, formatter: formatter)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)

                }
                
                
                Picker("Unit", selection: $unit) {
                    ForEach(Unit.allCases, id: \.self) { unit in
                        Text(unit.rawValue).tag(unit)
                    }
                }
                
                ColorPicker("Color", selection: $color)
            }
        }
        .navigationTitle(edit ? "Edit Bar" : addingBar ? "New Bar" : "New Plate")
        

    }
}

#Preview {
    NavigationStack {
        AddInventorySheet(addingBar: false, weight: .constant(1.23), unit: .constant(.kg), color: .constant(.blue), name: .constant("nonef"), kind: .constant(.dumbbell))
    }
    
}
