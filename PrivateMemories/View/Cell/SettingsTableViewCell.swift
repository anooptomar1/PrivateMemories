//
//  SettingsTableViewCell.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 09.12.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
