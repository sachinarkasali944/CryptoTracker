//
//  CryptoView.swift
//  CryptoTracker
//
//  Created by Sachin Arkasali on 15/11/25.
//

import SwiftUI

// MARK: - Main CryptoView
struct CryptoView: View {
    @StateObject private var viewModel = CryptoViewModel()
    @State private var selectedCrypto: CryptoModel? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "0A0E1A"), Color(hex: "0D1B2A")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    headerView
                    searchBar
                    if viewModel.isLoading {
                        loadingView
                    } else if let error = viewModel.errorMessage {
                        errorView(message: error)
                    } else {
                        cryptoList
                    }
                }
            }
            .navigationBarHidden(true)
            .task {
                await viewModel.fetchCryptos()
            }
            .sheet(item: $selectedCrypto) { crypto in
                CryptoDetailView(crypto: crypto)
            }
        }
    }

    // MARK: - Header
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Crypto")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                Text("Tracker")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(Color(hex: "00D4FF"))
            }
            Spacer()
            Button {
                Task { await viewModel.fetchCryptos() }
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color(hex: "00D4FF"))
                    .rotationEffect(.degrees(viewModel.isLoading ? 360 : 0))
                    .animation(
                        viewModel.isLoading
                            ? .linear(duration: 1).repeatForever(autoreverses: false)
                            : .default,
                        value: viewModel.isLoading
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }

    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(hex: "00D4FF"))
            TextField("Search coins...", text: $viewModel.searchText)
                .foregroundColor(.white)
                .tint(Color(hex: "00D4FF"))
            if !viewModel.searchText.isEmpty {
                Button { viewModel.searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.08))
        .cornerRadius(14)
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }

    // MARK: - Loading
    private var loadingView: some View {
        VStack(spacing: 20) {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "00D4FF")))
                .scaleEffect(1.6)
            Text("Fetching live prices...")
                .foregroundColor(.gray)
                .font(.subheadline)
            Spacer()
        }
    }

    // MARK: - Error
    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            Text("Oops!")
                .font(.title2.bold())
                .foregroundColor(.white)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button {
                Task { await viewModel.fetchCryptos() }
            } label: {
                Label("Retry", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color(hex: "00D4FF"))
                    .cornerRadius(12)
            }
            Spacer()
        }
    }

    // MARK: - Coin List
    private var cryptoList: some View {
        ScrollView {
            if !viewModel.cryptos.isEmpty && viewModel.searchText.isEmpty {
                topGainersSection
            }

            HStack {
                Text("All Coins")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Text("\(viewModel.filteredCryptos.count) coins")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 6)

            HStack {
                Text("#").frame(width: 24, alignment: .center)
                Text("Coin")
                Spacer()
                Text("Price").frame(width: 90, alignment: .trailing)
                Text("24h %").frame(width: 70, alignment: .trailing)
            }
            .font(.caption)
            .foregroundColor(.gray)
            .padding(.horizontal, 20)
            .padding(.bottom, 4)

            LazyVStack(spacing: 0) {
                ForEach(viewModel.filteredCryptos) { crypto in
                    CryptoRowView(crypto: crypto)
                        .onTapGesture { selectedCrypto = crypto }
                    Divider()
                        .background(Color.white.opacity(0.06))
                        .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 20)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Top Gainers
    private var topGainersSection: some View {
        let gainers = viewModel.cryptos
            .filter { ($0.price_change_percentage_24h ?? 0) > 0 }
            .sorted { ($0.price_change_percentage_24h ?? 0) > ($1.price_change_percentage_24h ?? 0) }
            .prefix(5)

        return VStack(alignment: .leading, spacing: 8) {
            Text("🔥 Top Gainers (24h)")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(gainers) { crypto in
                        GainerCardView(crypto: crypto)
                            .onTapGesture { selectedCrypto = crypto }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 4)
            }
        }
        .padding(.bottom, 16)
    }
}

// MARK: - Gainer Card
struct GainerCardView: View {
    let crypto: CryptoModel

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                AsyncImage(url: URL(string: crypto.image)) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    Circle().fill(Color.white.opacity(0.1))
                }
                .frame(width: 28, height: 28)
                .clipShape(Circle())

                Text(crypto.symbol.uppercased())
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
            }
            Text("$\(formatPrice(crypto.current_price))")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)

            if let change = crypto.price_change_percentage_24h {
                HStack(spacing: 2) {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 10, weight: .bold))
                    Text("\(String(format: "%.2f", abs(change)))%")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(.green)
            }
        }
        .padding(12)
        .background(
            LinearGradient(
                colors: [Color(hex: "0F2A1D"), Color(hex: "0B1E14")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.green.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(14)
    }

    private func formatPrice(_ price: Double) -> String {
        if price >= 1000 { return String(format: "%.0f", price) }
        else if price >= 1 { return String(format: "%.2f", price) }
        else { return String(format: "%.5f", price) }
    }
}

// MARK: - Crypto Row
struct CryptoRowView: View {
    let crypto: CryptoModel
    @State private var isPressed = false

    var changeColor: Color {
        guard let change = crypto.price_change_percentage_24h else { return .gray }
        return change >= 0 ? Color(hex: "00C97A") : Color(hex: "FF4B6E")
    }

    var body: some View {
        HStack(spacing: 12) {
            Text("\(crypto.market_cap_rank ?? 0)")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .frame(width: 24, alignment: .center)

            AsyncImage(url: URL(string: crypto.image)) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                Circle().fill(Color.white.opacity(0.1))
            }
            .frame(width: 38, height: 38)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.3), radius: 4)

            VStack(alignment: .leading, spacing: 2) {
                Text(crypto.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text(crypto.symbol.uppercased())
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(formatPrice(crypto.current_price))")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)

                if let change = crypto.price_change_percentage_24h {
                    HStack(spacing: 3) {
                        Image(systemName: change >= 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                            .font(.system(size: 8))
                        Text("\(String(format: "%.2f", abs(change)))%")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(changeColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(changeColor.opacity(0.12))
                    .cornerRadius(6)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(isPressed ? Color.white.opacity(0.05) : Color.clear)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.12), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }

    private func formatPrice(_ price: Double) -> String {
        if price >= 1000 { return String(format: "%.0f", price) }
        else if price >= 1 { return String(format: "%.2f", price) }
        else { return String(format: "%.5f", price) }
    }
}

// MARK: - Detail View
struct CryptoDetailView: View {
    let crypto: CryptoModel
    @Environment(\.dismiss) private var dismiss

    var changeColor: Color {
        guard let change = crypto.price_change_percentage_24h else { return .gray }
        return change >= 0 ? Color(hex: "00C97A") : Color(hex: "FF4B6E")
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "0A0E1A"), Color(hex: "0D1B2A")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Button { dismiss() } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                    VStack(spacing: 12) {
                        AsyncImage(url: URL(string: crypto.image)) { image in
                            image.resizable().aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Circle().fill(Color.white.opacity(0.1))
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .shadow(color: Color(hex: "00D4FF").opacity(0.4), radius: 16)

                        Text(crypto.name)
                            .font(.system(size: 26, weight: .black, design: .rounded))
                            .foregroundColor(.white)

                        Text(crypto.symbol.uppercased())
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(8)

                        HStack(spacing: 16) {
                            Text("$\(formatPrice(crypto.current_price))")
                                .font(.system(size: 34, weight: .black))
                                .foregroundColor(.white)

                            if let change = crypto.price_change_percentage_24h {
                                HStack(spacing: 4) {
                                    Image(systemName: change >= 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                                        .font(.system(size: 10))
                                    Text("\(String(format: "%.2f", abs(change)))%")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .foregroundColor(changeColor)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(changeColor.opacity(0.12))
                                .cornerRadius(10)
                            }
                        }
                    }

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        if let rank = crypto.market_cap_rank {
                            StatCard(title: "Market Rank", value: "#\(rank)", icon: "trophy.fill", color: Color(hex: "FFD700"))
                        }
                        if let mc = crypto.market_cap {
                            StatCard(title: "Market Cap", value: formatLargeNumber(mc), icon: "chart.bar.fill", color: Color(hex: "00D4FF"))
                        }
                        if let vol = crypto.total_volume {
                            StatCard(title: "24h Volume", value: formatLargeNumber(vol), icon: "waveform.path.ecg", color: Color(hex: "A78BFA"))
                        }
                        if let high = crypto.high_24h {
                            StatCard(title: "24h High", value: "$\(formatPrice(high))", icon: "arrow.up.circle.fill", color: Color(hex: "00C97A"))
                        }
                        if let low = crypto.low_24h {
                            StatCard(title: "24h Low", value: "$\(formatPrice(low))", icon: "arrow.down.circle.fill", color: Color(hex: "FF4B6E"))
                        }
                        if let ath = crypto.ath {
                            StatCard(title: "All-Time High", value: "$\(formatPrice(ath))", icon: "star.fill", color: Color(hex: "FFD700"))
                        }
                        if let supply = crypto.circulating_supply {
                            StatCard(title: "Circulating Supply", value: formatLargeNumber(supply), icon: "bitcoinsign.circle.fill", color: Color(hex: "FB923C"))
                        }
                        if let athChange = crypto.ath_change_percentage {
                            StatCard(title: "From ATH", value: "\(String(format: "%.2f", athChange))%", icon: "chart.line.downtrend.xyaxis", color: Color(hex: "FF4B6E"))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
    }

    private func formatPrice(_ price: Double) -> String {
        if price >= 1000 { return String(format: "%.0f", price) }
        else if price >= 1 { return String(format: "%.2f", price) }
        else { return String(format: "%.6f", price) }
    }

    private func formatLargeNumber(_ number: Double) -> String {
        switch number {
        case 1_000_000_000_000...: return String(format: "$%.2fT", number / 1_000_000_000_000)
        case 1_000_000_000...: return String(format: "$%.2fB", number / 1_000_000_000)
        case 1_000_000...: return String(format: "$%.2fM", number / 1_000_000)
        default: return String(format: "$%.0f", number)
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.06))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    CryptoView()
}
