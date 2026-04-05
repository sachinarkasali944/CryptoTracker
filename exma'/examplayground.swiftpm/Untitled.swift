////
////  Untitled.swift
////  examplayground
////
////  Created by Sachin Arkasali on 27/11/25.
////
//
//import SwiftUI
//
//struct product: Codable {
//    let id: Int
//    let title: String
//    let description: String
//    
//}
//
//struct productDisplay: Equatable {
//    let id: Int
//    let title: String?
//    let description: String?
//}
//
//func mapProducts(from products: [product]) -> [productDisplay] {
//    return products.map { product in
//        return productDisplay(id: product.id,
//                              title: product.title,
//                              description: product.description)
//    }
//}
//
//protocol Cycle {
//    func pedal()
//}
//
//protocol Car {
//    func drive()
//}
//
//class Bike: Cycle, Car {
//    func pedal() {
//        print("Pedaling the bike")
//    }
//    func drive() {
//        print("fsjfh")
//    }
//
//}
//    
//struct stateModel {
//    var id: Int
//    var stateName: String
//}
//
//class Apiservice {
//    func fetchStates() async throws -> [stateModel] {
//        let url = URL(string: "https://example.com/api/states")!
//        let (data,response) = try await URLSession.shared.data(from: url)
//        let httpResponse = response as! HTTPURLResponse {
//            guard httpResponse.statusCode == 200 else {
//                throw URLError(.badServerResponse)
//            }
//        }
//        let states = try JSONDecoder().decode([stateModel].self, from: data)
//    }
//    
//    enum viewStates {
//        
//    }
//    
//    final class stateViewModel: ObservableObject {
//        var apiservice = Apiservice()
//        var title: String = "States List"
//        var error: String
//        var isloading: Bool = false
//        @Published var states: [stateModel] = []
//        
//        func fetchStates() async {
//            do {
//                self.states = try await apiservice.fetchStates()
//            } catch {
//                error = "Failed to fetch states"
//                print("Failed to fetch states: \(error)")
//            }
//        }
//        
//        init() {
//            self.states = [
//                stateModel(id: 1, stateName: "Maharashtra"),
//                stateModel(id: 2, stateName: "Gujarat"),
//            ]
//        }
//    }
//    
//    
//    final class ItemRepository {
//        private var items: [String] = []
//        private let queue = DispatchQueue(label: "com.example.itemrepository", attributes: .concurrent)
//        func readItems(completion: @escaping ([String]) -> Void) {
//            queue.async {
//                completion(self.items)
//            }
//            
//        }
//        
//    }
//
//        struct ContentView: View {
//            @StateObject private var viewModel = stateViewModel()
//            var body: some View {
//                List(viewModel.states, id: \.id) { state in
//                    if let
//                        Text(state.stateName)
//                }.onAppear {
//                    
//                }
//            }
//        }
