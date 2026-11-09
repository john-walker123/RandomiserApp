//
//  RandomNumberView.swift
//  Randomiser
//
//  Created by Pradyumna Bharadwaj on 09/11/2026.
//

import SwiftUI

struct RandomNumberView: View {
    
    @State private var minNumber: String = ""
    @State private var maxNumber: String = ""
    @State private var randomNumber: Int?
    
    var body: some View {
        
        if let randomNumber {
            Text("\(randomNumber)")
                .font(.title)
                .bold()
        }
        
        VStack(spacing: 20) {
            
            HStack(alignment: .top, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Minimum number:")
                    
                    TextField("", text: $minNumber)
                        .padding(12)
                        .frame(width: 130, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    
                    Text("Maximum number:")
                    
                    TextField("", text: $maxNumber)
                        .padding(12)
                        .frame(width: 130, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                }
            }
            
            Button("Generate random number") {
                if let min = Int(minNumber),
                   let max = Int(maxNumber),
                   min <= max {
                    randomNumber = Int.random(in: min...max)
                }
            }
                .buttonStyle(.plain)
                .focusEffectDisabled()
        }
        .padding()
    }
}

#Preview {
    RandomNumberView()
}

