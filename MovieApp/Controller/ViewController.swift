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

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
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
        performSegue(withIdentifier: "detailSegue", sender: movies[indexPath.row])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let destination = segue.destination as? DetailVC {
                destination.movieDetailItem = sender as? MovieModel
            }
        }
    }
    
    private func preparingAllDelegateAndDatasource(){
        collection.delegate = self
        collection.dataSource = self
        
        searchBar.delegate = self
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
    
    @IBAction func sortMovie(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Sort Option", message: "What do you want to sort", preferredStyle: .actionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            return
        }
        
        let popularSort: UIAlertAction = UIAlertAction(title: "Popular", style: .default) { (action) in
            self.requestJson(i: 0)
            self.collection.reloadData()
        }
        
        let topRatedSort: UIAlertAction = UIAlertAction(title: "Top Rated", style: .default) { (action) in
            self.requestJson(i: 1)
            self.collection.reloadData()
        }
        
        let comingSoonSort: UIAlertAction = UIAlertAction(title: "Coming Soon", style: .default) { (action) in
            self.requestJson(i: 2)
            self.collection.reloadData()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(popularSort)
        alert.addAction(topRatedSort)
        alert.addAction(comingSoonSort)
        
        self.present(alert, animated: true, completion: nil)
    }
    

    private func requestJson(i: Int){
        if (i==0){
            filmCategory = "popular";
            self.title = "Most Popular"
        } else if (i==1){
            filmCategory = "top_rated";
            self.title = "Top Rated"
        } else if (i==2){
            filmCategory = "upcoming";
            self.title = "Coming Soon"
        }
        let fullUrl = "http://api.themoviedb.org/3/movie/"
            + filmCategory +
            "?api_key=" + API_KEY
        myParsingJson(url: fullUrl)
        print("URLnya adalah \(fullUrl)")
    }
}
