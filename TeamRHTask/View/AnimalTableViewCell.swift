//
//  AnimalTableViewCell.swift
//  TeamRHTask
//
//  Created by Joshua on 30/03/2022.
//

import UIKit

class AnimalTableViewCell: UITableViewCell {

    @IBOutlet weak var animalNameLabel: UILabel!
    @IBOutlet weak var animalHabitatLabel: UILabel!
    @IBOutlet weak var animalImageView: CustomImageView!
    private var urlString = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func setupCell(_ animal: AnimalsModel) {
        updateUI(animalName: animal.name, animalHabitat: animal.habitat, animalImage: animal.imageLink)
    }

    private func updateUI(animalName: String?, animalHabitat: String?, animalImage: String?) {
        self.animalNameLabel.text = animalName
        self.animalHabitatLabel.text = animalHabitat

        guard let animalImageString = animalImage else {return}
        urlString = animalImageString

        guard let animalImageURL = URL(string: urlString) else { return }
        animalImageView.loadImage(from: animalImageURL)
    }
}
