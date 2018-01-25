//
//  TrailerModel.swift
//  MovieApp
//
//  Created by Aji Saputra Raka Siwi on 1/17/18.
//  Copyright © 2018 Aji Saputra Raka Siwi. All rights reserved.
//

import Foundation

public class TrailerModel{
    private var _source:String?
    private var _name:String?
    
    var source: String{
        if _source == nil {
            _source = ""
        }
        return _source!
    }
    
    var name: String{
        if _name == nil {
            _name = ""
        }
        return _name!
    }
    
    init(movieTrailerDict: Dictionary<String, AnyObject>){
        if let source = movieTrailerDict["source"] as? String{
            _source = source
        }
        
        if let name = movieTrailerDict["name"] as? String{
            _name = name
        }
    }
}
