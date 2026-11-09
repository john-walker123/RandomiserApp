//
//  CoinFlipView.swift
//  Randomiser
//
//  Created by Pradyumna Bharadwaj on 09/11/2026.
//

import SwiftUI

struct CoinFlipView: View{
    @State var selectedCoin = 0
    @State private var rotation = 0.0
    
    func showHeads() -> some View {
        ZStack{
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.yellow, Color(red: 0.85, green: 0.65, blue: 0.0)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 120)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.6), lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 4)
            Image("Heads")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
        }
    }
    
    
    func showTails() -> some View {
        ZStack{
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.yellow, Color(red: 0.85, green: 0.65, blue: 0.0)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 120)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.6), lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 4)
            Image("Tails")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
        }
    }
    
    var CoinViews: [AnyView] {
        [
            AnyView(showHeads()),
            AnyView(showTails())
        ]
    }
    func Flip() {
        let result = Int.random(in: 0...1)
        
        withAnimation(.easeInOut(duration: 1.0)) {
            rotation += 1800
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            selectedCoin = result
        }
    }
    
    var body: some View{
        VStack{
            Text("Coin Flipper!")
            CoinViews[selectedCoin]
                .rotation3DEffect(
                    .degrees(rotation),
                    axis: (x: 0, y: 1, z: 0)
                )
            Button {
                Flip()
            } label: {
                Text("Flip Coin!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .frame(width: 200, height: 60)
                    .background(.yellow)
                    .cornerRadius(15)
            }
                .buttonStyle(.plain)
                .focusEffectDisabled()
        }
    }
}
#Preview{
    MenuView()
}

