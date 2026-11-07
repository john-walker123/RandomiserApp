import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationStack{
            VStack{
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
            }
        }
    }
}
