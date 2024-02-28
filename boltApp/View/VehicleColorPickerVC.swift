//
//  VehicleColorPickerVC.swift
//  Bolt
//
//  Created by Vivek Kumar on 06/07/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import ColorSlider
protocol afterColorPicked {
    func reloadTableData()
}
class VehicleColorPickerVC: UIViewController {
    var kscreenheight = UIScreen.main.bounds.height
    var kscreenwidth = UIScreen.main.bounds.width
    var colorView: UIView!
    var selectedColorImageView: UIImageView!
    var colorSlider: ColorSlider!
    var selectColorButton: UIButton!
    var appSettingVc = AppSettingViewController()
    var delegate:afterColorPicked?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    delegate.self = appSettingVc
      addViews()
        addConstraints()
       
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.delegate?.reloadTableData()
    }
    func addViews()
    {
        colorView = UIView(frame: CGRect.zero)
        colorView.backgroundColor = .white
        view.addSubview(colorView)
        
        selectedColorImageView = UIImageView(frame: CGRect.zero)
        selectedColorImageView.contentMode = .scaleAspectFit
        selectedColorImageView.image = UIImage(named: "car-iconred")
        colorView.addSubview(selectedColorImageView)
        
        selectColorButton = UIButton(frame: CGRect.zero)
        selectColorButton.backgroundColor = appGreenTheme
        selectColorButton.setTitle("SELECT  COLOR", for: .normal)
        selectColorButton.setTitleColor(UIColor.white, for: .normal)
        selectColorButton.layer.cornerRadius = 5
        selectColorButton.layer.masksToBounds = true
        colorView.addSubview(selectColorButton)
        selectColorButton.addTarget(self, action: #selector(dismissBtnAction(_sender:)), for: .touchUpInside)
        
        colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider.frame = CGRect.zero
        colorSlider.backgroundColor = .white
        colorSlider.gradientView.layer.borderWidth = 1.0
        colorSlider.gradientView.layer.borderColor = UIColor.white.cgColor
        colorSlider.gradientView.automaticallyAdjustsCornerRadius = false
        colorView.addSubview(colorSlider)
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
    }
    func addConstraints()
    {
        colorView.snp.makeConstraints{(make) in
            make.height.equalTo(0.3 * kscreenheight)
            make.width.equalTo(0.9 * kscreenwidth)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        selectedColorImageView.snp.makeConstraints{(make) in
            make.top.equalTo(0.02 * kscreenheight)
            make.centerX.equalToSuperview()
            make.width.equalTo(0.1 * kscreenwidth)
            make.height.equalTo(0.08 * kscreenheight)
        }
        colorSlider.snp.makeConstraints{(make) in
            make.bottom.equalTo(selectColorButton.snp.top).offset(-0.02 * kscreenheight)
            make.width.equalTo(0.8 * kscreenwidth)
            make.centerX.equalToSuperview()
            make.height.equalTo(0.03 * kscreenheight)
        }
        
        selectColorButton.snp.makeConstraints{(make) in
            make.bottom.equalToSuperview().offset(-0.02 * kscreenheight)
            make.width.equalTo(0.85 * kscreenwidth)
            make.centerX.equalToSuperview()
            make.height.equalTo(0.05 * kscreenheight)
        }
        
    }
    
//    @objc func sliderChanged(sender: AnyObject) {
//        let value: Int = Int(colorSlider.value)
//
//        let image = UIImage(named: "car-iconred")
//        selectedColorImageView.backgroundColor = uiColorFromHex(rgbValue: value)
//        selectedColorImageView.image =  image?.maskWithColor(color: uiColorFromHex(rgbValue: value))
//    }
//    func uiColorFromHex(rgbValue: Int) -> UIColor {
//
//        let red =   CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
//        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
//        let blue =  CGFloat(rgbValue & 0x0000FF) / 0xFF
//        let alpha = CGFloat(1.0)
//
//        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
//    }
     @objc func changedColor(_ slider: ColorSlider) {
        let color = slider.color
        let image = UIImage(named: "car-iconred")
         UserDefaults.standard.set(true, forKey: "color")
       // UserDefaults.standard.setColor(color: color, forKey: "vehicleColor")
        selectedColorImageView.image = image?.maskWithColors(color: color)
    }
    @objc func dismissBtnAction(_sender : UIButton){
        UserDefaults.standard.setColor(color: colorSlider.color, forKey: "vehicleColor")
       self.removeFromParentViewController()
        self.view.removeFromSuperview()
//        self.dismiss(animated: true) {
//            self.delegate?.reloadTableData()
//        }
    }
}
extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}
extension UIImage {
    func maskWithColors(color: UIColor) -> UIImage? {
        let maskingColors: [CGFloat] = [50, 255, 50, 255, 50, 255] // We should replace white color.
        let maskImage = cgImage! //
        let bounds = CGRect(x: 0, y: 0, width: size.width * 3, height: size.height * 3) // * 3, for best resolution.
        let sz = CGSize(width: size.width * 3, height: size.height * 3) // Size.
        var returnImage: UIImage? // Image, to return

        /* Firstly we will remove transparent background, because
         maskingColorComponents don't work with transparent images. */

        UIGraphicsBeginImageContextWithOptions(sz, true, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        context.scaleBy(x: 1.0, y: -1.0) // iOS flips images upside down, this fix it.
        context.translateBy(x: 0, y: -sz.height) // and this :)
        context.draw(maskImage, in: bounds)
        context.restoreGState()
        let noAlphaImage = UIGraphicsGetImageFromCurrentImageContext() // new image, without transparent elements.
        UIGraphicsEndImageContext()

        let noAlphaCGRef = noAlphaImage?.cgImage // get CGImage.

        if let imgRefCopy = noAlphaCGRef?.copy(maskingColorComponents: maskingColors) { // Magic.
            UIGraphicsBeginImageContextWithOptions(sz, false, 0.0)
            let context = UIGraphicsGetCurrentContext()!
            context.scaleBy(x: 1.0, y: -1.0)
            context.translateBy(x: 0, y: -sz.height)
            context.clip(to: bounds, mask: maskImage) // Remove background from image with mask.
            context.setFillColor(color.cgColor) // set new color. We remove white color, and set red.
            context.fill(bounds)
            context.draw(imgRefCopy, in: bounds) // draw new image
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            returnImage = finalImage! // YEAH!
            UIGraphicsEndImageContext()
        }
        return returnImage
    }
}
extension UserDefaults {
 func colorForKey(key: String) -> UIColor? {
  var color: UIColor?
  if let colorData = data(forKey: key) {
   color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
  }
  return color
 }

 func setColor(color: UIColor?, forKey key: String) {
  var colorData: NSData?
   if let color = color {
    colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
  }
  set(colorData, forKey: key)
 }

}
