//
//  CommentTableViewCell.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 12/20/23.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var commentDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
