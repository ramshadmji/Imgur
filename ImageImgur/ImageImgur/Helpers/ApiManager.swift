//
//  ApiManager.swift
//  Imgur
//
//  Created by Mohammed Ramshad K on 07/05/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class  ApiManager {
    
    
    static func callingImgurApi(section: String, success: @escaping ([ImgurModel])->(), failure: @escaping (Error)->()) {
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID 88e1fa4b3d2dca7",
            "Accept": "application/json"
        ]
        let url = "https://api.imgur.com/3/gallery/search?q=" + section
        AF.request(url, headers: headers).responseJSON { response in
            debugPrint(response)
            if let error = response.error{
                failure(error)
            }else{
                guard let responseData = response.data else{return}
                let jsonDecoder = JSONDecoder()
                do{
                    let json = try jsonDecoder.decode(ImgurModels.self, from: responseData)
                    success(json.data)
                }catch{
                    failure(error)
                }
                
            }
            
        }
    }
}
