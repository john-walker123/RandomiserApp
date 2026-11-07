import SwiftUI

struct CoinFlipView: View{
    @State var selectedCoin = 0
    
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
            Text("Heads")
                .foregroundStyle(.black)
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
            Text("Tails")
                .foregroundStyle(.black)
        }
    }
    
    var CoinViews: [AnyView] {
        [
            AnyView(showHeads()),
            AnyView(showTails())
        ]
    }
    func Flip(){
        selectedCoin = Int.random(in: 0...1)
    }
    
    var body: some View{
        VStack{
            Text("Coin Flipper!")
            CoinViews[selectedCoin]
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
        }
    }
}
#Preview{
    MenuView()
}
