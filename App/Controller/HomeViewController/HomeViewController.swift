//
//  HomeViewController.swift
//  App
//
//  Created by Javed Multani on 24/07/18.
//  Copyright © 2018 iOS. All rights reserved.
//

import UIKit
import SwiftIcons
import SwiftyJSON
import RealmSwift
import Realm

class HomeViewController: BaseVC {
    
    @IBOutlet weak var viewLogout: UIView!
    @IBOutlet weak var viewGallery: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelMobileNum: UILabel!
    
    var objUser:RObjUser?
    var arrayPhotoURL = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationbarleft_imagename(left_icon_Name: IoniconsType.androidMenu, left_action: #selector(self.btnBackHandle(_:)),
                                            right_icon_Name: IoniconsType.androidSearch,
                                            right_action: #selector(self.btnBackHandle(_:)),
                                            title: "HOME")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        self.viewGallery.shadowAllSides(color: APP_GREY_COLOR)
        self.viewTop.setCornerRadius(radius: 12)
        self.viewGallery.setCornerRadius(radius: 12)
        self.viewLogout.setCornerRadius(radius: 12)
        
        
        
        self.labelUserName.text = "Welcome, " + (objUser?.firstName)! + " " + (objUser?.lastName)!
        let mobileNum = String((objUser?.mobileNum)!)
        self.labelMobileNum.text = "+60 " + mobileNum
        self.navigationController?.setNavigationBarHidden (true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden (true, animated: false)
    }
    //MARK: - button actions
    @IBAction func buttonHandlerEditMobile(_ sender: Any) {
        let alert = UIAlertController(title: "Edit Mobile Number", message: "Enter Mobile Number", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
            textField.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if textField?.text! == ""{
                showAlertWithTitleWithMessage(message: "Please enter mobile number.")
                return
            }else{
                
                if (textField?.text?.length)! > 7 && (textField?.text?.length)! < 11{
                    
                    let num = Int((textField?.text!)!)!
                    let realm = try! Realm()
                    try! realm.write {
                        self.objUser!["mobileNum"] = num
                    }
                    runOnAfterTime(afterTime: 1.0, block: {
                        customeSimpleAlertView(title: "Updated", message: "Number was edited successfully.")
                        let mobileNum = String((self.objUser?.mobileNum)!)
                        self.labelMobileNum.text = "+60 " + mobileNum
                    })
                    
                }else{
                    showAlertWithTitleWithMessage(message: "Please enter valid mobile number.(Mobile number should be 8-10 digits only)")
                }
                
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    //This button action logout the user and navigate back to login screen
    @IBAction func buttonHandlerLogout(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //This button action is used to navigate image displayer screen
    @IBAction func buttonHandlerGallery(_ sender: Any) {
        
        let imageDisplayerVC = loadVC(storyboardMain, viewImageDisplayerVC) as! ImageDisplayerViewController
        self.navigationController?.pushViewController(imageDisplayerVC, animated: true)
        
    }
    
}
