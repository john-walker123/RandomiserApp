//
//  MenuView.swift
//  Randomiser
//
//  Created by Pradyumna Bharadwaj on 09/11/2026.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        
        NavigationStack{
            VStack(spacing: 17){
                NavigationLink{
                    DiceRollerView()
                } label: {
                    Text("Dice Roller")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(width: 300, height: 60)
                        .background(.blue)
                        .cornerRadius(15)
                }
                    .buttonStyle(.plain)
                    .focusEffectDisabled()
                NavigationLink{
                    CoinFlipView()
                } label: {
                    Text("Coin Flip")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(width: 300, height: 60)
                        .background(.green)
                        .cornerRadius(15)
                }
                    .buttonStyle(.plain)
                    .focusEffectDisabled()
                NavigationLink{
                    RandomNumberView()
                } label: {
                    Text("Random Number Generator")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(width: 300, height: 60)
                        .background(.yellow)
                        .cornerRadius(15)
                }
                    .buttonStyle(.plain)
                    .focusEffectDisabled()
                NavigationLink{
                    CurrencyConverterView()
                } label: {
                    Text("Currency Convertor")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(width: 300, height: 60)
                        .background(.red)
                        .cornerRadius(15)
                }
                    .buttonStyle(.plain)
                    .focusEffectDisabled()
                NavigationLink{
                    PasswordGeneratorView()
                } label: {
                    Text("Password Generator")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(width: 300, height: 60)
                        .background(.orange)
                        .cornerRadius(15)
                }
                    .buttonStyle(.plain)
                    .focusEffectDisabled()
            }
        }
    }
}
