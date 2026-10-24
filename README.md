# 🪙 CryptoTracker

A **SwiftUI iOS app** that displays real-time cryptocurrency prices and market data, built with modern Swift concurrency (`async/await`), MVVM architecture, and a sleek dark-themed UI.

---

## 📱 Screenshots

> _Run the app on a simulator or device to see it in action._

| Coin List | Top Gainers | Detail Sheet |
|-----------|-------------|--------------|
| Dark themed list with rank, icon, price & 24h % | Horizontal scrollable gainer cards | Full stats sheet with market cap, ATH, volume & more |

---

## ✨ Features

- 🔴 **Live crypto prices** fetched from the [CoinGecko API](https://www.coingecko.com/en/api)
- 🔥 **Top Gainers strip** — horizontal scroll of the top 5 coins by 24h gain
- 🔍 **Live search** — filter coins by name or symbol instantly
- 📊 **Detail sheet** — tap any coin to see:
  - Current price & 24h % change
  - Market Cap, 24h Volume
  - 24h High / Low
  - All-Time High & % from ATH
  - Circulating Supply
  - Market Rank
- 🔄 **Refresh button** with spinning animation while loading
- ⚠️ **Error state** with a Retry button
- 🎨 **Dark gradient UI** with cyan accent color (`#00D4FF`)
- ⚡ **Smooth press animations** on rows

---

## 🏗 Architecture

This project follows the **MVVM (Model-View-ViewModel)** pattern:

```
CryptoTracker/
├── Models/
│   └── CryptoModel.swift          # Decodable struct for CoinGecko API response
├── Services/
│   └── cryptoService.swift        # URLSession-based async API layer
├── ViewModels/
│   └── CryptoViewModel.swift      # @MainActor ObservableObject, search + fetch logic
├── Views/
│   └── CryptoView.swift           # All SwiftUI views (list, row, detail, cards)
├── ContentView.swift              # Root view entry point
└── CryptoTrackerApp.swift         # @main App entry
```

---

## 🌐 API

Data is sourced from the **CoinGecko Public API** — no API key required.

**Endpoint used:**
```
GET https://api.coingecko.com/api/v3/coins/markets
    ?vs_currency=usd
    &order=market_cap_desc
    &per_page=10
    &page=1
    &sparkline=false
```

**Fields decoded from response:**

| Field | Description |
|-------|-------------|
| `id` | Unique coin identifier |
| `symbol` | Ticker (e.g. `btc`) |
| `name` | Full name (e.g. `Bitcoin`) |
| `image` | URL to coin logo |
| `current_price` | Current price in USD |
| `market_cap` | Total market capitalisation |
| `market_cap_rank` | Global rank by market cap |
| `total_volume` | 24h trading volume |
| `high_24h` / `low_24h` | 24h price range |
| `price_change_percentage_24h` | 24h % change |
| `ath` | All-Time High price |
| `ath_change_percentage` | % below ATH |
| `circulating_supply` | Coins in circulation |

---

## 🛠 Tech Stack

| Technology | Usage |
|------------|-------|
| **SwiftUI** | All UI components |
| **Swift Concurrency** (`async/await`) | Network calls |
| **Combine** | `@Published` + `ObservableObject` |
| **URLSession** | HTTP networking |
| **MVVM** | Architecture pattern |
| **CoinGecko API** | Free crypto data source |
| **AsyncImage** | Remote image loading |

---

## 🚀 Getting Started

### Requirements
- **Xcode 15+**
- **iOS 17+** deployment target
- **macOS Sonoma** or later (for development)
- No third-party dependencies — pure Swift / SwiftUI

### Steps

1. **Clone the repo:**
   ```bash
   git clone https://github.com/sachinarkasali944/CryptoTracker.git
   cd CryptoTracker
   ```

2. **Open in Xcode:**
   ```bash
   open CryptoTracker/CryptoTracker.xcodeproj
   ```

3. **Run** on a simulator or real device (iOS 17+).

> ⚠️ The CoinGecko free tier has a rate limit of ~10–30 calls/minute. If you see a fetch error, wait a moment and tap **Retry**.

---

## 📂 Project Structure

```
CryptoTracker/
└── CryptoTracker/
    └── CryptoTracker/
        ├── CryptoTrackerApp.swift
        ├── ContentView.swift
        ├── Models/
        │   └── CryptoModel.swift
        ├── Services/
        │   └── cryptoService.swift
        ├── ViewModels/
        │   └── CryptoViewModel.swift
        ├── Views/
        │   └── CryptoView.swift
        └── Assets.xcassets/
```

---

## 🎨 UI Design Highlights

- Background: `#0A0E1A → #0D1B2A` dark navy gradient
- Accent: `#00D4FF` cyan blue
- Green badge: `#00C97A` for positive % changes
- Red badge: `#FF4B6E` for negative % changes
- All views are built with native SwiftUI — no UIKit, no third-party UI libraries

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

## 🙋 Author

**Sachin Arkasali**  
Built as a SwiftUI learning project.
