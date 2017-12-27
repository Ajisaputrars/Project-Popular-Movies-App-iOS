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
    
    @IBOutlet weak var collection: UICollectionView!
    
    private var movies = [MovieModel]()
    private var filmCategory: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preparingAllDelegateAndDatasource()
        
        requestJson(i: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieCell {
            
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
            let json = JSON(response.result.value!)
            
            if let movieDbData = json["results"].arrayObject as? [Dictionary<String, AnyObject>] {
                for obj in movieDbData{
                    let movie = MovieModel(movieDict: obj)
                    self.movies.append(movie)
                }
                self.collection.reloadData()
            }
            
            
            
            print("Ini URL nya gan! = " + url)
            print("Nih Value dari json MovieDB = \(json)")
            
        }
    }

    private func requestJson(i: Int){
        if (i==0){
            filmCategory = "popular";
        } else if (i==1){
            filmCategory = "top_rated";
        } else if (i==2){
            filmCategory = "upcoming";
        }
        
        let fullUrl = "http://api.themoviedb.org/3/movie/"
            + filmCategory +
            "?api_key=" + API_KEY
        
        myParsingJson(url: fullUrl)
    }
}
