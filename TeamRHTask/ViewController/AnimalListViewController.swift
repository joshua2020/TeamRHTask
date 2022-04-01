//
//  ViewController.swift
//  TeamRHTask
//
//  Created by Joshua on 30/03/2022.
//

import UIKit

class AnimalListViewController: UIViewController, AnimalsViewModelDelegate {
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    private let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    var viewModel = AnimalViewModel()
    var animals = [AnimalsModel]()

    var apiService = ApiService()
    var selectedRow = 0
    var selectedNumber: String!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewNewAnimalsBarButton: UIBarButtonItem!
    
    @IBAction func reloadAnimals(_ sender: UIBarButtonItem) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        
        let alert = UIAlertController(title: "Revist Zoo", message: "How many animals do you want to see?", preferredStyle: .actionSheet)
        
        alert.setValue(vc, forKey: "ContentViewController")
        alert.addAction(UIAlertAction(title: "Go Back", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "See New Animals", style: .default, handler: { (UIAlertAction) in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            self.selectedNumber = Array(self.numbers)[self.selectedRow].description
            self.loadAnimalData()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AnimalViewModel(delegate: self)
        loadAnimalData()
    }
    
    func getZooAnimals() -> String {
        guard let number = selectedNumber else { return ""}
        return number
    }

    private func loadAnimalData() {
        viewModel.fetchAnimalsData { [weak self] in
            self?.tableView.dataSource = self
            self?.tableView.delegate = self
            DispatchQueue.main.async {
            self?.tableView.reloadData()
            }
        }
    }
}

extension AnimalListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AnimalTableViewCell
        
        let animal = viewModel.cellForRowAt(indexPath: indexPath)
        cell.setupCell(animal)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAnimalDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if let destination = segue.destination as? AnimalDetailsViewController {
           
           let indexPath = tableView.indexPathForSelectedRow!

           destination.animalDetails = viewModel.cellForRowAt(indexPath: indexPath)
      }
    }
}

extension AnimalListViewController: UITableViewDelegate {
}

extension AnimalListViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 20))
        label.text = Array(numbers)[row]
        label.sizeToFit()
        return label
    }
}


extension AnimalListViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numbers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
}


