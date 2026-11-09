//
//  PasswordGeneratorView.swift
//  Randomiser
//
//  Created by Pradyumna Bharadwaj on 09/11/2026.
//

import SwiftUI; import AppKit

struct PasswordGeneratorView: View{
    
    @State private var password = ""
    @State private var hasCopied = false
    
    var adjectives = [
        "Adorable", "Affectionate", "Agreeable", "Amiable", "Angelic",
        "Bright", "Brilliant", "Charming", "Cheerful", "Compassionate",
        "Delightful", "Dazzling", "Ebullient", "Enchanting", "Friendly",
        "Gentle", "Graceful", "Harmonious", "Inspiring", "Joyful",
        "Kindhearted", "Lovely", "Radiant", "Thoughtful", "Vibrant"
    ]
    
    var colours = [
        "Red", "Blue", "Green", "Yellow", "Orange",
        "Purple", "Pink", "Black", "White", "Gray",
        "Brown", "Silver", "Gold"
    ]
    
    var nouns = [
        "Anchor", "Balloon", "Blossom", "Breeze", "Butterfly", "Candle", "Cheetah", "Compass",
        "Diamond", "Dolphin", "Eagle", "Elephant", "Feather", "Forest", "Garden", "Horizon",
        "Kitten", "Meadow", "Ocean", "Otter", "Pebble", "Rainbow", "River", "Sapphire"
    ]
    
    var punctuations = [
        ",", "!", "?", ";", ":", "-", "—",
        "(", ")", "[", "]", "{", "}",
        "/", "\\", "|", "@", "#", "$", "%",
        "^", "&", "*", "+", "=", "<", ">", "~"
    ]
    
    func makePassword() {
        password =
        adjectives.randomElement()!
        + colours.randomElement()!
        + nouns.randomElement()!
        + punctuations.randomElement()!
        + String(Int.random(in: 1...1000))
    }
    
    var body: some View{
        VStack(spacing: 20){
            Button {
                makePassword()
                hasCopied = false
            } label: {
                Text("Generate Password!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .frame(width: 230, height: 60)
                    .background(.yellow)
                    .cornerRadius(15)
            }
                .buttonStyle(.plain)
                .focusEffectDisabled()
            
            VStack{
                Text("Your password is: ")
                Text(password)
                    .font(.title)
                    .foregroundStyle(.red)
                    .bold()
                    .italic()
            }
            
            Button {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(password, forType: .string)
                hasCopied = true
            } label: {
                Text(hasCopied ? "Copied!" : "Copy")
                    .frame(width: 70, height: 40)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .foregroundStyle(.black)
            }
            .disabled(password.isEmpty)
        }
    }
}

#Preview{
    PasswordGeneratorView()
}

