//
//  VCeditProfile.swift
//  mallakcom
//
//  Created by mohave on 9/10/19.
//  Copyright © 2019 mallakcom. All rights reserved.
//

import UIKit
import YNExpandableCell
import Firebase
import FirebaseMessaging
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import CodableFirebase



class VCeditProfile: UIViewController , YNTableViewDelegate  {
    
    var db: Firestore!
    var model: profileInfo!
    var modelAddress: Address?
    @IBOutlet weak var ynTableView: YNTableView!
    var row : Int!
    let list = ["Edit Info","Address","Country:Language","Contact Us","LogOut"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        row = 0
        NSLog("ahmadsaleh")
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        
        let cells = ["YNExpandableCellEx","YNSliderCell","YNSegmentCell"]
        ynTableView.registerCellsWith(nibNames: cells, and: cells)
        ynTableView.registerCellsWith(cells: [UITableViewCell.self as AnyClass], and: ["YNNonExpandableCell"])
        ynTableView.ynDelegate = self
        ynTableView.ynTableViewRowAnimation = .middle
        
        
        getProfileInfo()
        getProfileAddress ()
    }
    
    func tableView(_ tableView: YNTableView, expandCellWithHeightAt indexPath: IndexPath) -> YNTableViewCell? {
        let ynSegmentCell = YNTableViewCell()
        ynSegmentCell.cell = tableView.dequeueReusableCell(withIdentifier: YNSegmentCell.ID ) as! YNSegmentCell
        ynSegmentCell.height = 320
        
        
        let unSliderCell = YNTableViewCell()
        unSliderCell.cell = tableView.dequeueReusableCell(withIdentifier: YNSliderCell.ID) as! YNSliderCell
        unSliderCell.height = 366
        
        
        if indexPath.section == 0 && indexPath.row == 0 {
            return ynSegmentCell
        } else if indexPath.section == 0 && indexPath.row == 1 {
            return unSliderCell
        } else if indexPath.section == 0 && indexPath.row == 2 {
            return nil
        } else if indexPath.section == 0 && indexPath.row == 3 {
            return nil
        } else if indexPath.section == 0 && indexPath.row == 4 {
            return nil
        }
        
        return nil
    }
    
    func tableView(_ tableView: YNTableView, expandCellAt indexPath: IndexPath) -> UITableViewCell? {
        
        let ynSegmentCell = YNTableViewCell()
        ynSegmentCell.cell = tableView.dequeueReusableCell(withIdentifier: YNSegmentCell.ID) as! YNSegmentCell
        let cell = tableView.dequeueReusableCell(withIdentifier: YNSegmentCell.ID) as! YNSegmentCell
        
        let button:UIButton = cell.viewWithTag(12) as! UIButton
        button.addTarget(self, action: #selector(ButtonClick), for: .touchUpInside)
        
    
        cell.Fname.text = self.model.firstName
        cell.Lname.text = self.model.lastName
        cell.Phone.text = self.model.phoneNumber
        cell.Email.text = self.model.emailAddress
        
       
        
        let ynSliderCell = YNTableViewCell()
        ynSliderCell.cell = tableView.dequeueReusableCell(withIdentifier: YNSliderCell.ID) as! YNSliderCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: YNSliderCell.ID) as! YNSliderCell
        cell2.Address.text = self.modelAddress?.Address
        cell2.City.text = self.modelAddress?.City
        cell2.Ditails.text = self.modelAddress?.Details
        cell2.flatNo.text = self.modelAddress?.FlatNo
        cell2.appartmentNo.text = self.modelAddress?.AppartmentNo
        
        let button2:UIButton = cell2.viewWithTag(13) as! UIButton
        button2.addTarget(self, action: #selector(ButtonClickAddress), for: .touchUpInside)
        
        
        ynSliderCell.cell = cell2
        ynSegmentCell.cell = cell
        
        if indexPath.section == 0 && indexPath.row == 0 {
            return ynSegmentCell.cell
        } else if indexPath.section == 0 && indexPath.row == 1 {
            return ynSliderCell.cell
        }
 
        return nil
    }
    
    
    //هاي شو اسم السيل من برى
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expandableCell = tableView.dequeueReusableCell(withIdentifier: YNExpandableCellEx.ID) as! YNExpandableCellEx
        
  
        if indexPath.section == 0 && indexPath.row == 0 {
            expandableCell.titleLabel.text = "Profile"
            expandableCell.normalCustomAccessoryType.image = UIImage(named: "icons8-registration-50")
            expandableCell.selectedCustomAccessoryType.image = UIImage(named: "icons8-registration-50")
            
            
            return expandableCell
            
        }
        else if indexPath.section == 0 && indexPath.row == 1 {
            expandableCell.titleLabel.text = "Address"
            expandableCell.normalCustomAccessoryType.image = UIImage(named: "icons8-address-50")
            expandableCell.selectedCustomAccessoryType.image = UIImage(named: "icons8-address-50")
            
            return expandableCell
        }
        else if indexPath.section == 0 && indexPath.row == 2 {
            
            expandableCell.titleLabel.text = "Language"
            expandableCell.normalCustomAccessoryType.image = UIImage(named: "icons8-english-to-arabic-50")
            expandableCell.selectedCustomAccessoryType.image = UIImage(named: "icons8-english-to-arabic-50")
            
            return expandableCell
            
            
            
        }
        else if indexPath.section == 0 && indexPath.row == 3 {
            
            expandableCell.titleLabel.text = "Contact Us"
            expandableCell.normalCustomAccessoryType.image = UIImage(named: "icons8-contact-us-50")
            expandableCell.selectedCustomAccessoryType.image = UIImage(named: "icons8-contact-us-50")
            
            return expandableCell
            
        }
        else if indexPath.section == 0 && indexPath.row == 4 {
            
            expandableCell.titleLabel.text = "Sign Out"
            expandableCell.normalCustomAccessoryType.image = UIImage(named: "icons8-export-50")
            expandableCell.selectedCustomAccessoryType.image = UIImage(named: "icons8-export-50")
            
            return expandableCell
            
        }
        
        
        
        return expandableCell
        
        
    }
    
