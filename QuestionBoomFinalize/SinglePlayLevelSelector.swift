//
//  SinglePlayLevelSelector.swift
//  projectQAlfa
//
//  Created by Кирилл on 25.03.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import SpriteKit

class SinglePlayLevelSelector: SKScene, UIScrollViewDelegate {
    
    var adDelegate: AdProtocol?
    
    let world = SKSpriteNode()
    var scrollView: SpriteScroll!
    fileprivate var contentView: UIView!
    var firstTouchedNode: SKNode?
    var touchedLevel: SinglePlayLevel?
    var nodes = [String: SKSpriteNode]()
    var coins = 0
    var levelsCost = 0
    
    var coinsLabel: SKSpriteNode!

    override func didMove(to view: SKView) {
        
        let userDefaults = UserDefaults.standard
        coins = userDefaults.integer(forKey: "coins")
        
        world.zPosition = 2
        addChild(world)
        let a = 2 * 206 + 114 * 9 + 14 * 230
        let s = convertTheSize(size: CGSize(width: a, height: 0))
        world.size = CGSize(width: s.width, height: view.bounds.height)
        print(world.size)
        world.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        let backgroundImage = SKSpriteNode(imageNamed: "background.jpg")
        backgroundImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backgroundImage.size = CGSize(width: self.frame.width, height: self.frame.height)
        backgroundImage.blendMode = .replace
        backgroundImage.zPosition = 1
        addChild(backgroundImage)
        
        
        
        
        do{
            
            let fileManager = FileManager.default
            
            let documentUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let documentLevelsDataUrl = documentUrl.appendingPathComponent("SingleData.json")
            if let documentLevelsData = try? Data(contentsOf: documentLevelsDataUrl){
                
                let json = JSON(data: documentLevelsData)
                let cost = json["Cost"].numberValue as Int
                self.levelsCost = cost
                let levels = json["Categories"].arrayValue
                
                for (index,level) in levels.enumerated(){
                    let category = level["category"].stringValue
                    if index == 0{
                        let medal = level["medal"].stringValue
                        let level = SinglePlayLevel(levelCategory: category, medal: medal, coinsNeeded: nil, isLocked: false, fontSize: convertFontSize(55), size: convertTheSize(size: CGSize(width: 345, height: 828)), position: convertToSize(point: CGPoint(x: 376 + index * 420, y: 440)))
                        level.name = "Level"
                        world.addChild(level)
                    }
                    else{
                        let isLocked = level["isLocked"].boolValue
                        if isLocked{
                            let level = SinglePlayLevel(levelCategory: category, medal: nil, coinsNeeded: cost, isLocked: true, fontSize: convertFontSize(55), size: convertTheSize(size: CGSize(width: 345, height: 828)), position: convertToSize(point: CGPoint(x: 376 + index * 420, y: 440)))
                            level.name = "Level"
                            world.addChild(level)
                        }
                            
                        else{
                            let medal = level["medal"].stringValue
                            let level = SinglePlayLevel(levelCategory: category, medal: medal, coinsNeeded: nil, isLocked: false, fontSize: convertFontSize(55), size: convertTheSize(size: CGSize(width: 345, height: 828)), position: convertToSize(point: CGPoint(x: 376 + index * 420, y: 440)))
                            level.name = "Level"
                            world.addChild(level)
                        }
                        
                    }
                }
                
            }
            else{
                
                if let levelsDataUrl = Bundle.main.url(forResource: "SingleData", withExtension: "json"){
                    let levelsJsonData = try Data(contentsOf: levelsDataUrl, options: .mappedIfSafe)
                    let json = JSON(data: levelsJsonData)
                    let cost = json["Cost"].numberValue as Int
                    self.levelsCost = cost
                    let levels = json["Categories"].arrayValue
                    
                    for (index,level) in levels.enumerated(){
                        let category = level["category"].stringValue
                        if index == 0{
                            let medal = level["medal"].stringValue
                            let level = SinglePlayLevel(levelCategory: category, medal: medal, coinsNeeded: nil, isLocked: false, fontSize: convertFontSize(55), size: convertTheSize(size: CGSize(width: 345, height: 828)), position: convertToSize(point: CGPoint(x: 376 + index * 420, y: 440)))
                            level.name = "Level"
                            world.addChild(level)
                        }
                        else{
                            let isLocked = level["isLocked"].boolValue
                            if isLocked{
                                let level = SinglePlayLevel(levelCategory: category, medal: nil, coinsNeeded: cost, isLocked: true, fontSize: convertFontSize(55), size: convertTheSize(size: CGSize(width: 345, height: 828)), position: convertToSize(point: CGPoint(x: 376 + index * 420, y: 440)))
                                level.name = "Level"
                                world.addChild(level)
                            }
                                
                            else{
                                let medal = level["medal"].stringValue
                                let level = SinglePlayLevel(levelCategory: category, medal: medal, coinsNeeded: nil, isLocked: false, fontSize: convertFontSize(55), size: convertTheSize(size: CGSize(width: 345, height: 828)), position: convertToSize(point: CGPoint(x: 376 + index * 420, y: 440)))
                                level.name = "Level"
                                world.addChild(level)
                            }
                            
                        }
                    }
                    
                }
                    
                    
                    
                else {
                    self.levelsCost = 2000
                    let categories = ["General_boom","Apple_boom", "Figure_boom", "History_boom","Astro_boom", "Sport_boom", "Science_boom", "Geo_boom","Literature_boom", "Music_boom", "Movie_boom", "Animals_boom", "Meal_boom"]
                    for i in 0...12{
                        let level = SinglePlayLevel(levelCategory: categories[i], medal: "no_medal", coinsNeeded: 2000, isLocked: i > 0, fontSize: convertFontSize(55), size: convertTheSize(size: CGSize(width: 345, height: 828)), position: convertToSize(point: CGPoint(x: 376 + i * 420, y: 440)))
                        level.name = "Level"
                        world.addChild(level)
                    }
                }
                
            }
        }
            
        catch {
            self.levelsCost = 2000
            let categories = ["General_boom","Apple_boom", "Figure_boom", "History_boom","Astro_boom", "Sport_boom", "Science_boom", "Geo_boom","Literature_boom", "Music_boom", "Movie_boom", "Animals_boom", "Meal_boom"]
            for i in 0...12{
                let level = SinglePlayLevel(levelCategory: categories[i], medal: "no_medal", coinsNeeded: 2000, isLocked: i > 0, fontSize: convertFontSize(55), size: convertTheSize(size: CGSize(width: 345, height: 828)), position: convertToSize(point: CGPoint(x: 376 + i * 420, y: 440)))
                level.name = "Level"
                world.addChild(level)
            }
            
        }
        let backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.name = "back"
        backButton.position = convertToSize(point: CGPoint(x: 148 - 266, y: 956))
        backButton.size = convertTheSize(size: CGSize(width: 235, height: 231))
        backButton.zPosition = 2
        addChild(backButton)
        backButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 148, y: 956)), duration: 1))
        

        
        let texture = SKTexture(image: ImageFromText(coins: coins, size: CGSize(width: 600, height: 100)))
        let coinsLabel = SKSpriteNode(texture: texture, color: UIColor.clear, size: convertTheSize(size: CGSize(width: 600, height: 100)))
        coinsLabel.position = convertToSize(point: CGPoint(x: 1553, y: 952))
        coinsLabel.zPosition = 2
        addChild(coinsLabel)
        self.coinsLabel = coinsLabel
        
        scrollView = SpriteScroll(frame: self.view!.bounds)
        print("self.view!.bounds:\(self.view!.bounds)")
        scrollView.delegate = self
        scrollView.contentSize = self.world.frame.size
        scrollView.delaysContentTouches = false
        print(scrollView.contentSize)
        view.addSubview(scrollView)
        
        contentView = UIView(frame: CGRect(origin: CGPoint.zero, size: self.world.size))
        print(contentView.frame.size)
        scrollView.addSubview(contentView)
        
        applyScrollViewToSpriteKitMapping()
    }
    
    fileprivate  func applyScrollViewToSpriteKitMapping() {
        let origin = contentView.frame.origin
        let skPosition = CGPoint(x: -scrollView.contentOffset.x + origin.x, y: -scrollView.contentSize.height + view!.bounds.height + scrollView.contentOffset.y - origin.y)
        
        
        world.position = skPosition
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        applyScrollViewToSpriteKitMapping()
        if let unwrappedNode = firstTouchedNode{
            unwrappedNode.run(SKAction.scale(to: 1, duration: 0.1))
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            for _ in nodes{
                let touchedNode = atPoint(location)
                if let nodeName = touchedNode.name{
                    switch nodeName{
                    case "back":
                        firstTouchedNode = touchedNode
                        touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                                                if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                    case "Level":
                        firstTouchedNode = touchedNode
                        touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                                                if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                        
                    case "levelObject":
                        firstTouchedNode = touchedNode.parent
                        touchedNode.parent!.run((SKAction.scale(to: 0.85, duration: 0.1)))
                        if adDelegate!.haveSound() {
                                touchedNode.parent!.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                        
                        
                    case "buttonPurchaseYes":
                        firstTouchedNode = touchedNode
                        touchedNode.run((SKAction.scale(to: 0.85, duration: 0.1)))
                                                if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                        touchedNode.userData = ["isTapped":true]
                        let node = touchedNode as? SKSpriteNode
                        node!.texture = SKTexture(imageNamed: "\(node!.name!)Tapped")
                    case "buttonPurchaseNo":
                        firstTouchedNode = touchedNode
                        touchedNode.run((SKAction.scale(to: 0.85, duration: 0.1)))
                                                if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                        touchedNode.userData = ["isTapped":true]
                        let node = touchedNode as? SKSpriteNode
                        node!.texture = SKTexture(imageNamed: "\(node!.name!)Tapped")
                    default: break
                    }
                    
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let location = touch.location(in: self)
            if let node = firstTouchedNode as? SKSpriteNode{
                if node.contains(location){
                    node.run(SKAction.scale(to: 0.85, duration: 0.1))
                    if node.userData != nil{
                        node.texture = SKTexture(imageNamed: "\(node.name!)Tapped")
                    }
                }
                else{
                    node.run(SKAction.scale(to: 1, duration: 0.1))
                    if node.userData != nil{
                        node.texture = SKTexture(imageNamed: "\(node.name!)")
                    }
                }
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let locationInScroll = touch.location(in: world)
            if let node = firstTouchedNode{
                if node.contains(location) || node.contains(locationInScroll){
                    node.run(SKAction.scale(to: 1, duration: 0.1))
                    if let nodeName = node.name{
                        switch nodeName {
                        case "back":

                            let skView = self.view as SKView!
                            let sizeRect = UIScreen.main.bounds
                            let width = sizeRect.size.width * UIScreen.main.scale
                            let height = sizeRect.size.height * UIScreen.main.scale
                            let scene = PlayModeSelect(size: CGSize(width: width, height: height))
                            scene.adDelegate = self.adDelegate
                            self.scrollView.removeFromSuperview()
                            skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                            
                        case "Level":
                            if let singleNode = firstTouchedNode as? SinglePlayLevel {
                                if !singleNode.isLocked {

                                    let skView = self.view as SKView!
                                    let sizeRect = UIScreen.main.bounds
                                    let width = sizeRect.size.width * UIScreen.main.scale
                                    let height = sizeRect.size.height * UIScreen.main.scale
                                    let scene = SingleGameScene(size: CGSize(width: width, height: height), category: singleNode.levelCategory)
                                    self.scrollView.removeFromSuperview()
                                    scene.adDelegate = self.adDelegate
                                    self.adDelegate?.pausePlayer()
                                    scene.preload(scene, view: skView!)
//                                    skView.presentScene(scene, transition: SKTransition.fadeWithDuration(0.85))
                                    
                                }
                                else{
                                    touchedLevel = singleNode
                                    confirmPurchase()
                                }
                            }
                        case "buttonPurchaseYes":
                            let spriteNode = node as? SKSpriteNode
                            spriteNode?.texture = SKTexture(imageNamed: "\(node.name!)")
                            endPurchase(touchedLevel!)
                            
                            closePurchaseWindow()
                        case "buttonPurchaseNo":
                            let spriteNode = node as? SKSpriteNode
                            spriteNode?.texture = SKTexture(imageNamed: "\(node.name!)")
                            closePurchaseWindow()
                        default: break
                        }
                    }
                }
            }
        }
        firstTouchedNode = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if let node = firstTouchedNode as? SKSpriteNode{
                if node.contains(location){
                    node.run(SKAction.scale(to: 0.85, duration: 0.1))
                    if node.userData != nil{
                        node.texture = SKTexture(imageNamed: "\(node.name!)Tapped")
                    }
                }
                else{
                    node.run(SKAction.scale(to: 1, duration: 0.1))
                    if node.userData != nil{
                        node.texture = SKTexture(imageNamed: "\(node.name!)")
                    }
                }
            }
        }
    }
    
    
    fileprivate func confirmPurchase(){
        let black = SKSpriteNode(texture: nil, color: UIColor.black, size: self.size)
        black.alpha = 0
        black.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        black.zPosition = 20
        addChild(black)
        black.run(SKAction.fadeAlpha(to: 0.7, duration: 0.75))
        nodes["black"] = black
        
        let purchaseFrame = SKSpriteNode(imageNamed: "purchaseFrame")
        purchaseFrame.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        purchaseFrame.size = convertTheSize(size: CGSize(width: 883 * 0.1, height: 503 * 0.1))
        purchaseFrame.alpha = 0
        purchaseFrame.zPosition = 21
        addChild(purchaseFrame)
        purchaseFrame.run(SKAction.fadeAlpha(to: 1, duration: 0.75))
        purchaseFrame.run(SKAction.resize(toWidth: purchaseFrame.size.width * 10, height: purchaseFrame.size.height * 10, duration: 0.75))
        nodes["purchaseFrame"] = purchaseFrame
        
        let yesButton = SKSpriteNode(imageNamed: "buttonPurchaseYes")
        yesButton.name = "buttonPurchaseYes"
        yesButton.size = convertTheSize(size: CGSize(width: 283 * 0.1, height: 141 * 0.1))
        yesButton.position = convertToSize(point: CGPoint(x: 746.5, y: 693.5))
        yesButton.zPosition = 22
        yesButton.alpha = 0
        addChild(yesButton)
        yesButton.run(SKAction.resize(toWidth: yesButton.size.width * 10, height: yesButton.size.height * 10, duration: 0.75))
        yesButton.run(SKAction.fadeAlpha(to: 1, duration: 0.75))
        nodes["yesButton"] = yesButton
        
        let noButton = SKSpriteNode(imageNamed: "buttonPurchaseNo")
        noButton.name = "buttonPurchaseNo"
        noButton.size = convertTheSize(size: CGSize(width: 283 * 0.1, height: 141 * 0.1))
        noButton.position = convertToSize(point: CGPoint(x: 1175.5, y: 693.5))
        noButton.zPosition = 22
        noButton.alpha = 0
        addChild(noButton)
        noButton.run(SKAction.resize(toWidth: noButton.size.width * 10, height: noButton.size.height * 10, duration: 0.75))
        noButton.run(SKAction.fadeAlpha(to: 1, duration: 0.75))
        nodes["noButton"] = noButton
        
        scrollView.isScrollEnabled = false
        
    }
    
    fileprivate func closePurchaseWindow(){
        for key in nodes.keys{
            let node = nodes[key]
            
            if key == "black"{
                node?.run(SKAction.fadeAlpha(to: 0, duration: 0.75), completion: {
                    node?.removeFromParent()
                })
            }else{
            node?.run(SKAction.group([SKAction.fadeAlpha(to: 0, duration: 0.75), SKAction.resize(toWidth: (node?.size.width)! * 0.1, height: (node?.size.height)! * 0.1, duration: 0.75)]), completion: {
            node?.removeFromParent()
            })
            }
        }
        scrollView.isScrollEnabled = true
    }
    
    func endPurchase(_ level: SinglePlayLevel) {
        
                let filemanager = FileManager.default
        
                do {let document = try filemanager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let single = document.appendingPathComponent("SingleData.json")
                    if let singleData = try? Data(contentsOf: single){
                        var json = JSON(data: singleData)
                        let cost = json["Cost"].numberValue as Int
                        let userDefaults = UserDefaults.standard
                        
                        let coins = userDefaults.integer(forKey: "coins")
                        if cost > coins{
                            let skView = self.view as SKView!
                            let sizeRect = UIScreen.main.bounds
                            let width = sizeRect.size.width * UIScreen.main.scale
                            let height = sizeRect.size.height * UIScreen.main.scale
                            let scene = ShopGameScene(size: CGSize(width: width, height: height))
                            scene.previousScene = .single
                            scene.adDelegate = self.adDelegate
                            self.scrollView.removeFromSuperview()
                            skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                        }else{
                            
                        
                        
                        userDefaults.set(Int(userDefaults.integer(forKey: "coins")) - cost, forKey: "coins")
                        self.coins = Int(userDefaults.integer(forKey: "coins"))
                        let texture = SKTexture(image: ImageFromText(coins: self.coins, size: CGSize(width: 600, height: 100)))
                        self.coinsLabel.texture = texture
                        
                        
                            json["Cost"].numberValue = NSNumber(value: json["Cost"].numberValue as Int + 500)
                            self.levelsCost = json["Cost"].numberValue as Int
                            self.rePrice()
                        let jsonData = json.description
                        
                        let fileManager = FileManager.default
                        
                        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                        let file = documentDirectory.appendingPathComponent("SingleData.json")
                        
                        let data = jsonData.data(using: String.Encoding.utf8)
                        try data?.write(to: file, options: .atomic)
                        level.unlockLevel()
                        }
                        
                    }else{
                        if let levelsDataUrl = Bundle.main.url(forResource: "SingleData", withExtension: "json"){
                            let levelsJsonData = try Data(contentsOf: levelsDataUrl, options: .mappedIfSafe)
                            var json = JSON(data: levelsJsonData)
                            let cost = json["Cost"].numberValue as Int
                            
                            let userDefaults = UserDefaults.standard
                            
                            let coins = userDefaults.integer(forKey: "coins")
                            if cost > coins{
                                let skView = self.view as SKView!
                                let sizeRect = UIScreen.main.bounds
                                let width = sizeRect.size.width * UIScreen.main.scale
                                let height = sizeRect.size.height * UIScreen.main.scale
                                let scene = ShopGameScene(size: CGSize(width: width, height: height))
                                scene.previousScene = .single
                                scene.adDelegate = self.adDelegate
                                self.scrollView.removeFromSuperview()
                                skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                            }else{
                            
                            
                            
                            userDefaults.set(Int(userDefaults.integer(forKey: "coins")) - cost, forKey: "coins")
                            self.coins = Int(userDefaults.integer(forKey: "coins"))
                            let texture = SKTexture(image: ImageFromText(coins: self.coins, size: CGSize(width: 600, height: 100)))
                            self.coinsLabel.texture = texture
                            
                            
                            json["Cost"].numberValue = NSNumber(value: json["Cost"].numberValue as Int + 500)
                                
                                self.levelsCost = json["Cost"].numberValue as Int
                                self.rePrice()
                            let jsonData = json.description
                            
                            let fileManager = FileManager.default
                            
                            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                            let file = documentDirectory.appendingPathComponent("SingleData.json")
                            
                            let data = jsonData.data(using: String.Encoding.utf8)
                            try data?.write(to: file, options: .atomic)
                                level.unlockLevel()
                            }
                        }
                    }
                }
                catch let errorPtr as NSError{
                print(errorPtr.localizedDescription)
                }
        
    }
    
    fileprivate func rePrice(){
        for child in self.world.children{
            let level = child as! SinglePlayLevel
            
            if level.isLocked{
                level.coinsNeededLabel!.texture = SKTexture(image: ImageFromText(text: String(self.levelsCost), size: NSString(string: String(self.levelsCost)).size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: convertFontSize(55))!]), multipleLine: false, fontSize: convertFontSize(55)))
            }
        }
    }

}
