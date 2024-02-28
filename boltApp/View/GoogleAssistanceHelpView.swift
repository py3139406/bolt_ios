//
//  GoogleAssistanceHelpView.swift
//  Bolt
//
//  Created by Vivek Kumar on 29/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import DefaultsKit

class GoogleAssistanceHelpView: UIView {

      var whoseViraImageView : UIImageView!
     var whoseViraLabel : UILabel!
     var meetViraImageView : UIImageView!
     var kscreenheight = UIScreen.main.bounds.height
     var kscreenwidth = UIScreen.main.bounds.width
     var meetViraLabel: UILabel!
    var hiMessageLabel: UILabel!
    var poweredIMageView: UIImageView!
    var voiceinteractionLabel: UILabel!
    var firstStepView: UIView!
    var stepOneLabel: UILabel!
    var enterGmailIdLabel: UILabel!
    var gmailIdTextField: UITextField!
    var signedinLabel: UILabel!
    var secondStepView: UIView!
    var stepTwoLabel: UILabel!
    var selectVehicleTextField: UITextField!
    var proceedButton: UIButton!
    let name = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.name ?? " "

     override init(frame: CGRect) {
       super.init(frame: frame)
       //function call here
      
       addview()
       addconstraints()
       
     }
     
     required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
     }
     
func addview()
{
    whoseViraImageView = UIImageView(frame: CGRect.zero)
    whoseViraImageView.image = UIImage(named: "more")
    whoseViraImageView.contentMode = .scaleAspectFit
    whoseViraImageView.isUserInteractionEnabled = true
    addSubview(whoseViraImageView)
    
    whoseViraLabel = UILabel(frame: CGRect.zero)
    whoseViraLabel.text = "What is Roadcast Bolt voice assistant?"
    whoseViraLabel.textColor = .black
    addSubview(whoseViraLabel)
    
    meetViraImageView = UIImageView(frame: CGRect.zero)
    meetViraImageView.image = UIImage(named: "robot")
    meetViraImageView.contentMode = .scaleAspectFit
    addSubview(meetViraImageView)
        
    
    let meetAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 20.0)]
    let viraAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 21.0)]

    let meetString = NSMutableAttributedString(string: "Meet", attributes: meetAttribute)
    let viraString = NSAttributedString(string: " Roadcast Bolt voice assistant", attributes: viraAttribute)
    meetString.append(viraString)

    meetViraLabel = UILabel(frame: CGRect.zero)
    meetViraLabel.attributedText = meetString
    meetViraLabel.textColor = appGreenTheme
    meetViraLabel.numberOfLines = 2
    meetViraLabel.textAlignment = .center
    meetViraLabel.adjustsFontSizeToFitWidth = true
    addSubview(meetViraLabel)
    
    
    let hiAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 20.0) as Any]
    let rahulAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 22.0) as Any]

       let hiString = NSMutableAttributedString(string: "Hi", attributes: hiAttribute)
       let rahulString = NSAttributedString(string: " \(name)!", attributes: rahulAttribute)
       hiString.append(rahulString)
    hiMessageLabel = UILabel(frame: CGRect.zero)
    hiMessageLabel.attributedText = hiString
    hiMessageLabel.layer.cornerRadius = 5
    hiMessageLabel.layer.masksToBounds = true
    hiMessageLabel.textAlignment = .center
    hiMessageLabel.textColor = .black
    hiMessageLabel.adjustsFontSizeToFitWidth = true
    hiMessageLabel.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.0)
    addSubview(hiMessageLabel)
    
    poweredIMageView = UIImageView(frame: CGRect.zero)
    poweredIMageView.image = UIImage(named: "poweredby")
    poweredIMageView.contentMode = .scaleAspectFit
    addSubview(poweredIMageView)
    
    voiceinteractionLabel = UILabel(frame: CGRect.zero)
    voiceinteractionLabel.text = " Voice interactive Roadcast Assistant "
    voiceinteractionLabel.textColor = .white
    voiceinteractionLabel.adjustsFontSizeToFitWidth = true
    voiceinteractionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    voiceinteractionLabel.textAlignment = .center
    voiceinteractionLabel.backgroundColor = .black
    voiceinteractionLabel.layer.cornerRadius = 5
    voiceinteractionLabel.layer.masksToBounds = true
    voiceinteractionLabel.frame.size.width = voiceinteractionLabel.intrinsicContentSize.width
    addSubview(voiceinteractionLabel)
    
    firstStepView = UIView(frame: CGRect.zero)
    firstStepView.backgroundColor = appDarkTheme
    addSubview(firstStepView)
    
    stepOneLabel = UILabel(frame: CGRect.zero)
    stepOneLabel.text = "STEP 1"
    stepOneLabel.textColor = appGreenTheme
    stepOneLabel.font = UIFont.systemFont(ofSize: 28, weight: .thin)
    firstStepView.addSubview(stepOneLabel)
    
    enterGmailIdLabel = UILabel(frame: CGRect.zero)
    enterGmailIdLabel.text = "Enter your gmail below to connect"
    enterGmailIdLabel.textColor = .white
    firstStepView.addSubview(enterGmailIdLabel)
    
    gmailIdTextField = UITextField(frame: CGRect.zero)
    gmailIdTextField.placeholder = "roadcast@gmail.com"
   // gmailIdTextField.attributedPlaceholder = NSAttributedString(string: "roadcast@gmail.com",
