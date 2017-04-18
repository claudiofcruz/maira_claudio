//
//  ProductTableViewCell.swift
//  MOB12MairaRamos_ClaudioCruz
//
//  Created by Claudio Cruz on 18/04/17.
//  Copyright © 2017 ClaudioCruz. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets

    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var ivProduct: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        

    }

    
}
