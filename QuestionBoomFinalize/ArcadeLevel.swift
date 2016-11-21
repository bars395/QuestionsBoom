//
//  ArcadeLevel.swift
//  projectQAlfa
//
//  Created by Кирилл on 15.02.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import SpriteKit


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class ArcadeLevel: SKSpriteNode {

    var score: Int
    
    var isLocked: Bool
    
    var levelNumber: Int
    
    var lock: SKSpriteNode?
    
    var shadow: SKSpriteNode?
    
    var starsNeeded: SKSpriteNode?
    
    var isUnlocked: Bool?
    
    var scoreLabel: SKSpriteNode?
    
    init(levelNumber: Int, scoreOrStars: Int, isLocked: Bool, fontSize: CGFloat, size: CGSize, position: CGPoint){
        self.levelNumber = levelNumber
        self.score = scoreOrStars
        self.isLocked = isLocked
        super.init(texture: SKTexture(imageNamed: "\(levelNumber)Level"), color: UIColor.clear, size: size)
        self.position = position
        if isLocked {
            
            
            shadow = SKSpriteNode(imageNamed: "levelShadow")
            shadow?.position = CGPoint(x: 0, y: 0)
            shadow?.name = "levelObject"
            shadow?.size = CGSize(width: size.width * 1.07, height: size.height * 1.01)
            shadow?.zPosition = 3
            
            
            lock = SKSpriteNode(imageNamed: "lock")
            lock?.name = "levelObject"
            lock?.position = CGPoint(x: 0, y: 0)
            lock?.size = CGSize(width: size.width * 0.37, height: size.height * 0.18)
            lock?.zPosition = 4
            
            
            let starsNeededText = 94 + levelNumber - score
            if starsNeededText > 0 {
            starsNeeded = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: String(score) + "/" + String(94 + levelNumber), size: NSString(string: String(score) + "/" + String(94 + levelNumber)).size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: fontSize)!]), multipleLine: false, fontSize: fontSize)))
                starsNeeded?.name = "levelObject"
            starsNeeded?.position = CGPoint(x: 0, y: -self.frame.size.height * 0.4)
            starsNeeded?.zPosition = 4
            addChild(starsNeeded!)
            }
            addChild(shadow!)
            addChild(lock!)
            
        }
        else{
             scoreLabel = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: String(score) + "/120", size: NSString(string: String(score) + "/120").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: fontSize)!]), multipleLine: false, fontSize: fontSize)))
            scoreLabel!.position = CGPoint(x: 0, y: -self.frame.size.height * 0.4)
            scoreLabel?.name = "levelObject"
            print(scoreLabel!.position)
            scoreLabel!.zPosition = 3
            addChild(scoreLabel!)
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func unlock(_ fontSize: CGFloat){
        self.isLocked = false
        starsNeeded?.removeFromParent()
        let action = SKAction.run{[unowned self] in
            self.lock?.size = CGSize(width: (self.lock?.size.width)! * 1.1, height: (self.lock?.size.height)! * 1.1)
            self.lock?.alpha = (self.lock?.alpha)! * 0.80
            self.shadow?.alpha = (self.shadow?.alpha)! * 0.80
            if self.lock?.alpha < 0.02{
                self.lock?.alpha = 0
                self.shadow?.alpha = 0
                self.lock?.removeFromParent()
                self.shadow?.removeFromParent()
            }
            
        }
        
        let delay = SKAction.wait(forDuration: 0.05)
        
        let sequence = SKAction.sequence([action, delay])
        let repeatAction = SKAction.repeat(sequence, count: 30)
        
        lock?.run(repeatAction)
        
        scoreLabel = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: String(0) + "/120", size: NSString(string: String(score) + "/120").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: fontSize)!]), multipleLine: false, fontSize: fontSize)))
        scoreLabel!.position = CGPoint(x: 0, y: -self.frame.size.height * 0.4)
        scoreLabel?.name = "levelObject"
        scoreLabel!.zPosition = 3
        addChild(scoreLabel!)
        score = 0
        save()
    }
    
    fileprivate func save(){
        
        do{
            
            let fileManager = FileManager.default
            
            let documentUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let documentLevelsDataUrl = documentUrl.appendingPathComponent("LevelsData.json")
            if let documentLevelsData = try? Data(contentsOf: documentLevelsDataUrl){
                
                var json = JSON(data: documentLevelsData)
                
                    json["Levels"][levelNumber - 1]["isLocked"].boolValue = false
                    
                    let jsonData = json.description
                    print(jsonData)
                    
                    let fileManager = FileManager.default
                    
                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let file = documentDirectory.appendingPathComponent("LevelsData.json")
                    
                    let data = jsonData.data(using: String.Encoding.utf8)
                    try data?.write(to: file, options: .atomic)
                    
                
            }
                
            else{
                if let levelsDataUrl = Bundle.main.url(forResource: "LevelsData", withExtension: "json"){
                    let levelsJsonData = try Data(contentsOf: levelsDataUrl, options: .mappedIfSafe)
                    var json = JSON(data: levelsJsonData)
                    
                    json["Levels"][levelNumber - 1]["isLocked"].boolValue = false
                    
                    let jsonData = json.description
                    print(jsonData)
                    
                    let fileManager = FileManager.default
                    
                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let file = documentDirectory.appendingPathComponent("LevelsData.json")
                    
                    let data = jsonData.data(using: String.Encoding.utf8)
                    try data?.write(to: file, options: .atomic)
                }
            }
            
            
        }
        catch let errorPtr as NSError {
            print(errorPtr.localizedDescription)
        }
        
    }

    
}
