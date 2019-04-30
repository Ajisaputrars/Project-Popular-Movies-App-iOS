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
    
    private var moviesInSearchTemp = [MovieModel]()
    private var inSearchMode = false
    
    private var filmCategory: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preparingAllDelegateAndDatasource()
        requestJson(i: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 2 - 3
        
        return CGSize(width: width, height: 200)
        
//        if UIDevice().userInterfaceIdiom == .pad
//        {
//            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad &&
//                (UIScreen.main.bounds.size.height == 1366 || UIScreen.main.bounds.size.width == 1366))
//            {
//                print("iPad Pro : 12.9 inch")
//                return CGSize(width: 236, height: 400)
//            }
//            else if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad &&
//                (UIScreen.main.bounds.size.height == 1024 || UIScreen.main.bounds.size.width == 1024))
//            {
//                print("iPad 2, Pro 9.7 Inch, iPad Air/iPad Air 2, iPad Retina, iPad 5th ")
//                return CGSize(width: 236, height: 400)
//            }
//            else
//            {
//                print("iPad 3")
//                /* //                return CGSize(width: 252, height: 400) */
//                return CGSize(width: collectionView.bounds.size.width/3, height: collectionView.bounds.size.height/3)
//
//            }
//           /* //            print("Ini iPad")
//            //            return CGSize(width: 236, height: 400) */
//        }
//
//        let sizeStandard = self.view.frame.width/2
//        return CGSize(width: sizeStandard - 21, height: sizeStandard * 1.3)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            //            flowLayout.itemSize = CGSize(width: 170, height: 150)
            let sizeStandard = self.view.frame.width/2
            flowLayout.itemSize = CGSize(width: sizeStandard - 25, height: sizeStandard * 1.3)
        }
        //        else {
        //            let sizeStandard = self.view.frame.width/2
        //            flowLayout.itemSize = CGSize(width: sizeStandard - 21, height: sizeStandard * 1.3)
        //        }
        //flowLayout.scrollDirection = .horizontal
        flowLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return moviesInSearchTemp.count
        }
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieCell {
            
            var movie: MovieModel!
            
            if inSearchMode{
                movie = moviesInSearchTemp[indexPath.row]
            } else {
                movie = movies[indexPath.row]
            }
            cell.configureCell(movie: movie)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        let sizeStandard = self.view.frame.width/2
    //        return CGSize(width: sizeStandard - 25, height: sizeStandard * 1.3)
    //
    //    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        collection.collectionViewLayout.invalidateLayout()
    //    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var movie: MovieModel
        if inSearchMode {
            movie = moviesInSearchTemp[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        
        performSegue(withIdentifier: "detailSegue", sender: movie)
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" || searchBar.text == nil {
            inSearchMode = false
            collection.reloadData()
        } else {
            inSearchMode = true
            if let text = searchBar.text {
                let url = "http://api.themoviedb.org/3/search/movie?popular&query=\(text)&api_key=0df44c4b965ae567948c8749ade6c374"
                let urlNoSpace = url.replacingOccurrences(of: " ", with: "%20")
                print("URL pencarian adalah = \(urlNoSpace)")
                let movieUrl = URL(string: urlNoSpace)
                Alamofire.request(movieUrl!).responseJSON { (response) in
                    self.moviesInSearchTemp.removeAll()
                    let json = JSON(response.result.value!)
                    if let movieDbData = json["results"].arrayObject as? [Dictionary<String, AnyObject>] {
                        for obj in movieDbData{
                            let movie = MovieModel(movieDict: obj)
                            self.moviesInSearchTemp.append(movie)
                        }
                        self.collection.reloadData()
                    }
                }
            }
            collection.reloadData()
        }
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        inSearchMode = false
    }
}
