//
//  KilometreCells.swift
//  Bolt
//
//  Created by Saanica Gupta on 19/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import SnapKit

class KilometreTableViewCell: UITableViewCell {
  let titleLabel = UILabel()
  let headersStackView = UIStackView()
  let stackView = UIStackView()
  let dateTitle = UILabel()
  let kilometersTitle = UILabel()
   var containerView: UIView!
  var kscreenwidth = UIScreen.main.bounds.width
  var kscreenheight = UIScreen.main.bounds.height
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    commonInit()
    setConstraints()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func commonInit() {
    
   containerView = UIView(frame: CGRect.zero)
    containerView.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
     containerView.layer.cornerRadius = 5
     containerView.clipsToBounds = true
    contentView.addSubview(containerView)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textAlignment = .center
    titleLabel.textColor = .white
    titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    titleLabel.backgroundColor =  UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1.0)
    containerView.addSubview(titleLabel)
    
    headersStackView.axis = .horizontal
    headersStackView.distribution = .fillEqually
    headersStackView.alignment = .fill
    headersStackView.spacing = 5
    headersStackView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(headersStackView)
    
    dateTitle.text = "Date"
    dateTitle.textColor =  UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1.0)
    dateTitle.textAlignment = .center
    kilometersTitle.text = "Kilometers"
    kilometersTitle.textColor = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1.0)
    kilometersTitle.textAlignment = .center
    headersStackView.addArrangedSubview(dateTitle)
    headersStackView.addArrangedSubview(kilometersTitle)
    
    
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
    stackView.spacing = 5
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.frame.size.height = stackView.intrinsicContentSize.height
    containerView.addSubview(stackView)
    
  }
    func setConstraints(){
        containerView.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(screensize.width * 0.05)
                make.right.equalToSuperview().offset(-screensize.width * 0.05)
                make.top.equalToSuperview().offset(screensize.height * 0.01)
                make.bottom.equalToSuperview()//.offset(-20)
            }
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        stackView.topAnchor.constraint(equalTo: headersStackView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        headersStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        headersStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        headersStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -20).isActive = true
        headersStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        headersStackView.bottomAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
    }
  
    func setup(names: [String],totalDist: Double) {
  
    stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0);$0.removeFromSuperview() }
    names.forEach {
      let label = UILabel()
      label.text = $0
      label.textColor = appGreenTheme
      label.textAlignment = .center
      label.adjustsFontSizeToFitWidth = true
      //label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
      label.heightAnchor.constraint(equalToConstant: 50).isActive = true
      stackView.addArrangedSubview(label)
    }
        let label = UILabel()
        label.text = "     Total          \(RCGlobals.convertDist(distance: totalDist))"
        label.textColor = .black
        label.font = .monospacedDigitSystemFont(ofSize: 16, weight: .heavy)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(label)
  }
}
