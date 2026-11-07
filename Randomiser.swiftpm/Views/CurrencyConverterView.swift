import SwiftUI

struct CurrencyConverterView: View {
    @State private var firstCurrency: Double = 0.0
    private var secondCurrency: Double {
        firstCurrency * conversionRate
    }
    @State private var conversionRate: Double = 0.0
    
    var body: some View {
        VStack{
            HStack{
                Text("Currency 1: ")
                    .font(.headline)
                TextField("", value: $firstCurrency, format: .number)
                    .padding(12)
                    .frame(width: 300, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 2)
                    )
            }
            HStack{
                Text("Currency 1 \nto Currency \n2 Rate: ")
                    .font(.headline)
                TextField("", value: $conversionRate, format: .number)
                    .padding(12)
                    .frame(width: 300, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 2)
                    )
            }
            HStack {
                Text("Currency 2: ")
                    .font(.title2)
                
                Text(String(format: "%.3f", secondCurrency))
                    .foregroundStyle(.red)
                    .font(.title2)
                    .bold()
            }
        }
    }
}
#Preview {
    CurrencyConverterView()
}
