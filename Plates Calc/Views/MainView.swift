//
//  MainView.swift
//  Plates Calc
//
//  Created by Simon Lang on 23.02.2025.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var weightWatcher: WeightWatcher
    
    @State private var weight: Double = 0
    @State private var unit: Unit = .kg
    @State private var color: Color = .black
    @State private var name: String = ""
    @State private var kind: ConfigKind = .dumbbell
    
    var body: some View {
        NavigationStack {
            VStack {
                WeightView(weight: weightWatcher.calculateWeightOfActiveConfig(), unit: weightWatcher.inventory.appUnit, isDumbbell: weightWatcher.inventory.configurations.last?.kind ?? ConfigKind.barbell == .dumbbell ? true : false)
                
                ConfigView(weightWatcher: weightWatcher, config: weightWatcher.inventory.configurations.last)
                    .padding(.bottom)

                //
                PlatesView(weightWatcher: weightWatcher, config: weightWatcher.inventory.configurations.last ?? Bar(id: UUID(), kind: .dumbbell, name: "", weight: 0, unit: .kg, color: .black, weights: [:]), plates: weightWatcher.inventory.plates)
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Add Bar") {
                            weightWatcher.showAddInventorySheetBar = true
                            name = ""
                        }
                        Button("Add Plate") {
                            weightWatcher.showAddInventorySheetPlate = true
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
            .sheet(isPresented: $weightWatcher.showAddInventorySheetBar, content: {
                NavigationStack {
                    AddInventorySheet(addingBar: true, weight: $weight, unit: $unit, color: $color, name: $name, kind: $kind)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    weightWatcher.showAddInventorySheetBar = false
                                    weight = 0
                                    name = ""
                                } label: {
                                    Text("Cancel")
                                        .tint(.red)
                                }
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    weightWatcher.showAddInventorySheetBar = false
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
            
            .sheet(isPresented: $weightWatcher.showAddInventorySheetPlate, content: {
                NavigationStack {
                    AddInventorySheet(addingBar: false, weight: $weight, unit: $unit, color: $color, name: $name, kind: $kind)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    weightWatcher.showAddInventorySheetPlate = false
                                    weight = 0
                                } label: {
                                    Text("Cancel")
                                        .tint(.red)
                                }
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    weightWatcher.showAddInventorySheetPlate = false
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
