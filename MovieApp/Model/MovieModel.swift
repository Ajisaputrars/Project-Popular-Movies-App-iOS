//
//  MovieModel.swift
//  MovieApp
//
//  Created by Aji Saputra Raka Siwi on 12/27/17.
//  Copyright © 2017 Aji Saputra Raka Siwi. All rights reserved.
//

import Foundation

public class MovieModel{
    
    private var _title: String!
    private var _posterPath: String!
    private var _overview: String!
    private var _releaseDate: String!
    private var _backdropPath: String!
    private var _voteAverage: String!
    private var _id: String!
    
    public var title: String{
        if _title == nil {
            _title = "Isinya nil"
        }
        return _title
    }
    
    public var overview: String{
        if _overview == nil {
            _overview = "Isinya nil"
        }
        return _overview
    }
    
    public var posterPath: String{
        if _posterPath == nil {
            _posterPath = "Isinya nil"
        }
        return _posterPath
    }
    
    public var releaseDate: String{
        if _releaseDate == nil {
            _releaseDate = "Isinya nil"
        }
        return _releaseDate
    }
    
    public var backdropPath: String{
        if _backdropPath == nil {
            _backdropPath = "Isinya nil"
        }
        return _backdropPath
    }
    
    public var voteAverage: String{
        if _voteAverage == nil {
            _voteAverage = "Isinya nil"
        }
        return _voteAverage
    }
    
    public var id: String{
        if _id == nil {
            _id = "Isinya nil"
        }
        return _id
    }
    
    init(movieDict: Dictionary<String, AnyObject>) {
        if let title = movieDict["title"] as? String{
            self._title = title
        }
        
        if let overview = movieDict["overview"] as? String{
            self._overview = overview
        }
        
        if let posterPath = movieDict["poster_path"] as? String{
            self._posterPath = posterPath
        }
        
        if let releaseDate = movieDict["release_date"] as? String{
            self._releaseDate =  releaseDate
        }
        
        if let backDrop = movieDict["backdrop_path"] as? String{
            self._backdropPath = backDrop
        }
        
        if let voteAverage = movieDict["vote_average"] as? String{
            self._voteAverage = voteAverage
        }
        
        if let id = movieDict["id"] as? String{
            self._id = id
        }
    }
}
