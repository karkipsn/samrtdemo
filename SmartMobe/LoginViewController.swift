//
//  LoginViewController.swift
//  SmartMobe
//
//  Created by MacBook on 4/16/19.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var email : String!
    var password : String!
    
    @IBOutlet weak var vieww:UIView!
    @IBOutlet weak var textFieldEmail:UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    @IBAction func buttonLogin(_ sender: UIButton) {
        
        if (Validate() == false) {
            // return as validation failed
            return
        }
        
        callLogin()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageName = "myImage.jpg"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        // imageView.frame = CGRect(x: 0, y: 0, width: 400, height: 700)
        imageView.frame = self.view.frame;
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        
        //Imageview on Top of View
        self.view.bringSubview(toFront: vieww)
        vieww.backgroundColor = .clear
        
        // Setting corner radius for the views
        textFieldEmail.layer.cornerRadius = CGFloat(Constants.viewradius)
        textFieldPassword.layer.cornerRadius = CGFloat(Constants.viewradius)
        buttonLogin.layer.cornerRadius = CGFloat(Constants.viewradius)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func callLogin(){
        
        Auth.auth().signIn(withEmail: self.textFieldEmail.text!, password: self.textFieldPassword.text!) { (user, error) in
            
            if error == nil {
                
                //Print into the console if successfully logged in
                print("You have successfully logged in")
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                self.present(vc!, animated: true, completion: nil)
                
            } else {
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    func Validate() -> Bool {
        
        var valid:Bool = true
        
        if (textFieldEmail.text?.isEmpty)! {
            //Change the placeholder color to red for textfield email if
            textFieldEmail.attributedPlaceholder = NSAttributedString(string: "Please enter Email ID", attributes: [NSForegroundColorAttributeName: UIColor.red])
            valid = false
        }
        
        if (textFieldPassword.text?.isEmpty)!{
            // Change the placeholder color to red for textfield passWord
            textFieldPassword.attributedPlaceholder = NSAttributedString(string: "Please enter Password", attributes: [NSForegroundColorAttributeName: UIColor.red])
            valid = false
        }
        
        return valid
    }
}
