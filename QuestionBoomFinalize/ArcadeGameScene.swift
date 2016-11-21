//
//  GameScene.swift
//  projectQAlfa
//
//  Created by Кирилл on 04.02.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import SpriteKit
//import GoogleMobileAds
import AVFoundation




class ArcadeGameScene: SKScene /* GADInterstitialDelegate */ {
    
    var adDelegate: AdProtocol?
    
    var firstTouchedNode: SKNode?
    
    var score: Int = 0
    
    var endScore = 0
    
    var questions =  [[String: String]]()
    
    var textures = [SKTexture]()
    
    var heartsCount = 3
    
    var answers = 10
    
    var passCount = 1
    
    var isAnswered = false
    
    var level: Int
    
    var subLevel: Int
    
    var isLostOnce = false
    
    var reviveWindowIsShowing = false
    
    var isEnd = false
    
    var isRus = false
    
    var nodes = [String: AnyObject]()
    
    init(size: CGSize, level: Int, subLevel: Int) {
        self.level = level
        self.subLevel = subLevel
        super.init(size: size)
        let locHeading = ["Nature_boom", "Figure_boom", "Literature_boom", "Movie_boom", "Music_boom", "Science_boom", "Apple_boom", "Astro_boom", "Geo_boom", "History_boom", "Meal_boom", "Sport_boom"]
        var heading = [String]()
        for head in locHeading{
            let locHead = NSLocalizedString(head,tableName: "LocalizableStrings", comment: "play")
            heading.append(locHead)
        }
        if heading[0] == "Nature_boom_eng"{
            isRus = false
        }else{
            isRus = true
        }
        heading.shuffle()
        for i in 0...heading.count - 1{
            if let path = Bundle.main.path(forResource: heading[i], ofType: "json"){
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)){
                    let json = JSON(data: data)
                    parseJSON(json)
                    questions.shuffle()
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func preload(_ scene: SKScene, view: SKView){
        
        let imageNames = ["background.jpg","mainFrame", "star", "imageFrame", "backButton", "heart"]
        for imageName in imageNames{
            let texture = SKTexture(imageNamed: imageName)
            textures.append(texture)
        }

        
        SKTexture.preload(textures){
            view.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
        
        }

    }
    fileprivate func parseJSON(_ json: JSON){
        for question in json["Questions"].arrayValue{
            let quest = question["question"].stringValue
            let isImage = question["isImage"].boolValue
            var imagePath = ""
            if isImage {
                imagePath = question["imagePath"].stringValue
            }else{
                imagePath = "icon"
            }
            let rightAnswer = question["rightAnswer"].stringValue
            let answers = question["answers"].arrayValue
            for answer in answers{
                let first = answer["1"].stringValue
                let second = answer["2"].stringValue
                let third = answer["3"].stringValue
                let dict = ["question": quest, "imagePath": imagePath, "rightAnswer": rightAnswer, "0": first, "1": second, "2": third]
                questions.append(dict)
                
            }
            
        }
        
        
    }
    
    override func didMove(to view: SKView) {
        
        
        
        let popTime = DispatchTime.now() + Double(Int64(0.7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime){
            
           self.adDelegate?.inGameBackgroundMusic()
        }
        
//        self.adDelegate?.loadInter()
//        
//        
//        
//        self.adDelegate?.loadEndGameInter()
        
        let userDefaults = UserDefaults.standard
        
        if let passNumber = userDefaults.object(forKey: "pass") as? Int{
            if passNumber != 0 {
            passCount = passNumber
            }
        }
        
        let question = questions.first!
        

            
            
        let backgroundImage = SKSpriteNode(texture: textures[0])
        backgroundImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backgroundImage.size = CGSize(width: self.frame.width, height: self.frame.height)
        backgroundImage.blendMode = .replace
        backgroundImage.zPosition = 1
        addChild(backgroundImage)
        
        let pass = SKSpriteNode(texture: SKTexture(image: ImageFromText(passCount: passCount)), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 417, height: 125)))
        pass.name = "pass"
        pass.position = convertToSize(point: CGPoint(x: 954.5, y: 71.5))
        pass.zPosition = 2
        addChild(pass)
        nodes["pass"] = pass
        
        let mainFrame = SKSpriteNode(texture: textures[1])
        mainFrame.position = convertToSize(point: CGPoint(x: 612 - 1241, y: 505))
        mainFrame.size = convertTheSize(size: CGSize(width: 1198, height: 706))
        mainFrame.zPosition = 2
        addChild(mainFrame)
        mainFrame.run(SKAction.move(to: convertToSize(point: CGPoint(x: 612, y: 505)), duration: 0.75))
        nodes["mainFrame"] = mainFrame
        let image = SKSpriteNode(imageNamed: question["imagePath"]!)
        image.size = convertTheSize(size: CGSize(width: 470, height: 422))
        image.position = convertToSize(point: CGPoint(x: 282 - 1241, y: 397))
        image.zPosition = 3
        addChild(image)
        image.run(SKAction.move(to: convertToSize(point: CGPoint(x: 282, y: 397)), duration: 0.75))
        nodes["image"] = image
        
        
        let star = SKSpriteNode(texture: textures[2])
        star.position = convertToSize(point: CGPoint(x: 80 - 326, y: 80))
        star.size = convertTheSize(size: CGSize(width: 86, height: 85))
        star.zPosition = 2
        addChild(star)
        star.run(SKAction.move(to: convertToSize(point: CGPoint(x: 80, y: 80)), duration: 1))
        nodes["star"] = star
        
        let starLabel = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(score)/10", size: CGSize(width: 210, height: 100), multipleLine: false, fontSize: 90)), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 170, height: 85)))
        starLabel.position = convertToSize(point: CGPoint(x: 250 - 326, y: 90))
        starLabel.zPosition = 2
        addChild(starLabel)
        starLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 230, y: 90)), duration: 1))
        nodes["starLabel"] = starLabel
        
        
        let imageFrame = SKSpriteNode(texture: textures[3])
        imageFrame.position = convertToSize(point: CGPoint(x: 282 - 1241, y: 397))
        imageFrame.size = convertTheSize(size: CGSize(width: 490, height: 443))
        imageFrame.zPosition = 4
        addChild(imageFrame)
        imageFrame.run(SKAction.move(to: convertToSize(point: CGPoint(x: 282, y: 397)), duration: 0.75))
        nodes["imageFrame"] = imageFrame
        
        let backButton = SKSpriteNode(texture: textures[4])
        backButton.name = "back"
        backButton.position = convertToSize(point: CGPoint(x: 148 - 266, y: 956))
        backButton.size = convertTheSize(size: CGSize(width: 235, height: 231))
        backButton.zPosition = 2
        addChild(backButton)
        backButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 148, y: 956)), duration: 1))
        nodes["backButton"] = backButton
        
        
        for i in 0...2{
            let heart = SKSpriteNode(texture: textures[5])
            heart.position = convertToSize(point: CGPoint(x: 1817 - i * 114, y: 80 - 147))
            heart.size = convertTheSize(size: CGSize(width: 100, height: 100))
            heart.zPosition = 2
            addChild(heart)
            heart.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1817 - i * 114, y: 80)), duration: 1))
            nodes["\(i)heart"] = heart
            
        }
        
        for i in 0...2{
            let answer = AnswerButton(answer: question["\(i)"]!, size: convertTheSize(size: CGSize(width: 687, height: 200)), image: "\(i)Button")
            answer.name = "\(i)Button"
            answer.position = convertToSize(point: CGPoint(x: 1565, y: 235 * i + 270))/*1565*/
            answer.alpha = 0.2
            answer.size = CGSize(width: answer.size.width * 0.1, height: answer.size.height * 0.1)
            answer.zPosition = 2
            addChild(answer)
            answer.run(SKAction.fadeAlpha(to: 1, duration: 2))
            answer.run(SKAction.resize(toWidth: answer.size.width * 10, height: answer.size.height * 10, duration: 1))
            nodes["\(i)answer"] = answer
        }
        
        let quest = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: question["question"]!, size: convertTheSize(size: CGSize(width: 626, height: 642)), multipleLine: true, fontSize: self.frame.width * 48 / 1920)), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 626, height: 642)))
        quest.position = convertToSize(point: CGPoint(x: 863 - 1241, y: 500))
        quest.zPosition = 3
        addChild(quest)
        quest.run(SKAction.move(to: convertToSize(point: CGPoint(x: 863, y: 500)), duration: 0.75))
        nodes["question"] = quest
        
        let timer = Timer(time: Int(timerTime()), spriteSize: convertTheSize(size: CGSize(width: 167, height: 167)))
        timer.position = convertToSize(point: CGPoint(x: 282 - 1241, y: 730))
        timer.zPosition = 3
        addChild(timer)
        timer.run(SKAction.move(to: convertToSize(point: CGPoint(x: 282, y: 730)), duration: 0.75))
        timer.runTimer(timerTime())
        nodes["timer"] = timer
        
    }
    
    fileprivate func reducePass(){
        passCount -= 1
        let pass = nodes["pass"] as? SKSpriteNode
        pass?.texture = SKTexture(image: ImageFromText(passCount: passCount))
    }
    
    fileprivate func showRightAnswer(){
        isAnswered = true
        let question = questions.first!
        for i in 0...2 {
            let rightAnswer = question["rightAnswer"]!
            let answer = nodes["\(i)answer"] as? AnswerButton
            if answer?.answer == rightAnswer{
                let delay = SKAction.wait(forDuration: 0.3)
                let tapped = SKAction.run{
                    answer?.tapped()
                }
                let untapped = SKAction.run{
                    answer?.untapped()
                }
                let action = SKAction.sequence([tapped, delay, untapped, delay])
                let repeatAction = SKAction.repeat(action, count: 3)
                answer?.run(SKAction.sequence([delay, repeatAction]))
            }
        }
    }
    fileprivate func changeQuestion(){
        if answers > 0{
        let mainFrame = nodes["mainFrame"] as? SKSpriteNode
        let imageFrame = nodes["imageFrame"] as? SKSpriteNode
        let image = nodes["image"] as? SKSpriteNode
        let timer = nodes["timer"] as? Timer
        let quest = nodes["question"] as? SKSpriteNode
        let firstButton = nodes["0answer"] as? AnswerButton
        let secondButton = nodes["1answer"] as? AnswerButton
        let thirdButton = nodes["2answer"] as? AnswerButton
        
        
        questions.shuffle()
        let question = questions.first!
        let changeQuestionAction = SKAction.run{
            quest?.texture = SKTexture(image: ImageFromText(text: question["question"]!, size: self.convertTheSize(size: CGSize(width: 626, height: 642)), multipleLine: true, fontSize: self.frame.width * 48 / 1920))
        }
        let changeFirstAnswerAction = SKAction.run{
            firstButton?.changeAnswer(question["0"]!)
        }
        let changeSecondAnswerAction = SKAction.run{
            secondButton?.changeAnswer(question["1"]!)
        }
        let changeThirdAnswerAction = SKAction.run{
            thirdButton?.changeAnswer(question["2"]!)
        }
        let changeImageAction = SKAction.run{
            let texture = SKTexture(imageNamed: question["imagePath"]!)
            SKTexture.preload([texture]){
            image?.texture = texture
            }
        }
        let changeTimerAction = SKAction.run{
            timer?.runTimer(self.timerTime())
        }
        let delay = SKAction.wait(forDuration: 0)
        
        
        mainFrame?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 612 - 1241, y: 505)), duration: 0.5), delay, SKAction.move(to: convertToSize(point: CGPoint(x: 612, y: 505)), duration: 0.75)]))
        imageFrame?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 282 - 1241, y: 397)), duration: 0.5), delay, SKAction.move(to: convertToSize(point: CGPoint(x: 282, y: 397)), duration: 0.75)]))
        image?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 282 - 1241, y: 397)), duration: 0.5), delay, changeImageAction, SKAction.move(to: convertToSize(point: CGPoint(x: 282, y: 397)), duration: 0.75)]))
        timer?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 282 - 1241, y: 730)), duration: 0.5), delay,changeTimerAction, SKAction.move(to: convertToSize(point: CGPoint(x: 282, y: 730)), duration: 0.75)]))
        quest?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 863 - 1241, y: 500)), duration: 0.5), delay, changeQuestionAction, SKAction.move(to: convertToSize(point: CGPoint(x: 863, y: 500)), duration: 0.75)]))
        firstButton?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 1565 + 716, y: 270)), duration: 0.5), delay, changeFirstAnswerAction, SKAction.move(to: convertToSize(point: CGPoint(x: 1565, y: 270)), duration: 0.75)]))
        secondButton?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 1565 + 716, y: 505)), duration: 0.5), delay, changeSecondAnswerAction, SKAction.move(to: convertToSize(point: CGPoint(x: 1565, y: 505)), duration: 0.75)]))
        thirdButton?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 1565 + 716, y: 740)), duration: 0.5), delay, changeThirdAnswerAction, SKAction.move(to: convertToSize(point: CGPoint(x: 1565, y: 740)), duration: 0.75)]))
        self.isAnswered = false
        }
    }
    
    fileprivate func reduceLife(){
        let heart = nodes["\(heartsCount - 1)heart"] as? SKSpriteNode
        heart?.texture = SKTexture(imageNamed: "emptyHeart")
        heartsCount = heartsCount - 1
    }
    
    fileprivate func addScore(){
        score += 1
        let scoreLabel = nodes["starLabel"] as? SKSpriteNode
        scoreLabel?.texture = SKTexture(image: ImageFromText(text: "\(score)/10", size: CGSize(width: 250, height: 100), multipleLine: false, fontSize: 90))
    }
    
    fileprivate func timerTime() -> Double{
        switch level {
        case 1:
            return Double(15)
        case 2:
            return Double(15)
        case 3:
            return Double(14)
        case 4:
            return Double(14)
        case 5:
            return Double(13)
        case 6:
            return Double(13)
        case 7:
            return Double(12)
        case 8:
            return Double(12)
        case 9:
            return Double(11)
        case 10:
            return Double(10)
        default:
            return Double(15)
        }
    }
    
    
    //    MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location =  touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let nodeName = touchedNode.name{
                switch nodeName{
                case "0Button":
                    if !isEnd{
                    firstTouchedNode = touchedNode
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                    let touchedAnswerNode = touchedNode as! AnswerButton
                    touchedAnswerNode.tapped()
                    }
                case "1Button":
                    if !isEnd{
                    firstTouchedNode = touchedNode
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                    let touchedAnswerNode = touchedNode as! AnswerButton
                    touchedAnswerNode.tapped()
                    }
                case "2Button":
                    if !isEnd{
                    firstTouchedNode = touchedNode
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                    let touchedAnswerNode = touchedNode as! AnswerButton
                    touchedAnswerNode.tapped()
                    }
                case "pass":
                    firstTouchedNode = touchedNode
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                case "back":
                    firstTouchedNode = touchedNode
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                                            if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                case "repeatButton":
                    firstTouchedNode = touchedNode
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                                            if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                case "nextLevelButton":
                    firstTouchedNode = touchedNode
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                                            if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                case "nextLevelButtonLocked":
                    firstTouchedNode = touchedNode
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                case "Facebook":
                    firstTouchedNode = touchedNode
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                                            if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                case "Twitter":
                    firstTouchedNode = touchedNode
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                                            if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                case "Game Center":
                    firstTouchedNode = touchedNode
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                                            if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                case "reviveBackground":
                    firstTouchedNode = touchedNode
//                case "videoRevive":
//                    firstTouchedNode = touchedNode
//                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
//                                            if adDelegate!.haveSound() {
//                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
//                        }
                case "reviveHeart":
                    firstTouchedNode = touchedNode
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                    if adDelegate!.haveSound() {
                               touchedNode.run(SKAction.playSoundFileNamed("click button.wav", waitForCompletion: false))
                        }
                    
                default:
                    break
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
                    if let answerNode = unwrappedNode as? AnswerButton{
                        answerNode.tapped()
                    }
                }
                else {
                    unwrappedNode.run(SKAction.scale(to: 1, duration: 0.1))
                    if let answerNode = unwrappedNode as? AnswerButton{
                        answerNode.untapped()
                        
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
                    touchedNode.run(SKAction.scale(to: 1, duration: 0.1), completion:{
//                    for node in touchedNodes{
                        if let nodeName = touchedNode.name{
                            switch nodeName{
                                
                            case "pass":
                                if self.passCount > 0 {
                                self.changeQuestion()
                                self.reducePass()
                                }
                                
                            case "back":
                                let skView = self.view as SKView!
                                let sizeRect = UIScreen.main.bounds
                                let width = sizeRect.size.width * UIScreen.main.scale
                                let height = sizeRect.size.height * UIScreen.main.scale
                                let scene = ArcadeSubLevelScene(levelNumber: self.level, size: CGSize(width: width, height: height))
                                scene.adDelegate = self.adDelegate
                                let popTime = DispatchTime.now() + Double(Int64(0.7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: popTime){
                                    
                                        self.adDelegate?.menuBacgroundMusic()
                                        
                                }
                                skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                                
                            case "repeatButton":
                                let skView = self.view as SKView!
                                let sizeRect = UIScreen.main.bounds
                                let width = sizeRect.size.width * UIScreen.main.scale
                                let height = sizeRect.size.height * UIScreen.main.scale
                                let scene = ArcadeGameScene(size: CGSize(width: width, height: height), level: self.level, subLevel: self.subLevel)
                                scene.adDelegate = self.adDelegate
                                scene.preload(scene, view: skView!)
                                
                            case "nextLevelButton":
                                let skView = self.view as SKView!
                                let sizeRect = UIScreen.main.bounds
                                let width = sizeRect.size.width * UIScreen.main.scale
                                let height = sizeRect.size.height * UIScreen.main.scale
                                let subLevelNumber = self.subLevel + 1
                                if self.subLevel == 12{
                                    if self.checkIfLevelCompleted(){
                                        let scene = ArcadeLevelSelector(size: CGSize(width: width, height: height))
                                        scene.adDelegate = self.adDelegate
                                        scene.presentLevel = self.level + 1
                                        let popTime = DispatchTime.now() + Double(Int64(0.7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                        DispatchQueue.main.asyncAfter(deadline: popTime){
                                            
                                            self.adDelegate?.menuBacgroundMusic()
                                            
                                        }
                                        skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                                    }else{
                                        let scene = ArcadeLevelSelector(size: CGSize(width: width, height: height))
                                        scene.adDelegate = self.adDelegate
                                        scene.presentLevel = self.level
                                        let popTime = DispatchTime.now() + Double(Int64(0.7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                        DispatchQueue.main.asyncAfter(deadline: popTime){
                                            
                                            self.adDelegate?.menuBacgroundMusic()
                                            
                                        }
                                        skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                                    }
                                }else{
                                    let scene = ArcadeGameScene(size: CGSize(width: width, height: height), level: self.level, subLevel: subLevelNumber)
                                    scene.adDelegate = self.adDelegate
                                    scene.preload(scene, view: skView!)
                                }
                                
                            case "0Button":
                                if !self.isAnswered{
                                let answerButton = touchedNode as? AnswerButton
                                answerButton?.untapped()
                                let question = self.questions.first
                                let rightAnswer = question!["rightAnswer"]
                                if answerButton?.answer == rightAnswer {
                                    self.answers -= 1
                                    self.addScore()
                                    if self.adDelegate!.haveSound() {
                                    self.run(SKAction.playSoundFileNamed("RIGHT ANSWER.mp3", waitForCompletion: false))
                                        }
                                    let timer = self.nodes["timer"] as? Timer
                                    timer?.stopTimer()
                                    
                                    let answerAction = SKAction.run{
                                        self.showRightAnswer()
                                    }
                                    let action = SKAction.run{
                                        self.changeQuestion()
                                    }
                                    let delay = SKAction.wait(forDuration: 1.95)
                                    self.run(SKAction.sequence([answerAction, delay, action]))
                                    
                                }
                                    
                                else{
                                    if self.adDelegate!.haveSound() {
                                    self.run(SKAction.playSoundFileNamed("wrongAnswer.wav", waitForCompletion: false))
                                        }
                                    
                                    self.answers -= 1
                                    self.reduceLife()
                                    let timer = self.nodes["timer"] as? Timer
                                    timer?.stopTimer()
                                    let answerAction = SKAction.run{
                                        self.showRightAnswer()
                                    }
                                    if self.heartsCount > 0{
                                    let action = SKAction.run{
                                        self.changeQuestion()
                                    }
                                        let delay = SKAction.wait(forDuration: 1.95)
                                        self.run(SKAction.sequence([answerAction, delay, action]))
                                    }else{
                                        self.run(answerAction)
                                    }

                                }
                                }
                                
                                
                            case "1Button":
                                if !self.isAnswered{
                                let answerButton = touchedNode as? AnswerButton
                                answerButton?.untapped()
                                let question = self.questions.first
                                let rightAnswer = question!["rightAnswer"]
                                if answerButton?.answer == rightAnswer {
                                    self.answers -= 1
                                    self.addScore()
                                    if self.adDelegate!.haveSound() {
                                    self.run(SKAction.playSoundFileNamed("RIGHT ANSWER.mp3", waitForCompletion: false))
                                        }
                                    let timer = self.nodes["timer"] as? Timer
                                    timer?.stopTimer()
                                    let answerAction = SKAction.run{
                                        self.showRightAnswer()
                                    }
                                    let action = SKAction.run{
                                        self.changeQuestion()
                                    }
                                    let delay = SKAction.wait(forDuration: 1.95)
                                    self.run(SKAction.sequence([answerAction, delay, action]))
                                }
                                    
                                else{
                                    if self.adDelegate!.haveSound() {
                                    self.run(SKAction.playSoundFileNamed("wrongAnswer.wav", waitForCompletion: false))
                                        
                                    }
                                    self.answers -= 1
                                    self.reduceLife()
                                    let timer = self.nodes["timer"] as? Timer
                                    timer?.stopTimer()
                                    let answerAction = SKAction.run{
                                        self.showRightAnswer()
                                    }
                                    if self.heartsCount > 0{
                                        let action = SKAction.run{
                                            self.changeQuestion()
                                        }
                                        let delay = SKAction.wait(forDuration: 1.95)
                                        self.run(SKAction.sequence([answerAction, delay, action]))
                                    }else{
                                        self.run(answerAction)
                                    }
                                    
                                    }
                                }
                                
                            case "2Button":
                                if !self.isAnswered{
                                let answerButton = touchedNode as? AnswerButton
                                answerButton?.untapped()
                                let question = self.questions.first
                                let rightAnswer = question!["rightAnswer"]
                                if answerButton?.answer == rightAnswer {
                                    self.answers -= 1
                                    self.addScore()
                                    if self.adDelegate!.haveSound() {
                                    self.run(SKAction.playSoundFileNamed("RIGHT ANSWER.mp3", waitForCompletion: false))
                                        }
                                    let timer = self.nodes["timer"] as? Timer
                                    timer?.stopTimer()
                                    let answerAction = SKAction.run{
                                        self.showRightAnswer()
                                    }
                                    let action = SKAction.run{
                                        self.changeQuestion()
                                    }
                                    let delay = SKAction.wait(forDuration: 1.95)
                                    self.run(SKAction.sequence([answerAction, delay, action]))
                                }
                                    
                                else{
                                    if self.adDelegate!.haveSound() {
                                    self.run(SKAction.playSoundFileNamed("wrongAnswer.wav", waitForCompletion: false))
                                        }
                                    self.answers -= 1
                                    self.reduceLife()
                                    let timer = self.nodes["timer"] as? Timer
                                    timer?.stopTimer()
                                    let answerAction = SKAction.run{
                                        self.showRightAnswer()
                                    }
                                    if self.heartsCount > 0{
                                        let action = SKAction.run{
                                            self.changeQuestion()
                                        }
                                        let delay = SKAction.wait(forDuration: 1.95)
                                        self.run(SKAction.sequence([answerAction, delay, action]))
                                    }else{
                                        self.run(answerAction)
                                    }
                                    
                                    }
                                }
                            case "Facebook":
                                self.createFacebookPost(.arcade, score: self.score)
                            case "Twitter":
                                self.creatTwitterTweet(.arcade, score: self.score)
                            case "Game Center":
                                self.adDelegate?.arcadeGameCenter(self.endScore)
                            case "reviveBackground":
                                self.closeReviveWindow()

//                            case "videoRevive":
//                                self.adDelegate?.displayAdIfCan(.rewarded, delegate: self)
//                                if interDelegate.inter.isReady{
//                                    interDelegate.inter.delegate = self
//                                    self.adDelegate?.displayAd(.Rewarded)
//                                }
                            case "reviveHeart":
                                let reviveHearts = UserDefaults.standard.integer(forKey: "hearts")
                                if reviveHearts != 0{
                                self.reviveWithHeart()
                                }
                            default: break
                            }
//                        }
                        
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
                    if let answerNode = unwrappedNode as? AnswerButton{
                        answerNode.tapped()
                    }
                }
                else {
                    unwrappedNode.run(SKAction.scale(to: 1, duration: 0.1))
                    if let answerNode = unwrappedNode as? AnswerButton{
                        answerNode.untapped()
                        
                    }
                }
            }
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if heartsCount == 0 && !isEnd {
            if !isLostOnce {
                if !reviveWindowIsShowing {
                    if let timer = nodes["timer"] as? Timer{
                        timer.stopTimer()
                    }
                    reviveWindowIsShowing = true
                    openReviveWindow()
                }
            }else{
                isEnd = true
            let popTime = DispatchTime.now() + Double(Int64(1.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime){
                self.failedEnd()
                }
            }
        }
        if answers == 0 && !isEnd{
            isEnd = true
            let popTime = DispatchTime.now() + Double(Int64(1.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime){
                self.end()
            }
        }
        if let timer = nodes["timer"] as? Timer {
            if timer.timerEnded {
                timer.timerEnded = false
                reduceLife()
                if heartsCount < 1{
                    isEnd = true
                    if answers >= 3 {
                        failedEnd()
                    }else{
                    end()
                    }
                }else{
                    changeQuestion()
                }
                
            }
        }
        
    }
    
    fileprivate func openReviveWindow(){
    let background = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.3), size: self.frame.size)
    background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    background.name = "reviveBackground"
    background.alpha = 0
    background.zPosition = 5
    addChild(background)
    background.run(SKAction.fadeAlpha(to: 1, duration: 0.75))
    nodes["reviveBackground"] = background
        
    let reviveFrame = SKSpriteNode(imageNamed: "adsFrame")
    reviveFrame.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    reviveFrame.size = convertTheSize(size: CGSize(width: 883 * 0.1, height: 503 * 0.1))
    reviveFrame.alpha = 0
    reviveFrame.zPosition = 6
    addChild(reviveFrame)
    reviveFrame.run(SKAction.group([SKAction.resize(byWidth: reviveFrame.size.width * 10, height: reviveFrame.size.height * 10, duration: 0.75), SKAction.fadeAlpha(to: 1, duration: 0.75)]))
    nodes["reviveFrame"] = reviveFrame
        
    let reviveHeart = SKSpriteNode(imageNamed: "adsHeart")
    reviveHeart.name = "reviveHeart"
    reviveHeart.position = convertToSize(point: CGPoint(x: 1920 / 2, y: 540))
    reviveHeart.size = convertTheSize(size: CGSize(width: 206 * 0.1, height: 257 * 0.1))
    reviveHeart.alpha = 0
    reviveHeart.zPosition = 7
    addChild(reviveHeart)
    reviveHeart.run(SKAction.group([SKAction.resize(byWidth: reviveHeart.size.width * 10, height: reviveHeart.size.height * 10, duration: 0.75), SKAction.fadeAlpha(to: 1, duration: 0.75)]))
    nodes["reviveHeart"] = reviveHeart
    
    let heartCountLabel = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "x" + String(checkHearts()), size: NSString(string: "x" + String(checkHearts())).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 50)]), multipleLine: false, fontSize: 48)), color: UIColor.clear, size: convertTheSize(size: NSString(string: "x" + String(checkHearts())).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 50)])))
    heartCountLabel.size = CGSize(width: heartCountLabel.size.width * 0.1, height: heartCountLabel.size.height * 0.1)
    heartCountLabel.position = convertToSize(point: CGPoint(x: 1920 / 2, y: 740))
    heartCountLabel.alpha = 0
    heartCountLabel.zPosition = 9
    addChild(heartCountLabel)
    heartCountLabel.run(SKAction.group([SKAction.resize(byWidth: heartCountLabel.size.width * 10, height: heartCountLabel.size.height * 10, duration: 0.75), SKAction.fadeAlpha(to: 1, duration: 0.75)]))
    nodes["heartCountLabel"] = heartCountLabel
        
