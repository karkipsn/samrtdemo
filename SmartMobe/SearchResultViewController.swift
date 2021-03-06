//
//  SearchResultViewController.swift
//  SmartMobe
//
//  Created by MacBook on 4/16/19.
//  Copyright © 2019 MacBook. All rights reserved.


import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class SearchResultViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var query: String!
    var imageId: Int?
    var picArray = [Image]()
    let URL_SEARCH = Constants.baseUrl+"/latest"
    
    @IBOutlet weak var tableViewPhotos: UITableView!
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return picArray.count
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.cellSpacingHeight)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSearch", for: indexPath) as!PhotoTableViewCell
        
        let color = self.picArray[indexPath.section]
        let url = URL(string: color.url!)!
        cell.labelImage.af_setImage(withURL: url)
        cell.layer.cornerRadius = CGFloat(Constants.cellradius)
        cell.labelImage.layer.cornerRadius = CGFloat(Constants.cellradius)
        //        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let image = self.picArray[indexPath.section]
        let ovc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        ovc.navigationItem.title = "Dr Shipment Details"
        navigationItem.title = "Back"
        ovc.imageId = "\(image.id!)"
        self.navigationController?.pushViewController(ovc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CircularProgess().showActivityIndicator(uiView: self.view)
        
        let parameters: Parameters=[
            "query" : query,
            ]
        
        Alamofire.request(URL_SEARCH, method: .get,  parameters: parameters, encoding:URLEncoding.queryString).responseJSON
            { response in
                
                let jsonData = JSON(response.result.value!)
                
                if self.picArray.count > 0 {
                    self.picArray.removeAll()
                }
                
                for images in jsonData["images"].arrayObject! {
                    
                    self.picArray.append(Image(
                        id: ((images as AnyObject)["id"] as? Int)!,
                        url: ((images as AnyObject)["url"] as? String)!
                    ))
                }
                
                self.tableViewPhotos.reloadData()
                self.tableViewPhotos.separatorStyle = .none
                self.tableViewPhotos.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                self.endActivityIndicator()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = query! + " Results"
    }
    
    
    func endActivityIndicator() {
        CircularProgess().hideActivityIndicator(uiView: self.view)
    }
    
}
