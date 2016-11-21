//
//  SingleGameScene.swift
//  projectQAlfa
//
//  Created by Кирилл on 28.03.16.
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

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class SingleGameScene: SKScene{
    
    var adDelegate: AdProtocol?
    
    var firstTouchedNode: SKNode?

    var questions = [[String: String]]()
    
    var nodes = [String: AnyObject]()
    
    var category: String
    
    var answers = 0
    
    var isEnd = false
    
    var coins = 500
    
    var score = 0
    
    var isAnswered = false
    
    var textures = [SKTexture]()
    
    var rusVersion = false
    
    init(size: CGSize, category: String){
        self.category = NSLocalizedString(category,tableName: "LocalizableStrings", comment: "play")
        super.init(size: size)
        if category == "General_boom"{
            
            let locHeading = ["Nature_boom", "Figure_boom", "Literature_boom", "Movie_boom", "Music_boom", "Science_boom", "Apple_boom", "Astro_boom", "Geo_boom", "History_boom", "Meal_boom", "Sport_boom"]
            var heading = [String]()
            for head in locHeading{
                let locHead = NSLocalizedString(head,tableName: "LocalizableStrings", comment: "play")
                heading.append(locHead)
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
        else{
            if let path = Bundle.main.path(forResource: self.category, ofType: "json"){
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)){
                    print(data)
                    let json = JSON(data: data)
                    print(json)
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
        
        let imageNames = ["background.jpg", "mainFrame", "imageFrame", "backButton", "star", "star", "star", "coin", "leftFrame", "rightFrame", NSLocalizedString("EXCELLENT",tableName: "LocalizableStrings", comment: "play"), NSLocalizedString("TIME",tableName: "LocalizableStrings", comment: "play"), NSLocalizedString("YOUR_TIME",tableName: "LocalizableStrings", comment: "play"), NSLocalizedString("MEDAL_BONUS",tableName: "LocalizableStrings", comment: "play"),  NSLocalizedString("TOTAL_COINS",tableName: "LocalizableStrings", comment: "play"), NSLocalizedString("COINS",tableName: "LocalizableStrings", comment: "play"), "menuButton", "repeatButton", "nextLevelButton", NSLocalizedString("WELL_DONE",tableName: "LocalizableStrings", comment: "play"), NSLocalizedString("NOT_BAD",tableName: "LocalizableStrings", comment: "play"), NSLocalizedString("FAILED",tableName: "LocalizableStrings", comment: "play")]
        
        if imageNames[11] == "time_rus" {
            rusVersion = true
        }else{
            rusVersion = false
        }
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
                var array = [first, second, third]
                array.shuffle()
                let dict = ["question": quest, "imagePath": imagePath, "rightAnswer": rightAnswer, "0": array[0], "1": array[1], "2": array[2]]
                questions.append(dict)
                
            }
            
        }
        
        
    }
    override func didMove(to view: SKView) {
        
        let popTime = DispatchTime.now() + Double(Int64(0.7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime){
            if self.adDelegate!.haveMusic(){
            self.adDelegate?.inGameBackgroundMusic()
            }
        }
        
        
        
        let question = questions.first!
        
        let backgroundImage = SKSpriteNode(texture: textures[0])
        backgroundImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backgroundImage.size = CGSize(width: self.frame.width, height: self.frame.height)
        backgroundImage.blendMode = .replace
        backgroundImage.zPosition = 1
        addChild(backgroundImage)
        
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
        
        let imageFrame = SKSpriteNode(texture: textures[2])
        imageFrame.position = convertToSize(point: CGPoint(x: 282 - 1241, y: 397))
        imageFrame.size = convertTheSize(size: CGSize(width: 490, height: 443))
        imageFrame.zPosition = 4
        addChild(imageFrame)
        imageFrame.run(SKAction.move(to: convertToSize(point: CGPoint(x: 282, y: 397)), duration: 0.75))
        nodes["imageFrame"] = imageFrame
        
        let backButton = SKSpriteNode(texture: textures[3])
        backButton.name = "back"
        backButton.position = convertToSize(point: CGPoint(x: 148 - 266, y: 956))
        backButton.size = convertTheSize(size: CGSize(width: 235, height: 231))
        backButton.zPosition = 2
        addChild(backButton)
        backButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 148, y: 956)), duration: 1))
        nodes["backButton"] = backButton
        
        let goldMedal = SKSpriteNode(texture: textures[4])
        goldMedal.position = convertToSize(point: CGPoint(x: 1484.0, y: 88.0 - 160))
        goldMedal.size = convertTheSize(size: CGSize(width: 100, height: 100))
        goldMedal.zPosition = 2
        addChild(goldMedal)
        goldMedal.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1484.0, y: 88.0)), duration: 0.75))
        goldMedal.run(SKAction.sequence([SKAction.wait(forDuration: 115.75), SKAction.move(to: convertToSize(point: CGPoint(x: 1484.0, y: 88.0 - 160)), duration: 0.75)]), withKey: "fadeMedal")
        nodes["goldMedal"] = goldMedal
        
        let silverMedal = SKSpriteNode(texture: textures[5])
        silverMedal.position = convertToSize(point: CGPoint(x: 1638.5, y: 88.0 - 160))
        silverMedal.size = convertTheSize(size: CGSize(width: 100, height: 100))
        silverMedal.zPosition = 2
        addChild(silverMedal)
        silverMedal.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1638.5, y: 88.0)), duration: 0.75))
        silverMedal.run(SKAction.sequence([SKAction.wait(forDuration: 125.75), SKAction.move(to: convertToSize(point: CGPoint(x: 1484.0, y: 88.0 - 160)), duration: 0.75)]), withKey: "fadeMedal")
        nodes["silverMedal"] = silverMedal
        
        let bronzeMedal = SKSpriteNode(texture: textures[6])
        bronzeMedal.position = convertToSize(point: CGPoint(x: 1795.0, y: 88.0 - 160))
        bronzeMedal.size = convertTheSize(size: CGSize(width: 100, height: 100))
        bronzeMedal.zPosition = 2
        addChild(bronzeMedal)
        bronzeMedal.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1795.0, y: 88.0)), duration: 0.75))
        bronzeMedal.run(SKAction.sequence([SKAction.wait(forDuration: 150.75), SKAction.move(to: convertToSize(point: CGPoint(x: 1484.0, y: 88.0 - 160)), duration: 0.75)]), withKey: "fadeMedal")
        nodes["bronzeMedal"] = bronzeMedal
        
        
        
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
        
        let timer = Timer(time: 150, spriteSize: convertTheSize(size: CGSize(width: 167, height: 167)))
        timer.position = convertToSize(point: CGPoint(x: 282 - 1241, y: 730))
        timer.zPosition = 3
        addChild(timer)
        timer.run(SKAction.move(to: convertToSize(point: CGPoint(x: 282, y: 730)), duration: 0.75))
        timer.runTimer(150)
        nodes["timer"] = timer
        
        let coin = SKSpriteNode(texture: textures[7])
        coin.position = convertToSize(point: CGPoint(x: 267.5, y: 66 - 90))
        coin.size = convertTheSize(size: CGSize(width: 80, height: 80))
        coin.zPosition = 3
        addChild(coin)
        coin.run(SKAction.move(to: convertToSize(point: CGPoint(x: 267.5, y: 66)), duration: 1))
        nodes["coin"] = coin
        
        
        let coinLabel = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "500", size: NSString(string: "500").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 140)!]), multipleLine: false, fontSize: 134)), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 170, height: 85)))
        coinLabel.zPosition = 3
        coinLabel.position = convertToSize(point: CGPoint(x: 125, y: 66 - 90))
        addChild(coinLabel)
        coinLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 125, y: 66)), duration: 1))
        nodes["coinLabel"] = coinLabel
        
        let coinAction = SKAction.run{
            self.coins -= 1
            coinLabel.texture = SKTexture(image: ImageFromText(text: "\(self.coins)", size: NSString(string: "1000").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 140)!]), multipleLine: false, fontSize: 134))
            
            
        }
        let delay = SKAction.wait(forDuration: 0.3)
        let comboAction = SKAction.sequence([coinAction,delay])
        let repeatAction = SKAction.repeat(comboAction, count: 500)
        coinLabel.run(SKAction.sequence([SKAction.wait(forDuration: 1), repeatAction]), withKey: "coins")
        
        let questionsLeft = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "0/10", size: NSString(string: "0/10").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 140)!]), multipleLine: false, fontSize: 134)), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 170, height: 85)))
        questionsLeft.zPosition = 2
        questionsLeft.position = convertToSize(point: CGPoint(x: 954.5, y: 71.5 - 90))
        addChild(questionsLeft)
        questionsLeft.run(SKAction.move(to: convertToSize(point: CGPoint(x: 954.5, y: 71.5)), duration: 1))
        nodes["questionsLeft"] = questionsLeft
        
    }
    
    fileprivate func changeQuestion(){
        
        if !isEnd{
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
            image?.texture = SKTexture(imageNamed: question["imagePath"]!)
        }
        let delay = SKAction.wait(forDuration: 0)
        
        
        mainFrame?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 612 - 1241, y: 505)), duration: 0.5), delay, SKAction.move(to: convertToSize(point: CGPoint(x: 612, y: 505)), duration: 0.75)]))
        imageFrame?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 282 - 1241, y: 397)), duration: 0.5), delay, SKAction.move(to: convertToSize(point: CGPoint(x: 282, y: 397)), duration: 0.75)]))
        image?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 282 - 1241, y: 397)), duration: 0.5), delay, changeImageAction, SKAction.move(to: convertToSize(point: CGPoint(x: 282, y: 397)), duration: 0.75)]))
        timer?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 282 - 1241, y: 730)), duration: 0.5), delay, SKAction.move(to: convertToSize(point: CGPoint(x: 282, y: 730)), duration: 0.75)]))
        quest?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 863 - 1241, y: 500)), duration: 0.5), delay, changeQuestionAction, SKAction.move(to: convertToSize(point: CGPoint(x: 863, y: 500)), duration: 0.75)]))
        firstButton?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 1565 + 716, y: 270)), duration: 0.5), delay, changeFirstAnswerAction, SKAction.move(to: convertToSize(point: CGPoint(x: 1565, y: 270)), duration: 0.75)]))
        secondButton?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 1565 + 716, y: 505)), duration: 0.5), delay, changeSecondAnswerAction, SKAction.move(to: convertToSize(point: CGPoint(x: 1565, y: 505)), duration: 0.75)]))
        thirdButton?.run(SKAction.sequence([SKAction.move(to: convertToSize(point: CGPoint(x: 1565 + 716, y: 740)), duration: 0.5), delay, changeThirdAnswerAction, SKAction.move(to: convertToSize(point: CGPoint(x: 1565, y: 740)), duration: 0.75)]))
            
        }
                self.isAnswered = false
    }
    
    fileprivate func showRightAnswer(){
        self.isAnswered = true
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
    
    fileprivate func addScore(){
        answers += 1
        let questionsLeft = nodes["questionsLeft"] as? SKSpriteNode
        questionsLeft?.texture = SKTexture(image: ImageFromText(text: "\(answers)/10", size: NSString(string: "\(answers)/10").size(attributes: [NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 140)!]), multipleLine: false, fontSize: 134))
        
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location =  touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let nodeName = touchedNode.name{
                switch nodeName{
                case "0Button":
                    firstTouchedNode = touchedNode
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                    let touchedAnswerNode = touchedNode as! AnswerButton
                    touchedAnswerNode.tapped()
                case "1Button":
                    firstTouchedNode = touchedNode
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                    let touchedAnswerNode = touchedNode as! AnswerButton
                    touchedAnswerNode.tapped()
                case "2Button":
                    firstTouchedNode = touchedNode
                    touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                    let touchedAnswerNode = touchedNode as! AnswerButton
                    touchedAnswerNode.tapped()
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
                    touchedNode.run(SKAction.scale(to: 1, duration: 0.1), completion: {
                    let touchedNodes = self.nodes(at: location)
                    for node in touchedNodes{
                        if let nodeName = node.name{
                            switch nodeName{
                                
                                
                            case "back":
                                let skView = self.view as SKView!
                                let sizeRect = UIScreen.main.bounds
                                let width = sizeRect.size.width * UIScreen.main.scale
                                let height = sizeRect.size.height * UIScreen.main.scale
                                let scene = SinglePlayLevelSelector(size: CGSize(width: width, height: height))
                                self.adDelegate?.menuBacgroundMusic()
                                scene.adDelegate = self.adDelegate
                                skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                            case "repeatButton":
                                let popTime = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * 0.1)) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: popTime){
                                let skView = self.view as SKView!
                                let sizeRect = UIScreen.main.bounds
                                let width = sizeRect.size.width * UIScreen.main.scale
                                let height = sizeRect.size.height * UIScreen.main.scale
                                let scene = SingleGameScene(size: CGSize(width: width, height: height), category: self.category)
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
                                        self.addScore()
                                        print("Правильно!")
                                        self.run(SKAction.playSoundFileNamed("RIGHT ANSWER.mp3", waitForCompletion: false))
                                        
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
                                        print("Неправильно")
                                        self.run(SKAction.playSoundFileNamed("wrongAnswer.wav", waitForCompletion: false))
                                        let answerAction = SKAction.run{
                                            self.showRightAnswer()
                                        }
                                        let action = SKAction.run{
                                            self.changeQuestion()
                                        }
                                        let delay = SKAction.wait(forDuration: 1.95)
                                        self.run(SKAction.sequence([answerAction, delay, action]))
                                    }
                                }
                                
                                
                            case "1Button":
                                if !self.isAnswered{
                                    let answerButton = touchedNode as? AnswerButton
                                    answerButton?.untapped()
                                    let question = self.questions.first
                                    let rightAnswer = question!["rightAnswer"]
                                    if answerButton?.answer == rightAnswer {
                                        
                                        self.addScore()
                                        print("Правильно!")
                                        self.run(SKAction.playSoundFileNamed("RIGHT ANSWER.mp3", waitForCompletion: false))
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
                                        print("Неправильно")
                                        self.run(SKAction.playSoundFileNamed("wrongAnswer.wav", waitForCompletion: false))
                                        
                                        let answerAction = SKAction.run{
                                            self.showRightAnswer()
                                        }
                                        let action = SKAction.run{
                                            self.changeQuestion()
                                        }
                                        let delay = SKAction.wait(forDuration: 1.95)
                                        self.run(SKAction.sequence([answerAction, delay, action]))
                                    }
                                }
                                
                            case "2Button":
                                if !self.isAnswered{
                                    let answerButton = touchedNode as? AnswerButton
                                    answerButton?.untapped()
                                    let question = self.questions.first
                                    let rightAnswer = question!["rightAnswer"]
                                    if answerButton?.answer == rightAnswer {
                                        
                                        self.addScore()
                                        print("Правильно!")
                                        self.run(SKAction.playSoundFileNamed("RIGHT ANSWER.mp3", waitForCompletion: false))
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
                                        
                                        print("Неправильно")
                                        self.run(SKAction.playSoundFileNamed("wrongAnswer.wav", waitForCompletion: false))
                                        let answerAction = SKAction.run{
                                            self.showRightAnswer()
                                        }
                                        let action = SKAction.run{
                                            self.changeQuestion()
                                        }
                                        let delay = SKAction.wait(forDuration: 1.95)
                                        self.run(SKAction.sequence([answerAction, delay, action]))
                                    }
                                }
                            case "Facebook":
                                let cat = self.category.replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
                                self.createFacebookPost(.arcade, score: self.score, category: cat)
                            case "Twitter":
                                let cat = self.category.replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
                                self.creatTwitterTweet(.arcade, score: self.score, category: cat)
                            case "Game Center":
                                let timer = self.nodes["timer"] as? Timer
                                self.adDelegate?.singleGameCenter(Int(timer!.currentTime))
                                break
                                
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
        if !isEnd && coins == 0 {
            isEnd = true
            
            let mainFrame = nodes["mainFrame"] as? SKSpriteNode
            let imageFrame = nodes["imageFrame"] as? SKSpriteNode
            let image = nodes["image"] as? SKSpriteNode
            let timer = nodes["timer"] as? Timer
            let quest = nodes["question"] as? SKSpriteNode
            let firstButton = nodes["0answer"] as? AnswerButton
            let secondButton = nodes["1answer"] as? AnswerButton
            let thirdButton = nodes["2answer"] as? AnswerButton
            let goldMedal = nodes["goldMedal"] as? SKSpriteNode
            let silverMedal = nodes["silverMedal"] as? SKSpriteNode
            let bronzeMedal = nodes["bronzeMedal"] as? SKSpriteNode
            let coin = nodes["coin"] as? SKSpriteNode
            let coinLabel = nodes["coinLabel"] as? SKSpriteNode
            let questionsLeft = nodes["questionsLeft"] as? SKSpriteNode
            let backButton = nodes["backButton"] as? SKSpriteNode
            
            let popTime = DispatchTime.now() + Double(Int64(NSEC_PER_SEC) * Int64(2)) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: popTime){
                mainFrame?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 612 - 1241, y: 505)), duration: 0.75))
                imageFrame?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 282 - 1241, y: 397)), duration: 0.75))
                image?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 282 - 1241, y: 397)), duration: 0.75))
                timer?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 282 - 1241, y: 730)), duration: 0.75))
                quest?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 863 - 1241, y: 500)), duration: 0.75))
                firstButton?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1565 + 716, y: 270)), duration: 0.75))
                secondButton?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1565 + 716, y: 235 * 1 + 270)), duration: 0.75))
                thirdButton?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1565 + 716, y: 235 * 2 + 270)), duration: 0.75))
                goldMedal?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1484.0, y: 88.0 - 160)), duration: 0.75))
                silverMedal?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1638.5, y: 88.0 - 160)), duration: 0.75))
                bronzeMedal?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1795.0, y: 88.0 - 160)), duration: 0.75))
                coin?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 267.5, y: 66 - 110)), duration: 0.75))
                coinLabel?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 125, y: 66 - 90)), duration: 0.75))
                questionsLeft?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 954.5, y: 71.5 - 90)), duration: 0.75))
                backButton?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 148 - 266, y: 956)), duration: 0.75))
                let popTimeForScore = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * 0.75)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: popTimeForScore){
                    self.failedEnd()
                }
            }
            
        }
        if !isEnd && answers == 10 {
            isEnd = true
            
            let mainFrame = nodes["mainFrame"] as? SKSpriteNode
            let imageFrame = nodes["imageFrame"] as? SKSpriteNode
            let image = nodes["image"] as? SKSpriteNode
            let timer = nodes["timer"] as? Timer
            let quest = nodes["question"] as? SKSpriteNode
            let firstButton = nodes["0answer"] as? AnswerButton
            let secondButton = nodes["1answer"] as? AnswerButton
            let thirdButton = nodes["2answer"] as? AnswerButton
            let goldMedal = nodes["goldMedal"] as? SKSpriteNode
            let silverMedal = nodes["silverMedal"] as? SKSpriteNode
            let bronzeMedal = nodes["bronzeMedal"] as? SKSpriteNode
            let coin = nodes["coin"] as? SKSpriteNode
            let coinLabel = nodes["coinLabel"] as? SKSpriteNode
            let questionsLeft = nodes["questionsLeft"] as? SKSpriteNode
            let backButton = nodes["backButton"] as? SKSpriteNode
            
            let popTime = DispatchTime.now() + Double(Int64(NSEC_PER_SEC) * Int64(2)) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: popTime){
                mainFrame?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 612 - 1241, y: 505)), duration: 0.75))
                imageFrame?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 282 - 1241, y: 397)), duration: 0.75))
                image?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 282 - 1241, y: 397)), duration: 0.75))
                timer?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 282 - 1241, y: 730)), duration: 0.75))
                quest?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 863 - 1241, y: 500)), duration: 0.75))
                firstButton?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1565 + 716, y: 270)), duration: 0.75))
                secondButton?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1565 + 716, y: 235 * 1 + 270)), duration: 0.75))
                thirdButton?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1565 + 716, y: 235 * 2 + 270)), duration: 0.75))
                goldMedal?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1484.0, y: 88.0 - 160)), duration: 0.75))
                silverMedal?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1638.5, y: 88.0 - 160)), duration: 0.75))
                bronzeMedal?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1795.0, y: 88.0 - 160)), duration: 0.75))
                coin?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 267.5, y: 66 - 110)), duration: 0.75))
                coinLabel?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 125, y: 66 - 90)), duration: 0.75))
                questionsLeft?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 954.5, y: 71.5 - 90)), duration: 0.75))
                backButton?.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 148 - 266, y: 956)), duration: 0.75))
                
                timer?.stopTimer()
                
                if timer?.currentTime > 35 {
                    let popTimeForScore = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * 0.75)) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: popTimeForScore){
                        self.excellentEnd()
                        self.save("gold_medal")
                        
                        
                    }
                }
                
                else if timer?.currentTime > 25 {
                    let popTimeForScore = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * 0.75)) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: popTimeForScore){
                        self.wellDoneEnd()
                        self.save("silver_medal")

                        
                    }
                }
                
                else if timer?.currentTime > 0{
                    let popTimeForScore = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * 0.75)) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: popTimeForScore){
                        self.notBadEnd()
                        self.save("bronze_medal")
                        
                        
                    }
                }else{
                    let popTimeForScore = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * 0.75)) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: popTimeForScore){
                        self.failedEnd()
                    }
                }
                

            }
            
            
            
            
        }
    }
    
    fileprivate func excellentEnd(){
        
        
        
        socialButtons()
        
        
        let leftFrame = SKSpriteNode(texture: textures[8])
        leftFrame.size = self.convertTheSize(size: CGSize(width: 761.5, height: 897))
        leftFrame.position = self.convertToSize(point: CGPoint(x: -380.75, y: 459.0))
        leftFrame.zPosition = 2
        self.addChild(leftFrame)
        if self.frame.width == 960{
            leftFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 563, y: 459)), duration: 0.75))
        }else{
            leftFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 575, y: 459)), duration: 0.75))
        }
        
        let rightFrame = SKSpriteNode(texture: textures[9])
        rightFrame.size = self.convertTheSize(size: CGSize(width: 761.5, height: 897))
        rightFrame.position = self.convertToSize(point: CGPoint(x: 2300.75, y: 459.0))
        rightFrame.zPosition = 2
        self.addChild(rightFrame)
        if self.frame.width == 960{
            rightFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1347.25, y: 459)), duration: 0.75))
        }else{
            rightFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1335.25, y: 459)), duration: 0.75))
        }
        
        
        let levelEndLabel = SKSpriteNode(texture: textures[10])
        levelEndLabel.size = convertTheSize(size: levelEndLabel.texture!.size())
        levelEndLabel.position = convertToSize(point: CGPoint(x: -224, y: 97))
        levelEndLabel.zPosition = 3
        addChild(levelEndLabel)
        levelEndLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 500, y: 97)), duration: 0.75))
        
        let bestTimeLabel = SKSpriteNode(texture: textures[11])
        bestTimeLabel.size = convertTheSize(size: bestTimeLabel.texture!.size())
        bestTimeLabel.position = convertToSize(point: CGPoint(x: 2052.5, y: 113))
        bestTimeLabel.zPosition = 3
        addChild(bestTimeLabel)
        if rusVersion {
            bestTimeLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1188, y: 113)), duration: 0.75))
        }else{
            
        bestTimeLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1228, y: 113)), duration: 0.75))
        
        }
        let yourTimeLabel = SKSpriteNode(texture: textures[12])
        yourTimeLabel.position = convertToSize(point: CGPoint(x: -150, y: 425))
        yourTimeLabel.size = convertTheSize(size: yourTimeLabel.texture!.size())
        yourTimeLabel.zPosition = 3
        addChild(yourTimeLabel)
        yourTimeLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 410, y: 425)), duration: 0.75))
        
        let medalBonus = SKSpriteNode(texture: textures[13])
        medalBonus.size = convertTheSize(size: medalBonus.texture!.size())
        medalBonus.position = convertToSize(point: CGPoint(x: -144, y: 612))
        medalBonus.zPosition = 3
        addChild(medalBonus)
        medalBonus.run(SKAction.move(to: convertToSize(point: CGPoint(x: 412, y: 612)), duration: 0.75))
        
        let totalCoins = SKSpriteNode(texture: textures[14])
        totalCoins.size = convertTheSize(size: totalCoins.texture!.size())
        totalCoins.position = convertToSize(point: CGPoint(x: -148.5, y: 770))
        totalCoins.zPosition = 3
        addChild(totalCoins)
        totalCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 414, y: 770)), duration: 0.75))
        
        let coinsLabel = SKSpriteNode(texture: textures[15])
        coinsLabel.size = convertTheSize(size: coinsLabel.texture!.size())
        coinsLabel.position = convertToSize(point: CGPoint(x: 1997, y: 290))
        coinsLabel.zPosition = 3
        addChild(coinsLabel)
        coinsLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1392, y: 290)), duration: 0.75))
        
        let menuButton = SKSpriteNode(texture: textures[16])
        menuButton.name = "back"
        menuButton.size = convertTheSize(size: CGSize(width: 167, height: 167))
        menuButton.position = convertToSize(point: CGPoint(x: 653, y: 1163.5))
        menuButton.zPosition = 2
        addChild(menuButton)
        menuButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 653, y: 1000)), duration: 0.75))
        
        let repeatButton = SKSpriteNode(texture: textures[17])
        repeatButton.name = "repeatButton"
        repeatButton.position = convertToSize(point: CGPoint(x: 960, y: 1163.5))
        repeatButton.size = convertTheSize(size: CGSize(width: 167, height: 167))
        repeatButton.zPosition = 2
        addChild(repeatButton)
        repeatButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 960, y: 1000)), duration: 0.75))
        
        let nextLevelButton = SKSpriteNode(texture: textures[18])
        nextLevelButton.name = "nextLevelButton"
        nextLevelButton.position = convertToSize(point: CGPoint(x: 1267, y: 1163.5))
        nextLevelButton.size = convertTheSize(size: CGSize(width: 167, height: 167))
        nextLevelButton.zPosition = 2
        addChild(nextLevelButton)
        nextLevelButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1267, y: 1000)), duration: 0.75))
        
        
        let timer = nodes["timer"] as? Timer
        let sec = "sec"
        let yourTime = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(Int((timer?.currentTime)!)) " + sec , size: CGSize(width: 300, height: 120), multipleLine: false, fontSize: self.convertFontSize(72))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        yourTime.position = convertToSize(point: CGPoint(x: -150, y: 420))
        yourTime.zPosition = 3
        addChild(yourTime)
        yourTime.run(SKAction.move(to: convertToSize(point: CGPoint(x: 817, y: 420)), duration: 0.75))
        
        let yourTimeCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(coins: self.coins, size: CGSize(width: 300, height: 120))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        yourTimeCoins.position = convertToSize(point: CGPoint(x: 2070, y: 420))
        yourTimeCoins.zPosition = 3
        addChild(yourTimeCoins)
        yourTimeCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1366, y: 420)), duration: 0.75))
        
        
        let medalBonusCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(coins: 200, size: CGSize(width: 300, height: 120))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        medalBonusCoins.position = convertToSize(point: CGPoint(x: 2070, y: 612))
        medalBonusCoins.zPosition = 3
        addChild(medalBonusCoins)
        medalBonusCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1366, y: 612)), duration: 0.75))
        
        let totalCoinsCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(coins: 200 + self.coins, size: CGSize(width: 300, height: 120))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        totalCoinsCoins.position = convertToSize(point: CGPoint(x: 2070, y: 770))
        totalCoinsCoins.zPosition = 3
        addChild(totalCoinsCoins)
        totalCoinsCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1366, y: 770)), duration: 0.75))
        
        let userDefaults = UserDefaults.standard
        let theBestTime = userDefaults.integer(forKey: "bestTime")
        if Int((timer?.currentTime)!) > theBestTime{
            let bestTime = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(Int((timer?.currentTime)!)) " + sec , size: CGSize(width: 300, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
            bestTime.position = convertToSize(point: CGPoint(x: 2070, y: 113))
            bestTime.zPosition = 3
            addChild(bestTime)
            bestTime.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1543, y: 113)), duration: 0.75))
            userDefaults.set(Int((timer?.currentTime)!), forKey: "bestTime")
            self.score = theBestTime
        }
        else{
            let bestTime = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(theBestTime) " + sec , size: CGSize(width: 300, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
            bestTime.position = convertToSize(point: CGPoint(x: 2070, y: 113))
            bestTime.zPosition = 3
            addChild(bestTime)
            bestTime.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1543, y: 113)), duration: 0.75))
            self.score = theBestTime
        }
        
        userDefaults.set( userDefaults.integer(forKey: "coins") + self.coins + 200, forKey: "coins")

    }

    fileprivate func wellDoneEnd(){
        
        
        socialButtons()
        
        let leftFrame = SKSpriteNode(texture: textures[8])
        leftFrame.size = self.convertTheSize(size: CGSize(width: 761.5, height: 897))
        leftFrame.position = self.convertToSize(point: CGPoint(x: -380.75, y: 459.0))
        leftFrame.zPosition = 2
        self.addChild(leftFrame)
        if self.frame.width == 960{
            leftFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 563, y: 459)), duration: 0.75))
        }else{
            leftFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 575, y: 459)), duration: 0.75))
        }
        
        let rightFrame = SKSpriteNode(texture: textures[9])
        rightFrame.size = self.convertTheSize(size: CGSize(width: 761.5, height: 897))
        rightFrame.position = self.convertToSize(point: CGPoint(x: 2300.75, y: 459.0))
        rightFrame.zPosition = 2
        self.addChild(rightFrame)
        if self.frame.width == 960{
            rightFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1347.25, y: 459)), duration: 0.75))
        }else{
            rightFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1335.25, y: 459)), duration: 0.75))
        }
        
        if self.rusVersion {
            let levelEndLabel = SKSpriteNode(texture: textures[19])
            levelEndLabel.size = convertTheSize(size: levelEndLabel.texture!.size())
            levelEndLabel.position = convertToSize(point: CGPoint(x: -224, y: 97))
            levelEndLabel.zPosition = 3
            addChild(levelEndLabel)
            levelEndLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 500, y: 147)), duration: 0.75))
            
        }else{
        
            let levelEndLabel = SKSpriteNode(texture: textures[19])
            levelEndLabel.size = convertTheSize(size: levelEndLabel.texture!.size())
            levelEndLabel.position = convertToSize(point: CGPoint(x: -224, y: 97))
            levelEndLabel.zPosition = 3
            addChild(levelEndLabel)
            levelEndLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 500, y: 97)), duration: 0.75))
            
        }
        
        let bestTimeLabel = SKSpriteNode(texture: textures[11])
        bestTimeLabel.size = convertTheSize(size: bestTimeLabel.texture!.size())
        bestTimeLabel.position = convertToSize(point: CGPoint(x: 2052.5, y: 55))
        bestTimeLabel.zPosition = 3
        addChild(bestTimeLabel)
        if rusVersion {
            bestTimeLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1188, y: 113)), duration: 0.75))
        }else{
            
            bestTimeLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1228, y: 113)), duration: 0.75))
            
        }
        
        let yourTimeLabel = SKSpriteNode(texture: textures[12])
        yourTimeLabel.position = convertToSize(point: CGPoint(x: -150, y: 425))
        yourTimeLabel.size = convertTheSize(size: yourTimeLabel.texture!.size())
        yourTimeLabel.zPosition = 3
        addChild(yourTimeLabel)
        yourTimeLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 410, y: 425)), duration: 0.75))
        
        let medalBonus = SKSpriteNode(texture: textures[13])
        medalBonus.size = convertTheSize(size: medalBonus.texture!.size())
        medalBonus.position = convertToSize(point: CGPoint(x: -144, y: 612))
        medalBonus.zPosition = 3
        addChild(medalBonus)
        medalBonus.run(SKAction.move(to: convertToSize(point: CGPoint(x: 412, y: 612)), duration: 0.75))
        
        let totalCoins = SKSpriteNode(texture: textures[14])
        totalCoins.size = convertTheSize(size: totalCoins.texture!.size())
        totalCoins.position = convertToSize(point: CGPoint(x: -148.5, y: 770))
        totalCoins.zPosition = 3
        addChild(totalCoins)
        totalCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 414, y: 770)), duration: 0.75))
        
        let coinsLabel = SKSpriteNode(texture: textures[15])
        coinsLabel.size = convertTheSize(size: coinsLabel.texture!.size())
        coinsLabel.position = convertToSize(point: CGPoint(x: 1997, y: 290))
        coinsLabel.zPosition = 3
        addChild(coinsLabel)
        coinsLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1392, y: 290)), duration: 0.75))
        
        let menuButton = SKSpriteNode(texture: textures[16])
        menuButton.name = "back"
        menuButton.size = convertTheSize(size: CGSize(width: 167, height: 167))
        menuButton.position = convertToSize(point: CGPoint(x: 653, y: 1163.5))
        menuButton.zPosition = 2
        addChild(menuButton)
        menuButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 653, y: 1000)), duration: 0.75))
        
        let repeatButton = SKSpriteNode(texture: textures[17])
        repeatButton.name = "repeatButton"
        repeatButton.position = convertToSize(point: CGPoint(x: 960, y: 1163.5))
        repeatButton.size = convertTheSize(size: CGSize(width: 167, height: 167))
        repeatButton.zPosition = 2
        addChild(repeatButton)
        repeatButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 960, y: 1000)), duration: 0.75))
        
        let nextLevelButton = SKSpriteNode(texture: textures[18])
        nextLevelButton.name = "nextLevelButton"
        nextLevelButton.position = convertToSize(point: CGPoint(x: 1267, y: 1163.5))
        nextLevelButton.size = convertTheSize(size: CGSize(width: 167, height: 167))
        nextLevelButton.zPosition = 2
        addChild(nextLevelButton)
        nextLevelButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1267, y: 1000)), duration: 0.75))
        
        let timer = nodes["timer"] as? Timer
        let sec = "sec"
        let yourTime = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(Int((timer?.currentTime)!)) " + sec , size: CGSize(width: 300, height: 120), multipleLine: false, fontSize: self.convertFontSize(72))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        yourTime.position = convertToSize(point: CGPoint(x: -150, y: 420))
        yourTime.zPosition = 3
        addChild(yourTime)
        yourTime.run(SKAction.move(to: convertToSize(point: CGPoint(x: 817, y: 420)), duration: 0.75))
        let yourTimeCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(coins: self.coins, size: CGSize(width: 300, height: 120))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        yourTimeCoins.position = convertToSize(point: CGPoint(x: 2070, y: 420))
        yourTimeCoins.zPosition = 3
        addChild(yourTimeCoins)
        yourTimeCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1366, y: 420)), duration: 0.75))
        
        
        let medalBonusCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(coins: 100, size: CGSize(width: 300, height: 120))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        medalBonusCoins.position = convertToSize(point: CGPoint(x: 2070, y: 612))
        medalBonusCoins.zPosition = 3
        addChild(medalBonusCoins)
        medalBonusCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1366, y: 612)), duration: 0.75))
        
        let totalCoinsCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(coins: 100 + self.coins, size: CGSize(width: 300, height: 120))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        totalCoinsCoins.position = convertToSize(point: CGPoint(x: 2070, y: 770))
        totalCoinsCoins.zPosition = 3
        addChild(totalCoinsCoins)
        totalCoinsCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1366, y: 770)), duration: 0.75))
        
        
        let userDefaults = UserDefaults.standard
        let theBestTime = userDefaults.integer(forKey: "bestTime")
        if Int((timer?.currentTime)!) > theBestTime{
            let bestTime = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(Int((timer?.currentTime)!)) " + sec , size: CGSize(width: 300, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
            bestTime.position = convertToSize(point: CGPoint(x: 2070, y: 113))
            bestTime.zPosition = 3
            addChild(bestTime)
            bestTime.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1543, y: 113)), duration: 0.75))
            userDefaults.set(Int((timer?.currentTime)!), forKey: "bestTime")
            self.score = theBestTime
        }
        else{
            let bestTime = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(theBestTime) " + sec , size: CGSize(width: 300, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
            bestTime.position = convertToSize(point: CGPoint(x: 2070, y: 113))
            bestTime.zPosition = 3
            addChild(bestTime)
            bestTime.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1543, y: 113)), duration: 0.75))
            self.score = theBestTime
        }
        userDefaults.set( userDefaults.integer(forKey: "coins") + self.coins + 100, forKey: "coins")
    }
    
    fileprivate func notBadEnd(){
        
        
        socialButtons()
        
        
        let leftFrame = SKSpriteNode(texture: textures[8])
        leftFrame.size = self.convertTheSize(size: CGSize(width: 761.5, height: 897))
        leftFrame.position = self.convertToSize(point: CGPoint(x: -380.75, y: 459.0))
        leftFrame.zPosition = 2
        self.addChild(leftFrame)
        if self.frame.width == 960{
            leftFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 563, y: 459)), duration: 0.75))
        }else{
            leftFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 575, y: 459)), duration: 0.75))
        }
        
        let rightFrame = SKSpriteNode(texture: textures[9])
        rightFrame.size = self.convertTheSize(size: CGSize(width: 761.5, height: 897))
        rightFrame.position = self.convertToSize(point: CGPoint(x: 2300.75, y: 459.0))
        rightFrame.zPosition = 2
        self.addChild(rightFrame)
        if self.frame.width == 960{
            rightFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1347.25, y: 459)), duration: 0.75))
        }else{
            rightFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1335.25, y: 459)), duration: 0.75))
        }
        
        
        let levelEndLabel = SKSpriteNode(texture: textures[20])
        levelEndLabel.size = convertTheSize(size: levelEndLabel.texture!.size())
        levelEndLabel.position = convertToSize(point: CGPoint(x: -224, y: 97))
        levelEndLabel.zPosition = 3
        addChild(levelEndLabel)
        levelEndLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 500, y: 97)), duration: 0.75))
        
        let bestTimeLabel = SKSpriteNode(texture: textures[11])
        bestTimeLabel.size = convertTheSize(size: bestTimeLabel.texture!.size())
        bestTimeLabel.position = convertToSize(point: CGPoint(x: 2052.5, y: 55))
        bestTimeLabel.zPosition = 3
        addChild(bestTimeLabel)
        if rusVersion {
            bestTimeLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1188, y: 113)), duration: 0.75))
        }else{
            
            bestTimeLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1228, y: 113)), duration: 0.75))
            
        }
        
        let yourTimeLabel = SKSpriteNode(texture: textures[12])
        yourTimeLabel.position = convertToSize(point: CGPoint(x: -150, y: 425))
        yourTimeLabel.size = convertTheSize(size: yourTimeLabel.texture!.size())
        yourTimeLabel.zPosition = 3
        addChild(yourTimeLabel)
        yourTimeLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 410, y: 425)), duration: 0.75))
        
        let medalBonus = SKSpriteNode(texture: textures[13])
        medalBonus.size = convertTheSize(size: medalBonus.texture!.size())
        medalBonus.position = convertToSize(point: CGPoint(x: -144, y: 612))
        medalBonus.zPosition = 3
        addChild(medalBonus)
        medalBonus.run(SKAction.move(to: convertToSize(point: CGPoint(x: 412, y: 612)), duration: 0.75))
        
        let totalCoins = SKSpriteNode(texture: textures[14])
        totalCoins.size = convertTheSize(size: totalCoins.texture!.size())
        totalCoins.position = convertToSize(point: CGPoint(x: -148.5, y: 770))
        totalCoins.zPosition = 3
        addChild(totalCoins)
        totalCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 414, y: 770)), duration: 0.75))
        
        let coinsLabel = SKSpriteNode(texture: textures[15])
        coinsLabel.size = convertTheSize(size: coinsLabel.texture!.size())
        coinsLabel.position = convertToSize(point: CGPoint(x: 1997, y: 290))
        coinsLabel.zPosition = 3
        addChild(coinsLabel)
        coinsLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1392, y: 290)), duration: 0.75))
        
        let menuButton = SKSpriteNode(texture: textures[16])
        menuButton.name = "back"
        menuButton.size = convertTheSize(size: CGSize(width: 167, height: 167))
        menuButton.position = convertToSize(point: CGPoint(x: 653, y: 1163.5))
        menuButton.zPosition = 2
        addChild(menuButton)
        menuButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 653, y: 1000)), duration: 0.75))
        
        let repeatButton = SKSpriteNode(texture: textures[17])
        repeatButton.name = "repeatButton"
        repeatButton.position = convertToSize(point: CGPoint(x: 960, y: 1163.5))
        repeatButton.size = convertTheSize(size: CGSize(width: 167, height: 167))
        repeatButton.zPosition = 2
        addChild(repeatButton)
        repeatButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 960, y: 1000)), duration: 0.75))
        
        let nextLevelButton = SKSpriteNode(texture: textures[18])
        nextLevelButton.name = "nextLevelButton"
        nextLevelButton.position = convertToSize(point: CGPoint(x: 1267, y: 1163.5))
        nextLevelButton.size = convertTheSize(size: CGSize(width: 167, height: 167))
        nextLevelButton.zPosition = 2
        addChild(nextLevelButton)
        nextLevelButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1267, y: 1000)), duration: 0.75))
        
        let timer = nodes["timer"] as? Timer
        let sec = "sec"
        let yourTime = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(Int((timer?.currentTime)!)) " + sec , size: CGSize(width: 300, height: 120), multipleLine: false, fontSize: self.convertFontSize(72))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        yourTime.position = convertToSize(point: CGPoint(x: -150, y: 420))
        yourTime.zPosition = 3
        addChild(yourTime)
        yourTime.run(SKAction.move(to: convertToSize(point: CGPoint(x: 817, y: 420)), duration: 0.75))
        
        
        let yourTimeCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(coins: self.coins, size: CGSize(width: 300, height: 120))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        yourTimeCoins.position = convertToSize(point: CGPoint(x: 2070, y: 420))
        yourTimeCoins.zPosition = 3
        addChild(yourTimeCoins)
        yourTimeCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1366, y: 420)), duration: 0.75))
        
        
        let medalBonusCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(coins: 50, size: CGSize(width: 300, height: 120))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        medalBonusCoins.position = convertToSize(point: CGPoint(x: 2070, y: 612))
        medalBonusCoins.zPosition = 3
        addChild(medalBonusCoins)
        medalBonusCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1366, y: 612)), duration: 0.75))
        
        let totalCoinsCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(coins: 50 + self.coins, size: CGSize(width: 300, height: 120))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        totalCoinsCoins.position = convertToSize(point: CGPoint(x: 2070, y: 770))
        totalCoinsCoins.zPosition = 3
        addChild(totalCoinsCoins)
        totalCoinsCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1366, y: 770)), duration: 0.75))
        
        
        let userDefaults = UserDefaults.standard
        let theBestTime = userDefaults.integer(forKey: "bestTime")
        if Int((timer?.currentTime)!) > theBestTime{
            let bestTime = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(Int((timer?.currentTime)!)) " + sec , size: CGSize(width: 300, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
            bestTime.position = convertToSize(point: CGPoint(x: 2070, y: 113))
            bestTime.zPosition = 3
            addChild(bestTime)
            bestTime.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1543, y: 113)), duration: 0.75))
            userDefaults.set(Int((timer?.currentTime)!), forKey: "bestTime")
            self.score = theBestTime
        }
        else{
            let bestTime = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(theBestTime) " + sec , size: CGSize(width: 300, height: 120), multipleLine: false, fontSize: 72)), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
            bestTime.position = convertToSize(point: CGPoint(x: 2070, y: 113))
            bestTime.zPosition = 3
            addChild(bestTime)
            bestTime.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1543, y: 113)), duration: 0.75))
            self.score = theBestTime
        }
        userDefaults.set( userDefaults.integer(forKey: "coins") + self.coins + 50, forKey: "coins")
        
        
        
    }
    
    fileprivate func save(_ medal: String){
        do{
            
            let fileManager = FileManager.default
            
            let documentUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let documentLevelsDataUrl = documentUrl.appendingPathComponent("SingleData.json")
            if let documentLevelsData = try? Data(contentsOf: documentLevelsDataUrl){
                
                var json = JSON(data: documentLevelsData)

                let categories = json["Categories"].arrayValue
                
                for (index, category) in categories.enumerated(){
                    if category["category"].stringValue == self.category{
                        switch medal {
                            
                        case "gold_medal":
                            json["Categories"][index]["medal"].stringValue = medal
                            
                            let jsonData = json.description
                            print(jsonData)
                            let fileManager = FileManager.default
                            
                            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                            let file = documentDirectory.appendingPathComponent("SingleData.json")
                            
                            let data = jsonData.data(using: String.Encoding.utf8)
                            try data?.write(to: file, options: .atomic)
                        case "silver_medal":
                            if category["medal"].stringValue != "gold_medal"{
                                json["Categories"][index]["medal"].stringValue = medal
                                
                                let jsonData = json.description
                                print(jsonData)
                                let fileManager = FileManager.default
                                
                                let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                                let file = documentDirectory.appendingPathComponent("SingleData.json")
                                
                                let data = jsonData.data(using: String.Encoding.utf8)
                                try data?.write(to: file, options: .atomic)
                            }
                        case "bronze_medal":
                            if category["medal"].stringValue != "silver_medal" && category["medal"] != "gold_medal"{
                                json["Categories"][index]["medal"].stringValue = medal
                                
                                let jsonData = json.description
                                print(jsonData)
                                let fileManager = FileManager.default
                                
                                let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                                let file = documentDirectory.appendingPathComponent("SingleData.json")
                                
                                let data = jsonData.data(using: String.Encoding.utf8)
                                try data?.write(to: file, options: .atomic)
                            }
                        default:
                            break
                        }
                        
                    }
                }
                

                
            }
            
            else{
            if let levelsDataUrl = Bundle.main.url(forResource: "SingleData", withExtension: "json"){
                let levelsJsonData = try Data(contentsOf: levelsDataUrl, options: .mappedIfSafe)
                var json = JSON(data: levelsJsonData)
                
                let categories = json["Categories"].arrayValue
                
                for (index, category) in categories.enumerated(){
                    if category["category"].stringValue == self.category{
                        switch medal {
                            
                        case "gold_medal":
                            json["Categories"][index]["medal"].stringValue = medal
                        
                            let jsonData = json.description
                            print(jsonData)
                            let fileManager = FileManager.default
                            
                            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                            let file = documentDirectory.appendingPathComponent("SingleData.json")
                            
                            let data = jsonData.data(using: String.Encoding.utf8)
                            try data?.write(to: file, options: .atomic)
                        case "silver_medal":
                            if category["medal"].stringValue != "gold_medal"{
                            json["Categories"][index]["medal"].stringValue = medal
                                
                                let jsonData = json.description
                                print(jsonData)
                                let fileManager = FileManager.default
                                
                                let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                                let file = documentDirectory.appendingPathComponent("SingleData.json")
                                
                                let data = jsonData.data(using: String.Encoding.utf8)
                                try data?.write(to: file, options: .atomic)
                            }
                        case "bronze_medal":
                            if category["medal"].stringValue != "silver_medal" && category["medal"] != "gold_medal"{
                                json["Categories"][index]["medal"].stringValue = medal
                                
                                let jsonData = json.description
                                print(jsonData)
                                let fileManager = FileManager.default
                                
                                let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                                let file = documentDirectory.appendingPathComponent("SingleData.json")
                                
                                let data = jsonData.data(using: String.Encoding.utf8)
                                try data?.write(to: file, options: .atomic)
                            }
                        default:
                            break
                        }
                        
                    }
                }

                
                
            }
            }
        }
        catch let errorPtr as NSError {
                print(errorPtr.localizedDescription)
            }
        

    }
    
    
    fileprivate func failedEnd(){
        
        let leftFrame = SKSpriteNode(texture: textures[8])
        leftFrame.size = self.convertTheSize(size: CGSize(width: 761.5, height: 897))
        leftFrame.position = self.convertToSize(point: CGPoint(x: -380.75, y: 459.0))
        leftFrame.zPosition = 2
        self.addChild(leftFrame)
        if self.frame.width == 960{
            leftFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 563, y: 459)), duration: 0.75))
        }else{
            leftFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 575, y: 459)), duration: 0.75))
        }
        
        let rightFrame = SKSpriteNode(texture: textures[9])
        rightFrame.size = self.convertTheSize(size: CGSize(width: 761.5, height: 897))
        rightFrame.position = self.convertToSize(point: CGPoint(x: 2300.75, y: 459.0))
        rightFrame.zPosition = 2
        self.addChild(rightFrame)
        if self.frame.width == 960{
            rightFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1347.25, y: 459)), duration: 0.75))
        }else{
            rightFrame.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 1335.25, y: 459)), duration: 0.75))
        }
        
        
        let levelEndLabel = SKSpriteNode(texture: textures[21])
        levelEndLabel.size = convertTheSize(size: levelEndLabel.texture!.size())
        levelEndLabel.position = convertToSize(point: CGPoint(x: -224, y: 97))
        levelEndLabel.zPosition = 3
        addChild(levelEndLabel)
        levelEndLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 500, y: 97)), duration: 0.75))
        
        let bestTimeLabel = SKSpriteNode(texture: textures[11])
        bestTimeLabel.size = convertTheSize(size: bestTimeLabel.texture!.size())
        bestTimeLabel.position = convertToSize(point: CGPoint(x: 2052.5, y: 55))
        bestTimeLabel.zPosition = 3
        addChild(bestTimeLabel)
        if rusVersion {
            bestTimeLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1188, y: 113)), duration: 0.75))
        }else{
            
            bestTimeLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1228, y: 113)), duration: 0.75))
            
        }
        
        let yourTimeLabel = SKSpriteNode(texture: textures[12])
        yourTimeLabel.position = convertToSize(point: CGPoint(x: -150, y: 425))
        yourTimeLabel.size = convertTheSize(size: yourTimeLabel.texture!.size())
        yourTimeLabel.zPosition = 3
        addChild(yourTimeLabel)
        yourTimeLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 410, y: 425)), duration: 0.75))
        
        let medalBonus = SKSpriteNode(texture: textures[13])
        medalBonus.size = convertTheSize(size: medalBonus.texture!.size())
        medalBonus.position = convertToSize(point: CGPoint(x: -144, y: 612))
        medalBonus.zPosition = 3
        addChild(medalBonus)
        medalBonus.run(SKAction.move(to: convertToSize(point: CGPoint(x: 412, y: 612)), duration: 0.75))
        
        let totalCoins = SKSpriteNode(texture: textures[14])
        totalCoins.size = convertTheSize(size: totalCoins.texture!.size())
        totalCoins.position = convertToSize(point: CGPoint(x: -148.5, y: 770))
        totalCoins.zPosition = 3
        addChild(totalCoins)
        totalCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 414, y: 770)), duration: 0.75))
        
        let coinsLabel = SKSpriteNode(texture: textures[15])
        coinsLabel.size = convertTheSize(size: coinsLabel.texture!.size())
        coinsLabel.position = convertToSize(point: CGPoint(x: 1997, y: 290))
        coinsLabel.zPosition = 3
        addChild(coinsLabel)
        coinsLabel.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1392, y: 290)), duration: 0.75))
        
        let menuButton = SKSpriteNode(texture: textures[16])
        menuButton.name = "back"
        menuButton.size = convertTheSize(size: CGSize(width: 167, height: 167))
        menuButton.position = convertToSize(point: CGPoint(x: 653, y: 1163.5))
        menuButton.zPosition = 2
        addChild(menuButton)
        menuButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 653, y: 1000)), duration: 0.75))
        
        let repeatButton = SKSpriteNode(texture: textures[17])
        repeatButton.name = "repeatButton"
        repeatButton.position = convertToSize(point: CGPoint(x: 960, y: 1163.5))
        repeatButton.size = convertTheSize(size: CGSize(width: 167, height: 167))
        repeatButton.zPosition = 2
        addChild(repeatButton)
        repeatButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 960, y: 1000)), duration: 0.75))
        
        let nextLevelButton = SKSpriteNode(texture: textures[18])
        nextLevelButton.name = "nextLevelButton"
        nextLevelButton.position = convertToSize(point: CGPoint(x: 1267, y: 1163.5))
        nextLevelButton.size = convertTheSize(size: CGSize(width: 167, height: 167))
        nextLevelButton.zPosition = 2
        addChild(nextLevelButton)
        nextLevelButton.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1267, y: 1000)), duration: 0.75))
        
        let timer = nodes["timer"] as? Timer
        let sec = "sec"
        let yourTime = SKSpriteNode(texture: SKTexture(image: ImageFromText(text: "\(Int((timer?.currentTime)!)) " + sec , size: CGSize(width: 300, height: 120), multipleLine: false, fontSize: self.convertFontSize(72))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        yourTime.position = convertToSize(point: CGPoint(x: -150, y: 420))
        yourTime.zPosition = 3
        addChild(yourTime)
        yourTime.run(SKAction.move(to: convertToSize(point: CGPoint(x: 817, y: 420)), duration: 0.75))
        let yourTimeCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(coins: 0, size: CGSize(width: 300, height: 120))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        yourTimeCoins.position = convertToSize(point: CGPoint(x: 2070, y: 420))
        yourTimeCoins.zPosition = 3
        addChild(yourTimeCoins)
        yourTimeCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1366, y: 420)), duration: 0.75))
        
        
        let medalBonusCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(coins: 0, size: CGSize(width: 300, height: 120))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        medalBonusCoins.position = convertToSize(point: CGPoint(x: 2070, y: 612))
        medalBonusCoins.zPosition = 3
        addChild(medalBonusCoins)
        medalBonusCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1366, y: 612)), duration: 0.75))
        
        let totalCoinsCoins = SKSpriteNode(texture: SKTexture(image: ImageFromText(coins: 0, size: CGSize(width: 300, height: 120))), color: UIColor.clear, size: convertTheSize(size: CGSize(width: 300, height: 120)))
        totalCoinsCoins.position = convertToSize(point: CGPoint(x: 2070, y: 770))
        totalCoinsCoins.zPosition = 3
        addChild(totalCoinsCoins)
        totalCoinsCoins.run(SKAction.move(to: convertToSize(point: CGPoint(x: 1366, y: 770)), duration: 0.75))
    }
    
    fileprivate func socialButtons(){
        
        let facebookLogo = SKSpriteNode(imageNamed: "Facebook")
        facebookLogo.size = self.convertTheSize(size: facebookLogo.texture!.size())
        facebookLogo.position = self.convertToSize(point: CGPoint(x: -100, y: 666))
        facebookLogo.zPosition = 2
        facebookLogo.name = "Facebook"
        self.addChild(facebookLogo)
        facebookLogo.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 100, y: 666)), duration: 0.75))
        
        let twitterLogo = SKSpriteNode(imageNamed: "Twitter")
        twitterLogo.size = self.convertTheSize(size: twitterLogo.texture!.size())
        twitterLogo.position = self.convertToSize(point: CGPoint(x: -100, y: 466))
        twitterLogo.zPosition = 2
        twitterLogo.name = "Twitter"
        self.addChild(twitterLogo)
        twitterLogo.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 100, y: 466)), duration: 0.75))
        
        let gameCenterLogo = SKSpriteNode(imageNamed: "Game Center")
        gameCenterLogo.size = self.convertTheSize(size: gameCenterLogo.texture!.size())
        gameCenterLogo.position = self.convertToSize(point: CGPoint(x: -100, y: 266))
        gameCenterLogo.zPosition = 2
        gameCenterLogo.name = "Game Center"
        self.addChild(gameCenterLogo)
        gameCenterLogo.run(SKAction.move(to: self.convertToSize(point: CGPoint(x: 100, y: 268)), duration: 0.75))
    }
    

    
    
}
