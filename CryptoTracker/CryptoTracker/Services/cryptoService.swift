//
//  cryptoService.swift
//  CryptoTracker
//
//  Created by Sachin Arkasali on 15/11/25.
//

import Foundation

final class CryptoService {
    func fetchCrypto() async throws -> [CryptoModel] {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        return try decoder.decode([CryptoModel].self, from: data)
    }
}
