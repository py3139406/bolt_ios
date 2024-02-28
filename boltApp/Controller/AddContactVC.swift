//
//  AddContactVC.swift
//  Consumer
//
//  Created by Roadcast on 16/12/19.
//  Copyright © 2019 Roadcast. All rights reserved.
//
import UIKit

class AddContactVC: UIViewController {
    
    var addcontactview : AddContactView!
    let kscreenheight = UIScreen.main.bounds.height
    let kscreenwidth = UIScreen.main.bounds.width
    var counter = 0
    var watchId = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addcontactview = AddContactView(frame: view.bounds)
        addcontactview.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1.0)
        self.navigationController?.isNavigationBarHidden = false
        view.addSubview(addcontactview)
        addcontactview.scrollview.isScrollEnabled = false
        addcontactview.addmorecontactButton.addTarget(self, action: #selector(checkforfildverifiction(_:)), for: .touchUpInside)
        
        addcontactview.saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        
        self.navigationController?.navigationBar.isHidden = true
        //addcontactview.scrollview.addmorecontactButton.addTarget(self, action: #selector(bottom), for: .touchUpInside)
        addcontactview.addmorecontactButton.isUserInteractionEnabled = true
        
    }
    
    
    @objc func saveButtonPressed(_ sender : UIButton) {
        
        
        _ = ""
        
        if !(addcontactview.scrollview.firstadminTextField.text?.isEmpty ?? true) {
            
            self.callSendApi(command: "CENTER,\(addcontactview.scrollview.firstadminTextField.text ?? "nothing")")
            
        }
        
        
        if !(addcontactview.scrollview.secondadminTextField.text?.isEmpty ?? true) {
            self.callSendApi(command: "SLAVE,\(addcontactview.scrollview.secondadminTextField.text ?? "nothing")")
            
        }
        
        
        if !(addcontactview.scrollview.sosnumberTextField.text?.isEmpty ?? true) {
            self.callSendApi(command: "SOS,\(addcontactview.scrollview.sosnumberTextField.text ?? "nothing")")
            
        }
        
        
        let contactString = createPhoneNumberStringForFirstFiveNumbers()
        
        self.callSendApi(command: contactString)  //"PHB,\(numberOne)," + "Saanica"
        
        
        
    }
    
    func createPhoneNumberStringForFirstFiveNumbers() -> String {
        
        var contactString = "PHB,"
        var textFieldCollectionPhoneBookOne = [UITextField]()
        var textFieldCollectionNamePhoneBook = [UITextField]()
        
            textFieldCollectionNamePhoneBook.append(addcontactview.scrollview.nameTextField)
        textFieldCollectionNamePhoneBook.append(addcontactview.scrollview.secondnameTextField)
        
         textFieldCollectionNamePhoneBook.append(addcontactview.scrollview.thirdnameTextField)
        
        textFieldCollectionNamePhoneBook.append(addcontactview.scrollview.fourthnameTextField)
        
         textFieldCollectionNamePhoneBook.append(addcontactview.scrollview.fifthnameTextField)
        textFieldCollectionPhoneBookOne.append(addcontactview.scrollview.phonenumberTextField)
         textFieldCollectionPhoneBookOne.append(addcontactview.scrollview.secondphonenumberTextField)
        textFieldCollectionPhoneBookOne.append(addcontactview.scrollview.thirdphonenumberTextField)
        textFieldCollectionPhoneBookOne.append(addcontactview.scrollview.fourthphonenumberTextField)
        
        textFieldCollectionPhoneBookOne.append(addcontactview.scrollview.fifthphonenumberTextField)
        

        
        for i in 0..<textFieldCollectionPhoneBookOne.count {
            
            
            
            if !(textFieldCollectionPhoneBookOne[i].text?.isEmpty ?? true) {
                
                let nameOfPerson = textFieldCollectionNamePhoneBook[i].text!
                let dataenc = nameOfPerson.data(using: String.Encoding.nonLossyASCII)!
                let encodevalue = String(data: dataenc, encoding: String.Encoding.utf8)
            
                
                let number = textFieldCollectionPhoneBookOne[i].text!
                
        
                
                contactString.append("\(number)," + "\(encodevalue ?? "")")
    
            }
        }
        
        return contactString
        
    }
    
    func callSendApi(command: String) {
        
        RCLocalAPIManager.shared.sendCommand(with: watchId, command: command, success: { (_) in
            
            UIApplication.shared.keyWindow?.makeToast("Contacts Added Successfully".toLocalize,
                                                      duration: 2.0, position: .bottom)
            
        }) { (_) in
            
            
            UIApplication.shared.keyWindow?.makeToast("Contacts Failed to Add".toLocalize,
                                                      duration: 2.0, position: .bottom)
            
        }
    }
    
    
    
    
    @objc func checkforfildverifiction(_ sender : UIButton)
    {
        
        if addcontactview.scrollview.phonenumberTextField.text?.count == 0 || addcontactview.scrollview.nameTextField.text?.count == 0
        {
            addcontactview.addmorecontactButton.isUserInteractionEnabled = false
            addcontactview.addmorecontactButton.isUserInteractionEnabled = true
        }
        else{
            addcontactview.scrollview.listcontactsView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 0.8)
            addcontactview.scrollview.isScrollEnabled = true
            view.layoutIfNeeded()
        }
        
        
        
        if addcontactview.scrollview.secondphonenumberTextField.text?.count == 0 || addcontactview.scrollview.secondnameTextField.text?.count == 0
        {
            addcontactview.addmorecontactButton.isUserInteractionEnabled = false
            addcontactview.addmorecontactButton.isUserInteractionEnabled = true
            
        }
        else{
            addcontactview.scrollview.thirdcontactsView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 1.0)
            addcontactview.scrollview.isScrollEnabled = true
            view.layoutIfNeeded()
            
        }
        
        if addcontactview.scrollview.thirdphonenumberTextField.text?.count == 0 || addcontactview.scrollview.thirdnameTextField.text?.count == 0
        {
            addcontactview.addmorecontactButton.isUserInteractionEnabled = false
            addcontactview.addmorecontactButton.isUserInteractionEnabled = true
            
        }
        else{
            addcontactview.scrollview.fourthcontactsView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 1.2)
            addcontactview.scrollview.isScrollEnabled = true
            view.layoutIfNeeded()
        }
        
        
        if addcontactview.scrollview.fourthphonenumberTextField.text?.count == 0 || addcontactview.scrollview.fourthnameTextField.text?.count == 0
        {
            addcontactview.addmorecontactButton.isUserInteractionEnabled = false
            addcontactview.addmorecontactButton.isUserInteractionEnabled = true
            
        }
        else{
            addcontactview.scrollview.fifthcontactsView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 1.45)
            addcontactview.scrollview.isScrollEnabled = true
            view.layoutIfNeeded()
        }
        
        
        if addcontactview.scrollview.fifthnameTextField.text?.count == 0 || addcontactview.scrollview.fifthphonenumberTextField.text?.count == 0
        {
            addcontactview.addmorecontactButton.isUserInteractionEnabled = false
            addcontactview.addmorecontactButton.isUserInteractionEnabled = false
            
        }
        else{
            addcontactview.scrollview.sixcontactsView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 1.65)
            addcontactview.scrollview.isScrollEnabled = true
            view.layoutIfNeeded()
        }
        
        
        if addcontactview.scrollview.sixphonenumberTextField.text?.count == 0 || addcontactview.scrollview.sixnameTextField.text?.count == 0
        {
            addcontactview.addmorecontactButton.isUserInteractionEnabled = false
            addcontactview.addmorecontactButton.isUserInteractionEnabled = true
            
        }
        else{
            addcontactview.scrollview.sevencontactsView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 1.9)
            addcontactview.scrollview.isScrollEnabled = true
            view.layoutIfNeeded()
        }
        
        if addcontactview.scrollview.nameTextField7.text?.count == 0 || addcontactview.scrollview.phonenumberTextField7.text?.count == 0
        {
            addcontactview.addmorecontactButton.isUserInteractionEnabled = false
            addcontactview.addmorecontactButton.isUserInteractionEnabled = true
            
        }
        else{
            addcontactview.scrollview.eightcontactsView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 2.1)
            addcontactview.scrollview.isScrollEnabled = true
            view.layoutIfNeeded()
        }
        
        if addcontactview.scrollview.nameTextField8.text?.count == 0 || addcontactview.scrollview.phonenumberTextField8.text?.count == 0
        {
            addcontactview.addmorecontactButton.isUserInteractionEnabled = false
            addcontactview.addmorecontactButton.isUserInteractionEnabled = true
            
        }
        else{
            addcontactview.scrollview.ninecontactsView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 2.31)
            addcontactview.scrollview.isScrollEnabled = true
            view.layoutIfNeeded()
        }
        
        if addcontactview.scrollview.nameTextField9.text?.count == 0 || addcontactview.scrollview.phonenumberTextField9.text?.count == 0
        {
            addcontactview.addmorecontactButton.isUserInteractionEnabled = false
            addcontactview.addmorecontactButton.isUserInteractionEnabled = true
            
        }
        else{
            addcontactview.scrollview.tencontactsView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 2.53)
            addcontactview.scrollview.isScrollEnabled = true
            view.layoutIfNeeded()
        }
        
        
        
        if addcontactview.scrollview.tenthnameTextField.text?.count == 0 || addcontactview.scrollview.tenthphonenumberTextField.text?.count == 0
        {
            addcontactview.addmorecontactButton.isUserInteractionEnabled = false
            addcontactview.addmorecontactButton.isUserInteractionEnabled = true
            
        }
        else{
            addcontactview.scrollview.tencontactsView.isHidden = false
            addcontactview.addmorecontactButton.isHidden = true
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 2.6)
            addcontactview.scrollview.isScrollEnabled = true
            view.layoutIfNeeded()
            addcontactview.addmorecontactButton.isHidden = true
            
            
        }
    }
    
    
    
    
    
    
    
    
    //            counter+=1
    //            switch counter{
    //            case 1 :
    //
    //
    //                addcontactview.scrollview.listcontactsView.isHidden = false
    //                UIView.animate(withDuration: 0.5) {
    //                    self.view.layoutIfNeeded()
    //                }
    //                addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 0.8)
    //                addcontactview.scrollview.isScrollEnabled = true
    //                view.layoutIfNeeded()
    //
    //
    //            case 2 :
    //                if addcontactview.scrollview.secondphonenumberTextField.text?.count == 0 || addcontactview.scrollview.secondnameTextField.text?.count == 0
    //                {
    //                    addcontactview.addmorecontactButton.isUserInteractionEnabled = false
    //                    let alert = UIAlertController(title: "Alert", message: "Please fill Phone number 2 and name number 2 details to continue and after that you can add more contacts", preferredStyle: UIAlertController.Style.alert)
    //                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    //                    self.present(alert, animated: true, completion: nil)
    //                    addcontactview.addmorecontactButton.isUserInteractionEnabled = true
    //
    //                }
    //                else{
    //
    //
    //                    addcontactview.scrollview.thirdcontactsView.isHidden = false
    //                                   UIView.animate(withDuration: 0.5) {
    //                                       self.view.layoutIfNeeded()
    //                                   }
    //                    addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 1.0)
    //                                   addcontactview.scrollview.isScrollEnabled = true
    //                                   view.layoutIfNeeded()
    //
    //                }
    //
    //
    //
    //
    //                case 3 :
    //
    //
    //
    //                              addcontactview.scrollview.fourthcontactsView.isHidden = false
    //                                             UIView.animate(withDuration: 0.5) {
    //                                                 self.view.layoutIfNeeded()
    //                                             }
    //                              addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 1.2)
    //                                             addcontactview.scrollview.isScrollEnabled = true
    //                                                view.layoutIfNeeded()
    //
    //                case 4 :
    //
    //
    //
    //                                             addcontactview.scrollview.fifthcontactsView.isHidden = false
    //                                                            UIView.animate(withDuration: 0.5) {
    //                                                                self.view.layoutIfNeeded()
    //                                                            }
    //                                             addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 1.45)
    //                                                            addcontactview.scrollview.isScrollEnabled = true
    //                                                               view.layoutIfNeeded()
    //
    //
    //                case 5 :
    //
    //                                             addcontactview.scrollview.sixcontactsView.isHidden = false
    //                                                            UIView.animate(withDuration: 0.5) {
    //                                                                self.view.layoutIfNeeded()
    //                                                            }
    //                                             addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 1.65)
    //                                                            addcontactview.scrollview.isScrollEnabled = true
    //                                                               view.layoutIfNeeded()
    //
    //                case 6 :
    //
    //
    //                                             addcontactview.scrollview.sevencontactsView.isHidden = false
    //                                                            UIView.animate(withDuration: 0.5) {
    //                                                                self.view.layoutIfNeeded()
    //                                                            }
    //                                             addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 1.9)
    //                                                            addcontactview.scrollview.isScrollEnabled = true
    //                                                               view.layoutIfNeeded()
    //
    //                case 7 :
    //
    //                                             addcontactview.scrollview.eightcontactsView.isHidden = false
    //                                                            UIView.animate(withDuration: 0.5) {
    //                                                                self.view.layoutIfNeeded()
    //                                                            }
    //                                             addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 2.1)
    //                                                            addcontactview.scrollview.isScrollEnabled = true
    //                                                               view.layoutIfNeeded()
    //
    //                case 8 :
    //
    //
    //                                             addcontactview.scrollview.ninecontactsView.isHidden = false
    //                                                            UIView.animate(withDuration: 0.5) {
    //                                                                self.view.layoutIfNeeded()
    //                                                            }
    //                                             addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 2.4)
    //                                                            addcontactview.scrollview.isScrollEnabled = true
    //                                                               view.layoutIfNeeded()
    //
    //            default:
    //
    //                                             addcontactview.scrollview.tencontactsView.isHidden = false
    //                                                            UIView.animate(withDuration: 0.5) {
    //                                                                self.view.layoutIfNeeded()
    //                                                            }
    //                                             addcontactview.scrollview.contentSize = CGSize(width: kscreenwidth * 1.0, height: kscreenheight * 2.6)
    //                                                            addcontactview.scrollview.isScrollEnabled = true
    //                                                               view.layoutIfNeeded()
    //                                             addcontactview.addmorecontactButton.isHidden = true
    //
    //
    //
    //
    //            }
    
}






