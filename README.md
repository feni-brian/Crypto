# Crypto
Crypto is a simple cryptocurrency app allows a user to create and monitor their crypto portfolio as well as prices in real-time.
It is build entirely in SwiftUI using the MVVM architectural pattern so as to organise the app's files while simultaneously keeping the code base as efficient as possible.
The app downloads these live crypto data from the internet using the [CoinGecko](https://www.coingecko.com/) API and then stores this data in the CoreData framework. This API was chosen for this purpose simply because it's free, robust and user-friendly. It is also a well maintained framework with constant updates to their database.

## CoinGecko API
The [CoinGecko](https://www.coingecko.com/) API provides a fundamental study of the global cryptocurrency market. Along with monitoring price, volume, and market capitalization, it also keeps tabs on community development, open-source software advancement, significant events, and on-chain indicators. It does this with the crypto market cap feature. The entire value of all coins of a given cryptocurrency that have been minted or are in circulation is known as the crypto market cap. The market capitalization of cryptocurrencies is used to rate them. The greater a crypto coin's market capitalization, the better its rating and market share. The total number of coins in circulation multiplied by the current price yields the cryptocurrency market cap.
With this API, you can track over 10,000 crypto prices across more than 50 currencies. Popular cryptocurrency pairs include BTC-USD, ETH-USD, and SLP-PHP. You can also track metrics such as 24 hour trading volume, market capitalization, price chart, historical performance chart, the circulating supply, and more.

## App Features.
- Real-time cryptocurrency data
- Saving the current user's portfolio
- Data searching, filtering, sorting, and reloading
- Custom colour theme and loading animations

In addition to the app features, some the technical elements encapsulated by the development of the Crypto App include but not limited to:
- MVVM Architecture
- Core Data (saving current user's portfolio)
- FileManager (saving images)
- Combine (publishers and subscribers)
- Multiple API calls
- Codable (decoding JSON data)
- 100% SwiftUI interface
- Multi-threading (using background threads)

To be fair, this app was built as part of the SwiftUI intermediate level course hosted by Nick on his channel [Swiftful Thinking](https://www.youtube.com/@SwiftfulThinking/featured). In case you wish to follow the same course for your own purposes, please visit that playlist [here](https://www.youtube.com/playlist?list=PLwvDm4Vfkdphbc3bgy_LpLRQ9DDfFGcFu). And in case you've benefited from it and wish to give back to him, you can buy him a coffee [here](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbnJzWkN0Z29RMW85MTVsaVZxUXlyNlpnT3lvd3xBQ3Jtc0ttMkt1cHpIXzZWclRBUU1aeXFaUVRTM1pnSEJrVzZZcUpHZG5NSEFNWllmeC1zcHFtOWIzMklfTlZLT244cUlLZC1aWGZkeTVsVElJYkNTcU1LVzV1VU5xRVUzSlctZVEwNG82c3JiVUdjb2IwVlRiaw&q=https%3A%2F%2Fwww.buymeacoffee.com%2Fnicksarno&v=TTYKL6CfbSs).


