//
//  AnimalDetailsViewController.swift
//  TeamRHTask
//
//  Created by Joshua on 30/03/2022.
//

import Foundation
import UIKit


class AnimalDetailsViewController: UIViewController {
    private var weightMinValue = ""
    private var weightMaxValue = ""

    private var heightMinValue = ""
    private var heightMaxValue = ""

    let userDefaults = UserDefaults.standard

    @IBOutlet weak var animalDetailImageView: CustomImageView!
    
    @IBOutlet weak var animalFullNameLabel: UILabel!
    @IBOutlet weak var animalDietLabel: UILabel!
    @IBOutlet weak var minWeightValueLabel: UILabel!
    @IBOutlet weak var maxWeightValueLabel: UILabel!
    @IBOutlet weak var minHeightValueLabel: UILabel!
    @IBOutlet weak var maxHeightValueLabel: UILabel!
    
    @IBOutlet weak var weightChoice: UISegmentedControl!
    @IBOutlet weak var heightChoice: UISegmentedControl!
    
    @IBAction func didChangeWeightChoice(_ sender: UISegmentedControl) {
        guard let weightMin = animalDetails?.weightMin,
              let weightMax = animalDetails?.weightMax else { return }
        
        guard let weightMinInt = Double(weightMin),
              let weightMaxInt = Double(weightMax) else { return }
        if sender.selectedSegmentIndex == 0 {
            weightMinValue = convertWeightMax(weight: weightMinInt)
            weightMaxValue = convertWeightMax(weight: weightMaxInt)
            
            minWeightValueLabel.text = weightMinValue
            maxWeightValueLabel.text = weightMaxValue
        } else if sender.selectedSegmentIndex == 1 {
            weightMinValue = convertWeightMax(weight: weightMinInt, toUnit: UnitMass.kilograms)
            weightMaxValue = convertWeightMin(weight: weightMaxInt, toUnit: UnitMass.kilograms)

            minWeightValueLabel.text = weightMinValue
            maxWeightValueLabel.text = weightMaxValue
        } else if sender.selectedSegmentIndex == 2 {
            weightMinValue = convertWeightMax(weight: weightMinInt, toUnit: UnitMass.stones)
            weightMaxValue = convertWeightMin(weight: weightMaxInt, toUnit: UnitMass.stones)

            minWeightValueLabel.text = weightMinValue
            maxWeightValueLabel.text = weightMaxValue
        }
    }

    @IBAction func didChangeHeightChoice(_ sender: UISegmentedControl) {
        guard let heightMin = animalDetails?.lengthMin,
              let heightMax = animalDetails?.lengthMax else { return }

        guard let heightMinInt = Double(heightMin),
              let heightMaxInt = Double(heightMax)  else { return }
        if sender.selectedSegmentIndex == 0 {
            heightMinValue = convertHeightMax(height: heightMinInt)
            heightMaxValue = convertHeightMax(height: heightMaxInt)

            minHeightValueLabel.text = heightMinValue
            maxHeightValueLabel.text = heightMaxValue
        } else if sender.selectedSegmentIndex == 1 {
            heightMinValue = convertHeightMax(height: heightMinInt, toUnit: UnitLength.centimeters)
            heightMaxValue = convertHeightMax(height: heightMaxInt, toUnit: UnitLength.centimeters)

            minHeightValueLabel.text = heightMinValue
            maxHeightValueLabel.text = heightMaxValue
        } else if sender.selectedSegmentIndex == 2 {
            heightMinValue = convertHeightMax(height: heightMinInt, toUnit: UnitLength.meters)
            heightMaxValue = convertHeightMax(height: heightMaxInt, toUnit: UnitLength.meters)

            minHeightValueLabel.text = heightMinValue
            maxHeightValueLabel.text = heightMaxValue
        }
    }
    
    @IBAction func saveChoices(sender: AnyObject) {
        userDefaults.set(weightChoice.selectedSegmentIndex, forKey: "WeightChoice")
        userDefaults.set(minWeightValueLabel.text, forKey: "WeightMaxValue")
        userDefaults.set(maxWeightValueLabel.text, forKey: "WeightMinValue")
        userDefaults.set(maxHeightValueLabel.text, forKey: "HeightMaxValue")
        userDefaults.set(minHeightValueLabel.text, forKey: "HeightMinValue")
        userDefaults.set(heightChoice.selectedSegmentIndex, forKey: "HeightChoice")
        popView()
    }
    
