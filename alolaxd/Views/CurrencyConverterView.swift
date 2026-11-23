//
//  CurrencyConverterView.swift
//  Randomiser
//
//  Created by Pradyumna Bharadwaj on 09/11/2026.
//

import SwiftUI; import AppKit

/// Currencies supported by the European Central Bank reference rates.
struct Currency: Identifiable, Hashable {
    let code: String
    let name: String
    var id: String { code }

    /// The flag emoji for the currency's country (EUR uses the EU flag).
    var flag: String {
        String(code.prefix(2).unicodeScalars.compactMap {
            UnicodeScalar(127397 + $0.value).map(Character.init)
        })
    }

    static let all: [Currency] = [
        ("AUD", "Australian Dollar"), ("BRL", "Brazilian Real"), ("CAD", "Canadian Dollar"),
        ("CHF", "Swiss Franc"), ("CNY", "Chinese Yuan"), ("CZK", "Czech Koruna"),
        ("DKK", "Danish Krone"), ("EUR", "Euro"), ("GBP", "British Pound"),
        ("HKD", "Hong Kong Dollar"), ("HUF", "Hungarian Forint"), ("IDR", "Indonesian Rupiah"),
        ("ILS", "Israeli New Shekel"), ("INR", "Indian Rupee"), ("ISK", "Icelandic Króna"),
        ("JPY", "Japanese Yen"), ("KRW", "South Korean Won"), ("MXN", "Mexican Peso"),
        ("MYR", "Malaysian Ringgit"), ("NOK", "Norwegian Krone"), ("NZD", "New Zealand Dollar"),
        ("PHP", "Philippine Peso"), ("PLN", "Polish Złoty"), ("RON", "Romanian Leu"),
        ("SEK", "Swedish Krona"), ("SGD", "Singapore Dollar"), ("THB", "Thai Baht"),
        ("TRY", "Turkish Lira"), ("USD", "US Dollar"), ("ZAR", "South African Rand"),
    ].map { Currency(code: $0.0, name: $0.1) }

    static func named(_ code: String) -> Currency {
        all.first { $0.code == code } ?? Currency(code: code, name: code)
    }
}

/// Fetches the latest reference rates from the free Frankfurter API (no key needed).
enum ExchangeRates {
    struct Response: Decodable {
        let date: String
        let rates: [String: Double]
    }

    static func latest(base: String) async throws -> Response {
        let url = URL(string: "https://api.frankfurter.dev/v1/latest?base=\(base)")!
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

struct CurrencyConverterView: View {
    @AppStorage("currency.from") private var fromCode = "GBP"
    @AppStorage("currency.to") private var toCode = "USD"
    @State private var amount: Double = 100

    @State private var rates: [String: Double] = [:]
    @State private var ratesDate: String?
    @State private var isLoading = false
    @State private var loadFailed = false

    @State private var useCustomRate = false
    @State private var customRate: Double = 1
    @State private var hasCopied = false

    /// How many `toCode` you get for 1 `fromCode`.
    private var rate: Double? {
        if useCustomRate { return customRate }
        if fromCode == toCode { return 1 }
        return rates[toCode]
    }

    private var converted: Double? {
        rate.map { amount * $0 }
    }

    private var formattedDate: String? {
        guard let ratesDate else { return nil }
        let parser = DateFormatter()
        parser.dateFormat = "yyyy-MM-dd"
        parser.locale = Locale(identifier: "en_US_POSIX")
        guard let date = parser.date(from: ratesDate) else { return ratesDate }
        return date.formatted(date: .abbreviated, time: .omitted)
    }

    func loadRates() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await ExchangeRates.latest(base: fromCode)
            rates = result.rates
            ratesDate = result.date
            loadFailed = false
        } catch is CancellationError {
            // A newer request replaced this one.
        } catch {
            rates = [:]
            ratesDate = nil
            loadFailed = true
        }
    }

    func swapCurrencies() {
        let previousRate = rate
        (fromCode, toCode) = (toCode, fromCode)
        if useCustomRate, let previousRate, previousRate != 0 {
            customRate = 1 / previousRate
        }
        hasCopied = false
    }

