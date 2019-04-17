//
//  HomeViewController.swift
//  SmartMobe
//
//  Created by MacBook on 4/16/19.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class HomeViewController: UIViewController, UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {
    
    // Search bar variables
    var searchBar = UISearchBar()
    var searchBarButtonItem: UIBarButtonItem?
    var sav_searchItem: UIBarButtonItem = UIBarButtonItem()
    
    var picArray = [Image]()
    let URL_TOP = Constants.baseUrl+"/latest"
    
    
    @IBOutlet weak var tableViewPhotos: UITableView!
    @IBOutlet weak var searchButton: UIBarButtonItem?
    
    @IBAction func searchButtonTapped(_ searchBar: UIBarButtonItem) {
        print("Hello I am Clicked")
        showSearchBar()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return picArray.count
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.cellSpacingHeight)
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPhoto", for: indexPath) as!PhotoTableViewCell
        
        let color = self.picArray[indexPath.section]
        let url = URL(string: color.url!)!
        cell.labelImage.af_setImage(withURL: url)
        cell.layer.cornerRadius = CGFloat(Constants.cellradius)
        cell.labelImage.layer.cornerRadius = CGFloat(Constants.cellradius)
        //  cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let image = self.picArray[indexPath.section]
        let ovc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        ovc.navigationItem.title = "Details"
        navigationItem.title = "Back"
        ovc.imageId = "\(image.id!)"
        self.navigationController?.pushViewController(ovc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Storing the UIRightBarButtonItems
        sav_searchItem = navigationItem.rightBarButtonItems![0]
        
        // Customized Circular progress bar while calling Api
        CircularProgess().showActivityIndicator(uiView: self.view)
        
        Alamofire.request(URL_TOP) .responseJSON
            { response in
                
                if self.picArray.count > 0 {
                    self.picArray.removeAll()
                }
                
                let jsonData = JSON(response.result.value!)
                for images in jsonData["images"].arrayObject! {
                    
                    self.picArray.append(Image(
                        id: ((images as AnyObject)["id"] as? Int)!,
                        url: ((images as AnyObject)["url"] as? String)!
                    ))
                }
                
                self.tableViewPhotos.reloadData()
                // self.tableViewPhotos.backgroundColor = .customGray
                self.tableViewPhotos.separatorStyle = .none
                self.tableViewPhotos.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                self.endActivityIndicator()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Ending the Customized Progess View
    
    func endActivityIndicator() {
        CircularProgess().hideActivityIndicator(uiView: self.view)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "SmartMobe"
    }
    
    
    // MARK: Search Bar Display
    
    func showSearchBar() {
        
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Enter your query for search ....."
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        // To show Cancel button on the right side of navigation bar
        searchBar.showsCancelButton = true
        searchBarButtonItem = navigationItem.rightBarButtonItem
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.searchBar.alpha = 1
            self.definesPresentationContext = true
            self.navigationItem.rightBarButtonItem = nil
            
        }, completion: { finished in
            
            // To focus within the searchbar and to dispaly the soft keyboard
            self.searchBar.becomeFirstResponder()
        })
        
    }
    
    // MARK: To Hide Search Bar Display
    
    func hideSearchBar() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBar.alpha = 0.0
            self.navigationItem.titleView = nil
            
        }, completion: { finished in
            
            if (self.navigationItem.rightBarButtonItem == nil) {
                
                self.navigationItem.rightBarButtonItem = self.sav_searchItem
                return
            }
        })
    }
    
    
    //MARK: UISearchBarDelegates (cancel button and search button functionality)
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        hideSearchBar()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.resignFirstResponder()
        guard let query = self.searchBar.text else { return }
        print(query)
        hideSearchBar()
        
        //segue to order Details with orderId as a parameter in OVC
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        vc.query = query
        navigationItem.title = "Back"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
