//
//  SettingsView.swift
//  Crypto
//
//  Created by Feni Brian on 01/07/2022.
//

import SwiftUI

struct SettingsView: View {
    private let defaultURL: URL
    private let youtubeSeriesURL: URL?
    private let websiteURL: URL?
    private let buyMeCoffeeURL: URL?
    private let coinGeckoURL: URL?
    @Binding var showSettingsSheet: Bool
    
    init(showInfoSheet: Binding<Bool>) {
        defaultURL = URL(string: "https://www.google.com/")!
        youtubeSeriesURL = URL(string: "https://www.youtube.com/c/swiftfulthinking/")
        websiteURL = URL(string: "https://www.nicksarno.com/")
        buyMeCoffeeURL = URL(string: "https://www.buymecoffee.com/nicksarno/")
        coinGeckoURL = URL(string: "https://www.coingecko.com/")
        _showSettingsSheet.self = showInfoSheet
    }
    
    var body: some View {
        NavigationView {
            Form {
                aboutCryptoSection
                aboutCoinGekoSection
                linkSection
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: { leadingNavButtons })
                ToolbarItem(placement: .navigationBarTrailing, content: { profileIcon })
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showInfoSheet: .constant(false))
    }
}

extension SettingsView {
    private var leadingNavButtons: some View {
        Button {
            showSettingsSheet.toggle()
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "xmark")
                Text("Close")
            }
            .foregroundColor(Color.theme.red)
        }
    }
    
    private var aboutCryptoSection: some View {
        Section(content: {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(.vertical, 7)
                Text("This app was made by Feni Brian, while taking the SwiftfulThinking course on YouTube hosted by Nick Sarno. It is entirely built using SwiftUI and the MVVM architecture, including some Combine, as well as Core Data.")
            }
            .font(.callout)
        }, header: { Text("Crypto") })
    }
    
    private var aboutCoinGekoSection: some View {
        Section(content: {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                Text("CoinGecko is a fee API provides a fundamental analysis of the crypto market. In addition to tracking price, volume and market capitalisation, CoinGecko tracks community growth, open-source code development, major events and on-chain metrics.")
            }
            .font(.callout)
        }, header: { Text("CoinGeko") })
    }
    
    private var linkSection: some View {
        Section(content: {
            Link(destination: youtubeSeriesURL ?? defaultURL, label: {
                HStack {
                    Image(systemName: "arrow.up.forward.app.fill")
                    Text("Go to the YouTube series tutorials")
                    Image(systemName: "network")
                }
            })
            .font(.caption)
            .tint(.blue)
            Link(destination: websiteURL ?? defaultURL, label: {
                HStack {
                    Image(systemName: "arrow.up.forward.app.fill")
                    Text("Visit Nick Sarno's website")
                    Image(systemName: "network")
                }
            })
            .font(.caption)
            .tint(.blue)
            Link(destination: buyMeCoffeeURL ?? defaultURL, label: {
                HStack {
                    Image(systemName: "arrow.up.forward.app.fill")
                    Text("Buy him coffee")
                    Image(systemName: "network")
                }
            })
            .font(.caption)
            .tint(.blue)
            Link(destination: coinGeckoURL ?? defaultURL, label: {
                HStack {
                    Image(systemName: "arrow.up.forward.app.fill")
                    Text("Go to the CoinGecko website")
                    Image(systemName: "network")
                }
            })
            .font(.caption)
            .tint(.blue)
        }, header: { Text("Links") })
    }
    
    private var profileIcon: some View {
        Image("logo-transparent")
            .resizable()
            .renderingMode(.original)
            .frame(width: 50, height: 50, alignment: .center)
            .clipShape(Circle())
    }
}
