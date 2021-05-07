//
//  ImgurModel.swift
//  Imgur
//
//  Created by Mohammed Ramshad K on 07/05/21.
//

import Foundation

struct ImgurModels: Codable {
    var data: [ImgurModel]
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
}
struct ImgurModel: Codable{
    let title: String
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case link = "link"
    }
}
