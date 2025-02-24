//
//  Plates_CalcApp.swift
//  Plates Calc
//
//  Created by Simon Lang on 23.02.2025.
//

import SwiftUI

@main
struct Plates_CalcApp: App {
    @StateObject private var weightWatcher = WeightWatcher()
    var body: some Scene {
        WindowGroup {
            MainView(weightWatcher: weightWatcher)
                .onAppear {
                    weightWatcher.loadInventoryFromDisk()
                }
        }
    }
}