//                                                                attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
    gmailIdTextField.textAlignment = .center
    gmailIdTextField.layer.cornerRadius = 5
    gmailIdTextField.backgroundColor = .white
    gmailIdTextField.layer.masksToBounds = true
    gmailIdTextField.keyboardAppearance = .dark
    gmailIdTextField.keyboardType = .emailAddress
    gmailIdTextField.autocapitalizationType = .none
    gmailIdTextField.setupLeftImage(imageName: "google")
    firstStepView.addSubview(gmailIdTextField)
    
    signedinLabel = UILabel(frame: CGRect.zero)
    signedinLabel.text = "make sure you are signed in on your phone with this email"
    signedinLabel.textColor = UIColor.systemBlue
    signedinLabel.adjustsFontSizeToFitWidth = true
    //signedinLabel.font = UIFont.systemFont(ofSize: 13.0)
    firstStepView.addSubview(signedinLabel)
    
   secondStepView = UIView(frame: CGRect.zero)
    secondStepView.backgroundColor = .white
    addSubview(secondStepView)
    
    
    stepTwoLabel = UILabel(frame: CGRect.zero)
    stepTwoLabel.text = "STEP 2"
    stepTwoLabel.textColor = appGreenTheme
    stepTwoLabel.font = UIFont.systemFont(ofSize: 28, weight: .thin)
    secondStepView.addSubview(stepTwoLabel)
    
    selectVehicleTextField = UITextField(frame: CGRect.zero)
    selectVehicleTextField.placeholder = "Demo"
    selectVehicleTextField.textAlignment = .center
    selectVehicleTextField.layer.cornerRadius = 5
    selectVehicleTextField.layer.masksToBounds = true
    selectVehicleTextField.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
    selectVehicleTextField.setupRightImage(imageName: "down_arrow")
    secondStepView.addSubview(selectVehicleTextField)
    
    proceedButton = UIButton(frame: CGRect.zero)
    proceedButton.backgroundColor = appGreenTheme
    proceedButton.setImage(UIImage(named: "oklogo")?.resizedImage(CGSize.init(width: 25.0, height: 25.0), interpolationQuality: .default), for: .normal)
    proceedButton.contentMode = .scaleAspectFit
    addSubview(proceedButton)
    }
    
    func addconstraints()
    {
        whoseViraImageView.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(screensize.height * 0.02)
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.width.height.equalTo(32)
        }
        whoseViraLabel.snp.makeConstraints{(make) in
            make.centerY.equalTo(whoseViraImageView)
            make.left.equalTo(whoseViraImageView.snp.right).offset(0.01 * kscreenwidth)
        }
        
        hiMessageLabel.snp.makeConstraints{(make) in
            make.top.equalTo(whoseViraImageView.snp.bottom).offset(0.01 * kscreenheight)
            make.left.equalTo(meetViraImageView.snp.right).offset(0.03 * kscreenwidth)
            make.height.equalToSuperview().multipliedBy(0.08)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        meetViraImageView.snp.makeConstraints{(make) in
            make.top.equalTo(whoseViraImageView.snp.bottom).offset(0.04 * kscreenheight)
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.height.equalToSuperview().multipliedBy(0.22)
            make.width.equalToSuperview().multipliedBy(0.35)
        }
        
        meetViraLabel.snp.makeConstraints{(make) in
            make.top.equalTo(hiMessageLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.centerX.equalTo(hiMessageLabel)//.offset(0.05 * kscreenwidth)
            make.width.equalToSuperview().multipliedBy(0.45)
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        poweredIMageView.snp.makeConstraints{(make) in
            make.bottom.equalTo(meetViraImageView.snp.bottom)//.offset(0.005 * kscreenheight)
            make.left.equalTo(hiMessageLabel)//.offset(0.03 * kscreenwidth)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        voiceinteractionLabel.snp.makeConstraints{(make) in
            make.top.equalTo(poweredIMageView.snp.bottom).offset(0.03 * kscreenheight)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.centerX.equalToSuperview()
        }
        
        firstStepView.snp.makeConstraints{(make) in
            make.top.equalTo(voiceinteractionLabel.snp.bottom).offset(0.03 * kscreenheight)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
            
        }
        stepOneLabel.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(0.01 * kscreenheight)
            make.left.equalToSuperview().offset(screensize.width * 0.05)
        }
        enterGmailIdLabel.snp.makeConstraints{(make) in
            make.top.equalTo(stepOneLabel.snp.bottom).offset(0.02 * kscreenheight)
            make.left.equalToSuperview().offset(screensize.width * 0.05)
        }
        gmailIdTextField.snp.makeConstraints{(make) in
            make.top.equalTo(enterGmailIdLabel.snp.bottom).offset(0.02 * kscreenheight)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        signedinLabel.snp.makeConstraints{(make) in
            make.top.equalTo(gmailIdTextField.snp.bottom).offset(0.01 * kscreenheight)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        }
        secondStepView.snp.makeConstraints{(make) in
            make.top.equalTo(firstStepView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalTo(proceedButton.snp.top)
        }
        stepTwoLabel.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(0.01 * kscreenheight)
            make.left.equalToSuperview().offset(screensize.width * 0.05)
               }
        selectVehicleTextField.snp.makeConstraints{(make) in
            make.top.equalTo(stepTwoLabel.snp.bottom).offset(0.02 * kscreenheight)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        
        proceedButton.snp.makeConstraints{(make) in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.06)
        }
    }
}
extension UITextField {

    //MARK:- Set Image on the right of text fields

  func setupRightImage(imageName:String){
    let imageView = UIImageView(frame: CGRect(x: 18, y: 8, width: 25, height: 20))
    imageView.image = UIImage(named: imageName)
    let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
    imageContainerView.addSubview(imageView)
    rightView = imageContainerView
    rightViewMode = .always
    self.tintColor = .lightGray
}

 //MARK:- Set Image on left of text fields

    func setupLeftImage(imageName:String){
       let imageView = UIImageView(frame: CGRect(x: 10, y: 7, width: 25, height: 25))
       imageView.image = UIImage(named: imageName)
       let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
       imageContainerView.addSubview(imageView)
       leftView = imageContainerView
       leftViewMode = .always
       self.tintColor = .lightGray
     }

  }
