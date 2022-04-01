//
//  ZooModel.swift
//  TeamRHTask
//
//  Created by Joshua on 30/03/2022.
//

import Foundation

// MARK: - AnimalModel
struct AnimalsModel: Codable {
    let name, latinName, animalType, activeTime: String
    let lengthMin, lengthMax, weightMin, weightMax: String
    let lifespan, habitat, diet, geoRange: String
    let imageLink: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case name
        case latinName = "latin_name"
        case animalType = "animal_type"
        case activeTime = "active_time"
        case lengthMin = "length_min"
        case lengthMax = "length_max"
        case weightMin = "weight_min"
        case weightMax = "weight_max"
        case lifespan, habitat, diet
        case geoRange = "geo_range"
        case imageLink = "image_link"
        case id
    }
}

typealias Animal = [AnimalsModel]
