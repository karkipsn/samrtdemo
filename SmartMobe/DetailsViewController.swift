//
//  DetailsViewController.swift
//  SmartMobe
//
//  Created by MacBook on 4/16/19.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class DetailsViewController: UIViewController {
    
    // To receive image id from previous pages
    var imageId: String!
    var id: Int!
    
    @IBOutlet weak var labelcopy : UILabel!
    @IBOutlet weak var labelsite : UILabel!
    @IBOutlet weak var imageUrl : UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageUrl.layer.cornerRadius = CGFloat(Constants.cellradius)
        imageUrl.clipsToBounds = true
        CircularProgess().showActivityIndicator(uiView: self.view)
        let URL_SEARCH = Constants.baseUrl+"/"+imageId!
        
        Alamofire.request(URL_SEARCH) .responseJSON
            { response in
                
                let jsonData = JSON(response.result.value!)
                self.id = jsonData["id"].intValue
                let url = jsonData["url"].stringValue
                let copyright = jsonData["copyright"].stringValue
                let site = jsonData["site"].stringValue
                
                let purl = URL(string: url)!
                self.imageUrl.af_setImage(withURL: purl)
                self.labelcopy.text = "Copyright Owned by " + copyright
                self.labelsite.text = "Image extracted from " + site
                self.endActivityIndicator()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Image Id : " + imageId
    }
    
    
    func endActivityIndicator() {
        CircularProgess().hideActivityIndicator(uiView: self.view)
    }
    
}
