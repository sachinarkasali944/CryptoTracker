//
//  modernMultithreading.swift
//  examplayground
//
//  Created by Sachin Arkasali on 30/11/25.
//


import Foundation

struct MyUser: Codable {
    let id: Int
    let name: String
}

@MainActor
class modernMultithreading: ObservableObject {
    @Published var users: [MyUser] = []
    @Published var errorMessage: String = ""
    
    func fetchData() async throws -> [MyUser] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let (data, _)  = try await URLSession.shared.data(from: url)
        let users: [MyUser] = try JSONDecoder().decode([MyUser].self, from: data)
        return users
    }
    
    func loadUsers() {
        Task {
            do {
                let data = try await fetchData()
                self.users = data
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

// using the old method of multithreading

class OldMultithreading: ObservableObject {
    @Published var users: [MyUser] = []
    @Published var errorMessage: String = ""
    
    func fetchData(completion: @escaping (Result<[MyUser], Error>) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            let users: [MyUser] = try! JSONDecoder().decode([MyUser].self, from: data)
            completion(.success(users))
        }
    }
    
    func loadUsers() {
        fetchData { result in
            switch result {
            case .success(let users):
                self.users = users
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
            


