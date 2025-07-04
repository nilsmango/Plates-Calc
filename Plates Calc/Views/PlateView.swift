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
    let kind: ConfigKind
    
    let width = UIScreen.main.bounds.width
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
    var contrastColor: Color {
        makeContrastColor(for: plate.color)
    }
    
    var body: some View {
        let editMode = weightWatcher.platesEditMode
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: weightWatcher.platesCornerRadius * 2)
                    .fill(editMode ? .red : plate.color)
                    .stroke((plate.color != .black && plate.color != .white) || editMode ? .clear : contrastColor, lineWidth: 1)
                    .modifier(JiggleModifier(isActive: editMode))
                
                VStack {
                    if editMode {
                        Button {
                            impactMed.impactOccurred()
                            weightWatcher.removePlate(plate)
                        } label: {
                            VStack {
                                Spacer()
                                Image(systemName: "trash")
                                Spacer()
                            }
                            .contentShape(Rectangle())
                        }
                    } else {
                        Button {
                            impactMed.impactOccurred()
                            weightWatcher.addPlateToActiveConfig(plate)
                        } label: {
                            VStack {
                                Spacer()
                                Text("+")
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .foregroundStyle(contrastColor)
                            
                        }
                        
                        if amount > 0 {
                            Divider()
                                .frame(height: 1)
                                .background(contrastColor)
                            
                            Button {
                                impactMed.impactOccurred()
                                weightWatcher.addPlateToActiveConfig(plate, remove: true)
                            } label: {
                                VStack {
                                    Spacer()
                                    Text("-")
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .foregroundStyle(contrastColor)
                                
                            }
                        }
                    }
                }
            }
            .tint(.white)
            .font(.title2)
//            .fontWeight(.bold)
            .frame(width: 40)
            .padding(.leading)
            
            VStack(alignment: .leading) {
                if kind == .kettlebell {
                    Text("\(amount) x")
                        .modifier(JiggleModifier(isActive: editMode))
                } else {
                    let pairAmount = amount/2
                    if pairAmount == 1 {
                        Text("\(pairAmount) pair x")
                            .modifier(JiggleModifier(isActive: editMode))
                    } else {
                        Text("\(pairAmount) pairs x")
                            .modifier(JiggleModifier(isActive: editMode))
                    }
                    
                }
                
                Text("\(plate.weight) \(plate.unit)")
                    .modifier(JiggleModifier(isActive: editMode))
                
            }
            .monospacedDigit()
            .font(.title2)
            .fontWeight(.bold)
            .padding(.leading, 8)
            
            Spacer(minLength: 0.0)
                        
        }
        .frame(width: width/2, height: 120)
        .padding(.vertical)
        .fontDesign(.rounded)
    }
}

#Preview {
    PlateView(weightWatcher: WeightWatcher(), amount: 2, plate: Plate(id: UUID(), weight: 23, unit: .lb, color: .indigo), kind: .dumbbell)
}
