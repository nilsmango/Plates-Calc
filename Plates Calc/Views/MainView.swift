//
//  MainView.swift
//  Plates Calc
//
//  Created by Simon Lang on 23.02.2025.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var weightWatcher: WeightWatcher
    
    @State private var showAddInventorySheetBar = false
    @State private var showAddInventorySheetPlate = false
    
    @State private var weight: Double = 0
    @State private var unit: Unit = .kg
    @State private var color: Color = .black
    @State private var name: String = ""
    @State private var kind: ConfigKind = .bar
    
    var body: some View {
        NavigationStack {
            VStack {
                WeightView(weight: weightWatcher.calculateWeightOfActiveConfig(), unit: weightWatcher.inventory.appUnit)
                ConfigView(config: weightWatcher.inventory.configurations.last)
    //
                PlatesView(weightWatcher: weightWatcher, config: weightWatcher.inventory.configurations.last ?? Bar(id: UUID(), kind: .bar, name: "", weight: 0, unit: .kg, color: .black, weights: [:]), plates: weightWatcher.inventory.plates)
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Add Bar") {
                            showAddInventorySheetBar = true
                            name = ""
                        }
                        Button("Add Plate") {
                            showAddInventorySheetPlate = true
                        }
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                    
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: OptionsView(weightWatcher: weightWatcher)) {
                        Label("Options", systemImage: "ellipsis.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showAddInventorySheetBar, content: {
                NavigationStack {
                    AddInventorySheet(addingBar: true, weight: $weight, unit: $unit, color: $color, name: $name, kind: $kind)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    showAddInventorySheetBar = false
                                    weight = 0
                                    name = ""
                                } label: {
                                    Text("Cancel")
                                        .tint(.red)
                                }
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    showAddInventorySheetBar = false
                                    weightWatcher.addBarToConfigs(Bar(id: UUID(), kind: kind, name: name, weight: weight, unit: unit, color: color, weights: [:]))
                                    weight = 0
                                    name = ""
                                } label: {
                                    Text("Save")
                                }
                            }
                        }
                }
            }
            )
            
            .sheet(isPresented: $showAddInventorySheetPlate, content: {
                NavigationStack {
                    AddInventorySheet(addingBar: false, weight: $weight, unit: $unit, color: $color, name: $name, kind: $kind)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    showAddInventorySheetPlate = false
                                    weight = 0
                                } label: {
                                    Text("Cancel")
                                        .tint(.red)
                                }
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    showAddInventorySheetPlate = false
                                    weightWatcher.addNewPlate(Plate(id: UUID(), weight: weight, unit: unit, color: color))
                                    weight = 0
                                } label: {
                                    Text("Save")
                                }
                            }
                        }
                }
            }
            )
        }
        
    }
}

#Preview {
    MainView(weightWatcher: WeightWatcher())
}
