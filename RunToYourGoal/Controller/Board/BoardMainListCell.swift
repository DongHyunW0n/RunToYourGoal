//
//  BoardMainListCell.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 12/8/23.
//

import UIKit

class BoardMainListCell: UITableViewCell {

    @IBOutlet weak var writterLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
