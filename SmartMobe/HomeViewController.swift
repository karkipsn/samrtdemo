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
    
    // Variables for saving the rightbuttons on nav bar
    
    var sav_searchItem: UIBarButtonItem = UIBarButtonItem()
    

    var picArray = [Image]()
    let URL_TOP = Constants.baseUrl+"/latest"
    
    @IBOutlet weak var tableViewPhotos: UITableView!
    @IBOutlet weak var searchButton: UIBarButtonItem?
    
    @IBAction func searchButtonTapped(_ searchBar: UIBarButtonItem) {
        print("Hello I am Clicked")
        
        showSearchBar()
    }
    
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPhoto", for: indexPath) as!PhotoTableViewCell
        
        let color = self.picArray[indexPath.section]
//        cell.labelImage?.image = color.Img
//        cell.labelImage.sd_setImage(with: URL(string: color.url))
        let url = URL(string: color.url!)!
        cell.labelImage.af_setImage(withURL: url)
        cell.layer.cornerRadius = CGFloat(Constants.cellradius)
        cell.labelImage.layer.cornerRadius = CGFloat(Constants.cellradius)
        cell.accessoryType = .disclosureIndicator
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
        
        // Storing the UIRightBarButtonItems
        
        sav_searchItem = navigationItem.rightBarButtonItems![0]
        
        CircularProgess().showActivityIndicator(uiView: self.view)
        
        Alamofire.request(URL_TOP) .responseJSON
            { response in
                
//                print(response)
                
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
    

    func endActivityIndicator() {
        CircularProgess().hideActivityIndicator(uiView: self.view)
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
//                self.navigationItem.rightBarButtonItems?.append(self.sav_barItem)
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
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