//    let videoLabel = SKSpriteNode(imageNamed: "adsVideo")
//    videoLabel.position = convertToSize(point: CGPoint(x: 1180, y: 540))
//    videoLabel.size = convertTheSize(size: CGSize(width: 338 * 0.1, height: 389 * 0.1))
//    videoLabel.name = "videoRevive"
//    videoLabel.alpha = 0
//    videoLabel.zPosition = 7
//    addChild(videoLabel)
//    videoLabel.run(SKAction.group([SKAction.resize(byWidth: videoLabel.size.width * 10, height: videoLabel.size.height * 10, duration: 0.75), SKAction.fadeAlpha(to: 1, duration: 0.75)]))
//    nodes["videoLabel"] = videoLabel
        
    }
    
    fileprivate func closeReviveWindow(){
        let reviveFrame = nodes["reviveFrame"] as? SKSpriteNode
        let reviveHeart = nodes["reviveHeart"] as? SKSpriteNode
//        let videoLable = nodes["videoLabel"] as? SKSpriteNode
        let background = nodes["reviveBackground"] as? SKSpriteNode
        let heartCountLabel = nodes["heartCountLabel"] as? SKSpriteNode
        heartCountLabel?.run(SKAction.group([SKAction.resize(toWidth: (heartCountLabel?.size.width)! * 0.1, height: (heartCountLabel?.size.height)! * 0.1, duration: 0.75), SKAction.fadeAlpha(to: 0, duration: 0.75)]), completion: {
            heartCountLabel?.removeFromParent()
        })
        reviveFrame?.run(SKAction.group([SKAction.resize(toWidth: (reviveFrame?.size.width)! * 0.1, height: (reviveFrame?.size.height)! * 0.1, duration: 0.75), SKAction.fadeAlpha(to: 0, duration: 0.75)]), completion: {
        reviveFrame?.removeFromParent()
        })
        reviveHeart?.run(SKAction.group([SKAction.resize(toWidth: (reviveHeart?.size.width)! * 0.1, height: (reviveHeart?.size.height)! * 0.1, duration: 0.75), SKAction.fadeAlpha(to: 0, duration: 0.75)]), completion: {
            reviveHeart?.removeFromParent()
        })
//        videoLable?.run(SKAction.group([SKAction.resize(toWidth: (videoLable?.size.width)! * 0.1, height: (videoLable?.size.height)! * 0.1, duration: 0.75), SKAction.fadeAlpha(to: 0, duration: 0.75)]), completion: {
//            videoLable?.removeFromParent()
//        })
        background?.run(SKAction.group([SKAction.fadeAlpha(to: 0, duration: 0.75)]), completion: {
            background?.removeFromParent()
            self.reviveWindowIsShowing = false
            self.isLostOnce = true
        })
    }
    
    fileprivate func end(){
        
//        if interDelegate.endGameInter.isReady{
//            interDelegate.endGameInter.delegate = self
//            self.adDelegate?.displayAd(.Default)
//        }
        
//        self.adDelegate?.displayAdIfCan(.default, delegate: self)
        
        
        
        let mainFrame = nodes["mainFrame"] as? SKSpriteNode
        let imageFrame = nodes["imageFrame"] as? SKSpriteNode
        let image = nodes["image"] as? SKSpriteNode
        let timer = nodes["timer"] as? Timer
        let quest = nodes["question"] as? SKSpriteNode
        let firstButton = nodes["0answer"] as? AnswerButton
        let secondButton = nodes["1answer"] as? AnswerButton
        let thirdButton = nodes["2answer"] as? AnswerButton
        let backButton = nodes["backButton"] as? SKSpriteNode
        let pass = nodes["pass"] as? SKSpriteNode
        let starNode = nodes["star"] as? SKSpriteNode
        let starLabel = nodes["starLabel"] as? SKSpriteNode
        
        
        
        
        
        for i in 0...2 {
            let heart = nodes["\(i)heart"] as? SKSpriteNode
            heart?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1817 - i * 114, y: 80 - 147)), duration: 0.75))
        }
        starLabel?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 250 - 376, y: 90)), duration: 0.75))
        starNode?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 80 - 326, y: 80)), duration: 0.75))
        pass?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 954.5, y: -100)), duration: 0.75))
        backButton?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 148 - 266, y: 956)), duration: 0.75))
        mainFrame?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 612 - 1241, y: 505)), duration: 0.75))
        imageFrame?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 282 - 1241, y: 397)), duration: 0.75))
        image?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 282 - 1241, y: 397)), duration: 0.75))
        timer?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 282 - 1241, y: 730)), duration: 0.75))
        quest?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 863 - 1241, y: 500)), duration: 0.75))
        firstButton?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1565 + 716, y: 270)), duration: 0.75))
        secondButton?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1565 + 716, y: 505)), duration: 0.75))
        thirdButton?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1565 + 716, y: 775)), duration: 0.75), completion: {
        
//        Social
            
            
        self.socialButtons()
          
//            END GAME
            
            let leftFrame = SKSpriteNode(imageNamed: "leftFrame")
            leftFrame.size = self.convertTheSize(size: CGSize(width: 761.5, height: 897))
            leftFrame.position = self.convertToSize(point: CGPoint(x: -380.75, y: 459.0))
            leftFrame.zPosition = 2
            self.addChild(leftFrame)
            if self.frame.width == 960{
                leftFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 563, y: 459)), duration: 0.75))
            }else{
                leftFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 575, y: 459)), duration: 0.75))
            }
            
            let rightFrame = SKSpriteNode(imageNamed: "rightFrame")
            rightFrame.size = self.convertTheSize(size: CGSize(width: 761.5, height: 897))
            rightFrame.position = self.convertToSize(point: CGPoint(x: 2300.75, y: 459.0))
            rightFrame.zPosition = 2
            self.addChild(rightFrame)
            if self.frame.width == 960{
                rightFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1347.25, y: 459)), duration: 0.75))
            }else{
                rightFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1335.25, y: 459)), duration: 0.75))
            }
        
        let levelComplete = SKSpriteNode(imageNamed: NSLocalizedString("LEVEL_COMPLETED",tableName: "LocalizableStrings", comment: "play"))
        levelComplete.size = self.convertTheSize(size: levelComplete.texture!.size())
        levelComplete.position = self.convertToSize(point: CGPoint(x: -294, y: 130))
        levelComplete.zPosition = 3
        self.addChild(levelComplete)
            
            if self.isRus{
                levelComplete.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 600, y: 130)), duration: 0.75))
            }else{
                levelComplete.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 500, y: 130)), duration: 0.75))
            }
        
        let levelBonusLabel = SKSpriteNode(imageNamed: NSLocalizedString("LEVEL_BONUS",tableName: "LocalizableStrings", comment: "play"))
        levelBonusLabel.position = self.convertToSize(point: CGPoint(x: -156, y: 425))
        levelBonusLabel.size = self.convertTheSize(size: levelBonusLabel.texture!.size())
        levelBonusLabel.zPosition = 3
        self.addChild(levelBonusLabel)
        levelBonusLabel.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 410, y: 425)), duration: 0.75))
        
        
        let heartBonusLabel = SKSpriteNode(imageNamed: NSLocalizedString("HEARTBONUS",tableName: "LocalizableStrings", comment: "play"))
        heartBonusLabel.position = self.convertToSize(point: CGPoint(x: -144, y: 580))
        heartBonusLabel.size = self.convertTheSize(size: heartBonusLabel.texture!.size())
        heartBonusLabel.zPosition = 3
        self.addChild(heartBonusLabel)
        heartBonusLabel.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 412, y: 580)), duration: 0.75))
        
        let totalBonusLabel = SKSpriteNode(imageNamed: NSLocalizedString("TOTAL",tableName: "LocalizableStrings", comment: "play"))
        totalBonusLabel.position = self.convertToSize(point: CGPoint(x: -148.5, y: 770))
        totalBonusLabel.size = self.convertTheSize(size: totalBonusLabel.texture!.size())
        totalBonusLabel.zPosition = 3
        self.addChild(totalBonusLabel)
        totalBonusLabel.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 414, y: 770)), duration: 0.75))
        
        
        let scoreLabel = SKSpriteNode(imageNamed: NSLocalizedString("SCORE",tableName: "LocalizableStrings", comment: "play"))
        scoreLabel.position = self.convertToSize(point: CGPoint(x: -79, y: 290))
        scoreLabel.size = self.convertTheSize(size: scoreLabel.texture!.size())
        scoreLabel.zPosition = 3
        self.addChild(scoreLabel)
        scoreLabel.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 817, y: 290)), duration: 0.75))
        
        
        let coinsLabel = SKSpriteNode(imageNamed: NSLocalizedString("COINS",tableName: "LocalizableStrings", comment: "play"))
        coinsLabel.position = self.convertToSize(point: CGPoint(x: 1997, y: 290))
        coinsLabel.size = self.convertTheSize(size: coinsLabel.texture!.size())
        coinsLabel.zPosition = 3
        self.addChild(coinsLabel)
        coinsLabel.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1392, y: 290)), duration: 0.75))
        
        
        let star = SKSpriteNode(imageNamed: "star")
        star.position = self.convertToSize(point: CGPoint(x: 2052.5, y: 105))
        star.size = self.convertTheSize(size: CGSize(width: 85, height: 85))
        star.zPosition = 3
        self.addChild(star)
        star.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1400, y: 105)), duration: 0.75))
        
        
        let starsLabel = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(self.score)/10", size: CGSize(width: 210, height: 100), multipleLine: false, fontSize: self.convertFontSize(72))), color: UIColor.clear, size: CGSize(width: 170, height: 85))
        starsLabel.position = self.convertToSize(point: CGPoint(x: 2005, y: 113))
        starsLabel.zPosition = 3
        self.addChild(starsLabel)
        starsLabel.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1543, y: 113)), duration: 0.75))
        
        
        let menuButton = SKSpriteNode(imageNamed: "menuButton")
        menuButton.name = "back"
        menuButton.size = self.convertTheSize(size: CGSize(width: 167, height: 167))
        menuButton.position = self.convertToSize(point: CGPoint(x: 653, y: 1163.5))
        menuButton.zPosition = 2
        self.addChild(menuButton)
        menuButton.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 653, y: 1000)), duration: 0.75))
        
        let repeatButton = SKSpriteNode(imageNamed: "repeatButton")
        repeatButton.name = "repeatButton"
        repeatButton.position = self.convertToSize(point: CGPoint(x: 960, y: 1163.5))
        repeatButton.size = self.convertTheSize(size: CGSize(width: 167, height: 167))
        repeatButton.zPosition = 2
        self.addChild(repeatButton)
        repeatButton.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 960, y: 1000)), duration: 0.75))
            
        
        let nextLevelButton = SKSpriteNode(imageNamed: "nextLevelButton")
        nextLevelButton.name = "nextLevelButton"
        nextLevelButton.position = self.convertToSize(point: CGPoint(x: 1267, y: 1163.5))
        nextLevelButton.size = self.convertTheSize(size: CGSize(width: 167, height: 167))
        nextLevelButton.zPosition = 2
        self.addChild(nextLevelButton)
        nextLevelButton.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1267, y: 1000)), duration: 0.75))

        
        
        let levelBonusScore = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(self.level * 100)" , size: CGSize(width: 200, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: self.convertTheSize(size: CGSize(width: 200, height: 120)))
        levelBonusScore.position = self.convertToSize(point: CGPoint(x: -100, y: 420))
        levelBonusScore.zPosition = 3
        self.addChild(levelBonusScore)
        levelBonusScore.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 817, y: 420)), duration: 0.75))
            
            switch self.heartsCount{
            case 1:
                let heartBonusScore = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(200)" , size: CGSize(width: 200, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: self.convertTheSize(size: CGSize(width: 200, height: 120)))
                heartBonusScore.position = self.convertToSize(point: CGPoint(x: -100, y: 580))
                heartBonusScore.zPosition = 3
                self.addChild(heartBonusScore)
                heartBonusScore.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 817, y: 580)), duration: 0.75))
            case 2:
                let heartBonusScore = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(300)" , size: CGSize(width: 200, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: self.convertTheSize(size: CGSize(width: 200, height: 120)))
                heartBonusScore.position = self.convertToSize(point: CGPoint(x: -100, y: 580))
                heartBonusScore.zPosition = 3
                self.addChild(heartBonusScore)
                heartBonusScore.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 817, y: 580)), duration: 0.75))
            case 3:
                let heartBonusScore = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(500)" , size: CGSize(width: 200, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: self.convertTheSize(size: CGSize(width: 200, height: 120)))
                heartBonusScore.position = self.convertToSize(point: CGPoint(x: -100, y: 580))
                heartBonusScore.zPosition = 3
                self.addChild(heartBonusScore)
                heartBonusScore.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 817, y: 580)), duration: 0.75))
            default:
                break
            }
        
        
            var heartBonusCoinsInt = 0
            switch self.heartsCount{
            case 1:
                heartBonusCoinsInt = 100
            case 2:
                heartBonusCoinsInt = 150
            case 3:
                heartBonusCoinsInt = 250
            default:
                break
                
            }
        
        let totalScore = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(self.level * 100 + heartBonusCoinsInt * 2)" , size: CGSize(width: 200, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: self.convertTheSize(size: CGSize(width: 200, height: 120)))
        totalScore.position = self.convertToSize(point: CGPoint(x: -100, y: 770))
        totalScore.zPosition = 3
        self.addChild(totalScore)
        totalScore.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 817, y: 770)), duration: 0.75))
        self.endScore = self.level * 100 + self.heartsCount * 150
        
        let levelBonusCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(self.level * 50)" , size: CGSize(width: 200, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: self.convertTheSize(size: CGSize(width: 200, height: 120)))
        levelBonusCoins.position = self.convertToSize(point: CGPoint(x: 2020, y: 420))
        levelBonusCoins.zPosition = 3
        self.addChild(levelBonusCoins)
        levelBonusCoins.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1366, y: 420)), duration: 0.75))
        
        let heartBonusCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(heartBonusCoinsInt)" , size: CGSize(width: 200, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: self.convertTheSize(size: CGSize(width: 200, height: 120)))
        heartBonusCoins.position = self.convertToSize(point: CGPoint(x: 2070, y: 580))
        heartBonusCoins.zPosition = 3
        self.addChild(heartBonusCoins)
        heartBonusCoins.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1366, y: 580)), duration: 0.75))
        
        let totalCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(self.level * 50 + heartBonusCoinsInt)" , size: CGSize(width: 200, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: self.convertTheSize(size: CGSize(width: 200, height: 120)))
        totalCoins.position = self.convertToSize(point: CGPoint(x: 2070, y: 770))
        totalCoins.zPosition = 3
        self.addChild(totalCoins)
        totalCoins.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1366, y: 770)), duration: 0.75))
            
        })
        
        switch self.heartsCount {
        case 1:
            save(self.level * 50 + 100)
        case 2:
            save(self.level * 50 + 150)
        case 3:
            save(self.level * 50 + 250)
        default:
            break
        }
        

    }
    
    fileprivate func failedEnd(){
        
//        if interDelegate.endGameInter.isReady{
//            interDelegate.endGameInter.delegate = self
//            self.adDelegate?.displayAd(.Default)
//        }
//        self.adDelegate?.displayAdIfCan(.default, delegate: self)
        
        let mainFrame = nodes["mainFrame"] as? SKSpriteNode
        let imageFrame = nodes["imageFrame"] as? SKSpriteNode
        let image = nodes["image"] as? SKSpriteNode
        let timer = nodes["timer"] as? Timer
        let quest = nodes["question"] as? SKSpriteNode
        let firstButton = nodes["0answer"] as? AnswerButton
        let secondButton = nodes["1answer"] as? AnswerButton
        let thirdButton = nodes["2answer"] as? AnswerButton
        let backButton = nodes["backButton"] as? SKSpriteNode
        let pass = nodes["pass"] as? SKSpriteNode
        let starNode = nodes["star"] as? SKSpriteNode
        let starLabel = nodes["starLabel"] as? SKSpriteNode
        
        
        
        
        
        for i in 0...2 {
            let heart = nodes["\(i)heart"] as? SKSpriteNode
            heart?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1817 - i * 114, y: 80 - 147)), duration: 0.75))
        }
        starLabel?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 250 - 376, y: 90)), duration: 0.75))
        starNode?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 80 - 326, y: 80)), duration: 0.75))
        pass?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 954.5, y: -100)), duration: 0.75))
        backButton?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 148 - 266, y: 956)), duration: 0.75))
        mainFrame?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 612 - 1241, y: 505)), duration: 0.75))
        imageFrame?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 282 - 1241, y: 397)), duration: 0.75))
        image?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 282 - 1241, y: 397)), duration: 0.75))
        timer?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 282 - 1241, y: 730)), duration: 0.75))
        quest?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 863 - 1241, y: 500)), duration: 0.75))
        firstButton?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1565 + 716, y: 270)), duration: 0.75))
        secondButton?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1565 + 716, y: 505)), duration: 0.75))
        thirdButton?.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1565 + 716, y: 775)), duration: 0.75), completion: {
            
            
            
            let leftFrame = SKSpriteNode(imageNamed: "leftFrame")
            leftFrame.size = self.convertTheSize(size: CGSize(width: 761.5, height: 897))
            leftFrame.position = self.convertToSize(point: CGPoint(x: -380.75, y: 459.0))
            leftFrame.zPosition = 2
            self.addChild(leftFrame)
            if self.frame.width == 960{
            leftFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 563, y: 459)), duration: 0.75))
            }else{
            leftFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 575, y: 459)), duration: 0.75))
            }
            
            let rightFrame = SKSpriteNode(imageNamed: "rightFrame")
            rightFrame.size = self.convertTheSize(size: CGSize(width: 761.5, height: 897))
            rightFrame.position = self.convertToSize(point: CGPoint(x: 2300.75, y: 459.0))
            rightFrame.zPosition = 2
            self.addChild(rightFrame)
            if self.frame.width == 960{
            rightFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1347.25, y: 459)), duration: 0.75))
            }else{
            rightFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1335.25, y: 459)), duration: 0.75))
            }
            
            let levelComplete = SKSpriteNode(imageNamed: NSLocalizedString("FAILED",tableName: "LocalizableStrings", comment: "play"))
            levelComplete.size = self.convertTheSize(size: levelComplete.texture!.size())
            levelComplete.position = self.convertToSize(point: CGPoint(x: -294, y: 130))
            levelComplete.zPosition = 3
            self.addChild(levelComplete)
            levelComplete.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 500, y: 130)), duration: 0.75))
            
            let levelBonusLabel = SKSpriteNode(imageNamed: NSLocalizedString("LEVEL_BONUS",tableName: "LocalizableStrings", comment: "play"))
            levelBonusLabel.position = self.convertToSize(point: CGPoint(x: -156, y: 425))
            levelBonusLabel.size = self.convertTheSize(size: levelBonusLabel.texture!.size())
            levelBonusLabel.zPosition = 3
            self.addChild(levelBonusLabel)
            levelBonusLabel.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 410, y: 425)), duration: 0.75))
            
            
            let heartBonusLabel = SKSpriteNode(imageNamed: NSLocalizedString("HEARTBONUS",tableName: "LocalizableStrings", comment: "play"))
            heartBonusLabel.position = self.convertToSize(point: CGPoint(x: -144, y: 580))
            heartBonusLabel.size = self.convertTheSize(size: heartBonusLabel.texture!.size())
            heartBonusLabel.zPosition = 3
            self.addChild(heartBonusLabel)
            heartBonusLabel.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 412, y: 580)), duration: 0.75))
            
            
            let totalBonusLabel = SKSpriteNode(imageNamed: NSLocalizedString("TOTAL",tableName: "LocalizableStrings", comment: "play"))
            totalBonusLabel.position = self.convertToSize(point: CGPoint(x: -148.5, y: 770))
            totalBonusLabel.size = self.convertTheSize(size: totalBonusLabel.texture!.size())
            totalBonusLabel.zPosition = 3
            self.addChild(totalBonusLabel)
            totalBonusLabel.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 414, y: 770)), duration: 0.75))
            
            
            let scoreLabel = SKSpriteNode(imageNamed: NSLocalizedString("SCORE",tableName: "LocalizableStrings", comment: "play"))
            scoreLabel.position = self.convertToSize(point: CGPoint(x: -79, y: 290))
            scoreLabel.size = self.convertTheSize(size: scoreLabel.texture!.size())
            scoreLabel.zPosition = 3
            self.addChild(scoreLabel)
            scoreLabel.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 817, y: 290)), duration: 0.75))
            
            
            let coinsLabel = SKSpriteNode(imageNamed: NSLocalizedString("COINS",tableName: "LocalizableStrings", comment: "play"))
            coinsLabel.position = self.convertToSize(point: CGPoint(x: 1997, y: 290))
            coinsLabel.size = self.convertTheSize(size: coinsLabel.texture!.size())
            coinsLabel.zPosition = 3
            self.addChild(coinsLabel)
            coinsLabel.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1392, y: 290)), duration: 0.75))
            
            
            let star = SKSpriteNode(imageNamed: "star")
            star.position = self.convertToSize(point: CGPoint(x: 2052.5, y: 105))
            star.size = self.convertTheSize(size: CGSize(width: 85, height: 85))
            star.zPosition = 3
            self.addChild(star)
            star.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1400, y: 105)), duration: 0.75))
            
            
            let starsLabel = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(self.score)/10", size: CGSize(width: 210, height: 100), multipleLine: false, fontSize: self.convertFontSize(72))), color: UIColor.clear, size: CGSize(width: 170, height: 85))
            
            starsLabel.position = self.convertToSize(point: CGPoint(x: 2005, y: 113))
            starsLabel.zPosition = 3
            self.addChild(starsLabel)
            starsLabel.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1543, y: 113)), duration: 0.75))
            
            
            let menuButton = SKSpriteNode(imageNamed: "menuButton")
            menuButton.name = "back"
            menuButton.size = self.convertTheSize(size: CGSize(width: 167, height: 167))
            menuButton.position = self.convertToSize(point: CGPoint(x: 653, y: 1163.5))
            menuButton.zPosition = 2
            self.addChild(menuButton)
            menuButton.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 653, y: 1000)), duration: 0.75))
            
            let repeatButton = SKSpriteNode(imageNamed: "repeatButton")
            repeatButton.name = "repeatButton"
            repeatButton.position = self.convertToSize(point: CGPoint(x: 960, y: 1163.5))
            repeatButton.size = self.convertTheSize(size: CGSize(width: 167, height: 167))
            repeatButton.zPosition = 2
            self.addChild(repeatButton)
            repeatButton.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 960, y: 1000)), duration: 0.75))
            
            if self.level != 12 && self.subLevel != 12{
            
            let nextLevelButton = SKSpriteNode(imageNamed: "nextLevelButton")
            nextLevelButton.position = self.convertToSize(point: CGPoint(x: 1267, y: 1163.5))
            nextLevelButton.size = self.convertTheSize(size: CGSize(width: 167, height: 167))
            nextLevelButton.zPosition = 2
            self.addChild(nextLevelButton)
            nextLevelButton.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1267, y: 1000)), duration: 0.75))
            }
            
            
            
            let levelBonusScore = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "0" , size: CGSize(width: 200, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: self.convertTheSize(size: CGSize(width: 200, height: 120)))
            levelBonusScore.position = self.convertToSize(point: CGPoint(x: -100, y: 420))
            levelBonusScore.zPosition = 3
            self.addChild(levelBonusScore)
            levelBonusScore.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 817, y: 420)), duration: 0.75))
            
            let heartBonusScore = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "0" , size: CGSize(width: 200, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: self.convertTheSize(size: CGSize(width: 200, height: 120)))
            heartBonusScore.position = self.convertToSize(point: CGPoint(x: -100, y: 580))
            heartBonusScore.zPosition = 3
            self.addChild(heartBonusScore)
            heartBonusScore.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 817, y: 580)), duration: 0.75))
            
            let totalScore = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "0" , size: CGSize(width: 200, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: self.convertTheSize(size: CGSize(width: 200, height: 120)))
            totalScore.position = self.convertToSize(point: CGPoint(x: -100, y: 770))
            totalScore.zPosition = 3
            self.addChild(totalScore)
            totalScore.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 817, y: 770)), duration: 0.75))
            
            let levelBonusCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "0" , size: CGSize(width: 200, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: self.convertTheSize(size: CGSize(width: 200, height: 120)))
            levelBonusCoins.position = self.convertToSize(point: CGPoint(x: 2020, y: 420))
            levelBonusCoins.zPosition = 3
            self.addChild(levelBonusCoins)
            levelBonusCoins.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1366, y: 420)), duration: 0.75))
            
            let heartBonusCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "0" , size: CGSize(width: 200, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: self.convertTheSize(size: CGSize(width: 200, height: 120)))
            heartBonusCoins.position = self.convertToSize(point: CGPoint(x: 2070, y: 580))
            heartBonusCoins.zPosition = 3
            self.addChild(heartBonusCoins)
            heartBonusCoins.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1366, y: 580)), duration: 0.75))
            
            let totalCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "0" , size: CGSize(width: 200, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: self.convertTheSize(size: CGSize(width: 200, height: 120)))
            totalCoins.position = self.convertToSize(point: CGPoint(x: 2070, y: 770))
            totalCoins.zPosition = 3
            self.addChild(totalCoins)
            totalCoins.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1366, y: 770)), duration: 0.75))
            
        })
        
        save(0)


    }

    fileprivate func save(_ coins: Int){
        let userDefaults = UserDefaults.standard
        userDefaults.set(userDefaults.integer(forKey: "coins") + coins, forKey: "coins")
        userDefaults.set(passCount, forKey: "pass")
        
        do{
            
            let fileManager = FileManager.default
            
            let documentUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let documentLevelsDataUrl = documentUrl.appendingPathComponent("LevelsData.json")
            if let documentLevelsData = try? Data(contentsOf: documentLevelsDataUrl){
                
                var json = JSON(data: documentLevelsData)
                
                let savedScore = json["Levels"][level - 1]["\(subLevel)"].numberValue as Int
                
                if score > savedScore && score > 7{
                    json["Levels"][level - 1]["\(subLevel)"].numberValue = NSNumber(value: score)
                    
                    let jsonData = json.description
                    
                    let fileManager = FileManager.default
                    
                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let file = documentDirectory.appendingPathComponent("LevelsData.json")
                    
                    let data = jsonData.data(using: String.Encoding.utf8)
                    try data?.write(to: file, options: .atomic)

                }
                
            }
         
            else{
                if let levelsDataUrl = Bundle.main.url(forResource: "LevelsData", withExtension: "json"){
                    let levelsJsonData = try Data(contentsOf: levelsDataUrl, options: .mappedIfSafe)
                    var json = JSON(data: levelsJsonData)
                    
                    if score > 7{
                    json["Levels"][level - 1]["\(subLevel)"].numberValue = NSNumber(value: score)
                    
                    let jsonData = json.description
                    
                    let fileManager = FileManager.default
                    
                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let file = documentDirectory.appendingPathComponent("LevelsData.json")
                    
                    let data = jsonData.data(using: String.Encoding.utf8)
                    try data?.write(to: file, options: .atomic)
                    }
                }
            }
            
            
        }
        catch let errorPtr as NSError {
            print(errorPtr.localizedDescription)
        }

    }
    
    fileprivate func socialButtons(){
        
        let facebookLogo = SKSpriteNode(imageNamed: "Facebook")
        facebookLogo.size = self.convertTheSize(size: facebookLogo.texture!.size())
        facebookLogo.position = self.convertToSize(point: CGPoint(x: -100, y: 666))
        facebookLogo.name = "Facebook"
        facebookLogo.zPosition = 2
        self.addChild(facebookLogo)
        facebookLogo.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 100, y: 666)), duration: 0.75))
        
        let twitterLogo = SKSpriteNode(imageNamed: "Twitter")
        twitterLogo.size = self.convertTheSize(size: twitterLogo.texture!.size())
        twitterLogo.position = self.convertToSize(point: CGPoint(x: -100, y: 466))
        twitterLogo.name = "Twitter"
        twitterLogo.zPosition = 2
        self.addChild(twitterLogo)
        twitterLogo.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 100, y: 466)), duration: 0.75))
        
        let gameCenterLogo = SKSpriteNode(imageNamed: "Game Center")
        gameCenterLogo.size = self.convertTheSize(size: gameCenterLogo.texture!.size())
        gameCenterLogo.position = self.convertToSize(point: CGPoint(x: -100, y: 266))
        gameCenterLogo.name = "Game Center"
        gameCenterLogo.zPosition = 2
        self.addChild(gameCenterLogo)
        gameCenterLogo.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 100, y: 268)), duration: 0.75))
    }
    
