//
//  MovieModel.swift
//  FreshPotatoes
//
//  Created by Jianfeng Ye on 2/3/15.
//  Copyright (c) 2015 Dion613. All rights reserved.
//

import Foundation

class Movie {
    var name = "Unknown"
    var synopsis = "Unknown"
    var posterSmallUrl = ""
    var posterBigUrl = ""
    
    init(name:String, synopsis:String, posterUrl:String) {
        self.name = name
        self.synopsis = synopsis
        self.posterSmallUrl = posterUrl
        self.posterBigUrl = posterUrl.stringByReplacingOccurrencesOfString("tmb.jpg", withString: "ori.jpg")
    }
}