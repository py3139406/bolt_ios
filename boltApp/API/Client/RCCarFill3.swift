//
//  RCCarFill3.swift
//  ProjectName
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//
//  Gencerated by PaintCode
//  http://www.paintcodeapp.com
//



import UIKit

public class RCCarFill3 : NSObject {

    //// Drawing Methods

    @objc public dynamic class func drawImageWith(_ color:UIColor) -> Void {
        RCCarFill3.drawCarCanvas(frame: CGRect.init(x: 0, y: 0, width: 234, height: 543), resizing: .aspectFill, color: color)
    }


    @objc public dynamic class func drawCarCanvas(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 234, height: 543), resizing: ResizingBehavior = .aspectFit, color:UIColor) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 234, height: 543), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 234, y: resizedFrame.height / 543)
        
        
        //// Color Declarations
        let fillColor = color
        let fillColor2 = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        let fillColor3 = UIColor(red: 0.815, green: 0.175, blue: 0.194, alpha: 1.000)
        let fillColor4 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        //// XMLID_1_
        //// XMLID_10_ Drawing
        let xMLID_10_Path = UIBezierPath()
        xMLID_10_Path.move(to: CGPoint(x: 224.1, y: 218))
        xMLID_10_Path.addCurve(to: CGPoint(x: 222, y: 169.1), controlPoint1: CGPoint(x: 224.1, y: 218), controlPoint2: CGPoint(x: 222.4, y: 179.8))
        xMLID_10_Path.addCurve(to: CGPoint(x: 224.7, y: 60), controlPoint1: CGPoint(x: 221.5, y: 158.4), controlPoint2: CGPoint(x: 228.7, y: 99.3))
        xMLID_10_Path.addCurve(to: CGPoint(x: 159.5, y: 6.4), controlPoint1: CGPoint(x: 220.7, y: 20.7), controlPoint2: CGPoint(x: 160, y: 13))
        xMLID_10_Path.addCurve(to: CGPoint(x: 117.9, y: 0), controlPoint1: CGPoint(x: 158.9, y: -0.3), controlPoint2: CGPoint(x: 117.9, y: 0))
        xMLID_10_Path.addCurve(to: CGPoint(x: 76.5, y: 6.2), controlPoint1: CGPoint(x: 117.9, y: 0), controlPoint2: CGPoint(x: 77, y: -0.4))
        xMLID_10_Path.addCurve(to: CGPoint(x: 11.2, y: 59.7), controlPoint1: CGPoint(x: 76, y: 12.9), controlPoint2: CGPoint(x: 15.3, y: 20.4))
        xMLID_10_Path.addCurve(to: CGPoint(x: 13.6, y: 168.8), controlPoint1: CGPoint(x: 7.1, y: 99), controlPoint2: CGPoint(x: 14.1, y: 158.1))
        xMLID_10_Path.addCurve(to: CGPoint(x: 11.3, y: 217.7), controlPoint1: CGPoint(x: 13.1, y: 179.5), controlPoint2: CGPoint(x: 11.3, y: 217.7))
        xMLID_10_Path.addLine(to: CGPoint(x: 0.1, y: 225.9))
        xMLID_10_Path.addLine(to: CGPoint(x: 0.1, y: 231.9))
        xMLID_10_Path.addLine(to: CGPoint(x: 9.6, y: 232))
        xMLID_10_Path.addCurve(to: CGPoint(x: 17.1, y: 485.5), controlPoint1: CGPoint(x: 9.6, y: 232), controlPoint2: CGPoint(x: 11.4, y: 475.3))
        xMLID_10_Path.addCurve(to: CGPoint(x: 48.8, y: 532.8), controlPoint1: CGPoint(x: 22.9, y: 495.7), controlPoint2: CGPoint(x: 30, y: 525.1))
        xMLID_10_Path.addCurve(to: CGPoint(x: 117.3, y: 543.1), controlPoint1: CGPoint(x: 67.7, y: 540.5), controlPoint2: CGPoint(x: 117.3, y: 543.1))
        xMLID_10_Path.addCurve(to: CGPoint(x: 185.8, y: 533), controlPoint1: CGPoint(x: 117.3, y: 543.1), controlPoint2: CGPoint(x: 166.9, y: 540.6))
        xMLID_10_Path.addCurve(to: CGPoint(x: 217.6, y: 485.8), controlPoint1: CGPoint(x: 204.7, y: 525.4), controlPoint2: CGPoint(x: 211.8, y: 496))
        xMLID_10_Path.addCurve(to: CGPoint(x: 225.7, y: 232.3), controlPoint1: CGPoint(x: 223.4, y: 475.6), controlPoint2: CGPoint(x: 225.7, y: 232.3))
        xMLID_10_Path.addLine(to: CGPoint(x: 234.2, y: 232.4))
        xMLID_10_Path.addLine(to: CGPoint(x: 234.2, y: 224.6))
        xMLID_10_Path.addLine(to: CGPoint(x: 224.1, y: 218))
        xMLID_10_Path.close()
        fillColor.setFill()
        xMLID_10_Path.fill()
        
        
        //// XMLID_9_ Drawing
        let xMLID_9_Path = UIBezierPath()
        xMLID_9_Path.move(to: CGPoint(x: 38.7, y: 193.5))
        xMLID_9_Path.addCurve(to: CGPoint(x: 52.6, y: 262.2), controlPoint1: CGPoint(x: 38.7, y: 193.5), controlPoint2: CGPoint(x: 49.2, y: 261.5))
        xMLID_9_Path.addCurve(to: CGPoint(x: 179, y: 262.4), controlPoint1: CGPoint(x: 56, y: 262.9), controlPoint2: CGPoint(x: 140.3, y: 250.4))
        xMLID_9_Path.addCurve(to: CGPoint(x: 196.8, y: 193.8), controlPoint1: CGPoint(x: 179, y: 262.4), controlPoint2: CGPoint(x: 184.8, y: 268.2))
        xMLID_9_Path.addCurve(to: CGPoint(x: 121, y: 172), controlPoint1: CGPoint(x: 196.8, y: 193.8), controlPoint2: CGPoint(x: 169, y: 171.3))
        xMLID_9_Path.addCurve(to: CGPoint(x: 38.7, y: 193.5), controlPoint1: CGPoint(x: 73, y: 172.4), controlPoint2: CGPoint(x: 38.7, y: 193.5))
        xMLID_9_Path.close()
        fillColor2.setFill()
        xMLID_9_Path.fill()
        
        
        //// XMLID_8_ Drawing
        let xMLID_8_Path = UIBezierPath()
        xMLID_8_Path.move(to: CGPoint(x: 29.1, y: 230))
        xMLID_8_Path.addCurve(to: CGPoint(x: 47.9, y: 284.1), controlPoint1: CGPoint(x: 29.1, y: 230), controlPoint2: CGPoint(x: 48.9, y: 269.3))
        xMLID_8_Path.addCurve(to: CGPoint(x: 44.7, y: 393.7), controlPoint1: CGPoint(x: 46.9, y: 298.9), controlPoint2: CGPoint(x: 50.3, y: 390.1))
        xMLID_8_Path.addCurve(to: CGPoint(x: 28.9, y: 393.7), controlPoint1: CGPoint(x: 39.1, y: 397.3), controlPoint2: CGPoint(x: 28.9, y: 393.7))
        xMLID_8_Path.addLine(to: CGPoint(x: 29.1, y: 230))
        xMLID_8_Path.close()
        fillColor2.setFill()
        xMLID_8_Path.fill()
        
        
        //// XMLID_7_ Drawing
        let xMLID_7_Path = UIBezierPath()
        xMLID_7_Path.move(to: CGPoint(x: 206.2, y: 230.2))
        xMLID_7_Path.addCurve(to: CGPoint(x: 187.3, y: 284.2), controlPoint1: CGPoint(x: 206.2, y: 230.2), controlPoint2: CGPoint(x: 186.3, y: 269.4))
        xMLID_7_Path.addCurve(to: CGPoint(x: 190.2, y: 393.8), controlPoint1: CGPoint(x: 188.3, y: 299), controlPoint2: CGPoint(x: 184.6, y: 390.2))
        xMLID_7_Path.addCurve(to: CGPoint(x: 206, y: 393.8), controlPoint1: CGPoint(x: 195.8, y: 397.4), controlPoint2: CGPoint(x: 206, y: 393.8))
        xMLID_7_Path.addLine(to: CGPoint(x: 206.2, y: 230.2))
        xMLID_7_Path.close()
        fillColor2.setFill()
        xMLID_7_Path.fill()
        
        
        //// XMLID_6_ Drawing
        let xMLID_6_Path = UIBezierPath()
        xMLID_6_Path.move(to: CGPoint(x: 38.6, y: 425.2))
        xMLID_6_Path.addLine(to: CGPoint(x: 66.5, y: 402.1))
        xMLID_6_Path.addLine(to: CGPoint(x: 173.2, y: 402.2))
        xMLID_6_Path.addLine(to: CGPoint(x: 196.3, y: 422.6))
        xMLID_6_Path.addCurve(to: CGPoint(x: 117.4, y: 475.5), controlPoint1: CGPoint(x: 196.3, y: 422.6), controlPoint2: CGPoint(x: 181.7, y: 475.4))
        xMLID_6_Path.addCurve(to: CGPoint(x: 38.6, y: 425.2), controlPoint1: CGPoint(x: 54.8, y: 475.7), controlPoint2: CGPoint(x: 38.6, y: 425.2))
        xMLID_6_Path.close()
        fillColor2.setFill()
        xMLID_6_Path.fill()
        
        
        //// XMLID_5_ Drawing
        let xMLID_5_Path = UIBezierPath()
        xMLID_5_Path.move(to: CGPoint(x: 31, y: 495.8))
        xMLID_5_Path.addCurve(to: CGPoint(x: 47.8, y: 523.7), controlPoint1: CGPoint(x: 31, y: 495.8), controlPoint2: CGPoint(x: 40.5, y: 520.6))
        xMLID_5_Path.addCurve(to: CGPoint(x: 82.3, y: 529.5), controlPoint1: CGPoint(x: 55.1, y: 526.8), controlPoint2: CGPoint(x: 82.3, y: 529.5))
        xMLID_5_Path.addCurve(to: CGPoint(x: 82.3, y: 525.1), controlPoint1: CGPoint(x: 82.3, y: 529.5), controlPoint2: CGPoint(x: 86, y: 526.8))
        xMLID_5_Path.addCurve(to: CGPoint(x: 50, y: 518.6), controlPoint1: CGPoint(x: 78.6, y: 523.4), controlPoint2: CGPoint(x: 54.8, y: 523))
        xMLID_5_Path.addCurve(to: CGPoint(x: 36.1, y: 495.8), controlPoint1: CGPoint(x: 45.2, y: 514.2), controlPoint2: CGPoint(x: 38.5, y: 497.2))
        xMLID_5_Path.addCurve(to: CGPoint(x: 31, y: 495.8), controlPoint1: CGPoint(x: 33.8, y: 494.4), controlPoint2: CGPoint(x: 31, y: 495.8))
        xMLID_5_Path.close()
        fillColor3.setFill()
        xMLID_5_Path.fill()
        
        
        //// XMLID_4_ Drawing
        let xMLID_4_Path = UIBezierPath()
        xMLID_4_Path.move(to: CGPoint(x: 204.2, y: 496))
        xMLID_4_Path.addCurve(to: CGPoint(x: 187.3, y: 523.8), controlPoint1: CGPoint(x: 204.2, y: 496), controlPoint2: CGPoint(x: 194.6, y: 520.8))
        xMLID_4_Path.addCurve(to: CGPoint(x: 152.8, y: 529.5), controlPoint1: CGPoint(x: 180, y: 526.8), controlPoint2: CGPoint(x: 152.8, y: 529.5))
        xMLID_4_Path.addCurve(to: CGPoint(x: 152.8, y: 525.1), controlPoint1: CGPoint(x: 152.8, y: 529.5), controlPoint2: CGPoint(x: 149.1, y: 526.8))
        xMLID_4_Path.addCurve(to: CGPoint(x: 185.1, y: 518.7), controlPoint1: CGPoint(x: 156.5, y: 523.4), controlPoint2: CGPoint(x: 180.3, y: 523.1))
        xMLID_4_Path.addCurve(to: CGPoint(x: 199.1, y: 495.9), controlPoint1: CGPoint(x: 189.9, y: 514.3), controlPoint2: CGPoint(x: 196.7, y: 497.3))
        xMLID_4_Path.addCurve(to: CGPoint(x: 204.2, y: 496), controlPoint1: CGPoint(x: 201.5, y: 494.6), controlPoint2: CGPoint(x: 204.2, y: 496))
        xMLID_4_Path.close()
        fillColor3.setFill()
        xMLID_4_Path.fill()
        
        
        //// XMLID_3_ Drawing
        let xMLID_3_Path = UIBezierPath()
        xMLID_3_Path.move(to: CGPoint(x: 28.2, y: 53.9))
        xMLID_3_Path.addCurve(to: CGPoint(x: 69.7, y: 26.4), controlPoint1: CGPoint(x: 28.2, y: 53.9), controlPoint2: CGPoint(x: 34, y: 33.5))
        xMLID_3_Path.addCurve(to: CGPoint(x: 56.8, y: 50.5), controlPoint1: CGPoint(x: 69.7, y: 26.4), controlPoint2: CGPoint(x: 71.7, y: 42.7))
        xMLID_3_Path.addCurve(to: CGPoint(x: 31, y: 61.7), controlPoint1: CGPoint(x: 41.8, y: 58.3), controlPoint2: CGPoint(x: 34.7, y: 64.4))
        xMLID_3_Path.addCurve(to: CGPoint(x: 28.2, y: 53.9), controlPoint1: CGPoint(x: 27.1, y: 59), controlPoint2: CGPoint(x: 26.3, y: 57.9))
        xMLID_3_Path.close()
        fillColor4.setFill()
        xMLID_3_Path.fill()
        
        
        //// XMLID_2_ Drawing
        let xMLID_2_Path = UIBezierPath()
        xMLID_2_Path.move(to: CGPoint(x: 204.5, y: 54.1))
        xMLID_2_Path.addCurve(to: CGPoint(x: 163.1, y: 26.5), controlPoint1: CGPoint(x: 204.5, y: 54.1), controlPoint2: CGPoint(x: 198.7, y: 33.7))
        xMLID_2_Path.addCurve(to: CGPoint(x: 176, y: 50.6), controlPoint1: CGPoint(x: 163.1, y: 26.5), controlPoint2: CGPoint(x: 161, y: 42.8))
        xMLID_2_Path.addCurve(to: CGPoint(x: 201.8, y: 61.8), controlPoint1: CGPoint(x: 190.9, y: 58.4), controlPoint2: CGPoint(x: 198.1, y: 64.6))
        xMLID_2_Path.addCurve(to: CGPoint(x: 204.5, y: 54.1), controlPoint1: CGPoint(x: 205.5, y: 59.2), controlPoint2: CGPoint(x: 206.4, y: 58.1))
        xMLID_2_Path.close()
        fillColor4.setFill()
        xMLID_2_Path.fill()
        
        context.restoreGState()
        
    }

    
    public func droppedMarkerImage(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: CGFloat(234), height: CGFloat(543)), false, 0)
        RCCarFill3.drawImageWith(color)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }





    @objc public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}


