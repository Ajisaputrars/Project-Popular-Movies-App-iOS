//
//  TrailerCell.swift
//  MovieApp
//
//  Created by Aji Saputra Raka Siwi on 1/17/18.
//  Copyright © 2018 Aji Saputra Raka Siwi. All rights reserved.
//

import UIKit

class TrailerCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    var source: String?
    
    func configureCell(trailerModel: TrailerModel){
        nameLabel.text = trailerModel.name
        source = trailerModel.source
    }
}
