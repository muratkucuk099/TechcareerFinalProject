//
//  FoodCollectionViewCell.swift
//  FoodOrderProject
//
//  Created by Mac on 11.10.2023.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var priceLabelCell: UILabel!
    @IBOutlet weak var nameLabelCell: UILabel!
    @IBOutlet weak var imageViewCell: UIImageView!
    
    var ekleButton: (() -> ())?
    
    @IBAction func addToBasketButton(_ sender: UIButton) {
        ekleButton?()
    }
}
