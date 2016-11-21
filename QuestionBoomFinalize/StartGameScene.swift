//
//  StartGameScene.swift
//  QuestionBoomFinalize
//
//  Created by Кирилл on 17.09.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import SpriteKit

import SpriteKit

class StartGameScene: SKScene{
    
    var adDelegate: AdProtocol?
    
    var firstTouchedNode: SKNode?
    
    var questions =  [[String: String]]()
    
    var start = false
    
    override func didMove(to view: SKView) {
        
        
        if start {
            self.startView()
            start = false
        }
        
        
        
        let backgroundImage = SKSpriteNode(imageNamed: "background.jpg")
        backgroundImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backgroundImage.size = CGSize(width: self.frame.width, height: self.frame.height)
        backgroundImage.blendMode = .replace
        addChild(backgroundImage)

        let playButton = SKSpriteNode(texture: SKTexture(imageNamed: NSLocalizedString("PLAY",tableName: "LocalizableStrings", comment: "play")))
        playButton.name = "play"
        playButton.position = convertToSize(point: CGPoint(x: 960, y: 406))
        playButton.size = convertTheSize(size: playButton.texture!.size())
        playButton.zPosition = 2
        addChild(playButton)
        
        let settingsButton = SKSpriteNode(imageNamed: NSLocalizedString("SETTINGS",tableName: "LocalizableStrings", comment: "settings"))
        
        settingsButton.name = "settings"
        settingsButton.position = convertToSize(point: CGPoint(x: 960, y: 717))
        settingsButton.size = convertTheSize(size: settingsButton.texture!.size())
        settingsButton.zPosition = 1
        addChild(settingsButton)
        
        let shopIcon = SKSpriteNode(imageNamed: "Shop_icon")
        shopIcon.name = "shop"
        shopIcon.size = convertTheSize(size: shopIcon.texture!.size())
        shopIcon.position = convertToSize(point: CGPoint(x: 1825, y: 95))
        shopIcon.zPosition = 3
        addChild(shopIcon)
        
        
        
        
        
        
        
    }
    
    func startView(){
        let blackBackground = SKSpriteNode(texture: nil, color: .black, size: self.frame.size)
        blackBackground.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        blackBackground.zPosition = 5
        addChild(blackBackground)
        
        let startImage = SKSpriteNode(imageNamed: "startLabel")
        startImage.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        startImage.size = self.frame.size
        startImage.alpha = 0
        startImage.zPosition = 6
        addChild(startImage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            startImage.run(SKAction.fadeAlpha(to: 1, duration: 2), completion: {
                startImage.run(SKAction.fadeAlpha(to: 0, duration: 1), completion: {
                    startImage.removeFromParent()
                    blackBackground.run(SKAction.fadeAlpha(to: 0, duration: 0.5), completion: {
                        blackBackground.removeFromParent()
                        self.adDelegate?.menuBacgroundMusic()
                        self.adDelegate?.initGameCenter()
                    })
                })
            })
        })
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            for node in nodes{
                let touchedNode = atPoint(location)
                if let nodeName = node.name{
                    switch nodeName{
                    case "play":
                        firstTouchedNode = touchedNode
                        touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                        if adDelegate!.haveSound() {
                            touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                        
                        
                        
                    case "settings":
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
                        //                touchedNode.xScale = 1
                        //                touchedNode.yScale = 1
                        let nodes = self.nodes(at: location)
                        for node in nodes{
                            if let nodeName = node.name{
                                switch nodeName{
                                case "play":
                                    let skView = self.view as SKView!
                                    let sizeRect = UIScreen.main.bounds
                                    let width = sizeRect.size.width * UIScreen.main.scale
                                    let height = sizeRect.size.height * UIScreen.main.scale
                                    let scene = PlayModeSelect(size: CGSize(width: width, height: height))
                                    scene.adDelegate = self.adDelegate
                                    skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                                    
                                case "settings":
                                    let skView = self.view as SKView!
                                    let sizeRect = UIScreen.main.bounds
                                    let width = sizeRect.size.width * UIScreen.main.scale
                                    let height = sizeRect.size.height * UIScreen.main.scale
                                    let scene = SettingsScene(size: CGSize(width: width, height: height))
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
                                        scene.previousScene = .start
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
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    
    
    
    
    
    
    
    
}
