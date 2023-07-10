//
//  HomeView.swift
//  Crypto
//
//  Created by Feni Brian on 06/06/2022.
//

import SwiftUI

// MARK: - HomeView
// 
struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioSheet: Bool = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    @State private var showSettingsView: Bool = false
    
    var body: some View {
        ZStack {
            // Background layer.
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioSheet) {
                    PortfolioView(showPortfolioSheet: $showPortfolioSheet)
                        .environmentObject(vm)
                }
            
            // Content layer.
            VStack {
                homeHeader
                HomeStatisticView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                columnTitles
                
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                } else {
                    emptyPortfolioView
                        .transition(.move(edge: .trailing))
                }

                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingsView, content: { SettingsView(showInfoSheet: $showSettingsView) })
        }
        .background(NavigationLink(destination: LoadCoinDetailView(coin: $selectedCoin), isActive: $showDetailView, label: { EmptyView() }))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}

// MARK: - HomeView Extension

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CoinButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .background(CoinButtonAnimationView(animate: $showPortfolio))
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioSheet.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none, value: showPortfolio)
            Spacer()
            CoinButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) {coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .onTapGesture {
                        withAnimation { segue(coin: coin) }
                    }
//                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var allPortfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) {coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .onTapGesture {
                        withAnimation { segue(coin: coin) }
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(.plain)
    }
    
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            Button(action: {
                withAnimation(.linear(duration: 2.0)) {
                    vm.updateCoins()
                }
            }, label: {
                Image(systemName: "arrow.clockwise")
            })
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
    private var emptyPortfolioView: some View {
        ZStack {
            if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                Text("Sorry, looks like your portfolio is empty! To add some coins, click the plus icon above...")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                    .lineLimit(0)
                    .multilineTextAlignment(.center)
                    .padding(50)
            } else {
                allPortfolioCoinsList
            }
        }
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView = true
    }
}
