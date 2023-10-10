//
//  MainListCell.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 2023/10/10.
//

import UIKit

class MainListCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var goalLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
