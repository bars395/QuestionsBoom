//
//  ArcadeLevelSelector.swift
//  projectQAlfa
//
//  Created by Кирилл on 15.02.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import SpriteKit


class ArcadeLevelSelector: SKScene, UIScrollViewDelegate {
    
    var adDelegate: AdProtocol?
    
    var node = SKSpriteNode()
    let world = SKSpriteNode()
    var scrollView: SpriteScroll!
    fileprivate var contentView: UIView!
    var firstTouchedNode: SKNode?
    var unlockableLevel: ArcadeLevel?
    var presentLevel: Int?
    override func didMove(to view: SKView) {
        
        world.zPosition = 2
        addChild(world)
        let a = 2 * 206 + 114 * 9 + 10 * 210
        let s = convertTheSize(size: CGSize(width: a, height: 0))
        world.size = CGSize(width: s.width, height: view.bounds.height)
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
            let documentLevelsDataUrl = documentUrl.appendingPathComponent("LevelsData.json")
            if let documentLevelsData = try? Data(contentsOf: documentLevelsDataUrl){
                let json = JSON(data: documentLevelsData)
                let levels = json["Levels"].arrayValue
                
                for (index,level) in levels.enumerated() {
                    if index == 0 {
                        var score = 0
                        for i in 1...12 {
                            let subLevelScore = Int(level["\(i)"].numberValue)
                            score += subLevelScore
                        }
                        let levelSprite = ArcadeLevel(levelNumber: index + 1, scoreOrStars: score, isLocked: false, fontSize: convertFontSize(60), size: convertTheSize(size: CGSize(width: 345, height: 828)), position: convertToSize(point: CGPoint(x: 376 + (index) * 420, y: 440)))
                        levelSprite.name = "Level"
                        world.addChild(levelSprite)
                    }else {
                        let isLocked = level["isLocked"].boolValue
                        
                        if isLocked {
                            let previousLevel = levels[index - 1]
                            var score = 0
                            for i in 1...12 {
                                let subLevelScore = Int(previousLevel["\(i)"].numberValue)
                                score += subLevelScore
                            }
                            let levelSprite = ArcadeLevel(levelNumber: index + 1, scoreOrStars: score, isLocked: true, fontSize: convertFontSize(60), size: convertTheSize(size: CGSize(width: 345, height: 828)), position: convertToSize(point: CGPoint(x: 376 + (index) * 420, y: 440)))
                            let starsNeeded = 94 + index + 1 - score
                            print("starsNeeded")
                            print(starsNeeded)
                            if starsNeeded <= 0{
                            unlockableLevel = levelSprite
                            }
                            levelSprite.name = "Level"
                            world.addChild(levelSprite)
                        }else {
                            var score = 0
                            for i in 1...12 {
                                let subLevelScore = Int(level["\(i)"].numberValue)
                                score += subLevelScore
                            }
                            let levelSprite = ArcadeLevel(levelNumber: index + 1, scoreOrStars: score, isLocked: false, fontSize: convertFontSize(60), size: convertTheSize(size: CGSize(width: 345, height: 828)), position: convertToSize(point: CGPoint(x: 376 + (index) * 420, y: 440)))
                            levelSprite.name = "Level"
                            world.addChild(levelSprite)
                        }
                    }
                    
                    
                    
                }
                
            }
            
            else{
            if let levelsDataUrl = Bundle.main.url(forResource: "LevelsData", withExtension: "json"){
                let levelsJsonData = try Data(contentsOf: levelsDataUrl, options: .mappedIfSafe)
                let json = JSON(data: levelsJsonData)
                let levels = json["Levels"].arrayValue
                
                for (index,level) in levels.enumerated() {
                    if index == 0 {
                        var score = 0
                        for i in 1...12 {
                            let subLevelScore = Int(level["\(i)"].numberValue)
                            score += subLevelScore
                        }
                        let levelSprite = ArcadeLevel(levelNumber: index + 1, scoreOrStars: score, isLocked: false, fontSize: convertFontSize(60), size: convertTheSize(size: CGSize(width: 345, height: 828)), position: convertToSize(point: CGPoint(x: 376 + (index) * 420, y: 440)))
                        levelSprite.name = "Level"
                        world.addChild(levelSprite)
                    }else {
                        let isLocked = level["isLocked"].boolValue
                        
                        if isLocked {
                            let previousLevel = levels[index - 1]
                            var score = 0
                            for i in 1...12 {
                                let subLevelScore = Int(previousLevel["\(i)"].numberValue)
                                score += subLevelScore
                            }
                            let levelSprite = ArcadeLevel(levelNumber: index + 1, scoreOrStars: score, isLocked: true, fontSize: convertFontSize(60), size: convertTheSize(size: CGSize(width: 345, height: 828)), position: convertToSize(point: CGPoint(x: 376 + (index) * 420, y: 440)))
                            levelSprite.name = "Level"
                            let starsNeeded = 94 + index + 1 - score
                            print("starsNeeded")
                            print(starsNeeded)
                            if starsNeeded <= 0{
                                unlockableLevel = levelSprite
                            }
                            world.addChild(levelSprite)
                        }else {
                            var score = 0
                            for i in 1...12 {
                                let subLevelScore = Int(level["\(i)"].numberValue)
                                score += subLevelScore
                            }
                            let levelSprite = ArcadeLevel(levelNumber: index + 1, scoreOrStars: score, isLocked: false, fontSize: convertFontSize(60), size: convertTheSize(size: CGSize(width: 345, height: 828)), position: convertToSize(point: CGPoint(x: 376 + (index) * 420, y: 440)))
                            levelSprite.name = "Level"
                            world.addChild(levelSprite)
                        }
                    }


                    
                }

            }
            

            
        else {
        for i in 0...9{
        let level = ArcadeLevel(levelNumber: i + 1, scoreOrStars: 0, isLocked: i > 0, fontSize: convertFontSize(60), size: convertTheSize(size: CGSize(width: 345, height: 828)),position: convertToSize(point: CGPoint(x: 376 + i * 420, y: 440)))
            level.name = "Level"
            node = level
            world.addChild(level)
            }
        }
            }
        
                    }
        
