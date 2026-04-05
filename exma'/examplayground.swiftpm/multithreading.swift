//
//  multithreading.swift
//  examplayground
//
//  Created by Sachin Arkasali on 29/11/25.
//

import Foundation
import UIKit

class multithreading: @unchecked Sendable {
    
    var lable: UILabel?

    
    func fecthData() {
        DispatchQueue.global().async {
            for i in 0...10_000 {
                print("Fetching data \(i)")
            }
            DispatchQueue.main.async {
                print("Data fetched successfully")
            }
        }
        
    }
    
    func loadImage() {
        DispatchQueue.global().async {
            for i in 0...10_000 {
                print("Loading image \(i)")
            }
            DispatchQueue.main.async {
                print("Image loaded successfully")
            }
        }
    }
    
    func useSerialQueue() {
        DispatchQueue.global(qos: .utility).async {
            let serialQueue = DispatchQueue(label: "com.example.serialQueue")
            serialQueue.async {
                for i in 0...5_000 {
                    print("Task 1 - \(i)")
                }
            }
        }
        
        let serialQueue = DispatchQueue(label: "com.example.serialQueue")
        serialQueue.async {
            for i in 0...5_000 {
                print("Task 2 - \(i)")
            }
        }
        
        let concurentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)
        concurentQueue.async {
            for i in 0...5_000 {
                print("Task 3 - \(i)")
            }
        }
        let queues = DispatchQueue.global(qos: .userInitiated)
        queues.async {
            for i in 0...5_000 {
                print("Task 4 - \(i)")
            }
        }
        
        DispatchQueue.global().async {
            // UI updates must happen on the main queue
            DispatchQueue.main.async {
                self.lable = UILabel()
                self.lable?.text = "Updated Text"
            }
        }
    }
    
    
}