    func tableView(_ tableView: YNTableView, didSelectRowAt indexPath: IndexPath, isExpandableCell: Bool, isExpandedCell: Bool) {
        //        print("Selected Section: \(indexPath.section) Row: \(indexPath.row) isExpandableCell: \(isExpandableCell) isExpandedCell: \(isExpandedCell)")
        if isExpandableCell{
            self.row = self.row + 1
        }
        print(indexPath.row)

        if indexPath.section == 0 && indexPath.row == 4 + self.row {
            do{
                print("Signed Out")
                try? Auth.auth().signOut()
            }
        }
    }
    
    func tableView(_ tableView: YNTableView, didDeselectRowAt indexPath: IndexPath, isExpandableCell: Bool, isExpandedCell: Bool) {
        //        print("Deselected Section: \(indexPath.section) Row: \(indexPath.row) isExpandableCell: \(isExpandableCell) isExpandedCell: \(isExpandedCell)")
        
        if isExpandableCell{
            self.row = self.row - 1
        }
        print(indexPath.row)
        if indexPath.section == 0 && indexPath.row  == 4 + self.row{
            do{
                print("Signed Out")
                try? Auth.auth().signOut()
            }
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Settings"
    }
    
    
    func getProfileInfo () {
        API.sharedInstance.getProfileInfo(onSuccess: { (profileInfo) in
            self.model = profileInfo
            self.ynTableView.reloadData()
        }) { (Error) in
            print(Error?.localizedDescription)
        }
    }
    
    func getProfileAddress () {
        API.sharedInstance.getAddress(onSuccess: { (Address) in
            self.modelAddress = Address
            self.ynTableView.reloadData()
        }) { (Error) in
            
        }
    }
    
    func updateProfileInfo () {
        let cell = ynTableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! YNSegmentCell
        let parameter : [String : String] = [
            "emailAddress":cell.Email.text!,
            "firstName":cell.Fname.text!,
            "lastName":cell.Lname.text!,
            "phoneNumber":cell.Phone.text!
        ]
        API.sharedInstance.setProfileInfo(parameter: parameter, onSuccess: { (Bool) in
            if Bool == true {
                self.showAlert(message: "Updated Profile Info")
self.getProfileInfo()
                
            }
        }) { (Error) in
            self.showAlert(message: "Please Try Agane")
            
        }
        
        
    }
    @objc func ButtonClick(_ sender: Any)  {
        self.updateProfileInfo()
    }
    
    func updateAddress () {
 let rowInt = 1 + self.row
        print(rowInt)
         let cell = ynTableView.cellForRow(at: IndexPath.init(row: rowInt , section: 0)) as! YNSliderCell
        
        
        let parameter : [String : String] = [
            "Address":cell.Address.text!,
            "City":cell.City.text!,
            "AppartmentNo":cell.appartmentNo.text!,
            "Details":cell.Ditails.text!,
            "FlatNo":cell.flatNo.text!
        ]

        API.sharedInstance.updateAddress(parameter: parameter, onSuccess: { (Bool) in
            if Bool == true {
                self.showAlert(message: "Updated Address")
                self.getProfileAddress()
                
            }

        }) { (Error) in
            self.showAlert(message: "Please Try Agane")

        }
        
    }
    
    @objc func ButtonClickAddress(_ sender: Any)  {
        self.updateAddress()
    }
    
    
}

