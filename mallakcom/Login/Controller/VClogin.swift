//
//  VClogin.swift
//  mallakcom
//
//  Created by mohave on 9/4/19.
//  Copyright © 2019 mallakcom. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import SkyFloatingLabelTextField
class VClogin: UIViewController , UITextFieldDelegate {
    
    
    
    @IBOutlet weak var BtVerify: MallakButton!
    @IBOutlet weak var BtStart: MallakButton!
    @IBOutlet weak var TePhoneNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var verifyCode: SkyFloatingLabelTextField!
    @IBOutlet weak var LoginStatus: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var loginType: UILabel!
    @IBOutlet weak var loginAsProvider: MallakButton!
    
    var db: Firestore!
    var userType = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        db = Firestore.firestore()


        
        self.hideKeyboardWhenTappedAround()

        
        loading.hidesWhenStopped = true
        loading.stopAnimating()
        
        BtVerify.isEnabled = false
        verifyCode.isEnabled = false
        BtVerify.setTitleColor(.darkGray, for: .normal)
        
        verifyCode.textAlignment = .center
        verifyCode.titleLabel.textAlignment = .center
        
        TePhoneNumber.delegate = self
        verifyCode.delegate = self
        
        TePhoneNumber.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        verifyCode.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        TePhoneNumber.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        verifyCode.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        
        
    }
    
    
    @IBAction func Start(_ sender: Any) {
        
        sendVireficationCode()
        
    }
    
    @IBAction func Resend(_ sender: Any) {
        sendVireficationCode()
    }
    
    
    @IBAction func verify(_ sender: Any) {
        self.loading.startAnimating()
        guard let verifyCode = verifyCode.text?.trimmingCharacters(in: CharacterSet.whitespaces), !verifyCode.isEmpty else {
            self.verifyCode.errorMessage = "Code Here"
            return
        }
        
        
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: verifyCode)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                self.verifyCode.errorMessage = "Invalid Code"
                self.loading.stopAnimating()
                
                return
            }
            else {
                self.LoginStatus.textColor = .green
                self.LoginStatus.text = "Loged In Success"
                self.loading.stopAnimating()
               
                let usertype = String(self.userType)
                let def = UserDefaults.standard
                def.setValue(usertype, forKey: "userType")
                let phoneNumber = "+962" + self.TePhoneNumber.text! 
                def.setValue( phoneNumber , forKey: "phoneNumber")
                def.synchronize()

 
            }
        }
        
        
    }
    
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if  textfield == TePhoneNumber {
                if text.isEmpty {
                    TePhoneNumber.errorMessage = "Please Enter Your Phone Number"
                }
                else
                {
                    TePhoneNumber.errorMessage = ""
                    
                }
            }
            
            
            if  textfield == verifyCode {
                if text.isEmpty {
                    
                    verifyCode.errorMessage = "Code Here"
                }
                else
                {
                    verifyCode.errorMessage = ""
                    
                }
            }
            
        }
    }
    
    @objc func textFieldDidEndEditing(_ textfield: UITextField) {
        verifyCode.errorMessage = ""
        TePhoneNumber.errorMessage = ""
    }
    
    
    func sendVireficationCode() {
        guard let phoneNumber = TePhoneNumber.text?.trimmingCharacters(in: CharacterSet.whitespaces), !phoneNumber.isEmpty else {
            TePhoneNumber.errorMessage = "Phone Number Empty"
            return
        }
        
        let def = UserDefaults.standard
        let usertupe = String(self.userType)
        def.setValue( usertupe, forKey: "userType")
        def.synchronize()

        
        let numberString = phoneNumber
        let numberAsInt = Int(numberString) ?? 0
        var numberTowString = "\(numberAsInt)"
        numberTowString = "+962" + numberTowString
        
        loading.startAnimating()
        
        PhoneAuthProvider.provider().verifyPhoneNumber( numberTowString , uiDelegate: nil) { (verificationID, error) in
            
            if error != nil {
                self.loading.stopAnimating()
                self.showAlert(message: "Please try agane" , title: "Error")
                return
            }
            else{
                self.loading.stopAnimating()
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                //            self.showAlert(message: "Please enter your Verification code is sent to your phone number")
                self.LoginStatus.text = "Please enter your Verification code is sent to your phone number"
                self.BtStart.isEnabled = false
                self.BtStart.setTitleColor(.darkGray, for: .normal)
                
                self.BtVerify.isEnabled = true
                self.verifyCode.isEnabled = true
                self.BtVerify.setTitleColor(.black, for: .normal)
                self.verifyCode.becomeFirstResponder()
            }
        }
        
    }
    
    @IBAction func loginAsProvider(_ sender: Any) {
        
        if loginAsProvider.titleLabel?.text == "Login" {
            loginType.text = "Provider"
            loginAsProvider.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.2549019608, blue: 0.4156862745, alpha: 1)
            loginAsProvider.setTitleColor(.white, for: .normal)
            loginAsProvider.setTitle("As User", for: .normal)
            userType = 2
            let def = UserDefaults.standard
            def.setValue("2", forKey: "userType")
            def.synchronize()


        }
        else {
            loginType.text = "User"
            loginAsProvider.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            loginAsProvider.setTitleColor(.black, for: .normal)
            loginAsProvider.setTitle("Login", for: .normal)
            userType = 3
            let def = UserDefaults.standard
            def.setValue("3", forKey: "userType")
            def.synchronize()


        }
        
    }
    
    
    
    
}
