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
    
    var imageId: String!
    var picArray = [Image]()
    
    
    @IBOutlet weak var labelid : UILabel!
    @IBOutlet weak var labelcopy : UILabel!
    @IBOutlet weak var labelsite : UILabel!
    @IBOutlet weak var imageUrl : UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let URL_SEARCH = Constants.baseUrl+"/"+imageId!
        
        CircularProgess().showActivityIndicator(uiView: self.view)
        
        
        Alamofire.request(URL_SEARCH) .responseJSON
            { response in
                
                print(response)
                
                let jsonData = JSON(response.result.value!)
                
                if self.picArray.count > 0 {
                    self.picArray.removeAll()
                }
                
                let id = jsonData["id"].intValue
                let url = jsonData["url"].stringValue
                let copyright = jsonData["copyright"].stringValue
                let site = jsonData["site"].stringValue
                
                let purl = URL(string: url)!
                self.imageUrl.af_setImage(withURL: purl)
                self.labelid.text = "\(id)"
                self.labelcopy.text = copyright
                self.labelsite.text = site
    
                self.endActivityIndicator()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Details"
    }
    
    
    func endActivityIndicator() {
        CircularProgess().hideActivityIndicator(uiView: self.view)
    }
    
}