    var animalDetails: AnimalsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        assignAnimalDetails()
    }

    private func popView() {
        let viewcontrollers = self.navigationController?.viewControllers

        viewcontrollers?.forEach({ (vc) in
            if  let AnimalsListVC = vc as? AnimalListViewController {
                self.navigationController?.popToViewController(AnimalsListVC, animated: true)
            }
        })
    }

    private func assignAnimalDetails() {
        weightChoice.selectedSegmentIndex = userDefaults.integer(forKey: "WeightChoice")
        heightChoice.selectedSegmentIndex = userDefaults.integer(forKey: "HeightChoice")

        guard let animalName = animalDetails?.name,
                  let animalLatinName = animalDetails?.latinName,
                  let imageURL = animalDetails?.imageLink,
                  let weightMin = animalDetails?.weightMin,
                  let weightMax = animalDetails?.weightMax,
                  let heightMin = animalDetails?.lengthMin,
                  let heightMax = animalDetails?.lengthMax else { return }
            
            let fullName = "\(animalName)" + " " + "(\(animalLatinName))"
            animalFullNameLabel.text = fullName
            animalDietLabel.text = animalDetails?.diet
            
            guard let intWeightMin = Double(weightMin),
                  let intWeightMax = Double(weightMax),
                  let intHeightMin = Double(heightMin),
                  let intHeightMax = Double(heightMax) else { return }
        
        if userDefaults.string(forKey: "WeightMinValue") != nil {
            minWeightValueLabel.text = userDefaults.string(forKey: "WeightMinValue")
        } else if  minWeightValueLabel.text == "" || weightMinValue == "" {
            minWeightValueLabel.text = Measurement(value: intWeightMin, unit: UnitMass.pounds).description
        }

        if userDefaults.string(forKey: "WeightMaxValue") != nil {
            maxWeightValueLabel.text = userDefaults.string(forKey: "WeightMaxValue")
        } else if  maxWeightValueLabel.text == "" || weightMaxValue == "" {
            maxWeightValueLabel.text = Measurement(value: intWeightMax, unit: UnitMass.pounds).description
        }
        if userDefaults.string(forKey: "HeightMinValue") != nil {
            minHeightValueLabel.text = userDefaults.string(forKey: "HeightMinValue")
        } else if  minHeightValueLabel.text == "" || heightMinValue == "" {
            minHeightValueLabel.text = Measurement(value: intHeightMin, unit: UnitLength.feet).description
        }
        if userDefaults.string(forKey: "HeightMaxValue") != nil {
            maxHeightValueLabel.text = userDefaults.string(forKey: "HeightMaxValue")
        } else if  maxHeightValueLabel.text == "" || heightMaxValue == "" {
            maxHeightValueLabel.text = Measurement(value: intHeightMax, unit: UnitLength.feet).description
        }
        
        
        guard let urlString = URL(string: imageURL) else { return }
        animalDetailImageView.loadImage(from: urlString)
    }

    private func convertWeightMax(weight: Double, toUnit: UnitMass = .pounds) -> String {
        return convertWeight(weight: weight, toUnit: toUnit)
    }
    
    private func convertWeightMin(weight: Double, toUnit: UnitMass = .pounds) -> String {
        return convertWeight(weight: weight, toUnit: toUnit)
    }
    
    private func convertWeight(weight: Double, toUnit: UnitMass) -> String {
        let weigthMes = Measurement(value: Double(weight), unit: UnitMass.pounds)
        let newWeight = weigthMes.converted(to: toUnit)
        return newWeight.description
    }
    
    private func convertHeightMax(height: Double, toUnit: UnitLength = .feet) -> String {
        return convertHeight(height: height, toUnit: toUnit)
    }

    private func convertHeightMin(height: Double, toUnit: UnitLength = .feet) -> String {
        return convertHeight(height: height, toUnit: toUnit)
    }

    private func convertHeight(height: Double, toUnit: UnitLength) -> String {
        let heightMes = Measurement(value: Double(height), unit: UnitLength.feet)
        let newHeight = heightMes.converted(to: toUnit)
        return newHeight.description
    }
}



//This detail view should display;
//- An image of the animal
//- The name of the animal with it’s latin name within brackets
//- e.g “Naked Mole-rat (Heterocephalus glaber)”
//- The diet of the animal
//- The minimum and maximum weight of the animal
//- The minimum and maximum height of the animal
//- All weight and height values must be converted to the users saved
//preference with the unit displayed alongside it e.g "1.9 lb”. If no user
//preference has been set yet, default to provided API values.
