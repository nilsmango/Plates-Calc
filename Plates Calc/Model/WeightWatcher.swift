//
//  WeightWatcher.swift
//  Plates Calc
//
//  Created by Simon Lang on 24.02.2025.
//

import Foundation

/// Last of configs is the active bar
class WeightWatcher: ObservableObject {
    @Published var inventory = Inventory()
    
    // MARK: - Storage
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
    
    // MARK: - Functions
    
    func addNewPlate(_ plate: Plate) {
        inventory.plates.append(plate)
        saveInventoryToDisk()
    }
    
    func removePlate(_ plate: Plate) {
        inventory.plates.removeAll { $0.id == plate.id }
        saveInventoryToDisk()
    }
    
    func editMaxAmount(for plate: Plate, maxAmount: Int?) {
        if let index = inventory.plates.firstIndex(where: { $0.id == plate.id }) {
            inventory.plates[index].maxAmount = maxAmount
            saveInventoryToDisk()
        }
    }
    
    func addBarToConfigs(_ bar: Bar) {
        inventory.configurations.append(bar)
        saveInventoryToDisk()
    }
    
    func removeBarFromConfigs(_ bar: Bar) {
        inventory.configurations.removeAll { $0.id == bar.id }
        saveInventoryToDisk()
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
    
    /// returns weight of config in the app unit
    func calculateWeightOfActiveConfig(_ barID: UUID) -> Double {
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
    
}
