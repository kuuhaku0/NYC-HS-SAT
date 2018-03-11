//
//  BoroughTableViewCell.swift
//  NYC HS SAT
//
//  Created by C4Q on 3/9/18.
//  Copyright © 2018 basedOnTy. All rights reserved.
//

import UIKit

class BoroughTableViewCell: UITableViewCell {
    
    @IBOutlet weak var boroughImage: UIImageView!
    @IBOutlet weak var BoroughLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
