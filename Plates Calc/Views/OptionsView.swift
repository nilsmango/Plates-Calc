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
        Text("Options")
    }
}

#Preview {
    OptionsView(weightWatcher: WeightWatcher())
}
