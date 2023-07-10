//
//  ChartView.swift
//  Crypto
//
//  Created by Feni Brian on 28/06/2022.
//

import SwiftUI

struct ChartView: View {
    private let data: [Double]
    private let minY: Double
    private let maxY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentage: CGFloat = 0.0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        minY = data.min() ?? 0
        maxY = data.max() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                yAxisLabels
//                Divider()
                chart
                    .background(yAxisLines)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.linear(duration: 2.0)) { percentage = 1.0 }
                        }
                    }
            }
            xAxisLabels
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
            .frame(height: 200)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

extension ChartView {
    var chart: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0.0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor.opacity(0.7), radius: 10, x: 0, y: 1)
        }
    }
    
    var yAxisLabels: some View {
        VStack {
            Text(minY.formattedWithAbbreviations())
            Spacer()
            Text(((minY + maxY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(maxY.formattedWithAbbreviations())
        }
        .font(.system(size: 8, weight: .light, design: .monospaced))
        .foregroundColor(Color.theme.secondaryText)
    }
    
    var xAxisLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
    }
    
    var yAxisLines: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
}
