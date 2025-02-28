//
//  MainView.swift
//  Plates Calc
//
//  Created by Simon Lang on 23.02.2025.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var weightWatcher: WeightWatcher
    
    var body: some View {
        NavigationStack {
            VStack {
                WeightView(weight: weightWatcher.calculateWeightOfActiveConfig(), unit: weightWatcher.inventory.appUnit, isDumbbell: weightWatcher.inventory.configurations.last?.kind ?? ConfigKind.barbell == .dumbbell ? true : false)
                    .padding(.bottom)
                
                ConfigView(weightWatcher: weightWatcher, config: weightWatcher.inventory.configurations.last)
                    .padding(.bottom)

                //
                PlatesView(weightWatcher: weightWatcher, config: weightWatcher.inventory.configurations.last ?? Bar(id: UUID(), kind: .dumbbell, name: "", weight: 0, unit: .kg, color: .black, weights: [:]), plates: weightWatcher.inventory.plates)
                
            }
            .padding()
            .toolbar {
                
                    
                if weightWatcher.platesEditMode {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            weightWatcher.platesEditMode = false
                        } label: {
                            Text("Done")
                        }
                            
                        
                    }
                    
                } else {
                    
                    ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Section {
                            Button {
                                weightWatcher.showAddInventorySheetPlate = true
                            } label: {
                                Label("Add new Plate", systemImage: "plus")
                            }
                            
                            if weightWatcher.inventory.plates.count > 0 {
                                Button {
                                    weightWatcher.platesEditMode = true
                                } label: {
                                    Label("Edit Plates", systemImage: "square.and.pencil")
                                }
                            }
                        }
                        
                        Section {
                            BarSectionMenuButtons(weightWatcher: weightWatcher)
                            
                        }
                                                
                        NavigationLink(destination: OptionsView(weightWatcher: weightWatcher)) {
                            Label("Options", systemImage: "ellipsis")
                        }
                        
                    } label: {
                        Label("Options", systemImage: "ellipsis.circle.fill")
                    }
                    
                }
                }
            }
            .sheet(isPresented: $weightWatcher.showAddInventorySheetBar, content: {
                NavigationStack {
                    AddInventorySheet(addingBar: true, weight: $weightWatcher.weight, unit: $weightWatcher.unit, color: $weightWatcher.color, name: $weightWatcher.name, kind: $weightWatcher.kind)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    weightWatcher.showAddInventorySheetBar = false
                                    weightWatcher.weight = 1
                                    weightWatcher.name = ""
                                } label: {
                                    Text("Cancel")
                                        .tint(.red)
                                }
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    weightWatcher.showAddInventorySheetBar = false
                                    weightWatcher.addBarToConfigs()
                                    weightWatcher.weight = 1
                                    weightWatcher.name = ""
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
                    AddInventorySheet(addingBar: false, weight: $weightWatcher.weight, unit: $weightWatcher.unit, color: $weightWatcher.color, name: $weightWatcher.name, kind: $weightWatcher.kind)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    weightWatcher.showAddInventorySheetPlate = false
                                    weightWatcher.weight = 1
                                } label: {
                                    Text("Cancel")
                                        .tint(.red)
                                }
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    weightWatcher.showAddInventorySheetPlate = false
                                    weightWatcher.addNewPlate()
                                    weightWatcher.weight = 1
                                } label: {
                                    Text("Save")
                                }
                            }
                        }
                }
            }
            )
            
            .sheet(isPresented: $weightWatcher.showEditSheet) {
                NavigationStack {
                    AddInventorySheet(addingBar: true, weight: $weightWatcher.weight, unit: $weightWatcher.unit, color: $weightWatcher.color, name: $weightWatcher.name, kind: $weightWatcher.kind, edit: true)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    weightWatcher.showEditSheet = false
                                    weightWatcher.weight = 1
                                    weightWatcher.name = ""
                                } label: {
                                    Text("Cancel")
                                        .tint(.red)
                                }
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    weightWatcher.showEditSheet = false
                                    weightWatcher.editActiveBar()
                                    weightWatcher.weight = 1
                                    weightWatcher.name = ""
                                } label: {
                                    Text("Save")
                                }
                            }
                        }
                }
            }
        }
        
    }
}

#Preview {
    MainView(weightWatcher: WeightWatcher())
}
