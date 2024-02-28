//
//  AddContactScrollView.swift
//  Consumer
//
//  Created by Roadcast on 19/12/19.
//  Copyright © 2019 Roadcast. All rights reserved.
//

import UIKit

class AddContactScrollView: UIScrollView {

    
      let kscreenheight = UIScreen.main.bounds.height
      let kscreenwidth = UIScreen.main.bounds.width
      var contactsView : UIView!
    var listcontactsView : UIView!
     
      var firstadminLabel : UILabel!
      var firstadminTextField : UITextField!
      var secondadminLabel : UILabel!
      var secondadminTextField : UITextField!
      var sosnumberLabel : UILabel!
      var sosnumberTextField : UITextField!
      var phonenumberLabel : UILabel!
      var phonenumberTextField : UITextField!
      var nameLabel : UILabel!
      var nameTextField : UITextField!
      var secondphonenumberLabel : UILabel!
      var secondphonenumberTextField : UITextField!
      var secondnameLabel : UILabel!
      var secondnameTextField : UITextField!
      var thirdcontactsView : UIView!
      var thirdphonenumberLabel : UILabel!
      var thirdphonenumberTextField : UITextField!
      var thirdnameLabel : UILabel!
      var thirdnameTextField : UITextField!
    var fourthcontactsView : UIView!
    var fourthphonenumberLabel : UILabel!
    var fourthphonenumberTextField : UITextField!
    var fourthnameLabel : UILabel!
    var fourthnameTextField : UITextField!
    var fifthcontactsView : UIView!
    var fifthphonenumberLabel : UILabel!
    var fifthphonenumberTextField : UITextField!
    var fifthnameLabel : UILabel!
    var fifthnameTextField : UITextField!
    var sixcontactsView : UIView!
    var sixphonenumberLabel : UILabel!
    var sixphonenumberTextField : UITextField!
    var sixnameLabel : UILabel!
    var sixnameTextField : UITextField!
    var sevencontactsView : UIView!
    var phonenumberLabel7 : UILabel!
    var phonenumberTextField7 : UITextField!
    var nameLabel7 : UILabel!
    var nameTextField7 : UITextField!
    var eightcontactsView : UIView!
    var phonenumberLabel8 : UILabel!
    var phonenumberTextField8 : UITextField!
    var nameLabel8 : UILabel!
    var nameTextField8 : UITextField!
    var ninecontactsView : UIView!
    var phonenumberLabel9 : UILabel!
    var phonenumberTextField9 : UITextField!
    var nameLabel9 : UILabel!
    var nameTextField9 : UITextField!
    var tencontactsView : UIView!
    var tenthphonenumberLabel : UILabel!
    var tenthphonenumberTextField : UITextField!
    var tenthnameLabel : UILabel!
    var tenthnameTextField : UITextField!
//      var addmorecontactButton : UIButton!
//      var saveButton : UIButton!
      var lineView : UIView!
    var secthirView : UIView!
      
