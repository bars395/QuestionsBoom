//
//  PlayModeSelect.swift
//  projectQAlfa
//
//  Created by Кирилл on 07.01.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import SpriteKit

class PlayModeSelect: SKScene {
    
    var adDelegate: AdProtocol?
    
    var firstTouchedNode: SKNode!

    override func didMove(to view: SKView) {
        
        
        let backgroundImage = SKSpriteNode(imageNamed: "background.jpg")
        backgroundImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backgroundImage.size = CGSize(width: self.frame.width, height: self.frame.height)
        backgroundImage.blendMode = .replace
        addChild(backgroundImage)
        
        let arcadeMode = SKSpriteNode(texture: SKTexture(imageNamed: NSLocalizedString("Arcade",tableName: "LocalizableStrings", comment: "arcade")))
        arcadeMode.name = "arcade"
        arcadeMode.position = convertToSize(point: CGPoint(x: 960, y: 406))
        arcadeMode.size = convertTheSize(size: arcadeMode.texture!.size())
        arcadeMode.zPosition = 2
        addChild(arcadeMode)
        
        let singlePlayMode = SKSpriteNode(texture: SKTexture(imageNamed: NSLocalizedString("SINGLE_PLAY",tableName: "LocalizableStrings", comment: "singlePlay")))
        singlePlayMode.name = "singlePlay"
        singlePlayMode.position = convertToSize(point: CGPoint(x: 960, y: 717))
        singlePlayMode.size = convertTheSize(size: singlePlayMode.texture!.size())
        singlePlayMode.zPosition = 1
        addChild(singlePlayMode)
        
        let backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.name = "back"
        backButton.position = convertToSize(point: CGPoint(x: 148, y: 956))
        backButton.size = convertTheSize(size: CGSize(width: 235, height: 231))
        backButton.zPosition = 1
        addChild(backButton)
        
        let userDefaults = UserDefaults.standard
        
        let coins = userDefaults.integer(forKey: "coins")
        
        let texture = SKTexture(image: ImageFromText(coins: coins, size: CGSize(width: 600, height: 100)))
        let coinsLabel = SKSpriteNode(texture: texture, color: UIColor.clear, size: convertTheSize(size: CGSize(width: 600, height: 100)))
        coinsLabel.position = convertToSize(point: CGPoint(x: 1553, y: 952))
        coinsLabel.zPosition = 1
        addChild(coinsLabel)
        
        let shopIcon = SKSpriteNode(imageNamed: "Shop_icon")
        shopIcon.name = "shop"
        shopIcon.size = convertTheSize(size: shopIcon.texture!.size())
        shopIcon.position = convertToSize(point: CGPoint(x: 1825, y: 95))
        shopIcon.zPosition = 3
        addChild(shopIcon)
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            for node in nodes{
                let touchedNode = atPoint(location)
                if let nodeName = node.name{
                    switch nodeName{
                    case "back":
                        firstTouchedNode = touchedNode
                        touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                                                if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                    case "arcade":
                        firstTouchedNode = touchedNode
                        touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                                                if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                    case "singlePlay":
                        firstTouchedNode = touchedNode
                        touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                                                if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                    case "shop":
                        firstTouchedNode = touchedNode
                        touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                                                if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                        if let shop = touchedNode as? SKSpriteNode {
                            if shop.name == "shop"{
                                shop.texture = SKTexture(imageNamed: "Shop_icon_tapped")
                            }
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
            let touchedNode = atPoint(location)
            if let unwrappedNode = firstTouchedNode{
                if touchedNode == unwrappedNode{
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                    
                    if let shop = touchedNode as? SKSpriteNode {
                        if shop.name == "shop"{
                            shop.texture = SKTexture(imageNamed: "Shop_icon_tapped")
                        }
                    }
                    
                }
                else {
                    unwrappedNode.run(SKAction.scale(to: 1, duration: 0.1))
                    
                    if let shop = unwrappedNode as? SKSpriteNode {
                        if shop.name == "shop"{
                            shop.texture = SKTexture(imageNamed: "Shop_icon")
                        }
                    }
                    
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if let unwrappedNode = firstTouchedNode {
                if touchedNode == unwrappedNode {
                    touchedNode.run(SKAction.scale(to: 1, duration: 0.1), completion: {
                    let nodes = self.nodes(at: location)
                    for node in nodes{
                        if let nodeName = node.name{
                            switch nodeName{
                            case "arcade":
                                let skView = self.view as SKView!
                                let sizeRect = UIScreen.main.bounds
                                let width = sizeRect.size.width * UIScreen.main.scale
                                let height = sizeRect.size.height * UIScreen.main.scale
                                let scene = ArcadeLevelSelector(size: CGSize(width: width, height: height))
                                scene.adDelegate = self.adDelegate
                                skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                                
                            case "singlePlay":
                                let skView = self.view as SKView!
                                let sizeRect = UIScreen.main.bounds
                                let width = sizeRect.size.width * UIScreen.main.scale
                                let height = sizeRect.size.height * UIScreen.main.scale
                                let scene = SinglePlayLevelSelector(size: CGSize(width: width, height: height))
                                scene.adDelegate = self.adDelegate
                                skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                            case "back":
                                let skView = self.view as SKView!
                                let sizeRect = UIScreen.main.bounds
                                let width = sizeRect.size.width * UIScreen.main.scale
                                let height = sizeRect.size.height * UIScreen.main.scale
                                let scene = StartGameScene(size: CGSize(width: width, height: height))
                                scene.adDelegate = self.adDelegate
                                skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                                
                            case "shop":
                                if let shop = touchedNode as? SKSpriteNode {
                                    if shop.name == "shop"{
                                        shop.texture = SKTexture(imageNamed: "Shop_icon")
                                        
                                    }
                                    let skView = self.view as SKView!
                                    let sizeRect = UIScreen.main.bounds
                                    let width = sizeRect.size.width * UIScreen.main.scale
                                    let height = sizeRect.size.height * UIScreen.main.scale
                                    let scene = ShopGameScene(size: CGSize(width: width, height: height))
                                    scene.previousScene = .playMode
                                    scene.adDelegate = self.adDelegate
                                    skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                                }
                            default: break
                            }
                            
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
            let touchedNode = atPoint(location)
            if let unwrappedNode = firstTouchedNode{
                if touchedNode == unwrappedNode{
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                    
                    if let shop = touchedNode as? SKSpriteNode {
                        if shop.name == "shop"{
                            shop.texture = SKTexture(imageNamed: "Shop_icon_tapped")
                        }
                    }
                    
                }
                else {
                    unwrappedNode.run(SKAction.scale(to: 1, duration: 0.1))
                    
                    if let shop = unwrappedNode as? SKSpriteNode {
                        if shop.name == "shop"{
                            shop.texture = SKTexture(imageNamed: "Shop_icon")
                        }
                    }
                    
                }
            }
        }
    }

}
