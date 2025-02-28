//
//  BarSectionMenuButtons.swift
//  Plates Calc
//
//  Created by Simon Lang on 28.02.2025.
//

import SwiftUI

struct BarSectionMenuButtons: View {
    @ObservedObject var weightWatcher: WeightWatcher
    
    var body: some View {
        Button {
            weightWatcher.showAddInventorySheetBar = true
            weightWatcher.name = ""
        } label: {
            Label("Add new Bar", systemImage: "plus")
        }
        
        if weightWatcher.inventory.configurations.count > 1 {
            
            Menu {
                ForEach(weightWatcher.inventory.configurations, id: \.self) { bar in
                    Button {
                        weightWatcher.makeBarActiveConfig(bar)
                    } label: {
                        Text(bar.name)
                    }
                }
            } label: {
                Label("Switch active Bar", systemImage: "square.and.pencil")
            }
        }
        
        if weightWatcher.inventory.configurations.count > 0 {
            Button {
                weightWatcher.removeAllPlates()
            } label: {
                Label("Empty active Bar", systemImage: "xmark")
            }
            
        Button {
            weightWatcher.showEditActiveBarSheet()
        } label: {
            Label("Edit active Bar", systemImage: "square.and.pencil")
        }
        
        Button(role: .destructive) {
            weightWatcher.removeActiveBar()
        } label: {
            Label("Delete active Bar", systemImage: "trash")
        }
        }
    }
}

#Preview {
    Menu {
        BarSectionMenuButtons(weightWatcher: WeightWatcher())
    } label: {
        Text("Bar Buttons")
    }
}
