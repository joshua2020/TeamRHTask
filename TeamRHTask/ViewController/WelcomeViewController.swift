//
//  WelcomeViewController.swift
//  TeamRHTask
//
//  Created by Joshua on 31/03/2022.
//

import Foundation
import UIKit


class WelcomeViewController: UIViewController, AnimalsViewModelDelegate {
    
    @IBOutlet weak var animalsPicker: UIPickerView!
    @IBOutlet weak var enterButton: UIButton! {
        didSet {
            enterButton.setTitle(numbers.first, for: .normal)
        }
    }
    
    private let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    private let apiService = ApiService()
    var viewModel: AnimalViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AnimalViewModel(delegate: self)
        animalsPicker.dataSource = self
        animalsPicker.delegate = self
    }
    
    func getZooAnimals() -> String {
        guard let number = enterButton.titleLabel?.text else { return "1" }
        return number
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAnimalList" {
            let listVC = segue.destination as! AnimalListViewController
            listVC.selectedNumber = self.getZooAnimals()
        }
    }
}


extension WelcomeViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numbers[row]
    }
}

extension WelcomeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        enterButton.setTitle(numbers[row], for: .normal)
    }
}
