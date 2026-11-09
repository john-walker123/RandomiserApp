//
//  DiceRollerView.swift
//  Randomiser
//
//  Created by Pradyumna Bharadwaj on 09/11/2026.
//

import SwiftUI

struct DiceRollerView: View {
    @State var selectedDice = 0
    
    func Roll() {
        selectedDice = Int.random(in: 0...5)
    }
    
    func show1onDice() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 100, height: 100)
                .foregroundStyle(.white)
                .shadow(radius: 5)
            
            HStack {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black)
            }
        }
    }
    
    func show2onDice() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
                .frame(width: 100, height: 100)
                .shadow(radius: 5)
            
            HStack(spacing: 20) {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black)
                
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black)
            }
        }
    }
    
    func show3onDice() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
                .frame(width: 100, height: 100)
                .shadow(radius: 5)
            
            Circle()
                .frame(width: 20, height: 20)
                .offset(x: -25, y: -25)
                .foregroundStyle(.black)
            
            Circle()
                .frame(width: 20, height: 20)
                .foregroundStyle(.black)
            
            Circle()
                .frame(width: 20, height: 20)
                .offset(x: 25, y: 25)
                .foregroundStyle(.black)
        }
    }
    
    func show4onDice() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
                .frame(width: 100, height: 100)
                .shadow(radius: 5)
            
            HStack(spacing: 25) {
                VStack(spacing: 25) {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                    
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                }
                
                VStack(spacing: 25) {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                    
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                }
            }
        }
    }
    
    func show5onDice() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
                .frame(width: 100, height: 100)
                .shadow(radius: 5)
            
            HStack(spacing: 25) {
                VStack(spacing: 25) {
                    Circle()
                        .frame(width: 20, height: 20)
                    
                    Circle()
                        .frame(width: 20, height: 20)
                }
                
                VStack(spacing: 25) {
                    Circle()
                        .frame(width: 20, height: 20)
                    
                    Circle()
                        .frame(width: 20, height: 20)
                }
            }
            .foregroundStyle(.black)
            
            Circle()
                .frame(width: 20, height: 20)
                .foregroundStyle(.black)
        }
    }
    
    func show6onDice() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
                .frame(width: 100, height: 100)
                .shadow(radius: 5)
            
            VStack(spacing: 20) {
                HStack(spacing: 10) {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                    
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                    
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                }
                
                HStack(spacing: 10) {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                    
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                    
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                }
            }
        }
    }
    
    var DiceViews: [AnyView] {
        [
            AnyView(show1onDice()),
            AnyView(show2onDice()),
            AnyView(show3onDice()),
            AnyView(show4onDice()),
            AnyView(show5onDice()),
            AnyView(show6onDice())
        ]
    }
    
    var body: some View {
        VStack {
            Text("Dice Roller!")
            DiceViews[selectedDice]
            
            Button {
                Roll()
            } label: {
                Text("Roll Dice")
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

// :)