//    func interstitialDidDismissScreen(_ ad: GADInterstitial!) {
//        
//        
//        adDelegate?.resumePlayer()
//        if self.adDelegate!.checkIfRewarded(ad){
//            heartsCount = 1
//            let heart = nodes["\(heartsCount - 1)heart"] as? SKSpriteNode
//            heart?.texture = textures[5]
//            self.answers += 1
//            closeReviveWindow()
//            changeQuestion()
//        }
//    }
//    
//
//    
//    
//    func interstitialWillPresentScreen(_ ad: GADInterstitial!) {
//        if adDelegate!.haveMusic(){
//            adDelegate?.pausePlayer()
//        }
//    }
    
    func reviveWithHeart(){
        heartsCount = 1
        let heart = nodes["\(heartsCount - 1)heart"] as? SKSpriteNode
        heart?.texture = textures[5]
        self.answers += 1
        closeReviveWindow()
        isLostOnce = false
        changeQuestion()
        let userDefaults = UserDefaults.standard
        if userDefaults.integer(forKey: "hearts") != 0{
            userDefaults.set(userDefaults.integer(forKey: "hearts") - 1, forKey: "hearts")
        }
    }
    
    func checkHearts() -> Int{
        let userDefaults = UserDefaults.standard
        
        let hearts = userDefaults.integer(forKey: "hearts")
        
        return hearts
    }
    
    fileprivate func checkIfLevelCompleted() ->Bool {
        do{
            
            let fileManager = FileManager.default
            
            let documentUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let documentLevelsDataUrl = documentUrl.appendingPathComponent("LevelsData.json")
            if let documentLevelsData = try? Data(contentsOf: documentLevelsDataUrl){
                let json = JSON(data: documentLevelsData)
                let level = json["Levels"].arrayValue[self.level]
                var levelStars = 0
                for index in 1...12{
                    levelStars += level["\(index)"].numberValue as Int
                }
                
                if levelStars > 96 + self.level {
                    return true
                }else{
                    return false
                }
            }
        }
        
        catch{
            return false
        }
        
        return false
        
    }
    
}
