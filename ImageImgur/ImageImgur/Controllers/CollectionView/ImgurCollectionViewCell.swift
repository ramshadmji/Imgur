//
//  ImgurCollectionViewCell.swift
//  Imgur
//
//  Created by Mohammed Ramshad K on 07/05/21.
//

import UIKit
import Alamofire
import SDWebImage

let imageCache = NSCache<AnyObject, AnyObject>()
class ImgurCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var imgurImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configureCell(with model: ImgurModel){
        imageTitle.text = model.title
        //downloadImageFromUrl(url: model.link)
        if model.link.contains(".jpg"){
            imageFromSdweb(with: model.link)
        }else{
            guard let Url = URL(string: model.link) else { return  }
            imgurImage.sd_setImage(with: Url, placeholderImage: nil, options: [.progressiveLoad])
        }
        
        
    }
    
    func downloadImageFromUrl(url: String){
        guard let Url = URL(string: url) else { return  }
        if let imageFromCache = imageCache.object(forKey: Url as AnyObject) as? UIImage{
            imgurImage.image = imageFromCache
        }
        AF.request(Url, method: .get).response { (responseData) in
            if let error = responseData.error, error != nil{
                return
            }else{
                if let data = responseData.data {
                    DispatchQueue.main.async { [self] in
                        if let imageToCache = UIImage(data: data){
                            imageCache.setObject(imageToCache, forKey: url as AnyObject)
                            imgurImage.image = imageToCache
                        }
                    }
                }
            }
        }
    }
    
    func imageFromSdweb(with url: String){
        //let manager = SDWebImageManager.shared
        guard let Url = URL(string: url) else { return  }
        if let image = SDImageCache.shared.imageFromMemoryCache(forKey: Url.absoluteString) {
        //use
            imgurImage.image = image
        }else{
            imgurImage.sd_setImage(with: URL(string:url), completed: { (image, error, type, url) in
                self.imgurImage.image = image
                SDImageCache.shared.store(image, forKey: Url.absoluteString)
                     //Do any thing with image here. This will be called instantly after image is downloaded to cache. E.g. if you want to save image (Which is not required for a simple image fetch,
                     //you can use FileManager.default.createFile(atPath: newPath, contents: UIImagePNGRepresentation(image), attributes: nil)
                 })
        }
        
    }
}
