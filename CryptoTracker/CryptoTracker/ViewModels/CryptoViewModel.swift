//
//  CryptoViewModel.swift
//  CryptoTracker
//
//  Created by Sachin Arkasali on 15/11/25.
//

import Foundation
import Combine

@MainActor
final class CryptoViewModel: ObservableObject {
    @Published var cryptos: [CryptoModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""

    private let cryptoService = CryptoService()

    var filteredCryptos: [CryptoModel] {
        if searchText.isEmpty {
            return cryptos
        }
        return cryptos.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.symbol.localizedCaseInsensitiveContains(searchText)
        }
    }

    func fetchCryptos() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedCryptos = try await cryptoService.fetchCrypto()
            self.cryptos = fetchedCryptos
        } catch {
            errorMessage = "Failed to fetch cryptocurrencies: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
