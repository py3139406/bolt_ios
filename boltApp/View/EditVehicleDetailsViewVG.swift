//
//  ToolsScrollView.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class xToolsScrollView: UIScrollView {
    
    
    var reportLabel: UILabel!
    var reportimageView: UIImageView!
    var reporttitleLabel: UILabel!
    
    var immobilizeLabel: UILabel!
    var immobilizeimageView: UIImageView!
    var immobilizetitleLabel: UILabel!
    
    var appSettingLabel: UILabel!
    var appSettingimageView: UIImageView!
    var apptitleLabel: UILabel!
    
    var smsLabel: UILabel!
    var smsimageView: UIImageView!
    var smstitleLabel: UILabel!
    
    var geoLabel: UILabel!
    var geoimageView: UIImageView!
    var geotitleLabel: UILabel!
    
    var helpLabel: UILabel!
    var helpimageView: UIImageView!
    var helptitleLabel: UILabel!
    
    var logoutLabel: UILabel!
    var logoutimageView: UIImageView!
    var logouttitleLabel: UILabel!
    
    var connectAndShareLabel: UILabel!
    var connectAndShareimv: UIImageView!
    var connectAndSharetitleLabel: UILabel!
    
    var profileLabel: UILabel!
    var profileimv: UIImageView!
    var profiletitleLabel: UILabel!
    
    var editVehicleInfoLabel: UILabel!
    var editVehicleInfoImage: UIImageView!
    var editVehicleInfoTitleLabel: UILabel!
    
    var faqLabel: UILabel!
    var faqimv: UIImageView!
    var faqtitleLabel: UILabel!
    
    var loadUnloadLabel: UILabel!
    var loadUnloadImageView: UIImageView!
    var loadUnloadTitleLabel: UILabel!
    
    var liveStreamingLabel: UILabel!
    var liveStreamingImageView: UIImageView!
    var liveStreamingTitleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        //addConstrans()
        addConstrans2()
        //        self.contentHeight = UIScreen.main.bounds.height * 1.25
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func addViews() {
        profileLabel = UILabel()
        profileLabel.isUserInteractionEnabled = true
        profileLabel.backgroundColor = .white
        profileLabel.layer.cornerRadius = 5
        profileLabel.clipsToBounds = true
        addSubview(profileLabel)
        
        profileimv = UIImageView()
        profileimv.image = #imageLiteral(resourceName: "profileicon")
        profileimv.contentMode = .scaleAspectFill
        addSubview(profileimv)
        
        profiletitleLabel = UILabel()
        profiletitleLabel.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.23, alpha: 1.0)
        profiletitleLabel.text = "PROFILE".toLocalize
        profiletitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        profiletitleLabel.textColor = .white
        profiletitleLabel.layer.cornerRadius = 3
        profiletitleLabel.clipsToBounds = true
        profiletitleLabel.textAlignment = .center
        addSubview(profiletitleLabel)
        
        helpLabel = UILabel()
        helpLabel.backgroundColor = .white
        helpLabel.isUserInteractionEnabled = true
        helpLabel.layer.cornerRadius = 5
        helpLabel.clipsToBounds = true
        addSubview(helpLabel)
        
        helpimageView = UIImageView()
        helpimageView.image = #imageLiteral(resourceName: "help")
        helpimageView.contentMode = .scaleAspectFill
        addSubview(helpimageView)
        
        helptitleLabel = UILabel()
        helptitleLabel.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.23, alpha: 1.0)
        helptitleLabel.text = "HELP".toLocalize
        helptitleLabel.textColor = .white
        helptitleLabel.layer.cornerRadius = 3
        helptitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        helptitleLabel.clipsToBounds = true
        helptitleLabel.textAlignment = .center
        addSubview(helptitleLabel)
        
        immobilizeLabel = UILabel()
        immobilizeLabel.isUserInteractionEnabled = true
        immobilizeLabel.backgroundColor = .white
        immobilizeLabel.layer.cornerRadius = 5
        immobilizeLabel.clipsToBounds = true
        addSubview(immobilizeLabel)
        
        immobilizeimageView = UIImageView()
        immobilizeimageView.image = #imageLiteral(resourceName: "dashicon2")
        immobilizeimageView.contentMode = .scaleAspectFill
        addSubview(immobilizeimageView)
        
        immobilizetitleLabel = UILabel()
        immobilizetitleLabel.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.23, alpha: 1.0)
        immobilizetitleLabel.text = "IMMOBILIZE".toLocalize
        immobilizetitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        immobilizetitleLabel.textColor = .white
        immobilizetitleLabel.layer.cornerRadius = 3
        immobilizetitleLabel.clipsToBounds = true
        immobilizetitleLabel.textAlignment = .center
        addSubview(immobilizetitleLabel)
        
        reportLabel = UILabel()
        reportLabel.backgroundColor = .white
        reportLabel.isUserInteractionEnabled = true
        reportLabel.layer.cornerRadius = 5
        reportLabel.clipsToBounds = true
        addSubview(reportLabel)
        
        reportimageView = UIImageView()
        reportimageView.image = #imageLiteral(resourceName: "reporttools")
        reportimageView.contentMode = .scaleAspectFill
        addSubview(reportimageView)
        
        reporttitleLabel = UILabel()
        reporttitleLabel.backgroundColor = UIColor(red: 0.15, green: 0.14, blue: 0.23, alpha: 1.0)
        reporttitleLabel.text = "REPORTS".toLocalize
        reporttitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        reporttitleLabel.textColor = .white
        reporttitleLabel.layer.cornerRadius = 3
        reporttitleLabel.clipsToBounds = true
        reporttitleLabel.textAlignment = .center
        addSubview(reporttitleLabel)
        
        smsLabel = UILabel()
        smsLabel.backgroundColor = .white
        smsLabel.isUserInteractionEnabled = true
        smsLabel.layer.cornerRadius = 5
        smsLabel.clipsToBounds = true
        addSubview(smsLabel)
        
        smsimageView = UIImageView()
        smsimageView.image = #imageLiteral(resourceName: "dashicon4")
        smsimageView.contentMode = .scaleAspectFill
        addSubview(smsimageView)
        
        smstitleLabel = UILabel()
        smstitleLabel.backgroundColor = UIColor(red: 0.15, green: 0.14, blue: 0.23, alpha: 1.0)
        smstitleLabel.text = "CONFIGURATION".toLocalize
        smstitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        smstitleLabel.textColor = .white
        smstitleLabel.layer.cornerRadius = 3
        smstitleLabel.clipsToBounds = true
        smstitleLabel.textAlignment = .center
        addSubview(smstitleLabel)
        
        geoLabel = UILabel()
        geoLabel.backgroundColor = .white
        geoLabel.isUserInteractionEnabled = true
        geoLabel.layer.cornerRadius = 5
        geoLabel.clipsToBounds = true
        addSubview(geoLabel)
        
        geoimageView = UIImageView()
        geoimageView.image = #imageLiteral(resourceName: "dashicon5")
        geoimageView.contentMode = .scaleAspectFill
        addSubview(geoimageView)
        
        geotitleLabel = UILabel()
        
        geotitleLabel.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.23, alpha: 1.0)
        geotitleLabel.text = "GEOFENCE".toLocalize
        geotitleLabel.textColor = .white
        geotitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        geotitleLabel.layer.cornerRadius = 3
        geotitleLabel.clipsToBounds = true
        geotitleLabel.textAlignment = .center
        addSubview(geotitleLabel)
        
        connectAndShareLabel = UILabel()
        connectAndShareLabel.backgroundColor = .white
        connectAndShareLabel.isUserInteractionEnabled = true
        connectAndShareLabel.layer.cornerRadius = 5
        connectAndShareLabel.clipsToBounds = true
        addSubview(connectAndShareLabel)
        
        connectAndShareimv = UIImageView()
        connectAndShareimv.image = #imageLiteral(resourceName: "Share")
        connectAndShareimv.contentMode = .scaleAspectFill
        addSubview(connectAndShareimv)
        
        connectAndSharetitleLabel = UILabel()
        connectAndSharetitleLabel.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.23, alpha: 1.0)
        connectAndSharetitleLabel.text = "CONNECT & SHARE".toLocalize
        connectAndSharetitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        connectAndSharetitleLabel.textColor = .white
        connectAndSharetitleLabel.layer.cornerRadius = 3
        connectAndSharetitleLabel.clipsToBounds = true
        connectAndSharetitleLabel.textAlignment = .center
        addSubview(connectAndSharetitleLabel)
        
        appSettingLabel = UILabel()
        appSettingLabel.isUserInteractionEnabled = true
        appSettingLabel.backgroundColor = .white
        appSettingLabel.layer.cornerRadius = 5
        appSettingLabel.clipsToBounds = true
        addSubview(appSettingLabel)
        
        appSettingimageView = UIImageView()
        appSettingimageView.image = #imageLiteral(resourceName: "dashicon3")
        appSettingimageView.contentMode = .scaleAspectFill
        addSubview(appSettingimageView)
        
        apptitleLabel = UILabel()
        apptitleLabel.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.23, alpha: 1.0)
        apptitleLabel.text = "APP SETTINGS".toLocalize
        apptitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        apptitleLabel.textColor = .white
        apptitleLabel.layer.cornerRadius = 3
        apptitleLabel.clipsToBounds = true
        apptitleLabel.textAlignment = .center
        addSubview(apptitleLabel)
        
        editVehicleInfoLabel = UILabel()
        editVehicleInfoLabel.isUserInteractionEnabled = true
        editVehicleInfoLabel.backgroundColor = .white
        editVehicleInfoLabel.layer.cornerRadius = 5
        editVehicleInfoLabel.clipsToBounds = true
        addSubview(editVehicleInfoLabel)
        
        editVehicleInfoImage = UIImageView()
        editVehicleInfoImage.image = #imageLiteral(resourceName: "tools")
        editVehicleInfoImage.contentMode = .scaleAspectFill
        addSubview(editVehicleInfoImage)
        
        editVehicleInfoTitleLabel = UILabel()
        editVehicleInfoTitleLabel.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.23, alpha: 1.0)
        editVehicleInfoTitleLabel.text = "VEHICLE DETAILS".toLocalize
        editVehicleInfoTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        editVehicleInfoTitleLabel.textColor = .white
        editVehicleInfoTitleLabel.adjustsFontSizeToFitWidth = true
        editVehicleInfoTitleLabel.layer.cornerRadius = 3
        editVehicleInfoTitleLabel.clipsToBounds = true
        editVehicleInfoTitleLabel.textAlignment = .center
        addSubview(editVehicleInfoTitleLabel)
        
        faqLabel = UILabel()
        faqLabel.isUserInteractionEnabled = true
        faqLabel.backgroundColor = .white
        faqLabel.layer.cornerRadius = 5
        faqLabel.clipsToBounds = true
        faqLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(faqLabel)
        
        faqimv = UIImageView()
        faqimv.image = UIImage(named: "more")
        faqimv.contentMode = .scaleAspectFill
        faqimv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(faqimv)
        
        faqtitleLabel = UILabel()
        faqtitleLabel.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.23, alpha: 1.0)
        faqtitleLabel.text = "F.A.Q.".toLocalize
        faqtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        faqtitleLabel.textColor = .white
        faqtitleLabel.adjustsFontSizeToFitWidth = true
        faqtitleLabel.layer.cornerRadius = 3
        faqtitleLabel.clipsToBounds = true
        faqtitleLabel.textAlignment = .center
        faqtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(faqtitleLabel)
        
        loadUnloadLabel = UILabel()
        loadUnloadLabel.isUserInteractionEnabled = true
        loadUnloadLabel.backgroundColor = .white
        loadUnloadLabel.layer.cornerRadius = 5
        loadUnloadLabel.clipsToBounds = true
        loadUnloadLabel.translatesAutoresizingMaskIntoConstraints = false
        loadUnloadLabel.isHidden = true
        addSubview(loadUnloadLabel)
        
        loadUnloadImageView = UIImageView()
        loadUnloadImageView.image = UIImage(named: "LoadUnload")
        loadUnloadImageView.contentMode = .scaleAspectFill
        loadUnloadImageView.translatesAutoresizingMaskIntoConstraints = false
        loadUnloadImageView.isHidden = true
        addSubview(loadUnloadImageView)
        
        loadUnloadTitleLabel = UILabel()
        loadUnloadTitleLabel.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.23, alpha: 1.0)
        loadUnloadTitleLabel.text = "Load/Unload".toLocalize
        loadUnloadTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        loadUnloadTitleLabel.textColor = .white
        loadUnloadTitleLabel.adjustsFontSizeToFitWidth = true
        loadUnloadTitleLabel.layer.cornerRadius = 3
        loadUnloadTitleLabel.clipsToBounds = true
        loadUnloadTitleLabel.textAlignment = .center
        loadUnloadTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        loadUnloadTitleLabel.isHidden = true
        addSubview(loadUnloadTitleLabel)
        
        
        liveStreamingLabel = UILabel()
        liveStreamingLabel.isUserInteractionEnabled = true
        liveStreamingLabel.backgroundColor = .white
        liveStreamingLabel.layer.cornerRadius = 5
        liveStreamingLabel.clipsToBounds = true
        liveStreamingLabel.translatesAutoresizingMaskIntoConstraints = false
        liveStreamingLabel.isHidden = true
        addSubview(liveStreamingLabel)
        
        liveStreamingImageView = UIImageView()
        liveStreamingImageView.image = UIImage(named: "liveStreamingPDF")
        liveStreamingImageView.contentMode = .scaleAspectFill
        liveStreamingImageView.translatesAutoresizingMaskIntoConstraints = false
        liveStreamingImageView.isHidden = true
        addSubview(liveStreamingImageView)
        
        liveStreamingTitleLabel = UILabel()
        liveStreamingTitleLabel.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.23, alpha: 1.0)
        liveStreamingTitleLabel.text = "Live Streaming".toLocalize
        liveStreamingTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        liveStreamingTitleLabel.textColor = .white
        liveStreamingTitleLabel.adjustsFontSizeToFitWidth = true
        liveStreamingTitleLabel.layer.cornerRadius = 3
        liveStreamingTitleLabel.clipsToBounds = true
        liveStreamingTitleLabel.textAlignment = .center
        liveStreamingTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        liveStreamingTitleLabel.isHidden = true
        addSubview(liveStreamingTitleLabel)
        
        logoutLabel = UILabel()
        logoutLabel.backgroundColor = .white
        logoutLabel.isUserInteractionEnabled = true
        logoutLabel.layer.cornerRadius = 5
        logoutLabel.clipsToBounds = true
        addSubview(logoutLabel)
        
        logoutimageView = UIImageView()
        logoutimageView.image = #imageLiteral(resourceName: "logoutlogo")
        logoutimageView.contentMode = .scaleAspectFill
        addSubview(logoutimageView)
        
        logouttitleLabel = UILabel(frame: CGRect.zero)
        logouttitleLabel.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.23, alpha: 1.0)
        logouttitleLabel.text = "LOGOUT".toLocalize
        logouttitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        logouttitleLabel.textColor = .white
        logouttitleLabel.layer.cornerRadius = 3
        logouttitleLabel.clipsToBounds = true
        logouttitleLabel.textAlignment = .center
        addSubview(logouttitleLabel)
        
        
        
    }
    
    
    func addConstrans2() {
        profileLabel.snp.makeConstraints{ (make) in
            make.left.equalToSuperview().offset(UIScreen.main.bounds.width * 0.05)
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height*0.05)
            make.width.equalToSuperview().multipliedBy(0.44)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        profileimv.snp.makeConstraints{ (make) in
            make.center.equalTo(profileLabel)
            make.height.width.equalTo(profileLabel).multipliedBy(0.27)
        }
        profiletitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(profileLabel)
            make.bottom.equalTo(profileLabel.snp.bottom).offset(-15)
            make.width.equalTo(profileLabel).multipliedBy(0.54)
            make.height.equalTo(profileLabel).multipliedBy(0.12)
        }
        helpLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(profileLabel.snp.right).offset(10)
            make.top.height.width.equalTo(profileLabel)
        }
        helpimageView.snp.makeConstraints{ (make) in
            make.center.equalTo(helpLabel)
            make.height.width.equalTo(helpLabel).multipliedBy(0.27)
        }
        helptitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(helpLabel)
            make.bottom.equalTo(helpLabel.snp.bottom).offset(-15)
            make.width.equalTo(helpLabel).multipliedBy(0.54)
            make.height.equalTo(helpLabel).multipliedBy(0.12)
        }
        reportLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(profileLabel.snp.bottom).offset(10)
            make.left.width.height.equalTo(profileLabel)
        }
        reportimageView.snp.makeConstraints{ (make) in
            make.center.equalTo(reportLabel)
            make.height.width.equalTo(reportLabel).multipliedBy(0.27)
        }
        reporttitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(reportLabel)
            make.bottom.equalTo(reportLabel.snp.bottom).offset(-15)
            make.width.equalTo(reportLabel).multipliedBy(0.54)
            make.height.equalTo(reportLabel).multipliedBy(0.12)
        }
        immobilizeLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(helpLabel.snp.bottom).offset(10)
            make.left.width.height.equalTo(helpLabel)
        }
        immobilizeimageView.snp.makeConstraints{ (make) in
            make.center.equalTo(immobilizeLabel)
            make.height.width.equalTo(immobilizeLabel).multipliedBy(0.27)
        }
        immobilizetitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(immobilizeLabel)
            make.bottom.equalTo(immobilizeLabel.snp.bottom).offset(-15)
            make.width.equalTo(immobilizeLabel).multipliedBy(0.54)
            make.height.equalTo(immobilizeLabel).multipliedBy(0.12)
        }
        appSettingLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(reportLabel.snp.bottom).offset(10)
            make.left.width.height.equalTo(reportLabel)
        }
        appSettingimageView.snp.makeConstraints{ (make) in
            make.center.equalTo(appSettingLabel)
            make.height.width.equalTo(appSettingLabel).multipliedBy(0.27)
        }
        apptitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(appSettingLabel)
            make.bottom.equalTo(appSettingLabel.snp.bottom).offset(-15)
            make.width.equalTo(appSettingLabel).multipliedBy(0.54)
            make.height.equalTo(appSettingLabel).multipliedBy(0.12)
        }
        connectAndShareLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(immobilizeLabel.snp.bottom).offset(10)
            make.left.width.height.equalTo(immobilizeLabel)
        }
        connectAndShareimv.snp.makeConstraints{ (make) in
            make.center.equalTo(connectAndShareLabel)
            make.height.width.equalTo(connectAndShareLabel).multipliedBy(0.27)
        }
        connectAndSharetitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(connectAndShareLabel)
            make.bottom.equalTo(connectAndShareLabel.snp.bottom).offset(-15)
            make.width.equalTo(connectAndShareLabel).multipliedBy(0.54)
            make.height.equalTo(connectAndShareLabel).multipliedBy(0.12)
        }
        geoLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(appSettingLabel.snp.bottom).offset(10)
            make.left.width.height.equalTo(appSettingLabel)
        }
        geoimageView.snp.makeConstraints{ (make) in
            make.center.equalTo(geoLabel)
            make.height.width.equalTo(geoLabel).multipliedBy(0.27)
        }
        geotitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(geoLabel)
            make.bottom.equalTo(geoLabel.snp.bottom).offset(-15)
            make.width.equalTo(geoLabel).multipliedBy(0.54)
            make.height.equalTo(geoLabel).multipliedBy(0.12)
        }
        smsLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(connectAndShareLabel.snp.bottom).offset(10)
            make.left.width.height.equalTo(connectAndShareLabel)
        }
        smsimageView.snp.makeConstraints{ (make) in
            make.center.equalTo(smsLabel)
            make.height.width.equalTo(smsLabel).multipliedBy(0.27)
        }
        smstitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(smsLabel)
            make.bottom.equalTo(smsLabel.snp.bottom).offset(-15)
            make.width.equalTo(smsLabel).multipliedBy(0.54)
            make.height.equalTo(smsLabel).multipliedBy(0.12)
        }
        editVehicleInfoLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(geoLabel.snp.bottom).offset(10)
            make.left.width.height.equalTo(geoLabel)
        }
        editVehicleInfoImage.snp.makeConstraints{ (make) in
            make.center.equalTo(editVehicleInfoLabel)
            make.height.width.equalTo(editVehicleInfoLabel).multipliedBy(0.27)
        }
        editVehicleInfoTitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(editVehicleInfoLabel)
            make.bottom.equalTo(editVehicleInfoLabel.snp.bottom).offset(-15)
            make.width.equalTo(editVehicleInfoLabel).multipliedBy(0.54)
            make.height.equalTo(editVehicleInfoLabel).multipliedBy(0.12)
        }
        faqLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(smsLabel.snp.bottom).offset(10)
            make.left.width.height.equalTo(smsLabel)
        }
        faqimv.snp.makeConstraints{ (make) in
            make.center.equalTo(faqLabel)
            make.height.width.equalTo(faqLabel).multipliedBy(0.27)
        }
        faqtitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(faqLabel)
            make.bottom.equalTo(faqLabel.snp.bottom).offset(-15)
            make.width.equalTo(faqLabel).multipliedBy(0.54)
            make.height.equalTo(faqLabel).multipliedBy(0.12)
        }
        logoutLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(editVehicleInfoLabel.snp.bottom).offset(10)
            make.left.width.height.equalTo(editVehicleInfoLabel)
        }
        logoutimageView.snp.makeConstraints{ (make) in
            make.center.equalTo(logoutLabel)
            make.height.width.equalTo(logoutLabel).multipliedBy(0.27)
        }
        logouttitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(logoutLabel)
            make.bottom.equalTo(logoutLabel.snp.bottom).offset(-15)
            make.width.equalTo(logoutLabel).multipliedBy(0.54)
            make.height.equalTo(logoutLabel).multipliedBy(0.12)
        }
    }
    
    
    func addConstrans() {
        
        reportLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(UIScreen.main.bounds.width * 0.05)
            make.top.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.44)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        
        reportimageView.snp.makeConstraints { (make) in
            make.center.equalTo(reportLabel)
            make.height.width.equalTo(reportLabel).multipliedBy(0.27)
            
        }
        
        reporttitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(reportLabel)
            make.bottom.equalTo(reportLabel.snp.bottom).offset(-15)
            make.width.equalTo(reportLabel).multipliedBy(0.54)
            make.height.equalTo(reportLabel).multipliedBy(0.12)
        }
        
        immobilizeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(reportLabel.snp.right).offset(10)
            make.top.height.width.equalTo(reportLabel)
            
        }
        
        immobilizeimageView.snp.makeConstraints { (make) in
            make.center.equalTo(immobilizeLabel)
            make.top.height.width.equalTo(reportimageView)
        }
        
        immobilizetitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(immobilizeLabel)
            make.top.height.equalTo(reporttitleLabel)
            make.width.equalTo(immobilizeLabel).multipliedBy(0.64)
        }
        
        appSettingLabel.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(reportLabel)
            make.top.equalTo(reportLabel.snp.bottom).offset(10)
            
        }
        
        appSettingimageView.snp.makeConstraints { (make) in
            make.center.equalTo(appSettingLabel)
            make.height.width.equalTo(reportimageView)
        }
        
        apptitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(appSettingLabel)
            make.bottom.equalTo(appSettingLabel.snp.bottom).offset(-15)
            make.height.equalTo(reporttitleLabel)
            make.width.equalTo(appSettingLabel).multipliedBy(0.75)
            
        }
        
        connectAndShareLabel.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(immobilizeLabel)
            make.top.equalTo(appSettingLabel)
        }
        
        connectAndShareimv.snp.makeConstraints { (make) in
            make.left.equalTo(immobilizeimageView)
            make.top.height.width.equalTo(appSettingimageView)
        }
        
        connectAndSharetitleLabel.snp.makeConstraints { (make) in
            make.top.height.equalTo(apptitleLabel)
            make.centerX.equalTo(connectAndShareLabel)
            make.width.equalTo(connectAndShareLabel).multipliedBy(0.94)
        }
        
        geoLabel.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(reportLabel)
            make.top.equalTo(appSettingLabel.snp.bottom).offset(10)
        }
        
        geoimageView.snp.makeConstraints { (make) in
            make.center.equalTo(geoLabel)
            make.height.width.equalTo(reportLabel).multipliedBy(0.25)
        }
        geotitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(geoLabel)
            make.bottom.equalTo(geoLabel.snp.bottom).offset(-15)
            make.width.equalTo(geoLabel).multipliedBy(0.6)
            make.height.equalTo(reporttitleLabel)
            
        }
        
        smsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(connectAndShareLabel)
            make.top.height.width.equalTo(geoLabel)
        }
        
        smsimageView.snp.makeConstraints { (make) in
            make.center.equalTo(smsLabel)
            make.height.width.equalTo(reportimageView)
        }
        
        smstitleLabel.snp.makeConstraints { (make) in
            make.top.height.equalTo(geotitleLabel)
            make.centerX.equalTo(smsLabel)
            make.width.equalTo(smsLabel).multipliedBy(0.86)
        }
        
        profileLabel.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(geoLabel)
            make.top.equalTo(geoLabel.snp.bottom).offset(10)
        }
        profileimv.snp.makeConstraints { (make) in
            make.center.equalTo(profileLabel)
            make.height.width.equalTo(profileLabel).multipliedBy(0.25)
        }
        profiletitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(profileLabel)
            make.bottom.equalTo(profileLabel.snp.bottom).offset(-15)
            make.width.equalTo(profileLabel).multipliedBy(0.86)
            make.height.equalTo(geotitleLabel)
            
        }
        
        helpLabel.snp.makeConstraints { (make) in
            make.left.equalTo(smsLabel)
            make.top.height.width.equalTo(profileLabel)
            
        }
        helpimageView.snp.makeConstraints { (make) in
            make.center.equalTo(helpLabel)
            make.height.width.equalTo(reportimageView)
        }
        helptitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(helpLabel)
            make.bottom.equalTo(helpLabel.snp.bottom).offset(-15)
            make.width.equalTo(helpLabel).multipliedBy(0.86)
            make.height.equalTo(reporttitleLabel)
        }
        editVehicleInfoLabel.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(profileLabel)
            make.top.equalTo(profileLabel.snp.bottom).offset(20)
        }
        
        editVehicleInfoImage.snp.makeConstraints { (make) in
            make.center.equalTo(editVehicleInfoLabel)
            make.height.width.equalTo(reportimageView)
        }
        
        editVehicleInfoTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(editVehicleInfoLabel)
            make.bottom.equalTo(editVehicleInfoLabel.snp.bottom).offset(-15)
            make.width.equalTo(editVehicleInfoLabel).multipliedBy(0.86)
            make.height.equalTo(reporttitleLabel)
        }
        
        
        faqLabel.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(helpLabel)
            make.top.equalTo(helpLabel.snp.bottom).offset(20)
            
        }
        
        faqimv.snp.makeConstraints { (make) in
            make.center.equalTo(faqLabel.snp.center)
            make.height.equalTo(editVehicleInfoImage.snp.height)
            make.width.equalTo(editVehicleInfoImage.snp.width)
        }
        
        faqtitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(faqLabel.snp.centerX)
            make.top.equalTo(faqimv.snp.bottom).offset(20)
            make.height.equalTo(editVehicleInfoTitleLabel.snp.height)
            make.width.equalTo(faqLabel.snp.width).multipliedBy(0.64)
        }
        
        loadUnloadLabel.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(editVehicleInfoLabel)
            make.top.equalTo(editVehicleInfoLabel.snp.bottom).offset(20)
        }
        
        loadUnloadImageView.snp.makeConstraints { (make) in
            make.center.equalTo(loadUnloadLabel)
            make.height.width.equalTo(reportimageView)
        }
        
        loadUnloadTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(loadUnloadLabel)
            make.bottom.equalTo(loadUnloadLabel.snp.bottom).offset(-15)
            make.width.equalTo(loadUnloadLabel).multipliedBy(0.49)
            make.height.equalTo(reporttitleLabel)
        }
        
        liveStreamingLabel.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(faqLabel)
            make.top.equalTo(faqLabel.snp.bottom).offset(20)
            
        }
        
        liveStreamingImageView.snp.makeConstraints { (make) in
            make.center.equalTo(liveStreamingLabel.snp.center)
            make.height.equalTo(faqimv.snp.height)
            make.width.equalTo(faqimv.snp.width)
        }
        
        liveStreamingTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(liveStreamingLabel.snp.centerX)
            make.top.equalTo(liveStreamingImageView.snp.bottom).offset(20)
            make.height.equalTo(faqtitleLabel.snp.height)
            make.width.equalTo(liveStreamingLabel.snp.width).multipliedBy(0.64)
        }
        
        logoutLabel.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(editVehicleInfoLabel)
            make.top.equalTo(editVehicleInfoLabel.snp.bottom).offset(20)
        }
        
        logoutimageView.snp.makeConstraints { (make) in
            make.center.equalTo(logoutLabel)
            make.height.width.equalTo(reportimageView)
        }
        
        logouttitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(logoutLabel)
            make.bottom.equalTo(logoutLabel.snp.bottom).offset(-15)
            make.width.equalTo(logoutLabel).multipliedBy(0.49)
            make.height.equalTo(reporttitleLabel)
        }
        
        
    }
    
}
