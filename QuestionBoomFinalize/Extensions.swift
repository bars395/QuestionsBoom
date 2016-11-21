//
//  Extensions.swift
//  projectQAlfa
//
//  Created by Кирилл on 06.02.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import Foundation
import SpriteKit
import Social


extension SKScene {
    
    func getFontFor(_ string: NSString,for rect: CGRect, with font: UIFont) -> UIFont{
        var returnFont = font
        var stringSize = string.size(attributes: [NSFontAttributeName: font])
        
        repeat{
            returnFont = returnFont.withSize(returnFont.pointSize - 1)
            stringSize = string.size(attributes: [NSFontAttributeName: returnFont])
            
        }while stringSize.width > rect.size.width
        
        return returnFont
    }
    
    func convertToSize(point: CGPoint) ->CGPoint{
        return CGPoint(x: self.frame.width * (point.x / 1920), y: self.frame.height * (1080 - point.y) / 1080)
    }
    
    func convertTheSize(size: CGSize) ->CGSize{
        
        if self.frame.width == 960{
            return CGSize(width: self.frame.width * (size.width / 1920) * 1.037, height: self.frame.height * (size.height / 1080) * 0.935)
        }
        else{
            return CGSize(width: self.frame.width * (size.width / 1920), height: self.frame.height * (size.height / 1080))
        }
    }
    
    func convertFontSize(_ fontSize: CGFloat) ->CGFloat{
        return fontSize * self.frame.width / CGFloat(1920)
    }
    
    func creatTwitterTweet(_ gameMode: GameMode, score: Int, category: String = ""){
        
        if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)){
            let tweet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            if gameMode == .arcade{
                tweet?.setInitialText(NSLocalizedString("ARCADE_SOC",tableName: "LocalizableStrings", comment: "tweet") + "\(score)" + NSLocalizedString("ARCADE_SOC2",tableName: "LocalizableStrings", comment: "play"))
            }else{
                tweet?.setInitialText(NSLocalizedString("SINGLE_SOC",tableName: "LocalizableStrings", comment: "tweet") + category + NSLocalizedString("SINGLE_SOC3",tableName: "LocalizableStrings", comment: "tweet") + "\(score)" + NSLocalizedString("SINGLE_SOC2",tableName: "LocalizableStrings", comment: "play"))
            }
            tweet?.add(UIImage(named: "icon"))
            self.view!.window!.rootViewController!.present(tweet!, animated: true, completion: nil)
            
        }
        else{
            let alert = UIAlertController(title: "Twitter", message: "Twitter not available!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.view!.window!.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
    
    func createFacebookPost(_ gameMode: GameMode, score: Int, category: String = ""){
        if (SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook))
        {
            // Create the post
            let post = SLComposeViewController(forServiceType: (SLServiceTypeFacebook))
            if gameMode == .arcade{
                post?.setInitialText(NSLocalizedString("ARCADE_SOC",tableName: "LocalizableStrings", comment: "face") + "\(score)" + NSLocalizedString("ARCADE_SOC2",tableName: "LocalizableStrings", comment: "play"))
            }else{
            post?.setInitialText(NSLocalizedString("SINGLE_SOC",tableName: "LocalizableStrings", comment: "tweet") + category + NSLocalizedString("SINGLE_SOC3",tableName: "LocalizableStrings", comment: "tweet") + "\(score)" + NSLocalizedString("SINGLE_SOC2",tableName: "LocalizableStrings", comment: "play"))
                
            }
            post?.add(UIImage(named: "icon"))
            self.view!.window!.rootViewController!.present(post!, animated: true, completion: nil)
        } else {
            // Facebook not available. Show a warning
            let alert = UIAlertController(title: "Facebook", message: "Facebook not available", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.view!.window!.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }

    
}

enum GameMode {
    case singlePlay
    case arcade
}


extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}



