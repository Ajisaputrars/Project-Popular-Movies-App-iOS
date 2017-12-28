//
//  WeatherCell.swift
//  MovieApp
//
//  Created by Aji Saputra Raka Siwi on 12/27/17.
//  Copyright © 2017 Aji Saputra Raka Siwi. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    
    private var movie: MovieModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(movie: MovieModel){
        self.movie = movie
        
        titleLabel.text = self.movie.title

        let urlString = "https://image.tmdb.org/t/p/w185" + self.movie.posterPath
        let url = URL(string: urlString)
        imageMovie.kf.setImage(with: url)
    }
}
