//
//  ForecastCell.swift
//  WheatherForecastTest
//
//  Created by mac on 16.05.2021.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