     override init(frame: CGRect) {
            super.init(frame: frame)
            addviews()
            addmakeConstraints()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
      func addviews()
      {   contactsView = UIView(frame: CGRect.zero)
          contactsView.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1.0)
          addSubview(contactsView)
                    
          firstadminLabel = UILabel(frame: CGRect.zero)
          firstadminLabel.text = "Admin number 1"
          firstadminLabel.textColor = .white
          firstadminLabel.textAlignment = .center
          contactsView.addSubview(firstadminLabel)
          
          firstadminTextField = UITextField(frame: CGRect.zero)
          firstadminTextField.placeholder = "Mobile Number"
          firstadminTextField.clearButtonMode = .whileEditing
          firstadminTextField.adjustsFontSizeToFitWidth = true
          firstadminTextField.keyboardType = .numberPad
          firstadminTextField.backgroundColor = .white
          firstadminTextField.textAlignment = .center
          firstadminTextField.layer.cornerRadius = 5
          firstadminTextField.spellCheckingType = .default
          contactsView.addSubview(firstadminTextField)
          
          secondadminLabel = UILabel(frame: CGRect.zero)
          secondadminLabel.text = "Admin number 2"
          secondadminLabel.textColor = .white
          secondadminLabel.textAlignment = .center
          contactsView.addSubview(secondadminLabel)
          
          secondadminTextField = UITextField(frame: CGRect.zero)
          secondadminTextField.placeholder = "Mobile Number"
          secondadminTextField.clearButtonMode = .whileEditing
          secondadminTextField.adjustsFontSizeToFitWidth = true
          secondadminTextField.layer.cornerRadius = 5
          secondadminTextField.keyboardType = .numberPad
          secondadminTextField.backgroundColor = .white
          secondadminTextField.textAlignment = .center
          secondadminTextField.spellCheckingType = .default
          contactsView.addSubview(secondadminTextField)
          
          sosnumberLabel = UILabel(frame: CGRect.zero)
          sosnumberLabel.text = "SOS number"
          sosnumberLabel.textColor = .white
          sosnumberLabel.textAlignment = .center
          contactsView.addSubview(sosnumberLabel)
          
          sosnumberTextField = UITextField(frame: CGRect.zero)
          sosnumberTextField.placeholder = "Mobile Number"
          sosnumberTextField.clearButtonMode = .whileEditing
          sosnumberTextField.adjustsFontSizeToFitWidth = true
          sosnumberTextField.layer.cornerRadius = 5
          sosnumberTextField.backgroundColor = .white
          sosnumberTextField.textAlignment = .center
          sosnumberTextField.keyboardType = .numberPad
          sosnumberTextField.spellCheckingType = .default
          contactsView.addSubview(sosnumberTextField)
          
          phonenumberLabel = UILabel(frame: CGRect.zero)
          phonenumberLabel.text = "Phone number"
          phonenumberLabel.textColor = .white
          phonenumberLabel.textAlignment = .center
          contactsView.addSubview(phonenumberLabel)
          
          phonenumberTextField = UITextField(frame: CGRect.zero)
          phonenumberTextField.placeholder = "Mobile Number"
          phonenumberTextField.clearButtonMode = .whileEditing
          phonenumberTextField.adjustsFontSizeToFitWidth = true
          phonenumberTextField.layer.cornerRadius = 5
          phonenumberTextField.backgroundColor = .white
          phonenumberTextField.textAlignment = .center
          phonenumberTextField.keyboardType = .numberPad
          phonenumberTextField.spellCheckingType = .default
          contactsView.addSubview(phonenumberTextField)
          
          nameLabel = UILabel(frame: CGRect.zero)
          nameLabel.text = "Name"
          nameLabel.textColor = .white
          nameLabel.textAlignment = .center
          contactsView.addSubview(nameLabel)
          
          nameTextField = UITextField(frame: CGRect.zero)
          nameTextField.placeholder = "Name"
          nameTextField.clearButtonMode = .whileEditing
          nameTextField.adjustsFontSizeToFitWidth = true
          nameTextField.layer.cornerRadius = 5
          nameTextField.backgroundColor = .white
          nameTextField.textAlignment = .center
          nameTextField.keyboardType = .default
          nameTextField.spellCheckingType = .default
          contactsView.addSubview(nameTextField)
        
        listcontactsView = UIView(frame: CGRect.zero)
        listcontactsView.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1.0)
        listcontactsView.isHidden = true
        addSubview(listcontactsView)
          
          secondphonenumberLabel = UILabel(frame: CGRect.zero)
          secondphonenumberLabel.text = "Phone number 2"
          secondphonenumberLabel.textColor = .white
          secondphonenumberLabel.textAlignment = .center
        listcontactsView.addSubview(secondphonenumberLabel)
             
          secondphonenumberTextField = UITextField(frame: CGRect.zero)
          secondphonenumberTextField.placeholder = "Mobile Number 2"
          secondphonenumberTextField.clearButtonMode = .whileEditing
          secondphonenumberTextField.adjustsFontSizeToFitWidth = true
          secondphonenumberTextField.layer.cornerRadius = 5
          secondphonenumberTextField.backgroundColor = .white
          //secondphonenumberTextField.isHidden = true
          secondphonenumberTextField.textAlignment = .center
          secondphonenumberTextField.keyboardType = .numberPad
          secondphonenumberTextField.spellCheckingType = .default
          listcontactsView.addSubview(secondphonenumberTextField)
          
          secondnameLabel = UILabel(frame: CGRect.zero)
          secondnameLabel.text = "Name 2"
          secondnameLabel.textColor = .white
          //secondnameLabel.isHidden = true
          secondnameLabel.textAlignment = .center
         listcontactsView.addSubview(secondnameLabel)
          
          secondnameTextField = UITextField(frame: CGRect.zero)
          secondnameTextField.placeholder = "Name 2"
          secondnameTextField.clearButtonMode = .whileEditing
          secondnameTextField.adjustsFontSizeToFitWidth = true
          secondnameTextField.layer.cornerRadius = 5
          //secondnameTextField.isHidden = true
          secondnameTextField.backgroundColor = .white
          secondnameTextField.textAlignment = .center
          secondnameTextField.keyboardType = .default
          secondnameTextField.spellCheckingType = .default
         listcontactsView.addSubview(secondnameTextField)
          
