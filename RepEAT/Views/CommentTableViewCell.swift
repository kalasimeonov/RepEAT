//
//  CommentTableViewCell.swift
//  RepEAT
//
//  Created by Kaloyan Simeonov on 20.01.22.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
