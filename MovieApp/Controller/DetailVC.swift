//
//  DetailVC.swift
//  MovieApp
//
//  Created by Aji Saputra Raka Siwi on 12/27/17.
//  Copyright © 2017 Aji Saputra Raka Siwi. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON

class DetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var movieDetailItem: MovieModel?
    var reviewItems = [ReviewModel]()
    var trailerItems = [TrailerModel]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var trailerTableView: UITableView!
    @IBOutlet weak var reviewTableView: UITableView!
    
    private var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegateAndDatasource()
        setPropertyInViewController()
        parsingReviews(id: id!)
        parsingTrailer(id: id!)
        trailerTableView.reloadData()
        print("Height TableView in viewdidload adalah = \(trailerTableView.contentSize.height)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.trailerTableView.reloadData()
    }
    
    func setDelegateAndDatasource(){
        trailerTableView.delegate = self
        trailerTableView.dataSource = self
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
    }
    
    func setPropertyInViewController(){
        var imageString = ""
        if let movieDetail = movieDetailItem {
            titleLabel.text = movieDetail.title
            yearLabel.text = movieDetail.releaseDate
            ratingLabel.text = movieDetail.voteAverage + " / 10"
            descriptionLabel.text = movieDetail.overview
            
            imageString = "https://image.tmdb.org/t/p/w185" + movieDetail.posterPath
            let url = URL(string: imageString)
            imageMovie.kf.setImage(with: url)
            
            id = movieDetail.id
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.trailerTableView {
            return trailerItems.count
        }
        if tableView == self.reviewTableView {
            return reviewItems.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.trailerTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "trailerTableView", for: indexPath) as? TrailerCell {
                let trailer = trailerItems[indexPath.row]
                cell.configureCell(trailerModel: trailer)
                return cell
            }
        }
        
        if tableView == self.reviewTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTableView", for: indexPath) as? ReviewCell {
                let review = reviewItems[indexPath.row]
                cell.configureCell(review: review)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    func parsingReviews(id: Int){
        let idString = String(id)
        let stringUrl = "http://api.themoviedb.org/3/movie/" + idString + "/reviews?api_key=" + API_KEY
        
        let url = URL(string: stringUrl)!
        Alamofire.request(url).responseJSON { (response) in
            let json = JSON(response.result.value!)
            if let movieReviews = json["results"].arrayObject as? [Dictionary<String, AnyObject>] {
                for i in movieReviews {
                    let review = ReviewModel(movieReviewDict: i)
                    self.reviewItems.append(review)
                }
                self.reviewTableView.reloadData()
            }
        }
    }
    func parsingTrailer(id: Int){
        let idString = String(id)
        let stringUrl = "http://api.themoviedb.org/3/movie/" + idString + "/trailers?api_key=" + API_KEY
        let url = URL(string: stringUrl)!
        
        Alamofire.request(url).responseJSON { (response) in
            let json = JSON(response.result.value!)
            if let movieTrailers = json["youtube"].arrayObject as? [Dictionary<String, AnyObject>]{
                for i in movieTrailers {
                    let trailer = TrailerModel(movieTrailerDict: i)
                    self.trailerItems.append(trailer)
                }
                self.trailerTableView.reloadData()
            }
        }
        print("Parsing trailer berhasil dengan ID = \(id)")
        print("StringURL adalah " + stringUrl)
    }
}
