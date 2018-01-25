//
//  ReviewCell.swift
//  MovieApp
//
//  Created by Aji Saputra Raka Siwi on 1/17/18.
//  Copyright © 2018 Aji Saputra Raka Siwi. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var contentDescription: UILabel!
    
    func configureCell(review: ReviewModel){
        authorName.text = review.author
        contentDescription.text = review.content
    }
}
