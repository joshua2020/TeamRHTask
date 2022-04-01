//
//  AnimalViewModel.swift
//  TeamRHTask
//
//  Created by Joshua on 30/03/2022.
//

import Foundation

protocol AnimalsViewModelType {
    var delegate: AnimalsViewModelDelegate! { get }
}

protocol AnimalsViewModelDelegate: AnyObject {
    func getZooAnimals() -> String
}

class AnimalViewModel: AnimalsViewModelType {

    private var apiService = ApiService()
    private var animalsCalled = [AnimalsModel]()
    weak var delegate: AnimalsViewModelDelegate!
    
    init(delegate: AnimalsViewModelDelegate? = nil) {
        self.delegate = delegate
    }

    func fetchAnimalsData(completion: @escaping () ->()) {
        guard let delegate = self.delegate else {
            return
        }

        var animals = delegate.getZooAnimals()
        apiService.getAnimalData(animalsToFecth: animals) { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                self?.animalsCalled = listOf.self
                completion()
            case .failure(let error):
                print("Error Processing json Data: \(error)")
            }
        }
    }

    func numberOfRowsInSection(section: Int) -> Int {
        if animalsCalled.count != 0 {
            return animalsCalled.count
        }
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> AnimalsModel {
        return animalsCalled[indexPath.row]
    }
}
