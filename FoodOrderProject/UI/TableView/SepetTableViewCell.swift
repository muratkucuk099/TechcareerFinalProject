//
//  SepetTableViewCell.swift
//  FoodOrderProject
//
//  Created by Mac on 13.10.2023.
//

import UIKit

class SepetTableViewCell: UITableViewCell {

    @IBOutlet weak var yemekImageView: UIImageView!
    @IBOutlet weak var fiyatLabel: UILabel!
    @IBOutlet weak var adetLabel: UILabel!
    @IBOutlet weak var isimLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
