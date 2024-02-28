//
//  ToolsScrollView.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class ToolsScrollView: UIScrollView {
    var kscreenheight = UIScreen.main.bounds.height
    var kscreenwidth = UIScreen.main.bounds.width
    var reportLabel: UILabel!
    var reportimageView: UIImageView!
    var reporttitleLabel: PaddingLabel!
    
    var immobilizeLabel: UILabel!
    var immobilizeimageView: UIImageView!
    var immobilizetitleLabel: PaddingLabel!
    
    var appSettingLabel: UILabel!
    var appSettingimageView: UIImageView!
    var apptitleLabel: PaddingLabel!
    
    var configurationLabel: UILabel!
    var configurationImgView: UIImageView!
    var configurationTitlelabel: PaddingLabel!
    
    var geoLabel: UILabel!
    var geoimageView: UIImageView!
    var geotitleLabel: PaddingLabel!
    
    var poiLabel: UILabel!
    var poiImageView: UIImageView!
    var poiTitleLabel: PaddingLabel!
    
    var helpLabel: UILabel!
    var helpimageView: UIImageView!
    var helptitleLabel: PaddingLabel!
    
    var logoutLabel: UILabel!
    var logoutimageView: UIImageView!
    var logouttitleLabel: PaddingLabel!
    
    var connectAndShareLabel: UILabel!
    var connectAndShareimv: UIImageView!
    var connectAndSharetitleLabel: PaddingLabel!
    
    var profileLabel: UILabel!
    var profileimv: UIImageView!
    var profiletitleLabel: PaddingLabel!
    
    var editVehicleInfoLabel: UILabel!
    var editVehicleInfoImage: UIImageView!
    var editVehicleInfoTitleLabel: PaddingLabel!
    
    var faqLabel: UILabel!
    var faqimv: UIImageView!
    var faqtitleLabel: PaddingLabel!
    
    var loadUnloadLabel: UILabel!
    var loadUnloadImageView: UIImageView!
    var loadUnloadTitleLabel: PaddingLabel!
    
    var liveStreamingLabel: UILabel!
    var liveStreamingImageView: UIImageView!
    var liveStreamingTitleLabel: PaddingLabel!
    
    var subscriptionLabel: UILabel!
    var subscriptionImageView: UIImageView!
    var subscriptionTitleLabel: PaddingLabel!
    
    var dashboardLabel:UILabel!
    var dashboardImageView:UIImageView!
    var dashboardTitleLabel:PaddingLabel!
    
    var googleAssistanceLabel: UILabel!
    var googleAssistanceImageView: UIImageView!
    var googleAssistanceTitleLabel: UILabel!
    var googleAssistanceWorkWithImageView: UIImageView!
    var flagImageView: UIImageView!
    var toolsLabelBgColor = UIColor(red: 0.15, green: 0.15, blue: 0.23, alpha: 1.0)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        //addConstrans()
        addConstrans2()
        //self.contentHeight = UIScreen.main.bounds.height * 1.25
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func addViews() {
        dashboardLabel = UILabel()
        dashboardLabel.isUserInteractionEnabled = true
        dashboardLabel.backgroundColor = .white
        dashboardLabel.layer.cornerRadius = 5
        dashboardLabel.clipsToBounds = true
        addSubview(dashboardLabel)
        
        dashboardImageView = UIImageView()
        dashboardImageView.image = #imageLiteral(resourceName: "Asset 1")
        dashboardImageView.contentMode = .scaleAspectFill
        addSubview(dashboardImageView)
        
        dashboardTitleLabel = PaddingLabel()
        dashboardTitleLabel.backgroundColor = toolsLabelBgColor
        dashboardTitleLabel.text = "DASHBOARD".toLocalize
        dashboardTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        dashboardTitleLabel.textColor = .white
        dashboardTitleLabel.frame.size.width = dashboardTitleLabel.intrinsicContentSize.width
        dashboardTitleLabel.layer.cornerRadius = 3
       // dashboardTitleLabel.minimumScaleFactor = 0.5
        dashboardTitleLabel.layer.masksToBounds = true
       // dashboardTitleLabel.adjustsFontSizeToFitWidth = true
        dashboardTitleLabel.textAlignment = .center
        addSubview(dashboardTitleLabel)
        
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
        
        profiletitleLabel = PaddingLabel()
        profiletitleLabel.backgroundColor = toolsLabelBgColor
        profiletitleLabel.text = "PROFILE".toLocalize
        profiletitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        profiletitleLabel.frame.size.width = profiletitleLabel.intrinsicContentSize.width
        profiletitleLabel.layer.masksToBounds = true
       // profiletitleLabel.minimumScaleFactor = 0.5
        profiletitleLabel.textColor = .white
        profiletitleLabel.layer.cornerRadius = 3
        profiletitleLabel.textAlignment = .center
        addSubview(profiletitleLabel)
        
        
        
        googleAssistanceLabel = UILabel()
        googleAssistanceLabel.isUserInteractionEnabled = true
        googleAssistanceLabel.backgroundColor = .white
        googleAssistanceLabel.layer.cornerRadius = 5
        googleAssistanceLabel.clipsToBounds = true
        addSubview(googleAssistanceLabel)
        
        googleAssistanceImageView = UIImageView()
        googleAssistanceImageView.image = #imageLiteral(resourceName: "mic")
        googleAssistanceImageView.contentMode = .scaleAspectFill
        addSubview(googleAssistanceImageView)
        
        googleAssistanceTitleLabel = PaddingLabel()
        googleAssistanceTitleLabel.backgroundColor = toolsLabelBgColor
        googleAssistanceTitleLabel.text = "VOICE ASSIST".toLocalize
        googleAssistanceTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        googleAssistanceTitleLabel.frame.size.width = profiletitleLabel.intrinsicContentSize.width
        googleAssistanceTitleLabel.layer.masksToBounds = true
      //  googleAssistanceTitleLabel.minimumScaleFactor = 0.5
        googleAssistanceTitleLabel.textColor = .white
        googleAssistanceTitleLabel.layer.cornerRadius = 3
        googleAssistanceTitleLabel.textAlignment = .center
        addSubview(googleAssistanceTitleLabel)
        
        
        googleAssistanceWorkWithImageView = UIImageView()
        googleAssistanceWorkWithImageView.image = #imageLiteral(resourceName: "workwith")
        googleAssistanceWorkWithImageView.contentMode = .scaleAspectFill
        addSubview(googleAssistanceWorkWithImageView)
        
        flagImageView = UIImageView()
        flagImageView.image = #imageLiteral(resourceName: "new label")
        flagImageView.contentMode = .scaleAspectFill
        addSubview(flagImageView)
        
        
        
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
        
        helptitleLabel = PaddingLabel()
        helptitleLabel.backgroundColor = toolsLabelBgColor
        helptitleLabel.text = "HELP".toLocalize
        helptitleLabel.textColor = .white
        helptitleLabel.layer.cornerRadius = 3
        helptitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        // helptitleLabel.clipsToBounds = true
        helptitleLabel.frame.size.width = helptitleLabel.intrinsicContentSize.width
        helptitleLabel.layer.masksToBounds = true
       // helptitleLabel.minimumScaleFactor = 0.5
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
        
        immobilizetitleLabel = PaddingLabel()
        immobilizetitleLabel.backgroundColor = toolsLabelBgColor
        immobilizetitleLabel.text = "IMMOBILIZE".toLocalize
        immobilizetitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        immobilizetitleLabel.frame.size.width = immobilizetitleLabel.intrinsicContentSize.width
        immobilizetitleLabel.layer.masksToBounds = true
        //immobilizetitleLabel.minimumScaleFactor = 0.5
        immobilizetitleLabel.textColor = .white
        immobilizetitleLabel.layer.cornerRadius = 3
        // immobilizetitleLabel.clipsToBounds = true
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
        
        reporttitleLabel = PaddingLabel()
        reporttitleLabel.backgroundColor = toolsLabelBgColor
        reporttitleLabel.text = "REPORTS".toLocalize
        reporttitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        reporttitleLabel.frame.size.width = reporttitleLabel.intrinsicContentSize.width
        reporttitleLabel.layer.masksToBounds = true
      //  reporttitleLabel.minimumScaleFactor = 0.5
        reporttitleLabel.textColor = .white
        reporttitleLabel.layer.cornerRadius = 3
        // reporttitleLabel.clipsToBounds = true
        reporttitleLabel.textAlignment = .center
        addSubview(reporttitleLabel)
        
        configurationLabel = UILabel()
        configurationLabel.backgroundColor = .white
        configurationLabel.isUserInteractionEnabled = true
        configurationLabel.layer.cornerRadius = 5
        configurationLabel.clipsToBounds = true
        addSubview(configurationLabel)
        
        configurationImgView = UIImageView()
        configurationImgView.image = #imageLiteral(resourceName: "dashicon4")
        configurationImgView.contentMode = .scaleAspectFill
        addSubview(configurationImgView)
        
        configurationTitlelabel = PaddingLabel()
        configurationTitlelabel.backgroundColor = toolsLabelBgColor
        configurationTitlelabel.text = "CONFIGURATION".toLocalize
        configurationTitlelabel.adjustsFontSizeToFitWidth = true
        configurationTitlelabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        configurationTitlelabel.textColor = .white
        configurationTitlelabel.layer.cornerRadius = 3
        //configurationTitlelabel.clipsToBounds = true
        configurationTitlelabel.frame.size.width = configurationTitlelabel.intrinsicContentSize.width
        configurationTitlelabel.layer.masksToBounds = true
      //  configurationTitlelabel.minimumScaleFactor = 0.5
        configurationTitlelabel.textAlignment = .center
        addSubview(configurationTitlelabel)
        
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
        
        geotitleLabel = PaddingLabel()
        geotitleLabel.backgroundColor = toolsLabelBgColor
        geotitleLabel.text = "GEOFENCE".toLocalize
        geotitleLabel.textColor = .white
        geotitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        geotitleLabel.frame.size.width = geotitleLabel.intrinsicContentSize.width
        geotitleLabel.layer.masksToBounds = true
       // geotitleLabel.minimumScaleFactor = 0.5
        geotitleLabel.layer.cornerRadius = 3
        //  geotitleLabel.clipsToBounds = true
        geotitleLabel.textAlignment = .center
        addSubview(geotitleLabel)
        
        poiLabel = UILabel()
        poiLabel.backgroundColor = .white
        poiLabel.isUserInteractionEnabled = true
        poiLabel.layer.cornerRadius = 5
        poiLabel.clipsToBounds = true
        addSubview(poiLabel)
        
        poiImageView = UIImageView()
        poiImageView.image = #imageLiteral(resourceName: "Asset 7")
        poiImageView.contentMode = .scaleAspectFill
        addSubview(poiImageView)
        
        poiTitleLabel = PaddingLabel()
        poiTitleLabel.backgroundColor = toolsLabelBgColor
        poiTitleLabel.text = "POI".toLocalize
        poiTitleLabel.textColor = .white
        poiTitleLabel.frame.size.width = poiTitleLabel.intrinsicContentSize.width
        poiTitleLabel.layer.masksToBounds = true
      //  poiTitleLabel.minimumScaleFactor = 0.5
        poiTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        poiTitleLabel.layer.cornerRadius = 3
        // poiTitleLabel.clipsToBounds = true
        poiTitleLabel.textAlignment = .center
        addSubview(poiTitleLabel)
        
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
        
        connectAndSharetitleLabel = PaddingLabel()
        connectAndSharetitleLabel.backgroundColor = toolsLabelBgColor
        connectAndSharetitleLabel.text = "CONNECT & SHARE".toLocalize
        connectAndSharetitleLabel.frame.size.width = connectAndSharetitleLabel.intrinsicContentSize.width
        connectAndSharetitleLabel.layer.masksToBounds = true
       // connectAndSharetitleLabel.minimumScaleFactor = 0.5
        //  connectAndSharetitleLabel.adjustsFontSizeToFitWidth = true
        connectAndSharetitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        // connectAndSharetitleLabel.frame.size.width = connectAndSharetitleLabel.intrinsicContentSize.width
        connectAndSharetitleLabel.textColor = .white
        connectAndSharetitleLabel.layer.cornerRadius = 3
        // connectAndSharetitleLabel.clipsToBounds = true
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
        
        apptitleLabel = PaddingLabel()
        apptitleLabel.backgroundColor = toolsLabelBgColor
        apptitleLabel.text = "APP SETTINGS".toLocalize
        //apptitleLabel.adjustsFontSizeToFitWidth = true
        apptitleLabel.frame.size.width = apptitleLabel.intrinsicContentSize.width
        apptitleLabel.layer.masksToBounds = true
       // apptitleLabel.minimumScaleFactor = 0.5
        apptitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        apptitleLabel.textColor = .white
        apptitleLabel.layer.cornerRadius = 3
        //  apptitleLabel.clipsToBounds = true
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
        
        editVehicleInfoTitleLabel = PaddingLabel()//UILabel()
        editVehicleInfoTitleLabel.backgroundColor = toolsLabelBgColor
        editVehicleInfoTitleLabel.text = "EDIT VEHICLE INFO".toLocalize
        editVehicleInfoTitleLabel.frame.size.width = editVehicleInfoTitleLabel.intrinsicContentSize.width
        editVehicleInfoTitleLabel.layer.masksToBounds = true
        //editVehicleInfoTitleLabel.minimumScaleFactor = 0.5
        editVehicleInfoTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        editVehicleInfoTitleLabel.textColor = .white
        //editVehicleInfoTitleLabel.adjustsFontSizeToFitWidth = true
        editVehicleInfoTitleLabel.layer.cornerRadius = 3
        // editVehicleInfoTitleLabel.clipsToBounds = true
        editVehicleInfoTitleLabel.textAlignment = .center
        addSubview(editVehicleInfoTitleLabel)
        
        faqLabel = UILabel()
        faqLabel.isUserInteractionEnabled = true
        faqLabel.backgroundColor = .white
        faqLabel.layer.cornerRadius = 5
        faqLabel.clipsToBounds = true
        // faqLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(faqLabel)
        
        faqimv = UIImageView()
        faqimv.image = UIImage(named: "more")
        faqimv.contentMode = .scaleAspectFill
        // faqimv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(faqimv)
        
        faqtitleLabel = PaddingLabel()
        faqtitleLabel.backgroundColor = toolsLabelBgColor
        faqtitleLabel.text = "F.A.Q.".toLocalize
        faqtitleLabel.frame.size.width = faqtitleLabel.intrinsicContentSize.width
        faqtitleLabel.layer.masksToBounds = true
      //  faqtitleLabel.minimumScaleFactor = 0.5
        faqtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        faqtitleLabel.textColor = .white
        // faqtitleLabel.adjustsFontSizeToFitWidth = true
        faqtitleLabel.layer.cornerRadius = 3
        //  faqtitleLabel.clipsToBounds = true
        faqtitleLabel.textAlignment = .center
        // faqtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(faqtitleLabel)
        
        loadUnloadLabel = UILabel()
        loadUnloadLabel.isUserInteractionEnabled = true
        loadUnloadLabel.backgroundColor = .white
        loadUnloadLabel.layer.cornerRadius = 5
        loadUnloadLabel.clipsToBounds = true
        // loadUnloadLabel.translatesAutoresizingMaskIntoConstraints = false
        loadUnloadLabel.isHidden = true
        addSubview(loadUnloadLabel)
        
        loadUnloadImageView = UIImageView()
        loadUnloadImageView.image = UIImage(named: "LoadUnload")
        loadUnloadImageView.contentMode = .scaleAspectFill
        // loadUnloadImageView.translatesAutoresizingMaskIntoConstraints = false
        loadUnloadImageView.isHidden = true
        addSubview(loadUnloadImageView)
        
        loadUnloadTitleLabel = PaddingLabel()
        loadUnloadTitleLabel.backgroundColor = toolsLabelBgColor
        loadUnloadTitleLabel.text = "Load/Unload".toLocalize
        loadUnloadTitleLabel.frame.size.width = loadUnloadTitleLabel.intrinsicContentSize.width
        loadUnloadTitleLabel.layer.masksToBounds = true
    //    loadUnloadTitleLabel.minimumScaleFactor = 0.5
        loadUnloadTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        loadUnloadTitleLabel.textColor = .white
        //loadUnloadTitleLabel.adjustsFontSizeToFitWidth = true
        loadUnloadTitleLabel.layer.cornerRadius = 3
        //   loadUnloadTitleLabel.clipsToBounds = true
        loadUnloadTitleLabel.textAlignment = .center
        // loadUnloadTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        loadUnloadTitleLabel.isHidden = true
        addSubview(loadUnloadTitleLabel)
        
        subscriptionLabel = UILabel(frame: CGRect.zero)
        subscriptionLabel.isUserInteractionEnabled = true
        subscriptionLabel.backgroundColor = .white
        subscriptionLabel.layer.cornerRadius = 5
        subscriptionLabel.clipsToBounds = true
        //  subscriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        //liveStreamingLabel.isHidden = true
        addSubview(subscriptionLabel)
        
        subscriptionImageView = UIImageView()
        subscriptionImageView.image = #imageLiteral(resourceName: "subscription.png")
        subscriptionImageView.contentMode = .scaleAspectFill
        // subscriptionImageView.translatesAutoresizingMaskIntoConstraints = false
        //liveStreamingImageView.isHidden = true
        addSubview(subscriptionImageView)
        
        subscriptionTitleLabel = PaddingLabel()//UILabel(frame: CGRect.zero)
        subscriptionTitleLabel.backgroundColor = toolsLabelBgColor
        subscriptionTitleLabel.text = "SUBSCRIPTIONS".toLocalize
        subscriptionTitleLabel.frame.size.width = subscriptionTitleLabel.intrinsicContentSize.width
        subscriptionTitleLabel.layer.masksToBounds = true
        //subscriptionTitleLabel.minimumScaleFactor = 0.5
        // liveStreamingTitleLabel.adjustsFontSizeToFitWidth = true
        subscriptionTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        subscriptionTitleLabel.textColor = .white
        //liveStreamingTitleLabel.adjustsFontSizeToFitWidth = true
        subscriptionTitleLabel.layer.cornerRadius = 3
        //  subscriptionTitleLabel.clipsToBounds = true
        subscriptionTitleLabel.textAlignment = .center
        // subscriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        // liveStreamingTitleLabel.isHidden = true
        addSubview(subscriptionTitleLabel)
        
        
        liveStreamingLabel = UILabel(frame: CGRect.zero)
        liveStreamingLabel.isUserInteractionEnabled = true
        liveStreamingLabel.backgroundColor = .white
        liveStreamingLabel.layer.cornerRadius = 5
        liveStreamingLabel.clipsToBounds = true
        //liveStreamingLabel.translatesAutoresizingMaskIntoConstraints = false
        //liveStreamingLabel.isHidden = true
        addSubview(liveStreamingLabel)
        
        liveStreamingImageView = UIImageView()
        liveStreamingImageView.image = UIImage(named: "liveStreamingPDF")
        liveStreamingImageView.contentMode = .scaleAspectFill
        // liveStreamingImageView.translatesAutoresizingMaskIntoConstraints = false
        //liveStreamingImageView.isHidden = true
        addSubview(liveStreamingImageView)
        
        liveStreamingTitleLabel = PaddingLabel()//UILabel(frame: CGRect.zero)
        liveStreamingTitleLabel.backgroundColor = toolsLabelBgColor
        liveStreamingTitleLabel.text = "LIVE STREAMING".toLocalize
        liveStreamingTitleLabel.frame.size.width = liveStreamingTitleLabel.intrinsicContentSize.width
        liveStreamingTitleLabel.layer.masksToBounds = true
      //  liveStreamingTitleLabel.minimumScaleFactor = 0.5
        //  liveStreamingTitleLabel.adjustsFontSizeToFitWidth = true
        liveStreamingTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        liveStreamingTitleLabel.textColor = .white
        //liveStreamingTitleLabel.adjustsFontSizeToFitWidth = true
        liveStreamingTitleLabel.layer.cornerRadius = 3
        // liveStreamingTitleLabel.clipsToBounds = true
        liveStreamingTitleLabel.textAlignment = .center
        //liveStreamingTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        // liveStreamingTitleLabel.isHidden = true
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
        
        logouttitleLabel = PaddingLabel()
        logouttitleLabel.backgroundColor = toolsLabelBgColor
        logouttitleLabel.text = "LOGOUT".toLocalize
        logouttitleLabel.frame.size.width = logouttitleLabel.intrinsicContentSize.width
        logouttitleLabel.layer.masksToBounds = true
      //  logouttitleLabel.minimumScaleFactor = 0.5
        logouttitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        logouttitleLabel.textColor = .white
        logouttitleLabel.layer.cornerRadius = 3
        // logouttitleLabel.clipsToBounds = true
        logouttitleLabel.textAlignment = .center
        addSubview(logouttitleLabel)
        
    }
    func addConstrans2() {
        dashboardLabel.snp.makeConstraints{ (make) in
            make.left.equalToSuperview().offset(UIScreen.main.bounds.width * 0.01)
            make.top.equalToSuperview().offset(2)
            make.width.equalToSuperview().multipliedBy(0.48)
            make.height.equalToSuperview().multipliedBy(0.20)
        }
        dashboardImageView.snp.makeConstraints{ (make) in
            make.centerX.centerY.equalTo(dashboardLabel)
            make.height.width.equalTo(dashboardLabel).multipliedBy(0.20)
        }
        dashboardTitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(dashboardLabel)
            make.bottom.equalTo(dashboardLabel.snp.bottom).offset(-kscreenheight * 0.02)
            //  make.width.equalTo(dashboardLabel).multipliedBy(0.54)
            make.height.equalTo(dashboardLabel).multipliedBy(0.15)
        }
        profileLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(appSettingLabel.snp.bottom).offset(5)
            make.left.width.height.equalTo(appSettingLabel)
        }
        profileimv.snp.makeConstraints{ (make) in
            make.center.equalTo(profileLabel)
            make.height.width.equalTo(profileLabel).multipliedBy(0.20)
        }
        profiletitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(profileLabel)
            make.bottom.equalTo(profileLabel.snp.bottom).offset(-kscreenheight * 0.02)
            // make.width.equalTo(profileLabel).multipliedBy(0.74)
            make.height.equalTo(profileLabel).multipliedBy(0.15)
        }
        helpLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(dashboardLabel.snp.right).offset(5)
            make.top.height.width.equalTo(dashboardLabel)
        }
        helpimageView.snp.makeConstraints{ (make) in
            make.center.equalTo(helpLabel)
            make.height.width.equalTo(helpLabel).multipliedBy(0.20)
        }
        helptitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(helpLabel)
            make.bottom.equalTo(helpLabel.snp.bottom).offset(-kscreenheight * 0.02)
            //make.width.equalTo(helpLabel).multipliedBy(0.54)
            make.height.equalTo(helpLabel).multipliedBy(0.15)
        }
        reportLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(dashboardLabel.snp.bottom).offset(5)
            make.left.width.height.equalTo(dashboardLabel)
        }
        reportimageView.snp.makeConstraints{ (make) in
            make.center.equalTo(reportLabel)
            make.height.width.equalTo(reportLabel).multipliedBy(0.20)
        }
        reporttitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(reportLabel)
            make.bottom.equalTo(reportLabel.snp.bottom).offset(-kscreenheight * 0.02)
            // make.width.equalTo(reportLabel).multipliedBy(0.54)
            make.height.equalTo(reportLabel).multipliedBy(0.15)
        }
        immobilizeLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(helpLabel.snp.bottom).offset(5)
            make.left.width.height.equalTo(helpLabel)
        }
        immobilizeimageView.snp.makeConstraints{ (make) in
            make.center.equalTo(immobilizeLabel)
            make.height.width.equalTo(immobilizeLabel).multipliedBy(0.20)
        }
        immobilizetitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(immobilizeLabel)
            make.bottom.equalTo(immobilizeLabel.snp.bottom).offset(-kscreenheight * 0.02)
            // make.width.equalTo(immobilizeLabel).multipliedBy(0.54)
            make.height.equalTo(immobilizeLabel).multipliedBy(0.15)
        }
        editVehicleInfoLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(poiLabel.snp.bottom).offset(5)
            make.left.width.height.equalTo(poiLabel)
        }
        editVehicleInfoImage.snp.makeConstraints{ (make) in
            make.center.equalTo(editVehicleInfoLabel)
            make.height.width.equalTo(editVehicleInfoLabel).multipliedBy(0.20)
        }
        editVehicleInfoTitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(editVehicleInfoLabel)
            make.bottom.equalTo(editVehicleInfoLabel.snp.bottom).offset(-kscreenheight * 0.02)
            //  make.width.equalTo(editVehicleInfoLabel).multipliedBy(0.84)
            make.height.equalTo(editVehicleInfoLabel).multipliedBy(0.15)
        }
        appSettingLabel.snp.makeConstraints{ (make) in
           make.top.equalTo(geoLabel.snp.bottom).offset(5)
            make.left.width.height.equalTo(geoLabel)
        }
        appSettingimageView.snp.makeConstraints{ (make) in
            make.center.equalTo(appSettingLabel)
            make.height.width.equalTo(appSettingLabel).multipliedBy(0.20)
        }
        apptitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(appSettingLabel)
            make.bottom.equalTo(appSettingLabel.snp.bottom).offset(-kscreenheight * 0.02)
            //  make.width.equalTo(appSettingLabel).multipliedBy(0.74)
            make.height.equalTo(appSettingLabel).multipliedBy(0.15)
        }
        connectAndShareLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(editVehicleInfoLabel.snp.bottom).offset(5)
            make.left.width.height.equalTo(editVehicleInfoLabel)
        }
        connectAndShareimv.snp.makeConstraints{ (make) in
            make.center.equalTo(connectAndShareLabel)
            make.height.width.equalTo(connectAndShareLabel).multipliedBy(0.20)
        }
        connectAndSharetitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(connectAndShareLabel)
            make.bottom.equalTo(connectAndShareLabel.snp.bottom).offset(-kscreenheight * 0.02)
            //   make.width.equalTo(connectAndShareLabel).multipliedBy(0.54)
            make.height.equalTo(connectAndShareLabel).multipliedBy(0.15)
        }
        configurationLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(profileLabel.snp.bottom).offset(5)
            make.left.width.height.equalTo(profileLabel)
        }
        configurationImgView.snp.makeConstraints{ (make) in
            make.center.equalTo(configurationLabel)
            make.height.width.equalTo(configurationLabel).multipliedBy(0.20)
        }
        configurationTitlelabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(configurationLabel)
            make.bottom.equalTo(configurationLabel.snp.bottom).offset(-kscreenheight * 0.02)
            //  make.width.equalTo(configurationLabel).multipliedBy(0.74)
            make.height.equalTo(configurationLabel).multipliedBy(0.15)
        }
        googleAssistanceLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(reportLabel.snp.bottom).offset(5)
            make.left.width.height.equalTo(reportLabel)
        }
        googleAssistanceImageView.snp.makeConstraints{ (make) in
            make.top.equalTo(googleAssistanceLabel).offset(20)
            make.centerX.equalTo(googleAssistanceLabel)
            make.height.width.equalTo(googleAssistanceLabel).multipliedBy(0.12)
        }
        googleAssistanceTitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(googleAssistanceLabel)
            make.bottom.equalTo(googleAssistanceWorkWithImageView.snp.top).offset(-kscreenheight * 0.01)
            make.height.equalTo(googleAssistanceLabel).multipliedBy(0.15)
        }
        flagImageView.snp.makeConstraints{(make) in
            make.top.equalTo(googleAssistanceLabel).offset(7)
            make.height.width.equalTo(googleAssistanceLabel).multipliedBy(0.15)
            make.right.equalTo(googleAssistanceLabel).offset(-kscreenwidth * 0.01)
        }
        googleAssistanceWorkWithImageView.snp.makeConstraints{(make) in
            make.bottom.equalTo(googleAssistanceLabel).offset(-kscreenheight * 0.02)
            make.centerX.equalTo(googleAssistanceLabel)
            make.height.equalTo(googleAssistanceLabel).multipliedBy(0.20)
            make.width.equalTo(googleAssistanceLabel).multipliedBy(0.9)
        }
            geoLabel.snp.makeConstraints{ (make) in
              make.top.equalTo(immobilizeLabel.snp.bottom).offset(5)
            make.left.width.height.equalTo(immobilizeLabel)
            }
            geoimageView.snp.makeConstraints{ (make) in
              make.center.equalTo(geoLabel)
              make.height.width.equalTo(geoLabel).multipliedBy(0.20)
            }
            geotitleLabel.snp.makeConstraints{ (make) in
              make.centerX.equalTo(geoLabel)
              make.bottom.equalTo(geoLabel.snp.bottom).offset(-kscreenheight * 0.02)
              // make.width.equalTo(editVehicleInfoLabel).multipliedBy(0.54)
              make.height.equalTo(geoLabel).multipliedBy(0.15)
            }
        poiLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(googleAssistanceLabel.snp.bottom).offset(5)
            make.left.width.height.equalTo(googleAssistanceLabel)
        }
        poiImageView.snp.makeConstraints{ (make) in
            make.center.equalTo(poiLabel)
            make.height.width.equalTo(poiLabel).multipliedBy(0.20)
        }
        poiTitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(poiLabel).offset(-10)
            make.bottom.equalTo(poiLabel.snp.bottom).offset(-kscreenheight * 0.02)
            // make.width.equalTo(editVehicleInfoLabel).multipliedBy(0.54)
            make.height.equalTo(googleAssistanceLabel).multipliedBy(0.15)
        }
        
        subscriptionLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(connectAndShareLabel.snp.bottom).offset(5)
            make.left.width.height.equalTo(connectAndShareLabel)
        }
        subscriptionImageView.snp.makeConstraints{ (make) in
            make.center.equalTo(subscriptionLabel)
            make.height.width.equalTo(subscriptionLabel).multipliedBy(0.20)
        }
        subscriptionTitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(subscriptionLabel)
            make.bottom.equalTo(subscriptionLabel.snp.bottom).offset(-kscreenheight * 0.02)
            // make.width.equalTo(editVehicleInfoLabel).multipliedBy(0.54)
            make.height.equalTo(subscriptionLabel).multipliedBy(0.15)
        }
        
        logoutLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(liveStreamingLabel.snp.bottom).offset(5)
            make.left.width.height.equalTo(liveStreamingLabel)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.safeAreaInsets.bottom).inset(10)
            } else {
                // Fallback on earlier versions
                make.bottom.equalToSuperview().inset(20)
            }
        }
        logoutimageView.snp.makeConstraints{ (make) in
            make.center.equalTo(logoutLabel)
            make.height.width.equalTo(logoutLabel).multipliedBy(0.20)
        }
        
        logouttitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(logoutLabel)
            make.bottom.equalTo(logoutLabel.snp.bottom).offset(-kscreenheight * 0.02)
            // make.width.equalTo(logoutLabel).multipliedBy(0.54)
            make.height.equalTo(logoutLabel).multipliedBy(0.15)
        }
        
        faqLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(subscriptionLabel.snp.bottom).offset(5)
            make.left.width.height.equalTo(subscriptionLabel)
            //        if #available(iOS 11.0, *) {
            //            make.bottom.equalTo(self.safeAreaInsets.bottom).inset(10)
            //        } else {
            //            // Fallback on earlier versions
            //            make.bottom.equalToSuperview().inset(20)
            //        }
            //make.left.equalTo(subscriptionLabel)
         //   make.bottom.equalToSuperview().offset(-10)
        }
        
        faqimv.snp.makeConstraints{ (make) in
            make.center.equalTo(faqLabel)
            make.height.width.equalTo(faqLabel).multipliedBy(0.20)
        }
        
        faqtitleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(faqLabel)
            make.bottom.equalTo(faqLabel.snp.bottom).offset(-kscreenheight * 0.02)
           // make.width.equalTo(faqLabel).multipliedBy(0.54)
            make.height.equalTo(faqLabel).multipliedBy(0.15)
        }
        
        liveStreamingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(configurationLabel.snp.bottom).offset(5)
            make.left.width.height.equalTo(configurationLabel)
        }
        
        liveStreamingImageView.snp.makeConstraints { (make) in
            make.center.equalTo(liveStreamingLabel)
            make.height.width.equalTo(liveStreamingLabel).multipliedBy(0.20)
        }
        
        liveStreamingTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(liveStreamingLabel)
            make.bottom.equalTo(liveStreamingLabel.snp.bottom).offset(-kscreenheight * 0.02)
          //  make.width.equalTo(liveStreamingLabel).multipliedBy(0.74)
            make.height.equalTo(liveStreamingLabel).multipliedBy(0.15)
            // make.width.equalTo(liveStreamingLabel.snp.width).multipliedBy(0.64)
        }
    }
    
    
    
}
