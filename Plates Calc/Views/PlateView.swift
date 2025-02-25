//
//  PlateView.swift
//  Plates Calc
//
//  Created by Simon Lang on 24.02.2025.
//

import SwiftUI

struct PlateView: View {
    @ObservedObject var weightWatcher: WeightWatcher
    let amount: Int
    let plate: Plate
    
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: weightWatcher.platesCornerRadius)
                    .fill(plate.color)
                VStack {
                    Button {
                        weightWatcher.addPlateToActiveConfig(plate)
                    } label: {
                        VStack {
                            Spacer()
                            Text("+")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    
                    if amount > 0 {
                        Divider()
                            .frame(height: 1)
                            .background(.white)
                        
                        Button {
                            weightWatcher.addPlateToActiveConfig(plate, remove: true)
                        } label: {
                            VStack {
                                Spacer()
                                Text("-")
                                Spacer()
                            }
                            .contentShape(Rectangle())
                        }
                    }
                    
                }
            }
            .tint(.white)
            .font(.title2)
//            .fontWeight(.bold)
            .frame(width: 28)
            .padding(.leading)
            
            VStack(alignment: .leading) {
                    Text("\(amount) x")
                Text("\(plate.weight) \(plate.unit)")
                
            }
            .monospacedDigit()
            .font(.title2)
            .fontWeight(.bold)
            .padding(.leading, 8)
            
            
            Spacer(minLength: 0.0)
                        
        }
        .frame(width: width/2, height: width/4)
        .padding(.vertical)
        .fontDesign(.rounded)
    }
}

#Preview {
    PlateView(weightWatcher: WeightWatcher(), amount: 2, plate: Plate(id: UUID(), weight: 23, unit: .lb, color: .black))
}
