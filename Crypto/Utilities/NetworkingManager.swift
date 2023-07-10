//
//  NetworkingManager.swift
//  Crypto
//
//  Created by Feni Brian on 09/06/2022.
//

import Foundation
import Combine

class NetworkingManager {
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let urlError):
                return "[🛑] Bad response from URL: \(urlError)!"
            case .unknown:
                return "[⚠️] Unknown error occured!"
            }
        }
    }
    
    static func handleUrlResponse(response output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func download(from url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            /*
             Reminder:
             Since the dataTaskPublisher is automatically run on the background thread,
             there it's not necessary to subscribe to a global dispatch queue as shown below.
             Commenting this ↓ out will not cause any crush or generate errors, whatsoever.
             */
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap( {try handleUrlResponse(response: $0, url: url)} )
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleCompletion(_ completion: Subscribers.Completion<Error>) -> Void {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
