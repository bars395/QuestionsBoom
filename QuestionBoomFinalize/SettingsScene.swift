//
//  SettingsScene.swift
//  projectQAlfa
//
//  Created by Кирилл on 09.01.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import SpriteKit

class SettingsScene: SKScene {
    
    
    var adDelegate: AdProtocol?
    
    var isEng = true

    var firstTouchedNode: SKSpriteNode!
    override func didMove(to view: SKView) {
        let backgroundImage = SKSpriteNode(imageNamed: "background.jpg")
        backgroundImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backgroundImage.size = CGSize(width: self.frame.width, height: self.frame.height)
        backgroundImage.blendMode = .replace
        backgroundImage.zPosition = 1
        addChild(backgroundImage)
        
        let musicLabel = SKSpriteNode(texture: SKTexture(imageNamed: NSLocalizedString("MUSIC",tableName: "LocalizableStrings", comment: "music")))
        
        if  NSLocalizedString("MUSIC",tableName: "LocalizableStrings", comment: "music") == "music_rus"{
            isEng = false
        }
        musicLabel.position = convertToSize(point: CGPoint(x: 547, y: 272))
        musicLabel.size = convertTheSize(size: musicLabel.texture!.size())
        musicLabel.zPosition = 2
        addChild(musicLabel)
        
        let soundLabel = SKSpriteNode(texture: SKTexture(imageNamed: NSLocalizedString("SOUND",tableName: "LocalizableStrings", comment: "sound")))
        if isEng{
            soundLabel.position = convertToSize(point: CGPoint(x: 671.89, y: 723))
        }else{
            soundLabel.position = convertToSize(point: CGPoint(x: 511.89, y: 723))
        }
        soundLabel.size = convertTheSize(size: soundLabel.texture!.size())
        soundLabel.zPosition = 2
        addChild(soundLabel)
        
        if !adDelegate!.haveMusic(){
            let music = SKSpriteNode(imageNamed: "musicBlack")
            music.name = "music"
            music.position = convertToSize(point: CGPoint(x: 1443.5, y: 272.5))
            music.size = convertTheSize(size: CGSize(width: 189, height: 216))
            music.zPosition = 2
            addChild(music)
            
        }else{
            let music = SKSpriteNode(imageNamed: "music")
            music.name = "music"
            music.position = convertToSize(point: CGPoint(x: 1443.5, y: 272.5))
            music.size = convertTheSize(size: CGSize(width: 189, height: 216))
            music.zPosition = 2
            addChild(music)
        }
        if !adDelegate!.haveSound(){
            let sound = SKSpriteNode(imageNamed: "soundBlack")
            sound.name = "sound"
            sound.position = convertToSize(point: CGPoint(x: 1444, y: 705))
            sound.size = convertTheSize(size: CGSize(width: 126, height: 210))
            sound.zPosition = 2
            addChild(sound)
            
        }else{
            let sound = SKSpriteNode(imageNamed: "sound")
            sound.name = "sound"
            sound.position = convertToSize(point: CGPoint(x: 1444, y: 705))
            sound.size = convertTheSize(size: CGSize(width: 126, height: 210))
            sound.zPosition = 2
            addChild(sound)
        }
        
        let backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.name = "back"
        backButton.position = convertToSize(point: CGPoint(x: 148, y: 956))
        backButton.size = convertTheSize(size: CGSize(width: 235, height: 231))
        backButton.zPosition = 2
        addChild(backButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            for node in nodes{
                let touchedNode = atPoint(location) as! SKSpriteNode
                if let nodeName = node.name{
                    switch nodeName{
                    case "music":
                        firstTouchedNode = touchedNode
                        touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                        if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                    case "sound":
                        firstTouchedNode = touchedNode
                        touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                                                if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                    case "back":
                        firstTouchedNode = touchedNode
                        touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                                                if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
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
                    
                }
                else {
                    unwrappedNode.run(SKAction.scale(to: 1, duration: 0.1))

                    
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
                                case "back":
                                    let skView = self.view as SKView!
                                    let sizeRect = UIScreen.main.bounds
                                    let width = sizeRect.size.width * UIScreen.main.scale
                                    let height = sizeRect.size.height * UIScreen.main.scale
                                    let scene = StartGameScene(size: CGSize(width: width, height: height))
                                    scene.adDelegate = self.adDelegate
                                    skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                                    
                                case "music":
                                                let userDefaults = UserDefaults.standard
                                                if !self.adDelegate!.haveMusic(){
                                                    unwrappedNode.texture = SKTexture(imageNamed: "music")
                                                    userDefaults.set(false, forKey: "musicOff")
                                                    self.adDelegate?.turnMusic(true)
                                                }else{
                                                    unwrappedNode.texture = SKTexture(imageNamed: "musicBlack")
                                                    userDefaults.set(true, forKey: "musicOff")
                                                    self.adDelegate?.turnMusic(false)
                                                }
                                    

                                case "sound":
                                                let userDefaults = UserDefaults.standard
                                                if !self.adDelegate!.haveSound(){
                                                    unwrappedNode.texture = SKTexture(imageNamed: "sound")
                                                    userDefaults.set(false, forKey: "soundOff")
                                                    self.adDelegate?.turnSound(true)
                                                }else{
                                                    unwrappedNode.texture = SKTexture(imageNamed: "soundBlack")
                                                    userDefaults.set(true, forKey: "soundOff")
                                                    self.adDelegate?.turnSound(false)
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
                    
                }
                else {
                    unwrappedNode.run(SKAction.scale(to: 1, duration: 0.1))
                    
                    
                }
            }
        }
    }
    
}
