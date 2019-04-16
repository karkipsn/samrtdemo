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
    var picArray = [Image]()
    let URL_SEARCH = Constants.baseUrl+"/latest"
    
    
    @IBOutlet weak var tableViewPhotos: UITableView!
    
    
    //the method returning the number of Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return picArray.count
    }
    
    
    //the method returning size of the list
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    
    //Set the spacing between sections through Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.cellSpacingHeight)
    }
    
    
    // Make the background color show through for either header of footer according to use // in this header it will clear the color between the gaps
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
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CircularProgess().showActivityIndicator(uiView: self.view)
        
        let parameters: Parameters=[
            "query" : query,
            ]
        
        Alamofire.request(URL_SEARCH, method: .get,  parameters: parameters, encoding:URLEncoding.queryString).responseJSON
            { response in
                
                print(response)
                
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
                self.tableViewPhotos.backgroundColor = .customGray
                self.tableViewPhotos.separatorStyle = .none
                self.tableViewPhotos.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                self.endActivityIndicator()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Searched" + query!
    }
    
    
    func endActivityIndicator() {
        CircularProgess().hideActivityIndicator(uiView: self.view)
    }
    
}
