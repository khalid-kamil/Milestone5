//
//  Photo.swift
//  Milestone5
//
//  Created by Khalid Kamil on 12/31/20.
//

import Foundation

class Photo: NSObject, Codable {
    var caption: String
    var image: String
    
    init(caption: String, image: String) {
        self.caption = caption
        self.image = image
    }
}
