//
//  CoinDetailView.swift
//  Crypto
//
//  Created by Feni Brian on 24/06/2022.
//

import SwiftUI

// MARK: - CoinDetailView
struct CoinDetailView: View {
    @StateObject var vm: CoinDetailViewModel
    @State var showDescriptionSheet: Bool = false
    let columns: [GridItem] = [
        GridItem(.flexible(minimum: 0, maximum: .infinity)),
        GridItem(.flexible(minimum: 0, maximum: .infinity))
    ]
    private var spacing:CGFloat = 15
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ChartView(coin: vm.coin)
                    .frame(height: 200)
                VStack(alignment: .leading) {
                    overviewBlocK
                    additionalBlock
                    websiteSection
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name ?? "")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: { trailingNavItems })
        }
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CoinDetailView(coin: dev.coin)
        }
    }
}

extension CoinDetailView {
    var overviewBlocK: some View {
        VStack {
            Text("Overview")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            descriptionBlock
            LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, pinnedViews: []) {
                ForEach(vm.overviewCoinDetails) {stat in
                    StatisticView(stat: stat)
                }
            }
        }
    }
    
    var additionalBlock: some View {
        VStack {
            Text("Additional Details")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, pinnedViews: []) {
                ForEach(vm.additionalCoinDetails) {stat in
                    StatisticView(stat: stat)
                }
            }
        }
    }
    
    var descriptionBlock: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(vm.coinDescription ?? "")
                    .font(.callout)
                    .foregroundColor(Color.theme.accent)
                    .lineLimit(4)
                Button(action: { showDescriptionSheet.toggle() }) {
                    Text("Read more...")
                        .font(.caption)
                        .tint(.blue)
                        .padding(.vertical, 3)
                }
            }
            .sheet(isPresented: withAnimation{
                $showDescriptionSheet
            }, content: {
                DescriptionView(description: vm.coinDescription ?? "", showDescriptionSheet: $showDescriptionSheet)
            })
        }
    }
    
    var trailingNavItems: some View {
        HStack {
            Text((vm.coin.symbol ?? "").uppercased())
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 20, height: 20)
        }
    }
    
    var websiteSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let homepageString = vm.coinHomepageURL, let homepageUrl = URL(string: homepageString) {
                Link(destination: homepageUrl) {
                    HStack {
                        Image(systemName: "arrow.up.forward.app.fill")
                        Text("Go to Website")
                        Image(systemName: "network")
                    }
                }
            }
            if let redditString = vm.coinSubredditURL, let subredditUrl = URL(string: redditString) {
                Link(destination: subredditUrl) {
                    HStack {
                        Image(systemName: "arrow.up.forward.app.fill")
                        Text("Go to Reddit page")
                        Image(systemName: "link")
                    }
                }
            }
        }
        .tint(.blue)
        .font(.caption)
        .padding(.vertical)
    }
}

// MARK: - LoadCoinDetailView
struct LoadCoinDetailView: View {
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                CoinDetailView(coin: coin)
            }
        }
    }
}
