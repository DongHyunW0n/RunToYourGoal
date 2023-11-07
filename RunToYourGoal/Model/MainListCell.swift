//
//  MainListCell.swift
//  RunToYourGoal
//
//  Created by WonDongHyun on 11/1/23.
//

import UIKit

class MainListCell: UITableViewCell {

    @IBOutlet weak var goalLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 6, bottom: 10, right: 6))
        
        setView()
//        dateLabel.adjustsFontSizeToFitWidth = true
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    

        // Configure the view for the selected state
    }
    func setView() {
           // Cell 둥근 모서리 적용(값이 커질수록 완만)
       contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
     }
}
