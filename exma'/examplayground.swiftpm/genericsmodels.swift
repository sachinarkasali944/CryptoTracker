//
//  genericsmodels.swift
//  examplayground
//
//  Created by Sachin Arkasali on 28/11/25.
//

import SwiftUI

struct User: Identifiable {
    let id: Int
    let name: String
    let email: String
    let bio: String
}

struct Product: Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
}


protocol Displayable {
    var displaytitle: String { get }
    var diplaysubtitle: String? { get }
    var displaytext: String? { get }
}

extension User: Displayable {
    var displaytitle: String {
        return name
    }
    var diplaysubtitle: String? {
        email
    }
    
    var displaytext: String? {
        bio
    }
}

extension Product: Displayable {
    var displaytitle: String {
        return title
    }
    var diplaysubtitle: String? {
        return "$\(price)"
    }
    var displaytext: String? {
        return description
    }
}

struct DisplayableDisplayScreen<Model: Displayable> : View {
    let model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(model.displaytitle)
                .font(.title)
                .fontWeight(.bold)
            if let subtitle = model.diplaysubtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            if let text = model.displaytext {
                Text(text)
                    .font(.body)
            }
        }
        .padding()
    }
}

struct CombinedListView: View {
    
    let users: [User] = [
        User(id: 1, name: "Alice", email: " alice@example.com", bio: "Loves coding and hiking."),
        User(id: 2, name: "Bob", email: " bob@example.com", bio: "Works as a designer."),
    ]
    let products: [Product] = [
        Product(id: 1, title: "Laptop", price: 999.99, description: "A high-performance laptop."),
        Product(id: 2, title: "Smartphone", price: 699.99, description: "A sleek new smartphone."),
    ]
    
    var body: some View {
          NavigationView {
            List {
                Section(header: Text("Users")) {
                    ForEach(users) { user in
                        DisplayableDisplayScreen(model: user)
                    }
                }
                Section(header: Text("Products")) {
                    ForEach(products) { product in
                        DisplayableDisplayScreen(model: product)
                    }
                }
            }
        }
    }
}

    
    

struct CombinedListView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedListView()
    }
}
