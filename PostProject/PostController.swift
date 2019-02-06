//
//  PostController.swift
//  PostProject
//
//  Created by Nathan Andrus on 2/6/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import Foundation

class PostController {
    
    var posts: [Post] = []
    
    static let shared = PostController()
    
    let baseURL = URL(string: "https://whydidyouchooseios.firebaseio.com/reasons")
    
    func fetchPosts(completion: @escaping ([Post]) -> Void) {
        guard let unwrappedURL = baseURL else { completion([]); return }
        let getterEndPoint = unwrappedURL.appendingPathComponent(".json")
        
        var request = URLRequest(url: getterEndPoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error receiving posts from url: \(error.localizedDescription)")
                completion([])
                return
            }
            guard let data = data else {
                print("There was a problem receiving data from URL")
                completion([])
                return
            }
            do {
                let decoder = JSONDecoder()
                let decodedDictionary = try decoder.decode([String:Post].self, from: data)
                let decodedPosts = decodedDictionary.compactMap({ $0.value })
                completion(decodedPosts)
            } catch {
                print("There was an error: \(error)")
                completion([])
                return
            }
        }
        dataTask.resume()
    }
    
    func postReason(cohort: String, name: String, reason: String, completion: @escaping ((Bool) -> Void)) {
        guard let unwrappedURL = baseURL else {
            print("This is not going to work out")
            completion(false)
            return
        }
        let fullURL = unwrappedURL.appendingPathComponent(".json")
        let newPost = Post(cohort: cohort, name: name, reason: reason)
        
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(newPost)
            var request = URLRequest(url: fullURL)
            request.httpMethod = "POST"
            request.httpBody = encodedData
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    print("There was an error posting data to url: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                guard let data = data else {
                    print("There was a problem posting the data")
                    completion(false)
                    return
                }
                completion(true)
                return
            }
            dataTask.resume()
        } catch {
            print(error)
            completion(false)
            return
        }
    }

}
