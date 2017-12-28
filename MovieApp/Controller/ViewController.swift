//
//  ViewController.swift
//  MovieApp
//
//  Created by Aji Saputra Raka Siwi on 12/27/17.
//  Copyright © 2017 Aji Saputra Raka Siwi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var mainSegmentedControl: UISegmentedControl!
    @IBOutlet weak var collection: UICollectionView!
    
    private var movies = [MovieModel]()
    private var filmCategory: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preparingAllDelegateAndDatasource()
        requestJson(i: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieCell {
            
            let aMovie = movies[indexPath.row]
            cell.configureCell(movie: aMovie)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeStandard = self.view.frame.width/2
        return CGSize(width: sizeStandard - 25, height: sizeStandard * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    @IBAction func changeSegmentedControl(_ sender: Any) {
        switch mainSegmentedControl.selectedSegmentIndex {
        case 0:
            requestJson(i: 0)
            self.collection.reloadData()
        case 1:
            requestJson(i: 1)
            self.collection.reloadData()
        case 2:
            requestJson(i: 2)
            self.collection.reloadData()
        default:
            break
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
           
        }
    }
    
    private func preparingAllDelegateAndDatasource(){
        collection.delegate = self
        collection.dataSource = self
    }
    
    private func myParsingJson(url: String){
        let movieUrl = URL(string: url)!
        Alamofire.request(movieUrl).responseJSON { (response) in
            self.movies.removeAll()
            let json = JSON(response.result.value!)
            if let movieDbData = json["results"].arrayObject as? [Dictionary<String, AnyObject>] {
                for obj in movieDbData{
                    let movie = MovieModel(movieDict: obj)
                    self.movies.append(movie)
                }
                self.collection.reloadData()
            }
        }
    }

    private func requestJson(i: Int){
        if (i==0){
            filmCategory = "popular";
            self.title = "Most Popular"
            print("Request JSON 0 dijalankan")
        } else if (i==1){
            filmCategory = "top_rated";
            self.title = "Top Rated"
            print("Request JSON 1 dijalankan")
        } else if (i==2){
            filmCategory = "upcoming";
            self.title = "Coming Soon"
            print("Request JSON 2 dijalankan")
        }
        let fullUrl = "http://api.themoviedb.org/3/movie/"
            + filmCategory +
            "?api_key=" + API_KEY
        myParsingJson(url: fullUrl)
    }
}
