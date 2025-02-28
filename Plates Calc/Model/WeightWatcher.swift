//
//  WeightWatcher.swift
//  Plates Calc
//
//  Created by Simon Lang on 24.02.2025.
//

import Foundation
import SwiftUICore

/// Last of configs is the active bar
class WeightWatcher: ObservableObject {
    
    // MARK: - Inventory
    
    @Published var inventory = Inventory()
    
    private let storageURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("PlatesCalc.data")

    private func saveInventoryToDisk() {
        do {
            let encodedData = try JSONEncoder().encode(inventory)
            try encodedData.write(to: storageURL)
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
    
    func loadInventoryFromDisk() {
        do {
            let data = try Data(contentsOf: storageURL)
            self.inventory = try JSONDecoder().decode(Inventory.self, from: data)
        } catch {
            print("Failed to load data: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Bars
    // MARK: Last of configs is active bar
    
    func addBarToConfigs() {
        let bar = Bar(id: UUID(), kind: kind, name: name, weight: weight, unit: unit, color: color, weights: [:])
        inventory.configurations.append(bar)
        saveInventoryToDisk()
    }
    
    func removeActiveBar() {
        if !inventory.configurations.isEmpty {
            inventory.configurations.removeLast()
            saveInventoryToDisk()
        }
    }
    
    func makeBarActiveConfig(_ bar: Bar) {
        if let index = inventory.configurations.firstIndex(of: bar) {
            inventory.configurations.remove(at: index)
            inventory.configurations.append(bar)
        }
        saveInventoryToDisk()
    }
    
    func showEditActiveBarSheet() {
        if let activeBar = inventory.configurations.last {
            kind = activeBar.kind
            name = activeBar.name
            weight = activeBar.weight
            unit = activeBar.unit
            color = activeBar.color
            showEditSheet = true
        }
    }
    
    func editActiveBar() {
        if let oldBar = inventory.configurations.last {
            let newBar = Bar(id: oldBar.id, kind: kind, name: name, weight: weight, unit: unit, color: color, weights: [:])
            inventory.configurations.removeLast()
            inventory.configurations.append(newBar)
            saveInventoryToDisk()
        }
    }
    
    // MARK: - Plates
    
    let platesCornerRadius = 8.0
    
    @Published var platesEditMode = false
    
    func addNewPlate() {
        let plate = Plate(id: UUID(), weight: weight, unit: unit, color: color)
        inventory.plates.append(plate)
        saveInventoryToDisk()
    }
    
    func removePlate(_ plate: Plate) {
        inventory.plates.removeAll { $0.id == plate.id }
        for (i, config) in inventory.configurations.enumerated() {
            if config.weights.keys.contains(plate) {
                var updatedConfig = config
                updatedConfig.weights.removeValue(forKey: plate)
                inventory.configurations[i] = updatedConfig
            }
        }
        if inventory.plates.isEmpty {
            platesEditMode = false
        }
        saveInventoryToDisk()
    }
    
    func removeAllPlates() {
        if inventory.configurations.isEmpty { return }
        let index = inventory.configurations.count - 1
        inventory.configurations[index].weights.removeAll()
        saveInventoryToDisk()
    }
    
    func editMaxAmount(for plate: Plate, maxAmount: Int?) {
        if let index = inventory.plates.firstIndex(where: { $0.id == plate.id }) {
            inventory.plates[index].maxAmount = maxAmount
            saveInventoryToDisk()
        }
    }
    
    func addPlateToActiveConfig(_ plate: Plate, remove: Bool = false) {
        if inventory.configurations.isEmpty { return }
        let index = inventory.configurations.count - 1
        let kind = inventory.configurations[index].kind
        let count = kind == .kettlebell ? 1 : 2
        if remove {
            var newCount = (inventory.configurations[index].weights[plate] ?? 0) - count
            if newCount < 0 {
                newCount = 0
            }
            inventory.configurations[index].weights[plate] = newCount
        } else {
            inventory.configurations[index].weights[plate] = (inventory.configurations[index].weights[plate] ?? 0) + count
        }
        saveInventoryToDisk()
    }
    
    // MARK: - Total Weight
    
    /// returns weight of config in the app unit
    func calculateWeightOfActiveConfig() -> Double {
        if let config = inventory.configurations.last {
            let barWeightInAppUnit = calculateWeightInAppUnit(weight: config.weight, unit: config.unit)
            var totalWeight = barWeightInAppUnit
            for (weight, count) in config.weights {
                let weightInAppUnit = calculateWeightInAppUnit(weight: weight.weight, unit: weight.unit)
                totalWeight += weightInAppUnit * Double(count)
            }
            return totalWeight
            
        } else {
            return 0
        }
    }
    
    private func calculateWeightInAppUnit(weight: Double, unit: Unit) -> Double {
        if unit == inventory.appUnit {
            return weight
        }
        switch inventory.appUnit {
        case .kg:
            return weight / 0.45359237
        case .lb:
            return weight * 0.45359237
        }
    }
    
    // MARK: - Adding and Editing
    
    @Published var showAddInventorySheetBar = false
    @Published var showAddInventorySheetPlate = false
    @Published var showEditSheet = false
    
    @Published var weight: Double = 1
    @Published var unit: Unit = .kg
    @Published var color: Color = .black
    @Published var name: String = ""
    @Published var kind: ConfigKind = .dumbbell
}