        catch {
            
            for i in 0...9 {
                let level = ArcadeLevel(levelNumber: i + 1, scoreOrStars: 0, isLocked: i > 0, fontSize: convertFontSize(60), size: convertTheSize(size: CGSize(width: 345, height: 828)),position: convertToSize(point: CGPoint(x: 376 + i * 420, y: 440)))
                level.name = "Level"
                node = level
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
        
        let userDefaults = UserDefaults.standard
        
        let coins = userDefaults.integer(forKey: "coins")
        
        let texture = SKTexture(image: ImageFromText(coins: coins, size: CGSize(width: 600, height: 100)))
        let coinsLabel = SKSpriteNode(texture: texture, color: UIColor.clear, size: convertTheSize(size: CGSize(width: 600, height: 100)))
        coinsLabel.position = convertToSize(point: CGPoint(x: 1553, y: 952))
        coinsLabel.zPosition = 2
        addChild(coinsLabel)
        
        scrollView = SpriteScroll(frame: self.view!.bounds)
        scrollView.delegate = self
        scrollView.contentSize = self.world.frame.size
        scrollView.delaysContentTouches = false
        view.addSubview(scrollView)
        
        contentView = UIView(frame: CGRect(origin: CGPoint.zero, size: self.world.size))
        print(contentView.frame.size)
        scrollView.addSubview(contentView)
        
        applyScrollViewToSpriteKitMapping()
        
        if presentLevel != nil{
            presentTheLevel(presentLevel!)
        }
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

                        
                    default: break
                    }
                    
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let location = touch.location(in: self)
            if let node = firstTouchedNode{
                if node.contains(location){
                    node.run(SKAction.scale(to: 0.85, duration: 0.1))
                }
                else{
                    node.run(SKAction.scale(to: 1, duration: 0.1))
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
                                let popTime = DispatchTime.now() + Double(Int64(0.08 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: popTime){
                                let skView = self.view as SKView!
                                let sizeRect = UIScreen.main.bounds
                                let width = sizeRect.size.width * UIScreen.main.scale
                                let height = sizeRect.size.height * UIScreen.main.scale
                                let scene = PlayModeSelect(size: CGSize(width: width, height: height))
                                self.scrollView.removeFromSuperview()
                                scene.adDelegate = self.adDelegate
                                skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                            }
                            case "Level":
                                if let ArcadeNode = node as? ArcadeLevel {
                                    if !ArcadeNode.isLocked {
                                        let popTime = DispatchTime.now() + Double(Int64(0.08 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                        DispatchQueue.main.asyncAfter(deadline: popTime){
                                        let skView = self.view as SKView!
                                        let sizeRect = UIScreen.main.bounds
                                        let width = sizeRect.size.width * UIScreen.main.scale
                                        let height = sizeRect.size.height * UIScreen.main.scale
                                        let scene = ArcadeSubLevelScene(levelNumber: ArcadeNode.levelNumber, size: CGSize(width: width, height: height))
                                        self.scrollView.removeFromSuperview()
                                        scene.adDelegate = self.adDelegate
                                        skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                                        }
                                    }
                            }
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
            if let node = firstTouchedNode{
                if node.contains(location){
                    node.run(SKAction.scale(to: 0.85, duration: 0.1))
                }
                else{
                    node.run(SKAction.scale(to: 1, duration: 0.1))
                }
            }
        }
    }
    
    fileprivate func presentTheLevel(_ number: Int){
        if number > 2  && number < 9{
        var x = 206 + 114 * (number - 2)
        x += Int((Double(number) - 2.5) * 210)
        let convertedX = convertTheSize(size: CGSize(width: x, height: 0))
        
        self.scrollView.contentOffset = CGPoint(x: convertedX.width, y: self.scrollView.contentOffset.y)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if let unwrappedUnlockedLevel = unlockableLevel{
            if convert(unwrappedUnlockedLevel.position, from: world).x < convertToSize(point: CGPoint(x: 1743, y: 0)).x{
                unwrappedUnlockedLevel.unlock(convertFontSize(60))
                unlockableLevel = nil
            }
        }

    }
    
}

















