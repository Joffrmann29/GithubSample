//
//  GithubModel.swift
//  GIthubSample
//
//  Created by Joffrey Mann on 8/2/18.
//  Copyright © 2018 Joffrey Mann. All rights reserved.
//

import Foundation

class GithubModel {
    var name:String?
    var desc:String?
    var createdAt:String?
    var license:String?
    
    convenience init(name: String, desc: String, createdAt:String, license:String) {
        self.init()
        self.name = name
        self.desc = desc
        self.createdAt = createdAt
        self.license = license
    }
}
