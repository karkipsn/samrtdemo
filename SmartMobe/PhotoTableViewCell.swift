//
//  PhotoTableViewCell.swift
//  SmartMobe
//
//  Created by MacBook on 4/16/19.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews() // This is important, don't forget to call the super.layoutSubviews
    }

}
