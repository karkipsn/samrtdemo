//
//  Photo.swift
//  SmartMobe
//
//  Created by MacBook on 4/16/19.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit


struct Image{
    
    var id : Int?
    var url : String?
    var large_url : String?
    var source_id : String?
    
    
    init(id: Int?, url: String?){
        self.id = id
        self.url = url
    }
    
}

