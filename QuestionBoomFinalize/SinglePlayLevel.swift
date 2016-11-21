//
//  SinglePlayLevel.swift
//  projectQAlfa
//
//  Created by Кирилл on 25.03.16.
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


class SinglePlayLevel: SKSpriteNode {
    
    
    var isLocked: Bool
    
    var levelCategory: String
    
    var lock: SKSpriteNode?
    
    var shadow: SKSpriteNode?
    
    var coin: SKSpriteNode?
    
    var coinsNeededLabel: SKSpriteNode?
    
    var medals: SKSpriteNode?
    
    init(levelCategory: String, medal: String?, coinsNeeded: Int?, isLocked: Bool, fontSize: CGFloat, size: CGSize, position: CGPoint){
        self.levelCategory = levelCategory
        self.isLocked = isLocked
        print("TEST")
        super.init(texture: SKTexture(imageNamed: "\(levelCategory)"), color: UIColor.clear, size: size)
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
            
            
            
            coinsNeededLabel = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: String(coinsNeeded!), size: NSString(string: String(coinsNeeded!)).size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: fontSize)!]), multipleLine: false, fontSize: fontSize)))
            coinsNeededLabel?.name = "levelObject"
            coinsNeededLabel?.position = CGPoint(x: 0, y: -self.frame.size.height * 0.4)
            coinsNeededLabel?.zPosition = 4
            
            coin = SKSpriteNode(imageNamed: "coin")
            coin?.position = CGPoint(x: self.frame.width * 0.3, y: -self.frame.size.height * 0.4)
            coin?.size = CGSize(width: self.frame.width * 0.225, height: self.frame.height * 0.093)
            coin?.zPosition = 4
            addChild(coin!)
            addChild(coinsNeededLabel!)
            addChild(shadow!)
            addChild(lock!)
            
        }
        else{
            medals = SKSpriteNode(imageNamed: "\(medal!)")
            medals!.position = CGPoint(x: 0, y: -self.frame.size.height * 0.4)
            medals?.size = CGSize(width: 0.7 * self.frame.width, height: self.frame.size.height * 0.093)
            medals?.name = "levelObject"
            medals!.zPosition = 5
            addChild(medals!)
        }
        
    }
    
    func unlockLevel(){
        self.isLocked = false
        coinsNeededLabel?.removeFromParent()
        coin?.removeFromParent()
        
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
        medals = SKSpriteNode(imageNamed: "no_medal")
        medals!.position = CGPoint(x: 0, y: -self.frame.size.height * 0.4)
        medals?.size = CGSize(width: 0.7 * self.frame.width, height: self.frame.size.height * 0.093)
        medals?.name = "levelObject"
        medals!.zPosition = 5
        addChild(medals!)
        save()
        
        
    }
    
    fileprivate func save(){
        do{
            
            let fileManager = FileManager.default
            
            let documentUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let documentLevelsDataUrl = documentUrl.appendingPathComponent("SingleData.json")
            if let documentLevelsData = try? Data(contentsOf: documentLevelsDataUrl){
                
                var json = JSON(data: documentLevelsData)
                
                let categories = json["Categories"].arrayValue
                
                for (index, category) in categories.enumerated(){
                    if category["category"].stringValue == self.levelCategory{
                        
                            json["Categories"][index]["isLocked"].boolValue = false
                            
                            let jsonData = json.description
                            print(jsonData)
                            let fileManager = FileManager.default
                            
                            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                            let file = documentDirectory.appendingPathComponent("SingleData.json")
                            
                            let data = jsonData.data(using: String.Encoding.utf8)
                            try data?.write(to: file, options: .atomic)

                        
                    }
                }
                
                
                
            }
                
            else{
                if let levelsDataUrl = Bundle.main.url(forResource: "SingleData", withExtension: "json"){
                    let levelsJsonData = try Data(contentsOf: levelsDataUrl, options: .mappedIfSafe)
                    var json = JSON(data: levelsJsonData)
                    
                    let categories = json["Categories"].arrayValue
                    
                    for (index, category) in categories.enumerated(){
                        if category["category"].stringValue == self.levelCategory{
                            
                            json["Categories"][index]["isLocked"].boolValue = false
                            
                            let jsonData = json.description
                            print(jsonData)
                            let fileManager = FileManager.default
                            
                            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                            let file = documentDirectory.appendingPathComponent("SingleData.json")
                            
                            let data = jsonData.data(using: String.Encoding.utf8)
                            try data?.write(to: file, options: .atomic)
                            
                            
                        }
                    }
                    
                    
                    
                }
            }
        }
        catch let errorPtr as NSError {
            print(errorPtr.localizedDescription)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
