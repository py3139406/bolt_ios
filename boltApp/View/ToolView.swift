//
//  ToolView.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class ToolView: UIView {
    var toolsLabel:UILabel!
    var collectionView:UICollectionView!
  //  var topView:UIView!
   // var bgImage:UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setViews(){
//        topView = UIView()
//        addSubview(topView)
//
//        bgImage = UIImageView(frame: CGRect.zero)
//        bgImage.contentMode = .scaleToFill
//        bgImage.image = #imageLiteral(resourceName: "ic_tools_header.png")
//        topView.addSubview(bgImage)
        self.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
        
        toolsLabel = PaddingToLabel(withInsets: 5, 5, 20, 20)
        toolsLabel.textColor = .black
        let boltString = "BOLT"
        let toolsString = "Tools"
        let boldFont = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold)]
        let lightFont = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .light)]
        let boltStr = NSAttributedString(string: boltString, attributes: lightFont)
        let toolsStr = NSAttributedString(string: toolsString, attributes: boldFont)
        let finalString:NSMutableAttributedString = NSMutableAttributedString()
        finalString.append(boltStr)
        finalString.append(NSAttributedString(string: " "))
        finalString.append(toolsStr)
        toolsLabel.attributedText = finalString
        toolsLabel.backgroundColor =  .white  //UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
     //   toolsLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
//        toolsLabel = PaddingLabel()
   //     toolsLabel.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
//        toolsLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
//        toolsLabel.text = "BOLT"
//        toolsLabel.textColor = .black
        //  add shadow
        // toolsLabel.addShadow()
         addSubview(toolsLabel)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
       //  layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
       // layout.itemSize = CGSize(width: screensize.width/2 - 10,
       //                          height: 150)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.footerReferenceSize = CGSize.zero
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        addSubview(collectionView)
        
    }
   
    func addConstraints(){
        toolsLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(toolsLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(collectionView.contentSize.height)
            make.bottom.equalToSuperview()
        }
    }
}




