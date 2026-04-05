////
////  practive.swift
////  examplayground
////
////  Created by Sachin Arkasali on 28/11/25.
////
//
//// Generics
//
//import Foundation
//class Solution {
//    
//    func printInt(_ value: Int) {
//        print("Integer value: \(value)")
//    }
//    
//    func printString(_ value: String) {
//        print("String value: \(value)")
//    }
//    
//    func printAny<T>(_ value: T) {
//        print("Value: \(value)")
//    }
//    
//    func demonstrateGenerics() {
//        printAny(42)           // Value: 42
//        printAny("Hello")      // Value: Hello
//    }
//    func show<T>(_ item: T) {
//        print("Item: \(item)")
//    }
//    
//    func swapValues<T>(_ a: inout T, _ b: inout T) {
//        let temp = a
//        a = b
//        b = temp
//    }
//    struct Stack<Element> {
//        private var element: [Element] = []
//        
//        mutating func push(_ value: Element) {
//            element.append(value)
//        }
//        
//        mutating func pop() -> Element? {
//            return element.isEmpty ? nil : element.removeLast()
//        }
//    }
//    
//    func demonstrateStack() {
//        var stack = Stack<Int>()
//        stack.push(10)
//        stack.push(20)
//        _ = stack.pop()
//    }
//    
//    func maxValue<T :Comparable>(_ a: T, _ b: T) -> T {
//        return a > b ? a : b
//    }
//    
//    func demonstrateMaxValue() {
//        let intMax = maxValue(10, 20)           // 20
//        let stringMax = maxValue("apple", "banana") // banana
//    }
//    
//    func findIndex<T: Equatable>(of value: T, in array: [T]) -> Int? {
//        for (index, element) in array.enumerated() {
//            if element == value {
//                return index
//            }
//        }
//        return nil
//    }
//}
//
//struct User: Identifiable, Codable {
//    let id: Int
//    let name: String
//}
//
//protocol Repository {
//    associatedtype Item
//    func fetch() async throws -> [Item]
//    func save(_ item: Item) async throws
//}
//
//class UserRepository: Repository {
//    
//    func fetch() async throws -> [User] {
//        return [
//            User(id: 1, name: "Alice"),
//            User(id: 2, name: "Bob")
//        ]
//    }
//    
//    func save(_ item: User) async throws {
//        print("Saving user: \(item.name)")
//    }
//    
//}
//
//struct Product: Identifiable, Codable {
//    let id: Int
//    let title: String
//}
//
//class ProductRepository: Repository {
//    
//    func fetch() async throws -> [Product] {
//        return [
//            Product(id: 1, title: "Laptop"),
//            Product(id: 2, title: "Smartphone")
//        ]
//    }
//    
//    func save(_ item: Product) async throws {
//        print("Saving product: \(item.title)")
//    }
//    
//    func decodeJSON<T: Decodable>(from data: Data, as type: T.Type) throws -> T {
//        try JSONDecoder().decode(T.self, from: data)
//    }
//    
//    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
//        let (data, _) = try await URLSession.shared.data(from: url)
//        return try decodeJSON(from: data, as: type)
//    }
//    
//    enum DecodeError: Error, LocalizedError {
//        case emptyData
//        case decodingFailed(underlyingError: Error)
//        
//        var errorDescription: String? {
//            switch self {
//            case .emptyData:
//                return "The provided data is empty."
//            case .decodingFailed(let underlyingError):
//                return "Decoding failed with error: \(underlyingError.localizedDescription)"
//            }
//        }
//        
//    }
//}
//
//class ListViewModel<Item>: ObservableObject {
//    @Published var items: [Item] = []
//
//}
