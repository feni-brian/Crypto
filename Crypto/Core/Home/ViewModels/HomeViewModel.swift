//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Feni Brian on 08/06/2022.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var statistics: [StatisticModel] = []
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank
        case rankReversed
        case holdings
        case holdingsReversed
        case price
        case priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    //MARK: - PUBLIC
    
    func addSubscribers() {
        // Updates coins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSort)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // Updates portfolio coins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoins)
            .sink { [weak self] (receivedCoins) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: receivedCoins)
            }
            .store(in: &cancellables)
        
        // Updates the global market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func updateCoins() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notify(for: .success)
    }
    
    //MARK: - PRIVATE
    
    private func filterAndSort(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return coins }
        let lowerCasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return (coin.name ?? "").lowercased().contains(lowerCasedText) || (coin.symbol ?? "").lowercased().contains(lowerCasedText) || (coin.id ?? "").lowercased().contains(lowerCasedText)
        }
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice ?? 0.0 > $1.currentPrice ?? 0.0 })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice ?? 0.0 < $1.currentPrice ?? 0.0 })
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    private func mapAllCoins(models: [CoinModel], entities: [PortfolioEntity]) -> [CoinModel] {
        models.compactMap { (coin) -> CoinModel? in
            guard let entity = entities.first(where: { $0.coinID == coin.id }) else { return nil }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = marketDataModel else { return stats }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap ?? "", percentageChange: data.marketCapChangePercentage24HUsd ?? 0.0)
        let volume = StatisticModel(title: "24h Volume", value: data.volume ?? "")
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance ?? "")
        let currentValue = portfolioCoins.map({ $0.currentHoldingsValue }).reduce(0, +)
        let previousValue = portfolioCoins.map { (coin) -> Double in
            let value = coin.currentHoldingsValue
            let priceChange = coin.priceChangePercentage24H ?? 0.0 / 100
            let oldValue = value / (1 + priceChange)
            return oldValue
        }.reduce(0, +)
        let percentageChange = ((currentValue - previousValue) / previousValue)
        let portfolio = StatisticModel(title: "Portfolio Value", value: currentValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        
        return stats
    }
}