        thirdcontactsView = UIView(frame: CGRect.zero)
            thirdcontactsView.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1.0)
               thirdcontactsView.isHidden = true
            addSubview(thirdcontactsView)
        
        
          thirdphonenumberLabel = UILabel(frame: CGRect.zero)
          thirdphonenumberLabel.text = "Phone number 3"
          thirdphonenumberLabel.textColor = .white
        //thirdphonenumberLabel.isHidden = true
          thirdphonenumberLabel.textAlignment = .center
         thirdcontactsView.addSubview(thirdphonenumberLabel)
             
          thirdphonenumberTextField = UITextField(frame: CGRect.zero)
          thirdphonenumberTextField.placeholder = "Mobile Number 3"
          thirdphonenumberTextField.clearButtonMode = .whileEditing
          thirdphonenumberTextField.adjustsFontSizeToFitWidth = true
          thirdphonenumberTextField.layer.cornerRadius = 5
          //thirdphonenumberTextField.isHidden = true
          thirdphonenumberTextField.backgroundColor = .white
          thirdphonenumberTextField.textAlignment = .center
          thirdphonenumberTextField.keyboardType = .numberPad
          thirdphonenumberTextField.spellCheckingType = .default
          thirdcontactsView.addSubview(thirdphonenumberTextField)
          
          thirdnameLabel = UILabel(frame: CGRect.zero)
          thirdnameLabel.text = "Name 3"
          thirdnameLabel.textColor = .white
        //thirdnameLabel.isHidden = true
          thirdnameLabel.textAlignment = .center
          thirdcontactsView.addSubview(thirdnameLabel)
          
          thirdnameTextField = UITextField(frame: CGRect.zero)
          thirdnameTextField.placeholder = "Name 3"
          thirdnameTextField.clearButtonMode = .whileEditing
          thirdnameTextField.adjustsFontSizeToFitWidth = true
        //thirdnameTextField.isHidden = true
          thirdnameTextField.layer.cornerRadius = 5
          thirdnameTextField.backgroundColor = .white
          thirdnameTextField.textAlignment = .center
          thirdnameTextField.keyboardType = .default
          thirdnameTextField.spellCheckingType = .default
          thirdcontactsView.addSubview(thirdnameTextField)
        
        fourthcontactsView = UIView(frame: CGRect.zero)
        fourthcontactsView.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1.0)
           fourthcontactsView.isHidden = true
            addSubview(fourthcontactsView)
        
        fourthphonenumberLabel = UILabel(frame: CGRect.zero)
        fourthphonenumberLabel.text = "Phone number 4"
        fourthphonenumberLabel.textColor = .white
        fourthphonenumberLabel.textAlignment = .center
        fourthcontactsView.addSubview(fourthphonenumberLabel)
        
        fourthphonenumberTextField = UITextField(frame: CGRect.zero)
        fourthphonenumberTextField.placeholder = "Mobile Number 4"
        fourthphonenumberTextField.clearButtonMode = .whileEditing
        fourthphonenumberTextField.adjustsFontSizeToFitWidth = true
        fourthphonenumberTextField.layer.cornerRadius = 5
        fourthphonenumberTextField.backgroundColor = .white
        fourthphonenumberTextField.textAlignment = .center
        fourthphonenumberTextField.keyboardType = .numberPad
        fourthphonenumberTextField.spellCheckingType = .default
        fourthcontactsView.addSubview(fourthphonenumberTextField)
        
        fourthnameLabel = UILabel(frame: CGRect.zero)
        fourthnameLabel.text = "Name 4"
        fourthnameLabel.textColor = .white
        fourthnameLabel.textAlignment = .center
        fourthcontactsView.addSubview(fourthnameLabel)
        
        fourthnameTextField = UITextField(frame: CGRect.zero)
        fourthnameTextField.placeholder = "Name 4"
        fourthnameTextField.clearButtonMode = .whileEditing
        fourthnameTextField.adjustsFontSizeToFitWidth = true
        fourthnameTextField.layer.cornerRadius = 5
        fourthnameTextField.backgroundColor = .white
        fourthnameTextField.textAlignment = .center
        fourthnameTextField.keyboardType = .default
        fourthnameTextField.spellCheckingType = .default
        fourthcontactsView.addSubview(fourthnameTextField)
        
        fifthcontactsView = UIView(frame: CGRect.zero)
        fifthcontactsView.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1.0)
           fifthcontactsView.isHidden = true
          addSubview(fifthcontactsView)
        
        fifthphonenumberLabel = UILabel(frame: CGRect.zero)
           fifthphonenumberLabel.text = "Phone number 5"
           fifthphonenumberLabel.textColor = .white
           fifthphonenumberLabel.textAlignment = .center
           fifthcontactsView.addSubview(fifthphonenumberLabel)
           
           fifthphonenumberTextField = UITextField(frame: CGRect.zero)
           fifthphonenumberTextField.placeholder = "Mobile Number 5"
           fifthphonenumberTextField.clearButtonMode = .whileEditing
           fifthphonenumberTextField.adjustsFontSizeToFitWidth = true
           fifthphonenumberTextField.layer.cornerRadius = 5
           fifthphonenumberTextField.backgroundColor = .white
           fifthphonenumberTextField.textAlignment = .center
           fifthphonenumberTextField.keyboardType = .numberPad
           fifthphonenumberTextField.spellCheckingType = .default
           fifthcontactsView.addSubview(fifthphonenumberTextField)
           
           fifthnameLabel = UILabel(frame: CGRect.zero)
           fifthnameLabel.text = "Name 5"
           fifthnameLabel.textColor = .white
           fifthnameLabel.textAlignment = .center
           fifthcontactsView.addSubview(fifthnameLabel)
           
           fifthnameTextField = UITextField(frame: CGRect.zero)
           fifthnameTextField.placeholder = "Name 5"
           fifthnameTextField.clearButtonMode = .whileEditing
           fifthnameTextField.adjustsFontSizeToFitWidth = true
           fifthnameTextField.layer.cornerRadius = 5
           fifthnameTextField.backgroundColor = .white
           fifthnameTextField.textAlignment = .center
           fifthnameTextField.keyboardType = .default
           fifthnameTextField.spellCheckingType = .default
           fifthcontactsView.addSubview(fifthnameTextField)
        
        sixcontactsView = UIView(frame: CGRect.zero)
        sixcontactsView.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1.0)
           sixcontactsView.isHidden = true
        addSubview(sixcontactsView)
        
              sixphonenumberLabel = UILabel(frame: CGRect.zero)
              sixphonenumberLabel.text = "Phone number 6"
              sixphonenumberLabel.textColor = .white
              sixphonenumberLabel.textAlignment = .center
              sixcontactsView.addSubview(sixphonenumberLabel)
              
              sixphonenumberTextField = UITextField(frame: CGRect.zero)
              sixphonenumberTextField.placeholder = "Mobile Number 6"
              sixphonenumberTextField.clearButtonMode = .whileEditing
              sixphonenumberTextField.adjustsFontSizeToFitWidth = true
              sixphonenumberTextField.layer.cornerRadius = 5
              sixphonenumberTextField.backgroundColor = .white
              sixphonenumberTextField.textAlignment = .center
              sixphonenumberTextField.keyboardType = .numberPad
              sixphonenumberTextField.spellCheckingType = .default
              sixcontactsView.addSubview(sixphonenumberTextField)
              
              sixnameLabel = UILabel(frame: CGRect.zero)
              sixnameLabel.text = "Name 6"
              sixnameLabel.textColor = .white
              sixnameLabel.textAlignment = .center
              sixcontactsView.addSubview(sixnameLabel)
              
              sixnameTextField = UITextField(frame: CGRect.zero)
              sixnameTextField.placeholder = "Name 6"
              sixnameTextField.clearButtonMode = .whileEditing
              sixnameTextField.adjustsFontSizeToFitWidth = true
              sixnameTextField.layer.cornerRadius = 5
              sixnameTextField.backgroundColor = .white
              sixnameTextField.textAlignment = .center
              sixnameTextField.keyboardType = .default
              sixnameTextField.spellCheckingType = .default
              sixcontactsView.addSubview(sixnameTextField)
        
        sevencontactsView = UIView(frame: CGRect.zero)
        sevencontactsView.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1.0)
           sevencontactsView.isHidden = true
           addSubview(sevencontactsView)
        
        phonenumberLabel7 = UILabel(frame: CGRect.zero)
        phonenumberLabel7.text = "Phone number 7"
        phonenumberLabel7.textColor = .white
        phonenumberLabel7.textAlignment = .center
        sevencontactsView.addSubview(phonenumberLabel7)
        
        phonenumberTextField7 = UITextField(frame: CGRect.zero)
        phonenumberTextField7.placeholder = "Mobile Number 7"
        phonenumberTextField7.clearButtonMode = .whileEditing
        phonenumberTextField7.adjustsFontSizeToFitWidth = true
        phonenumberTextField7.layer.cornerRadius = 5
        phonenumberTextField7.backgroundColor = .white
        phonenumberTextField7.textAlignment = .center
        phonenumberTextField7.keyboardType = .numberPad
        phonenumberTextField7.spellCheckingType = .default
        sevencontactsView.addSubview(phonenumberTextField7)
        
        nameLabel7 = UILabel(frame: CGRect.zero)
        nameLabel7.text = "Name 7"
        nameLabel7.textColor = .white
        nameLabel7.textAlignment = .center
        sevencontactsView.addSubview(nameLabel7)
        
        nameTextField7 = UITextField(frame: CGRect.zero)
        nameTextField7.placeholder = "Name 7"
        nameTextField7.clearButtonMode = .whileEditing
        nameTextField7.adjustsFontSizeToFitWidth = true
        nameTextField7.layer.cornerRadius = 5
        nameTextField7.backgroundColor = .white
        nameTextField7.textAlignment = .center
        nameTextField7.keyboardType = .default
        nameTextField7.spellCheckingType = .default
        sevencontactsView.addSubview(nameTextField7)
        
        eightcontactsView = UIView(frame: CGRect.zero)
        eightcontactsView.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1.0)
           eightcontactsView.isHidden = true
           addSubview(eightcontactsView)
        
        phonenumberLabel8 = UILabel(frame: CGRect.zero)
        phonenumberLabel8.text = "Phone number 8"
        phonenumberLabel8.textColor = .white
        phonenumberLabel8.textAlignment = .center
        eightcontactsView.addSubview(phonenumberLabel8)
        
        phonenumberTextField8 = UITextField(frame: CGRect.zero)
        phonenumberTextField8.placeholder = "Mobile Number 8"
        phonenumberTextField8.clearButtonMode = .whileEditing
        phonenumberTextField8.adjustsFontSizeToFitWidth = true
        phonenumberTextField8.layer.cornerRadius = 5
        phonenumberTextField8.backgroundColor = .white
        phonenumberTextField8.textAlignment = .center
        phonenumberTextField8.keyboardType = .numberPad
        phonenumberTextField8.spellCheckingType = .default
        eightcontactsView.addSubview(phonenumberTextField8)
        
        nameLabel8 = UILabel(frame: CGRect.zero)
        nameLabel8.text = "Name 8"
        nameLabel8.textColor = .white
        nameLabel8.textAlignment = .center
        eightcontactsView.addSubview(nameLabel8)
        
        nameTextField8 = UITextField(frame: CGRect.zero)
        nameTextField8.placeholder = "Name 8"
        nameTextField8.clearButtonMode = .whileEditing
        nameTextField8.adjustsFontSizeToFitWidth = true
        nameTextField8.layer.cornerRadius = 5
        nameTextField8.backgroundColor = .white
        nameTextField8.textAlignment = .center
        nameTextField8.keyboardType = .default
        nameTextField8.spellCheckingType = .default
        eightcontactsView.addSubview(nameTextField8)
        
        ninecontactsView = UIView(frame: CGRect.zero)
        ninecontactsView.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1.0)
           ninecontactsView.isHidden = true
          addSubview(ninecontactsView)
        
        phonenumberLabel9 = UILabel(frame: CGRect.zero)
        phonenumberLabel9.text = "Phone number 9"
        phonenumberLabel9.textColor = .white
        phonenumberLabel9.textAlignment = .center
        ninecontactsView.addSubview(phonenumberLabel9)
        
        phonenumberTextField9 = UITextField(frame: CGRect.zero)
        phonenumberTextField9.placeholder = "Mobile Number 9"
        phonenumberTextField9.clearButtonMode = .whileEditing
        phonenumberTextField9.adjustsFontSizeToFitWidth = true
        phonenumberTextField9.layer.cornerRadius = 5
        phonenumberTextField9.backgroundColor = .white
        phonenumberTextField9.textAlignment = .center
        phonenumberTextField9.keyboardType = .numberPad
        phonenumberTextField9.spellCheckingType = .default
        ninecontactsView.addSubview(phonenumberTextField9)
        
        nameLabel9 = UILabel(frame: CGRect.zero)
        nameLabel9.text = "Name 9"
        nameLabel9.textColor = .white
        nameLabel9.textAlignment = .center
        ninecontactsView.addSubview(nameLabel9)
        
        nameTextField9 = UITextField(frame: CGRect.zero)
        nameTextField9.placeholder = "Name 9"
        nameTextField9.clearButtonMode = .whileEditing
        nameTextField9.adjustsFontSizeToFitWidth = true
        nameTextField9.layer.cornerRadius = 5
        nameTextField9.backgroundColor = .white
        nameTextField9.textAlignment = .center
        nameTextField9.keyboardType = .default
        nameTextField9.spellCheckingType = .default
        ninecontactsView.addSubview(nameTextField9)
        
        tencontactsView = UIView(frame: CGRect.zero)
        tencontactsView.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1.0)
           tencontactsView.isHidden = true
           addSubview(tencontactsView)
        
        tenthphonenumberLabel = UILabel(frame: CGRect.zero)
        tenthphonenumberLabel.text = "Phone number 10"
        tenthphonenumberLabel.textColor = .white
        tenthphonenumberLabel.textAlignment = .center
        tencontactsView.addSubview(tenthphonenumberLabel)
        
        tenthphonenumberTextField = UITextField(frame: CGRect.zero)
        tenthphonenumberTextField.placeholder = "Mobile Number 10"
        tenthphonenumberTextField.clearButtonMode = .whileEditing
        tenthphonenumberTextField.adjustsFontSizeToFitWidth = true
        tenthphonenumberTextField.layer.cornerRadius = 5
        tenthphonenumberTextField.backgroundColor = .white
        tenthphonenumberTextField.textAlignment = .center
        tenthphonenumberTextField.keyboardType = .numberPad
        tenthphonenumberTextField.spellCheckingType = .default
        tencontactsView.addSubview(tenthphonenumberTextField)
        
        tenthnameLabel = UILabel(frame: CGRect.zero)
        tenthnameLabel.text = "Name 10"
        tenthnameLabel.textColor = .white
        tenthnameLabel.textAlignment = .center
        tencontactsView.addSubview(tenthnameLabel)
        
        tenthnameTextField = UITextField(frame: CGRect.zero)
        tenthnameTextField.placeholder = "Name 10"
        tenthnameTextField.clearButtonMode = .whileEditing
        tenthnameTextField.adjustsFontSizeToFitWidth = true
        tenthnameTextField.layer.cornerRadius = 5
        tenthnameTextField.backgroundColor = .white
        tenthnameTextField.textAlignment = .center
        tenthnameTextField.keyboardType = .default
        tenthnameTextField.spellCheckingType = .default
        tencontactsView.addSubview(tenthnameTextField)
          
          
