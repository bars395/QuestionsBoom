//
//  Timer.swift
//  projectQAlfa
//
//  Created by Кирилл on 05.02.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import SpriteKit
import UIKit
class Timer: SKSpriteNode {
    
    var timerEnded = false
    var currentTime = 0.0
    init(time: Int, spriteSize: CGSize){
        let size = CGSize(width: 192, height: 192)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        path.stroke(inside: 10, color: UIColor.white)
        let stringPath = UIBezierPath(for: String(time), with: UIFont(name: "Noteworthy-Bold", size: 72)!)
        stringPath?.apply(CGAffineTransform(translationX: (size.width - (stringPath?.bounds.width)!) / 2 ,y: (size.height - (stringPath?.bounds.height)!) / 2 ))
        MirrorPathVertically(stringPath)
        UIColor.white.setFill()
        stringPath?.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let texture = SKTexture(image: image!)
        super.init(texture: texture, color: UIColor.clear, size: spriteSize)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func runTimer(_ timerTime: Double){
        
        stopTimer()
        currentTime = timerTime
        var time = timerTime
        timerEnded = false
        var timeInt = Int(time)

        let delayTime = time / 360
        var deegree: CGFloat = 270
        let size = CGSize(width: 192, height: 192)
            let action = SKAction.run {[unowned self] in
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
                deegree += 1
        let path = UIBezierPath(arcCenter: CGPoint(x: size.height / 2, y: size.width / 2), radius: size.width / 2, startAngle: CGFloat(3 * M_PI / 2), endAngle: self.degreesToRadians(deegree), clockwise: false)
                path.stroke(inside: 10, color: UIColor.white)
                time = time - delayTime
                self.currentTime = time
            timeInt = Int(time + 1)
                if deegree == 630 {timeInt = 0}
        let stringPath = UIBezierPath(for: String(timeInt), with: UIFont(name: "Noteworthy-Bold", size: 72)!)
            stringPath?.apply(CGAffineTransform(translationX: (size.width - (stringPath?.bounds.width)!) / 2 ,y: (size.height - (stringPath?.bounds.height)!) / 2 ))
                MirrorPathVertically(stringPath)
            UIColor.white.setFill()
                stringPath?.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.texture = SKTexture(image: image!)
                
                if deegree == 630 {
                    self.timerEnded = true
                    print(self.timerEnded)
                }
            }
            
            let delay = SKAction.wait(forDuration: time / 360)
            let sequence = SKAction.sequence([action, delay])
            let repeatAction = SKAction.repeat(sequence, count: 360)
            self.run(repeatAction, withKey: "timer")
            deegree = 270
        
    }
    
    func stopTimer(){
        self.removeAction(forKey: "timer")
    }
    
    fileprivate func degreesToRadians(_ degrees: CGFloat) ->CGFloat{
        return CGFloat(M_PI) * degrees / 180
    }
    
}