    func copyResult() {
        guard let converted else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(converted.formatted(.number.precision(.fractionLength(2))), forType: .string)
        withAnimation { hasCopied = true }
    }

    var body: some View {
        ToolScreen(title: "Currency Converter",
                   subtitle: "Convert between 30 currencies with live exchange rates.",
                   symbol: "arrow.left.arrow.right",
                   tint: .red) {
            VStack(spacing: 14) {
                LabeledInput(label: "Amount") {
                    TextField("0", value: $amount, format: .number)
                }

                HStack(alignment: .bottom, spacing: 10) {
                    currencyPicker(label: "From", selection: $fromCode)

                    Button(action: swapCurrencies) {
                        Image(systemName: "arrow.left.arrow.right")
                            .font(.body.weight(.semibold))
                            .frame(width: 34, height: 34)
                            .background(Circle().fill(.primary.opacity(0.08)))
                            .contentShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .focusEffectDisabled()
                    .help("Swap currencies")
                    .padding(.bottom, 2)

                    currencyPicker(label: "To", selection: $toCode)
                }
            }

            Card(padding: 24) {
                VStack(spacing: 8) {
                    if let converted {
                        Text(converted, format: .currency(code: toCode))
                            .font(.system(size: 44, weight: .semibold).monospacedDigit())
                            .contentTransition(.numericText())
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                            .textSelection(.enabled)

                        Text("\(amount.formatted(.currency(code: fromCode))) in \(Currency.named(toCode).name)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else if isLoading {
                        ProgressView()
                            .controlSize(.small)
                            .frame(height: 52)
                        Text("Fetching the latest rates…")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.title)
                            .foregroundStyle(.secondary)
                        Text("Couldn't load live rates. Check your connection, or enter your own rate below.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .animation(.snappy, value: converted)

            if let rate, rate != 0 {
                VStack(spacing: 4) {
                    Text("1 \(fromCode) = \(rate.formatted(.number.precision(.fractionLength(0...4)))) \(toCode)")
                    Text("1 \(toCode) = \((1 / rate).formatted(.number.precision(.fractionLength(0...4)))) \(fromCode)")
                }
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(.secondary)
            }

            HStack(spacing: 10) {
                Button(action: copyResult) {
                    Label(hasCopied ? "Copied!" : "Copy",
                          systemImage: hasCopied ? "checkmark" : "doc.on.doc")
                        .foregroundStyle(hasCopied ? Color.green : Color.primary)
                }
                .disabled(converted == nil)

                Button {
                    Task { await loadRates() }
                } label: {
                    Label("Refresh rates", systemImage: "arrow.clockwise")
                }
                .disabled(isLoading || useCustomRate)
            }
            .buttonStyle(.secondaryAction)
            .focusEffectDisabled()

            VStack(alignment: .leading, spacing: 10) {
                Toggle("Use my own exchange rate", isOn: $useCustomRate)
                    .toggleStyle(.switch)
                    .controlSize(.small)

                if useCustomRate {
                    LabeledInput(label: "1 \(fromCode) = ? \(toCode)") {
                        TextField("1", value: $customRate, format: .number)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Group {
                if useCustomRate {
                    Text("Using your own rate.")
                } else if let formattedDate {
                    Text("European Central Bank reference rates from \(formattedDate).")
                } else {
                    Text("Rates are provided by the European Central Bank via frankfurter.dev.")
                }
            }
            .font(.caption)
            .foregroundStyle(.tertiary)
            .multilineTextAlignment(.center)
        }
        .task(id: fromCode) {
            await loadRates()
        }
        .onChange(of: toCode) { hasCopied = false }
        .onChange(of: amount) { hasCopied = false }
        .onChange(of: useCustomRate) { _, isOn in
            if isOn, let live = (fromCode == toCode ? 1 : rates[toCode]) {
                customRate = live
            }
        }
    }

    private func currencyPicker(label: String, selection: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Picker(label, selection: selection) {
                ForEach(Currency.all) { currency in
                    Text("\(currency.flag)  \(currency.code) – \(currency.name)")
                        .tag(currency.code)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CurrencyConverterView()
}
