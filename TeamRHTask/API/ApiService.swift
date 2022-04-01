//
//  ApiService.swift
//  TeamRHTask
//
//  Created by Joshua on 30/03/2022.
//

import Foundation
class ApiService {
    private var dataTask: URLSessionDataTask?
    
    func getAnimalData(animalsToFecth: String, completion: @escaping (Result<Animal, Error>) -> Void) {
        let animalsURL = "https://zoo-animal-api.herokuapp.com/animals/rand/" + animalsToFecth

        guard let url = URL(string: animalsURL) else {
            return
        }

        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                print("DataTask Error: \(error.localizedDescription)")
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("No Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([AnimalsModel].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
}
