//
//  VCsignUp.swift
//  mallakcom
//
//  Created by mohave on 9/6/19.
//  Copyright © 2019 mallakcom. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class VCsignUp: UIViewController , UITextFieldDelegate{
    
    var db: Firestore!
    
    
    @IBOutlet weak var BtMail: MallakButton!
    @IBOutlet weak var BtFemail: MallakButton!
    @IBOutlet weak var BtSubmit: MallakButton2!
    
    @IBOutlet weak var TextFname: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var TextLname: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var DateOfBirth: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var TextEmail: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var TextPhoneNumber: SkyFloatingLabelTextFieldWithIcon!
    
    
    
    var Gender : Int!
    var genderSelected : Int = 0
    
    let datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        
        let def = UserDefaults.standard
let phone = def.object(forKey: "phoneNumber") as? String
        TextPhoneNumber.text = phone
        
        

        
        self.hideKeyboardWhenTappedAround()
        
        showDatePicker()
        
        TextEmail.delegate = self
        TextPhoneNumber.delegate = self
        TextLname.delegate = self
        TextFname.delegate = self
        DateOfBirth.delegate = self
        
        TextEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        TextPhoneNumber.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        TextLname.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        TextFname.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        DateOfBirth.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        
        
    }
    
    @IBAction func mail(_ sender: UIButton) {
        
        if sender.isSelected != !sender.isSelected
        {
            sender.isSelected = !sender.isSelected
            BtMail.backgroundColor = #colorLiteral(red: 0.1016548041, green: 0.1074270964, blue: 0.3822176396, alpha: 1)
            BtMail.tintColor = #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.3803921569, alpha: 1)
            BtFemail.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            BtMail.setTitleColor(.white, for: .normal)
            BtFemail.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            BtFemail.isSelected = false
        }
        self.genderSelected = 1
    }
    
    
    
    @IBAction func femail(_ sender: UIButton) {
        if sender.isSelected != !sender.isSelected
        {
            sender.isSelected = !sender.isSelected
            BtMail.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            BtFemail.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.3803921569, alpha: 1)
            BtFemail.tintColor = #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.3803921569, alpha: 1)
            BtFemail.setTitleColor(.white, for: .normal)
            BtMail.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            
            BtMail.isSelected = false
        }
        self.genderSelected = 2
        
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        DateOfBirth.inputAccessoryView = toolbar
        DateOfBirth.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        DateOfBirth.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    @objc func textFieldDidChange(_ textfield: SkyFloatingLabelTextFieldWithIcon) {
       
        if let text = textfield.text {
            if  textfield == TextEmail {
                if text.isEmpty {
                    TextEmail.errorMessage = "Please Enter Your Email"
                }
                else
                {
                    TextEmail.errorMessage = ""
                    if isValidEmail(testStr: text){
                        TextEmail.errorMessage = ""
                        
                    }
                    else {
                        TextEmail.errorMessage = "Please Enter Valide Email"
                        
                    }
                }
            }
            else {
                if text.isEmpty {
                    textfield.errorMessage = "This Field Required"
                }
                else {
                    textfield.errorMessage = ""

                }
            }
            
            
        }
        
        
        
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    @IBAction func SubmitSignUp(_ sender: Any) {
        
        guard let Fname = TextFname.text, !(TextFname.text?.isEmpty)! else {
            self.TextFname.becomeFirstResponder()
            self.TextFname.errorMessage = "Please Enter Your First Name"
            return
        }
        
        guard let Lname = TextLname.text, !(TextLname.text?.isEmpty)! else {
            self.TextLname.becomeFirstResponder()
            self.TextLname.errorMessage = "Please Enter Your Last Name"
            return
        }
        
        guard let Dob = DateOfBirth.text, !(DateOfBirth.text?.isEmpty)! else {             self.DateOfBirth.becomeFirstResponder()
            self.DateOfBirth.errorMessage = "Please Enter Your Date Of Birth"

            return
        }
        
        if genderSelected == 0 {
self.showAlert(message: "Please Select Your Gender")
            return
        }
        
        guard let Email = TextEmail.text, !(TextEmail.text?.isEmpty)! else {
            
            self.TextEmail.becomeFirstResponder()
            self.TextEmail.errorMessage = "Please Enter Your Email"

            return
        }
        if isValidEmail(testStr: TextEmail.text!){
            print("corruct email")
        }
        else {
            self.TextEmail.errorMessage = "Please Enter Your Valid Email"

            return
        }

        
        guard let PhoneNumber = TextPhoneNumber.text, !(TextPhoneNumber.text?.isEmpty)! else { self.TextPhoneNumber.becomeFirstResponder()
            self.TextPhoneNumber.errorMessage = "Please Enter Your Phone Number"

            return
        }
        var genderString = ""
        if genderSelected == 1 {
            genderString = "Mail"

        }
        else if genderSelected == 2
        {
            genderString = "Fmail"
        }
        let def = UserDefaults.standard

        let parameter: [String : Any] = [
            "firstName": Fname,
            "lastName": Lname,
            "birthOfDate": Dob ,
            "gender": genderString,
            "emailAddress": Email,
            "phoneNumber": PhoneNumber,
            "userType": "Customer",
            "platform": "iOS"
        ]
       let uid = Auth.auth().currentUser?.uid

        if  let userType : String = def.object(forKey: "userType") as? String  {
            switch userType {
            case "2":
                db.collection(Strings.providers).document(uid!).setData(parameter) { (Error) in
                    if Error != nil {
                        self.showAlert(message: "Please try agane" , title: "Error")
                    }
                    else
                    {
                        let def = UserDefaults.standard
                        
                        def.setValue("2", forKey: "userTypeAfterLogin")
                        def.synchronize()
                        let storyboard = UIStoryboard(name: "SThomeProvider", bundle: nil)
                        let controller = storyboard.instantiateInitialViewController()
                        self.present(controller!, animated: true, completion: nil)

                    }
                    
                }

            case "3":
                db.collection(Strings.users).document(uid!).setData(parameter) { (Error) in
                    if Error != nil {
                        self.showAlert(message: "Please try agane" , title: "Error")
                    }
                    else
                    {
                        let def = UserDefaults.standard
                        def.setValue("3", forKey: "userTypeAfterLogin")
                        def.synchronize()
                        let storyboard = UIStoryboard(name: "SThomeUser", bundle: nil)
                        let controller = storyboard.instantiateInitialViewController()
                        self.present(controller!, animated: true, completion: nil)

                    }
                    
                }

            default:
                print("not user or provider !!")
            }
        }
        
        
        
        
    }
    
}



