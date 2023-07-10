//
//  CoinDetailViewModel.swift
//  Crypto
//
//  Created by Feni Brian on 24/06/2022.
//

import Foundation
import Combine

class CoinDetailViewModel: ObservableObject {
    @Published var coin: CoinModel
    @Published var overviewCoinDetails: [StatisticModel] = []
    @Published var additionalCoinDetails: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var coinHomepageURL: String? = nil
    @Published var coinSubredditURL: String? = nil
    private let coinDetailDataService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailDataService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailDataService.$coinDetail
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] (receivedArrays) in
                self?.overviewCoinDetails = receivedArrays.overview
                self?.additionalCoinDetails = receivedArrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailDataService.$coinDetail
            .sink { [weak self] receivedDetails in
                self?.coinDescription = receivedDetails?.legibleDescription
                self?.coinHomepageURL = receivedDetails?.links?.homepage?.first
                self?.coinSubredditURL = receivedDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(detail: CoinDetailModel?, coin: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        let overviewArray = createOverviewArray(coin: coin)
        let additionalArray = createAdditionalArray(coin: coin, detail: detail)
        
        return (overviewArray, additionalArray)
    }
    
    private func createOverviewArray(coin: CoinModel) -> [StatisticModel] {
        let pricePercentChange = coin.priceChangePercentage24H ?? 0.0
        let marketCapPercentChange = coin.marketCapChangePercentage24H ?? 0.0
        let price = (coin.currentPrice ?? 0.0).asCurrencyWith6Decimals()
        let marketCap = "€" + (coin.marketCap ?? 0.0).formattedWithAbbreviations()
        let rank = "\(coin.rank)"
        let volume = "€" + (coin.totalVolume ?? 0.0).formattedWithAbbreviations()
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
        let marketCapStat = StatisticModel(title: "Market Capitalisation", value: marketCap, percentageChange: marketCapPercentChange)
        let rankStat = StatisticModel(title: "Rank", value: rank)
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        let overviewArray: [StatisticModel] = [priceStat, marketCapStat, rankStat, volumeStat]
        
        return overviewArray
    }
    
    private func createAdditionalArray(coin: CoinModel, detail: CoinDetailModel?) -> [StatisticModel] {
        let pricePercentChange = coin.priceChangePercentage24H ?? 0.0
        let marketCapPercentChange = coin.marketCapChangePercentage24H ?? 0.0
        let high = (coin.high24H ?? 0.0).asCurrencyWith6Decimals()
        let low = (coin.low24H ?? 0.0).asCurrencyWith6Decimals()
        let priceChange = (coin.priceChange24H ?? 0.0).asCurrencyWith6Decimals()
        let marketCapChange = "€" + (coin.marketCapChange24H ?? 0.0).formattedWithAbbreviations()
        let blockTime = detail?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "N/A" : "\(blockTime)"
        let hashing = detail?.hashingAlgorithm ?? "N/A"
        let highStat = StatisticModel(title: "24-hour High", value: high)
        let lowStat = StatisticModel(title: "24-hour Low", value: low)
        let priceChangeStat = StatisticModel(title: "24-hour Price Change", value: priceChange, percentageChange: pricePercentChange)
        let marketCapChangeStat = StatisticModel(title: "24-hour Market Capitalisation Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeString)
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        let additionalArray: [StatisticModel] = [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockTimeStat, hashingStat]
        
        return additionalArray
    }
}
