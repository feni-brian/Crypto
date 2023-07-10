//
//  PortfolioView.swift
//  Crypto
//
//  Created by Feni Brian on 20/06/2022.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolioSheet: Bool
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    if selectedCoin != nil {
                        portforlioInput
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: { leadingNavButtons })
                ToolbarItem(placement: .navigationBarTrailing, content: { trailingNavButtons })
            }
            .onChange(of: vm.searchText) { newValue in
                if newValue == "" {
                    selectedCoin = nil
                    quantityText = ""
                }
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(showPortfolioSheet: .constant(false))
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView {
    var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                withAnimation {
                    ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                        CoinLogoView(coin: coin)
                            .frame(width: 60)
                            .padding(4)
                            .onTapGesture {
                                withAnimation {
                                    updateSelectedCoin(coin: coin)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1)
                            )
                    }
                }
            }
            .frame(height: 120)
            .padding(.horizontal)
        }
    }
    
    private var portforlioInput: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol?.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice?.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount in your portfolio:")
                Spacer()
                TextField("e.g., 6.92", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith6Decimals())
            }
        }
        .animation(.none, value: quantityText)
        .font(.headline)
        .padding()
    }
    
    private var leadingNavButtons: some View {
        Button {
            showPortfolioSheet.toggle()
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "xmark")
                Text("Close")
            }
            .foregroundColor(Color.theme.red)
        }
    }
    
    private var trailingNavButtons: some View {
        HStack(spacing: 5) {
            Image(systemName: "checkmark")
                .foregroundColor(Color.theme.green)
                .opacity(showCheckmark ? 1.0 : 0.0)
            Button {
                saveButtonPressed()
            } label: {
                Text("Save")
            }
            .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0)
        }
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else { quantityText = "" }
    }
    
    private func getCurrentValue() -> Double {
        guard let quantity = Double(quantityText) else { return 0 }
        return quantity * (selectedCoin?.currentPrice ?? 0)
    }
    
    private func saveButtonPressed() {
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else { return }
        
        // Update portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        // Show checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
            selectedCoin = nil
            quantityText = ""
        }
        
        // Hide keyboard
        UIApplication.shared.endEditing()
        
        // Hide Checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }
}
