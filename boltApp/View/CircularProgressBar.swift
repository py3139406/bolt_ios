//
//  CircularProgressBar.swift
//  Bolt
//
//  Created by Saanica Gupta on 31/03/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let appPurple = UIColor(red:149/255 , green:142/255 ,blue:237/255, alpha:1.0)
    static let appGreen = UIColor(red: 47/255, green: 174/255, blue: 160/255, alpha: 1.0)
     static let appRed = UIColor(red: 249/255, green: 53/255, blue: 55/255, alpha: 1.0)
}
class CircularProgressBar: UIView {
    //MARK:- methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        label.text = "0"
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
       //MARK: Public
       
       public var lineWidth:CGFloat = 16 {
           didSet{
               foregroundLayer.lineWidth = lineWidth
               backgroundLayer.lineWidth = lineWidth - (0.20 * lineWidth)
           }
       }
    
       public var strokeColour: CGColor = UIColor.black.cgColor {
        didSet{
            print("new colour is set")
         }
      }
    
    public var numerator: Int = 0 {
       didSet{
           print("new colour is set")
        }
     }
    
   public var denominator: Int = 100 {
        didSet{
            print("new colour is set")
         }
      }
       
       public var labelSize: CGFloat = 22{
           didSet {
            label.font = UIFont.boldSystemFont(ofSize: labelSize)
            label.textColor = .white
               label.sizeToFit()
               configLabel()
           }
       }
       
       public var safePercent: Int = 10 {
           didSet{
            setForegroundLayerColorForSafePercent()
           }
       }
    
       public func setProgress(to progressConstant: Double, withAnimation: Bool) {
           
           var progress: Double {
               get {
                   if progressConstant > 1 { return 1 }
                   else if progressConstant < 0 { return 0 }
                   else { return progressConstant }
               }
           }
           
           foregroundLayer.strokeEnd = CGFloat(progress)
           if withAnimation {
               let animation = CABasicAnimation(keyPath: "strokeEnd")
               animation.fromValue = 0
               animation.toValue = progress
               animation.duration = 2
               foregroundLayer.add(animation, forKey: "foregroundAnimation")
           }
           
           var currentTime:Double = 0
           let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
               if currentTime >= 2{
                   timer.invalidate()
               } else {
                   currentTime += 0.05
                _ = currentTime/2 * 100 //progress * percent
                self.label.text = "\(Int(self.numerator))"
                self.setForegroundLayerColorForSafePercent()
                   self.configLabel()
               }
           }
           timer.fire()
       }
       
       //MARK: Private
    
       private var label = UILabel()
       private let foregroundLayer = CAShapeLayer()
       private let backgroundLayer = CAShapeLayer()
       private var radius: CGFloat {
           get{
            if self.frame.width < self.frame.height { return (self.frame.width - lineWidth)/0.7}///2 }
            else { return (self.frame.height - lineWidth)/0.7}///2 }
           }
       }
       
       private var pathCenter: CGPoint{ get{ return self.convert(self.center, from:self.superview) } }
       private func makeBar(){
           self.layer.sublayers = nil
           drawBackgroundLayer()
           drawForegroundLayer()
       }
       
       private func drawBackgroundLayer(){
           let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
           self.backgroundLayer.path = path.cgPath
           self.backgroundLayer.strokeColor = UIColor.lightGray.cgColor
           self.backgroundLayer.lineWidth = lineWidth - (lineWidth * 20/100)
           self.backgroundLayer.fillColor = UIColor.clear.cgColor
           self.layer.addSublayer(backgroundLayer)
       }

       private func drawForegroundLayer(){
           
           let startAngle = (-CGFloat.pi/2)
           let endAngle = 2 * CGFloat.pi + startAngle
           
           let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
           
           foregroundLayer.lineCap = "round"
           foregroundLayer.path = path.cgPath
           foregroundLayer.lineWidth = lineWidth
           foregroundLayer.fillColor = UIColor.clear.cgColor
           foregroundLayer.strokeColor = UIColor.red.cgColor
           foregroundLayer.strokeEnd = CGFloat(CGFloat(numerator)/CGFloat(denominator))
        
           self.layer.addSublayer(foregroundLayer)
       }
       
       private func makeLabel(withText text: String) -> UILabel {
           let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
           label.text = text
           label.font = UIFont.systemFont(ofSize: labelSize)
           label.sizeToFit()
           label.center = pathCenter
           return label
       }
       private func configLabel(){
           label.sizeToFit()
           label.center = pathCenter
       }
      private func setForegroundLayerColorForSafePercent(){
           if Int(label.text!)! >= self.safePercent {
               self.foregroundLayer.strokeColor = strokeColour
           } else {
            self.foregroundLayer.strokeColor = strokeColour
           }
       }
       
       private func setupView() {
           makeBar()
           self.addSubview(label)
       }
       
       //Layout Sublayers
    
       private var layoutDone = false
       override func layoutSublayers(of layer: CALayer) {
           if !layoutDone {
               let tempText = label.text
               setupView()
               label.text = tempText
               layoutDone = true
           }
       }
    
       
   }

