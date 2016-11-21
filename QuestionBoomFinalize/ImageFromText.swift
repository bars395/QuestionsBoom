//
//  StylizedTextNode.swift
//  projectQAlfa
//
//  Created by Кирилл on 30.01.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import UIKit

class ImageFromText: UIImage {
    
    init(coins: Int, size: CGSize) {
        let coinImage = UIImage(named: "coin")!
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        coinImage.draw(in: CGRect(x: size.width - coinImage.size.width, y: size.height / 2 - coinImage.size.height / 2, width: coinImage.size.width, height: coinImage.size.height))
        let coinsLabel = UIBezierPath(for: "\(coins)", with: UIFont(name: "IowanOldStyle-BoldItalic", size: 72))
        let positionX = size.width - (coinsLabel?.bounds.size.width)! - coinImage.size.width
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.translateBy(x: positionX * 0.9, y: size.height / 2 - (coinsLabel?.bounds.height)! / 2)
        UIColor.white.setFill()
        MirrorPathVertically(coinsLabel)
        coinsLabel?.fill()
        context?.restoreGState()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        super.init(cgImage: (image?.cgImage!)!, scale: 1.0, orientation: .up)
    }
    
    init(passCount: Int) {
        let passFrame = UIImage(named: "passFrame")
        let passLabel = UIImage(named: "passLabel")
        let size = CGSize(width: 409, height: 123)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)

        let passCountLabel = UIBezierPath(for: "x\(passCount)", with: UIFont(name: "IowanOldStyle-BoldItalic", size: 72))
        passFrame?.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let space = (409 - (passLabel?.size.width)! - (passCountLabel?.bounds.size.width)!) / 2
        passLabel?.draw(in: CGRect(origin: CGPoint(x: space - 10, y: 20), size: (passLabel?.size)!))
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.translateBy(x: space + (passLabel?.size.width)! + 10, y: 43)
        UIColor.white.setFill()
        MirrorPathVertically(passCountLabel)
        passCountLabel?.fill()
//        passCountLabel.drawInnerShadow(UIColor.blackColor(), size: CGSizeMake(3, -3), blur: 0)
//        passCountLabel.drawInnerShadow(UIColor.whiteColor(), size: CGSizeMake(-0.5, 0.5), blur: 0)
//        passCountLabel.drawOuterGlow(UIColor(red: 85, green: 141, blue: 235, alpha: 0.09), withRadius: 40)
        context?.restoreGState()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        super.init(cgImage: (image?.cgImage!)!, scale: 1.0, orientation: .up)
        
    }
    
    init(text: String, size: CGSize, multipleLine: Bool, fontSize: CGFloat){
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        
        let font = UIFont(name: "IowanOldStyle-BoldItalic", size: fontSize)
        if multipleLine{
            let path = UIBezierPath(forMultilineString: text, with: font, maxWidth: size.width, textAlignment: NSTextAlignment.left)
            UIColor.white.setFill()
            path?.apply(CGAffineTransform(translationX: (size.width - (path?.bounds.width)!) / 2 ,y: (size.height - (path?.bounds.height)!) / 2 ))
            MirrorPathVertically(path)
            
            path?.fill()
//            path.drawInnerShadow(UIColor.blackColor(), size: CGSizeMake(3, -3), blur: 0)
//            path.drawInnerShadow(UIColor.whiteColor(), size: CGSizeMake(-0.5, 0.5), blur: 0)
//            path.drawOuterGlow(UIColor(red: 85, green: 141, blue: 235, alpha: 0.09), withRadius: 40)
        }else{
            let path = UIBezierPath(for: text, with: font)
            UIColor.white.setFill()
            path?.apply(CGAffineTransform(translationX: (size.width - (path?.bounds.width)!) / 2 ,y: (size.height - (path?.bounds.height)!) / 2 ))
            MirrorPathVertically(path)
            
            path?.fill()
//            path.drawInnerShadow(UIColor.blackColor(), size: CGSizeMake(3, -3), blur: 0)
//            path.drawInnerShadow(UIColor.whiteColor(), size: CGSizeMake(-0.5, 0.5), blur: 0)
//            path.drawOuterGlow(UIColor(red: 85, green: 141, blue: 235, alpha: 0.09), withRadius: 40)
        }
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        super.init(cgImage: image.cgImage!, scale: 1, orientation: .up)
        
    }

    required convenience init(imageLiteral name: String) {
        fatalError("init(imageLiteral:) has not been implemented")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required convenience init(imageLiteralResourceName name: String) {
        fatalError("init(imageLiteralResourceName:) has not been implemented")
    }
    
}








