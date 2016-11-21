//
//  ArcadeSubLevel.swift
//  projectQAlfa
//
//  Created by Кирилл on 27.02.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import SpriteKit

class ArcadeSubLevelScene: SKScene {
    
    var adDelegate: AdProtocol?
    
    var firstTouchedNode: SKNode?
    
    var levelNumber: Int
    
    init(levelNumber: Int, size: CGSize){
        self.levelNumber = levelNumber
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        
        let backgroundImage = SKSpriteNode(imageNamed: "background.jpg")
        backgroundImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backgroundImage.size = CGSize(width: self.frame.width, height: self.frame.height)
        backgroundImage.blendMode = .replace
        addChild(backgroundImage)
        
        var subLevelNumber = 1
        do{
            
            let fileManager = FileManager.default
            
            let documentUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let documentLevelsDataUrl = documentUrl.appendingPathComponent("LevelsData.json")
            if let documentLevelsData = try? Data(contentsOf: documentLevelsDataUrl){
                
                let json = JSON(data: documentLevelsData)
                print(json.description)
                let levels = json["Levels"].arrayValue
                let level = levels[levelNumber - 1]
                
                for j in 0...2 {
                    
                    for i in 0...3 {
                        let score = level["\(subLevelNumber)"].numberValue as Int
                        
                        
                        if subLevelNumber == 1{
                            let subLevel = ArcadeSubLevel(subLevelNumber: subLevelNumber, isLocked: false, image: "\(levelNumber)", size: convertTheSize(size: CGSize(width: 200, height: 200)), position : convertToSize(point: CGPoint(x: Double(414 + i * 382), y: Double(155.5 + Double(j * 310)))) )
                            subLevel.name = "subLevel"
                            subLevel.zPosition = 2
                            addChild(subLevel)
                            
                            let scoreLabel = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: String(score) + "/10", size: NSString(string: String(score) + "/10").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 60)!]), multipleLine: false, fontSize: 60)))
                            scoreLabel.size = convertTheSize(size: NSString(string: String(score) + "/10").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 60)!]))
                            scoreLabel.position = convertToSize(point: CGPoint(x: 414 + i * 382, y: 315 + j * 310))
                            scoreLabel.zPosition = 5
                            addChild(scoreLabel)
                            
                            subLevelNumber += 1
                            
                            
                        }else{
                            let previousSubLevelScore = level["\(subLevelNumber - 1)"].numberValue as Int
                            
                            
                            if previousSubLevelScore >= 7{
                                let subLevel = ArcadeSubLevel(subLevelNumber: subLevelNumber, isLocked: false, image: "\(levelNumber)", size: convertTheSize(size: CGSize(width: 200, height: 200)), position : convertToSize(point: CGPoint(x: Double(414 + i * 382), y: Double(155.5 + Double(j * 310)))) )
                                subLevel.name = "subLevel"
                                subLevel.zPosition = 2
                                addChild(subLevel)
                                
                                let scoreLabel = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: String(score) + "/10", size: NSString(string: String(score) + "/10").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 60)!]), multipleLine: false, fontSize: 60)))
                                scoreLabel.size = convertTheSize(size: NSString(string: String(score) + "/10").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 60)!]))
                                scoreLabel.position = convertToSize(point: CGPoint(x: 414 + i * 382, y: 315 + j * 310))
                                scoreLabel.zPosition = 5
                                addChild(scoreLabel)
                                
                                subLevelNumber += 1
                            }
                                
                                
                            else{
                                let subLevel = ArcadeSubLevel(subLevelNumber: subLevelNumber, isLocked: true, image: "\(levelNumber)", size: convertTheSize(size: CGSize(width: 200, height: 200)), position : convertToSize(point: CGPoint(x: Double(414 + i * 382), y: Double(155.5 + Double(j * 310)))) )
                                subLevel.name = "subLevel"
                                subLevel.zPosition = 2
                                addChild(subLevel)
                                subLevelNumber += 1
                            }
                            
                        }
                        
                    }
                }

                
            }
            
            else if let levelsDataUrl = Bundle.main.url(forResource: "LevelsData", withExtension: "json"){
                let levelsJsonData = try Data(contentsOf: levelsDataUrl, options: .mappedIfSafe)
                let json = JSON(data: levelsJsonData)
                let levels = json["Levels"].arrayValue
                let level = levels[levelNumber - 1]
                
                for j in 0...2 {
                    
                    for i in 0...3 {
                        let score = level["\(subLevelNumber)"].numberValue as Int
                        
                        
                        if subLevelNumber == 1{
                            let subLevel = ArcadeSubLevel(subLevelNumber: subLevelNumber, isLocked: false, image: "\(levelNumber)", size: convertTheSize(size: CGSize(width: 200, height: 200)), position : convertToSize(point: CGPoint(x: Double(414 + i * 382), y: Double(155.5 + Double(j * 310)))) )
                            subLevel.name = "subLevel"
                            subLevel.zPosition = 2
                            addChild(subLevel)
                            
                            let scoreLabel = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: String(score) + "/10", size: NSString(string: String(score) + "/10").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 60)!]), multipleLine: false, fontSize: 60)))
                            scoreLabel.size = convertTheSize(size: NSString(string: String(score) + "/10").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 60)!]))
                            scoreLabel.position = convertToSize(point: CGPoint(x: 414 + i * 382, y: 315 + j * 310))
                            scoreLabel.zPosition = 5
                            addChild(scoreLabel)
                            
                            subLevelNumber += 1
                            
                            
                        }else{
                            let previousSubLevelScore = level["\(subLevelNumber - 1)"].numberValue as Int
                            
                            
                            if previousSubLevelScore >= 7{
                                let subLevel = ArcadeSubLevel(subLevelNumber: subLevelNumber, isLocked: false, image: "\(levelNumber)", size: convertTheSize(size: CGSize(width: 200, height: 200)), position : convertToSize(point: CGPoint(x: Double(414 + i * 382), y: Double(155.5 + Double(j * 310)))) )
                                subLevel.name = "subLevel"
                                subLevel.zPosition = 2
                                addChild(subLevel)
                                
                                let scoreLabel = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: String(score) + "/10", size: NSString(string: String(score) + "/10").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 60)!]), multipleLine: false, fontSize: 60)))
                                scoreLabel.size = convertTheSize(size: NSString(string: String(score) + "/10").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 60)!]))
                                scoreLabel.position = convertToSize(point: CGPoint(x: 414 + i * 382, y: 315 + j * 310))
                                scoreLabel.zPosition = 5
                                addChild(scoreLabel)
                                
                                subLevelNumber += 1
                            }
                                
                                
                            else{
                                let subLevel = ArcadeSubLevel(subLevelNumber: subLevelNumber, isLocked: true, image: "\(levelNumber)", size: convertTheSize(size: CGSize(width: 200, height: 200)), position : convertToSize(point: CGPoint(x: Double(414 + i * 382), y: Double(155.5 + Double(j * 310)))) )
                                subLevel.name = "subLevel"
                                subLevel.zPosition = 2
                                addChild(subLevel)
                                subLevelNumber += 1
                            }
                            
                        }
                        
                    }
                }
                
                
            }
                
                
            else{
                for j in 0...2 {
                    for i in 0...3 {
                        let subLevel = ArcadeSubLevel(subLevelNumber: subLevelNumber, isLocked: i + j > 0, image: "\(levelNumber)", size: convertTheSize(size: CGSize(width: 200, height: 200)), position : convertToSize(point: CGPoint(x: Double(414 + i * 382), y: Double(155.5 + Double(j * 310)))) )
                        subLevel.name = "subLevel"
                        subLevel.zPosition = 2
                        addChild(subLevel)
                        
                        if !subLevel.isLocked{
                            let scoreLabel = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: String(0) + "/10", size: NSString(string: String(0) + "/10").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 60)!]), multipleLine: false, fontSize: 60)))
                            scoreLabel.position = convertToSize(point: CGPoint(x: 414 + i * 382, y: 315 + j * 310))
                            scoreLabel.size = convertTheSize(size: NSString(string: String(0) + "/10").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 60)!]))
                            scoreLabel.zPosition = 5
                            let star = SKSpriteNode(imageNamed: "star")
                            star.position = convertToSize(point: CGPoint(x: 530.5 + Double(i * 382), y: 300.98))
                            star.size = convertTheSize(size: CGSize(width: 75, height: 74))
                            star.zPosition = 3
                            addChild(star)
                            addChild(scoreLabel)
                        }
                        subLevelNumber += 1
                    }
                }
            }
        }
        catch{
                for j in 0...2 {
                    for i in 0...3 {
                        let subLevel = ArcadeSubLevel(subLevelNumber: subLevelNumber, isLocked: i + j > 0, image: "\(levelNumber)", size: convertTheSize(size: CGSize(width: 200, height: 200)), position : convertToSize(point: CGPoint(x: Double(414 + i * 382), y: Double(155.5 + Double(j * 310)))) )
                        subLevel.name = "subLevel"
                        subLevel.zPosition = 2
                        addChild(subLevel)
                        
                        if !subLevel.isLocked{
                            let scoreLabel = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: String(0) + "/10", size: NSString(string: String(0) + "/10").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 60)!]), multipleLine: false, fontSize: 60)))
                            scoreLabel.position = convertToSize(point: CGPoint(x: 414 + i * 382, y: 315 + j * 310))
                            scoreLabel.size = convertTheSize(size: NSString(string: String(0) + "/10").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 60)!]))
                            scoreLabel.zPosition = 5
                            addChild(scoreLabel)
                        }
                        subLevelNumber += 1
                    }
                }
        }
        
        let backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.name = "back"
        backButton.position = convertToSize(point: CGPoint(x: 148 - 266, y: 956))
        backButton.size = convertTheSize(size: CGSize(width: 235, height: 231))
        backButton.zPosition = 2
        addChild(backButton)
        backButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 148, y: 956)), duration: 1))
        
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
                    case "subLevel":
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
            if let node = firstTouchedNode{
                if node.contains(location){
                    node.run(SKAction.scale(to: 1, duration: 0.1), completion:{
                    if let nodeName = node.name{
                        switch nodeName {
                        case "back":
                            let skView = self.view as SKView!
                            let sizeRect = UIScreen.main.bounds
                            let width = sizeRect.size.width * UIScreen.main.scale
                            let height = sizeRect.size.height * UIScreen.main.scale
                            let scene = ArcadeLevelSelector(size: CGSize(width: width, height: height))
                            scene.adDelegate = self.adDelegate
                            skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                        case "subLevel":
                            if let sublevel = node as? ArcadeSubLevel {
                                if !sublevel.isLocked{
                                    let skView = self.view as SKView!
                                    let sizeRect = UIScreen.main.bounds
                                    let width = sizeRect.size.width * UIScreen.main.scale
                                    let height = sizeRect.size.height * UIScreen.main.scale
                                    let scene = ArcadeGameScene(size: CGSize(width: width, height: height), level: self.levelNumber, subLevel: sublevel.subLevelNumber)/**/
                                    scene.adDelegate = self.adDelegate
                                    print("checkfornil\(self.adDelegate)")
                                    if self.adDelegate!.haveMusic(){
                                        self.adDelegate?.pausePlayer()
                                
                                    }
                                    scene.preload(scene, view: skView!)

                                }
                                
                            }
                            
                        default: break
                        }
                    }
                    })
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
}






















