//
//  OptionsView.swift
//  Plates Calc
//
//  Created by Simon Lang on 24.02.2025.
//

import SwiftUI

struct OptionsView: View {
    @ObservedObject var weightWatcher: WeightWatcher
    var body: some View {
        List {
            Section {
                HStack {
                    HStack {
                        Spacer()
                        
                        Text(weightWatcher.inventory.appUnit == .kg ? "✓ kg" : "kg")
                        
                        
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if weightWatcher.inventory.appUnit == .kg { weightWatcher.inventory.appUnit = .lb } else {
                            weightWatcher.inventory.appUnit = .kg
                        }}
                    
                    Divider()
                    
                    HStack {
                        Spacer()
                        
                        Text(weightWatcher.inventory.appUnit == .lb ? "✓ lb" : "lb")
                            
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if weightWatcher.inventory.appUnit == .lb { weightWatcher.inventory.appUnit = .kg } else {
                            weightWatcher.inventory.appUnit = .lb
                        }
                        
                    }
                    
                }
            } header: {
                Text("App Unit")
            }
            
            Section {
                Text("**Contact**\nSend us an [email](hi@project7iii.com) to ask for support, report bugs, or send suggestions.")
                Text("**Privacy Policy**\nThis app does not collect any data or track anything. Everything gets saved on your device only.")
                Text("**Support Us**\nCheck out our [other Apps](https://project7iii.com/apps/)!")
            } header: {
                Text("Help")
            } footer: {
                Text("Made with a little sweat and tears in Biel/Bienne, CH.\nVersion: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")")
            }
            
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        OptionsView(weightWatcher: WeightWatcher())
    }
}
