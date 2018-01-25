//
//  ReviewModel.swift
//  MovieApp
//
//  Created by Aji Saputra Raka Siwi on 1/17/18.
//  Copyright © 2018 Aji Saputra Raka Siwi. All rights reserved.
//

import Foundation

public class ReviewModel{
    private var _author: String?
    private var _content: String?
    
    var author: String{
        if _author == nil{
            _author = ""
        }
        return _author!
    }
    
    var content: String{
        if _content == nil {
            _content = ""
        }
        return _content!
    }
    
    init(movieReviewDict: Dictionary<String, AnyObject>){
        if let author = movieReviewDict["author"] as? String{
            _author = author
        }
        
        if let content = movieReviewDict["content"] as? String{
            _content = content
        }
    }
}