//          addmorecontactButton = UIButton(frame: CGRect.zero)
//          addmorecontactButton.backgroundColor = .blue
//          addmorecontactButton.setTitle("Add more contacts", for: .normal)
//          addmorecontactButton.layer.cornerRadius = 5
//          addSubview(addmorecontactButton)
//
//          saveButton = UIButton(frame: CGRect.zero)
//          saveButton.backgroundColor = .blue
//          saveButton.setTitle("Save", for: .normal)
//          saveButton.translatesAutoresizingMaskIntoConstraints = false
//          saveButton.layer.cornerRadius = 5
//          addSubview(saveButton)
          
          lineView = UIView(frame: CGRect.zero)
          lineView.backgroundColor = .purple
          contactsView.addSubview(lineView)
      }
      func addmakeConstraints()
      {        
          
          contactsView.snp.makeConstraints{(make) in
              make.top.equalToSuperview().offset(0.001 * kscreenheight)
              make.height.equalTo(0.55 * kscreenheight)
              make.width.equalToSuperview()
              }
          firstadminLabel.snp.makeConstraints{(make) in
              make.top.equalToSuperview().offset(0.015 * kscreenheight)
              make.centerX.equalToSuperview()
               }
          firstadminTextField.snp.makeConstraints{(make) in
              make.top.equalTo(firstadminLabel.snp.bottom).offset(0.01 * kscreenheight)
              make.centerX.equalToSuperview()
              make.height.equalTo(0.05 * kscreenheight)
              make.width.equalTo(0.8 * kscreenwidth)
          }      
      
          secondadminLabel.snp.makeConstraints{(make) in
              make.top.equalTo(firstadminTextField.snp.bottom).offset(0.01 * kscreenheight)
              make.centerX.equalToSuperview()
               }
          secondadminTextField.snp.makeConstraints{(make) in
              make.top.equalTo(secondadminLabel.snp.bottom).offset(0.01 * kscreenheight)
              make.centerX.equalToSuperview()
              make.height.equalTo(0.05 * kscreenheight)
              make.width.equalTo(0.8 * kscreenwidth)
          }
          sosnumberLabel.snp.makeConstraints{(make) in
              make.top.equalTo(secondadminTextField.snp.bottom).offset(0.01 * kscreenheight)
              make.centerX.equalToSuperview()
               }
          sosnumberTextField.snp.makeConstraints{(make) in
              make.top.equalTo(sosnumberLabel.snp.bottom).offset(0.01 * kscreenheight)
              make.centerX.equalToSuperview()
              make.height.equalTo(0.05 * kscreenheight)
              make.width.equalTo(0.8 * kscreenwidth)
          }
          lineView.snp.makeConstraints{(make) in
              make.top.equalTo(sosnumberTextField.snp.bottom).offset(0.02 * kscreenheight)
              make.width.equalToSuperview()
              make.height.equalTo(0.001 * kscreenheight)
          }
          phonenumberLabel.snp.makeConstraints{(make) in
              make.top.equalTo(lineView.snp.bottom).offset(0.02 * kscreenheight)
              make.centerX.equalToSuperview()
               }
          phonenumberTextField.snp.makeConstraints{(make) in
              make.top.equalTo(phonenumberLabel.snp.bottom).offset(0.01 * kscreenheight)
              make.centerX.equalToSuperview()
              make.height.equalTo(0.05 * kscreenheight)
              make.width.equalTo(0.8 * kscreenwidth)
          }
          nameLabel.snp.makeConstraints{(make) in
              make.top.equalTo(phonenumberTextField.snp.bottom).offset(0.01 * kscreenheight)
              make.centerX.equalToSuperview()
               }
          nameTextField.snp.makeConstraints{(make) in
              make.top.equalTo(nameLabel.snp.bottom).offset(0.01 * kscreenheight)
              make.centerX.equalToSuperview()
              make.height.equalTo(0.05 * kscreenheight)
              make.width.equalTo(0.8 * kscreenwidth)
          }
        listcontactsView.snp.makeConstraints{(make) in
        make.top.equalTo(contactsView.snp.bottom).offset(0.001 * kscreenheight)
            make.height.equalTo(0.22 * kscreenheight)
//            make.height.equalTo(0.001 * kscreenheight)
        make.width.equalToSuperview()
        }
        
        secondphonenumberLabel.snp.makeConstraints{(make) in
                        make.top.equalToSuperview().offset(0.01 * kscreenheight)
                        make.centerX.equalToSuperview()
                         }
                    secondphonenumberTextField.snp.makeConstraints{(make) in
                        make.top.equalTo(secondphonenumberLabel.snp.bottom).offset(0.01 * kscreenheight)
                        make.centerX.equalToSuperview()
                        make.height.equalTo(0.05 * kscreenheight)
                        make.width.equalTo(0.8 * kscreenwidth)
                    }
                    secondnameLabel.snp.makeConstraints{(make) in
                        make.top.equalTo(secondphonenumberTextField.snp.bottom).offset(0.01 * kscreenheight)
                        make.centerX.equalToSuperview()
                         }
                    secondnameTextField.snp.makeConstraints{(make) in
                        make.top.equalTo(secondnameLabel.snp.bottom).offset(0.01 * kscreenheight)
                        make.centerX.equalToSuperview()
                        make.height.equalTo(0.05 * kscreenheight)
                        make.width.equalTo(0.8 * kscreenwidth)
                    }
        
        thirdcontactsView.snp.makeConstraints{(make) in
        make.top.equalTo(listcontactsView.snp.bottom).offset(0.001 * kscreenheight)
           make.height.equalTo(0.22 * kscreenheight)
            //make.height.equalTo(0.001 * kscreenheight)
        make.width.equalToSuperview()
        }
        
              thirdphonenumberLabel.snp.makeConstraints{(make) in
                           make.top.equalToSuperview().offset(0.01 * kscreenheight)
                           make.centerX.equalToSuperview()
                            }
                       thirdphonenumberTextField.snp.makeConstraints{(make) in
                           make.top.equalTo(thirdphonenumberLabel.snp.bottom).offset(0.01 * kscreenheight)
                           make.centerX.equalToSuperview()
                           make.height.equalTo(0.05 * kscreenheight)
                           make.width.equalTo(0.8 * kscreenwidth)
                       }
                       thirdnameLabel.snp.makeConstraints{(make) in
                           make.top.equalTo(thirdphonenumberTextField.snp.bottom).offset(0.01 * kscreenheight)
                           make.centerX.equalToSuperview()
                            }
                       thirdnameTextField.snp.makeConstraints{(make) in
                           make.top.equalTo(thirdnameLabel.snp.bottom).offset(0.01 * kscreenheight)
                           make.centerX.equalToSuperview()
                           make.height.equalTo(0.05 * kscreenheight)
                           make.width.equalTo(0.8 * kscreenwidth)
                       }
        
        fourthcontactsView.snp.makeConstraints{(make) in
        make.top.equalTo(thirdcontactsView.snp.bottom).offset(0.001 * kscreenheight)
           make.height.equalTo(0.22 * kscreenheight)
//            make.height.equalTo(0.001 * kscreenheight)
        make.width.equalToSuperview()
        }
        
        
        fourthphonenumberLabel.snp.makeConstraints{(make) in
             make.top.equalToSuperview().offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
             }
        fourthphonenumberTextField.snp.makeConstraints{(make) in
            make.top.equalTo(fourthphonenumberLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
            make.height.equalTo(0.05 * kscreenheight)
            make.width.equalTo(0.8 * kscreenwidth)
        }
        fourthnameLabel.snp.makeConstraints{(make) in
            make.top.equalTo(fourthphonenumberTextField.snp.bottom).offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
             }
        fourthnameTextField.snp.makeConstraints{(make) in
            make.top.equalTo(fourthnameLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
            make.height.equalTo(0.05 * kscreenheight)
            make.width.equalTo(0.8 * kscreenwidth)
        }
        fifthcontactsView.snp.makeConstraints{(make) in
        make.top.equalTo(fourthcontactsView.snp.bottom).offset(0.001 * kscreenheight)
           make.height.equalTo(0.22 * kscreenheight)
//            make.height.equalTo(0.001 * kscreenheight)
        make.width.equalToSuperview()
        }
        
        
        fifthphonenumberLabel.snp.makeConstraints{(make) in
                make.top.equalToSuperview().offset(0.01 * kscreenheight)
               make.centerX.equalToSuperview()
                }
           fifthphonenumberTextField.snp.makeConstraints{(make) in
               make.top.equalTo(fifthphonenumberLabel.snp.bottom).offset(0.01 * kscreenheight)
               make.centerX.equalToSuperview()
               make.height.equalTo(0.05 * kscreenheight)
               make.width.equalTo(0.8 * kscreenwidth)
           }
           fifthnameLabel.snp.makeConstraints{(make) in
               make.top.equalTo(fifthphonenumberTextField.snp.bottom).offset(0.01 * kscreenheight)
               make.centerX.equalToSuperview()
                }
           fifthnameTextField.snp.makeConstraints{(make) in
               make.top.equalTo(fifthnameLabel.snp.bottom).offset(0.01 * kscreenheight)
               make.centerX.equalToSuperview()
               make.height.equalTo(0.05 * kscreenheight)
               make.width.equalTo(0.8 * kscreenwidth)
           }
        
        sixcontactsView.snp.makeConstraints{(make) in
        make.top.equalTo(fifthcontactsView.snp.bottom).offset(0.001 * kscreenheight)
           make.height.equalTo(0.22 * kscreenheight)
//            make.height.equalTo(0.001 * kscreenheight)
        make.width.equalToSuperview()
        }
        
        sixphonenumberLabel.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
             }
        sixphonenumberTextField.snp.makeConstraints{(make) in
            make.top.equalTo(sixphonenumberLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
            make.height.equalTo(0.05 * kscreenheight)
            make.width.equalTo(0.8 * kscreenwidth)
        }
        sixnameLabel.snp.makeConstraints{(make) in
            make.top.equalTo(sixphonenumberTextField.snp.bottom).offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
             }
        sixnameTextField.snp.makeConstraints{(make) in
            make.top.equalTo(sixnameLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
            make.height.equalTo(0.05 * kscreenheight)
            make.width.equalTo(0.8 * kscreenwidth)
        }
        sevencontactsView.snp.makeConstraints{(make) in
              make.top.equalTo(sixcontactsView.snp.bottom).offset(0.001 * kscreenheight)
             make.height.equalTo(0.22 * kscreenheight)
//                  make.height.equalTo(0.001 * kscreenheight)
              make.width.equalToSuperview()
              }
        
        phonenumberLabel7.snp.makeConstraints{(make) in
                 make.top.equalToSuperview().offset(0.01 * kscreenheight)
                  make.centerX.equalToSuperview()
                   }
              phonenumberTextField7.snp.makeConstraints{(make) in
                  make.top.equalTo(phonenumberLabel7.snp.bottom).offset(0.01 * kscreenheight)
                  make.centerX.equalToSuperview()
                  make.height.equalTo(0.05 * kscreenheight)
                  make.width.equalTo(0.8 * kscreenwidth)
              }
              nameLabel7.snp.makeConstraints{(make) in
                  make.top.equalTo(phonenumberTextField7.snp.bottom).offset(0.01 * kscreenheight)
                  make.centerX.equalToSuperview()
                   }
              nameTextField7.snp.makeConstraints{(make) in
                  make.top.equalTo(nameLabel7.snp.bottom).offset(0.01 * kscreenheight)
                  make.centerX.equalToSuperview()
                  make.height.equalTo(0.05 * kscreenheight)
                  make.width.equalTo(0.8 * kscreenwidth)
              }
        eightcontactsView.snp.makeConstraints{(make) in
                     make.top.equalTo(sevencontactsView.snp.bottom).offset(0.001 * kscreenheight)
                        make.height.equalTo(0.22 * kscreenheight)
//                         make.height.equalTo(0.001 * kscreenheight)
                     make.width.equalToSuperview()
                     }
        
        
        phonenumberLabel8.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
             }
        phonenumberTextField8.snp.makeConstraints{(make) in
            make.top.equalTo(phonenumberLabel8.snp.bottom).offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
            make.height.equalTo(0.05 * kscreenheight)
            make.width.equalTo(0.8 * kscreenwidth)
        }
        nameLabel8.snp.makeConstraints{(make) in
            make.top.equalTo(phonenumberTextField8.snp.bottom).offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
             }
        nameTextField8.snp.makeConstraints{(make) in
            make.top.equalTo(nameLabel8.snp.bottom).offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
            make.height.equalTo(0.05 * kscreenheight)
            make.width.equalTo(0.8 * kscreenwidth)
        }
        ninecontactsView.snp.makeConstraints{(make) in
                            make.top.equalTo(eightcontactsView.snp.bottom).offset(0.001 * kscreenheight)
                              make.height.equalTo(0.22 * kscreenheight)
//                                make.height.equalTo(0.001 * kscreenheight)
                            make.width.equalToSuperview()
                            }
        
        
        
        phonenumberLabel9.snp.makeConstraints{(make) in
              make.top.equalToSuperview().offset(0.01 * kscreenheight)
               make.centerX.equalToSuperview()
                }
           phonenumberTextField9.snp.makeConstraints{(make) in
               make.top.equalTo(phonenumberLabel9.snp.bottom).offset(0.01 * kscreenheight)
               make.centerX.equalToSuperview()
               make.height.equalTo(0.05 * kscreenheight)
               make.width.equalTo(0.8 * kscreenwidth)
           }
           nameLabel9.snp.makeConstraints{(make) in
               make.top.equalTo(phonenumberTextField9.snp.bottom).offset(0.01 * kscreenheight)
               make.centerX.equalToSuperview()
                }
           nameTextField9.snp.makeConstraints{(make) in
               make.top.equalTo(nameLabel9.snp.bottom).offset(0.01 * kscreenheight)
               make.centerX.equalToSuperview()
               make.height.equalTo(0.05 * kscreenheight)
               make.width.equalTo(0.8 * kscreenwidth)
           }
        tencontactsView.snp.makeConstraints{(make) in
                                   make.top.equalTo(ninecontactsView.snp.bottom).offset(0.001 * kscreenheight)
                                  make.height.equalTo(0.22 * kscreenheight)
//                                       make.height.equalTo(0.001 * kscreenheight)
                                   make.width.equalToSuperview()
                                   }
        tenthphonenumberLabel.snp.makeConstraints{(make) in
           make.top.equalToSuperview().offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
             }
        tenthphonenumberTextField.snp.makeConstraints{(make) in
            make.top.equalTo(tenthphonenumberLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
            make.height.equalTo(0.05 * kscreenheight)
            make.width.equalTo(0.8 * kscreenwidth)
        }
        tenthnameLabel.snp.makeConstraints{(make) in
            make.top.equalTo(tenthphonenumberTextField.snp.bottom).offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
             }
        tenthnameTextField.snp.makeConstraints{(make) in
            make.top.equalTo(tenthnameLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
            make.height.equalTo(0.05 * kscreenheight)
            make.width.equalTo(0.8 * kscreenwidth)
        }
//        addmorecontactButton.snp.makeConstraints{(make) in
//            make.top.equalTo(contactsView.snp.bottom).offset(0.001 * kscreenheight)
//            make.width.equalTo(0.8 * kscreenwidth)
//            make.centerX.equalToSuperview()
//            make.height.equalTo(0.08 * kscreenheight)
//                    }
//        saveButton.snp.makeConstraints{(make) in
//            make.top.equalTo(addmorecontactButton.snp.bottom).offset(0.01 * kscreenheight)
//            make.width.equalTo(0.8 * kscreenwidth)
//            make.centerX.equalToSuperview()
//            make.height.equalTo(0.06 * kscreenheight)
//
//        }
         
        

          
      }
   
}
