//
//  ShopGameScene.swift
//  Questions boom
//
//  Created by Кирилл on 21.08.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import SpriteKit
import StoreKit

class ShopGameScene: SKScene, UIScrollViewDelegate , SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    
    var productIDs: [String] = []
    
    var productsArray: [SKProduct] = []
    
    var adDelegate: AdProtocol?
    
    let world = SKSpriteNode()
    var scrollView: SpriteScroll!
    fileprivate var contentView: UIView!
    var firstTouchedNode: SKNode?
    var transactionInProgress = false
    
    
    var previousScene: BackScene = .start

    
    
    override func didMove(to view: SKView) {
        
        SKPaymentQueue.default().add(self)
        
        world.zPosition = 2
        addChild(world)
        let a = 2 * 420 + 114 * 14 + 15 * 210
        let s = convertTheSize(size: CGSize(width: a, height: 0))
        world.size = CGSize(width: s.width, height: view.bounds.height)
        world.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        let backgroundImage = SKSpriteNode(imageNamed: "background.jpg")
        backgroundImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backgroundImage.size = CGSize(width: self.frame.width, height: self.frame.height)
        backgroundImage.blendMode = .replace
        addChild(backgroundImage)
        
        let backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.name = "back"
        backButton.position = convertToSize(point: CGPoint(x: 148, y: 956))
        backButton.size = convertTheSize(size: CGSize(width: 235, height: 231))
        backButton.zPosition = 10
        addChild(backButton)
        
        
        let coins = ["Shop_coins","Shop_bag","Shop_bigBag","Shop_chest"]
        
        for (index, coin) in coins.enumerated(){
            let coinSprite = SKSpriteNode(texture: SKTexture(imageNamed: coin))
            coinSprite.size = convertTheSize(size: coinSprite.texture!.size())
            coinSprite.position = convertToSize(point: CGPoint(x: 400 + index * 420, y: 440))
            world.addChild(coinSprite)
        }
        
        let hearts = ["heart_3","heart_7","heart_12","heart_30"]
        
        for (index, heart) in hearts.enumerated(){
            let heartSprite = SKSpriteNode(texture: SKTexture(imageNamed: heart))
            heartSprite.size = convertTheSize(size: heartSprite.texture!.size())
            heartSprite.position = convertToSize(point: CGPoint(x: 400 + (index + 4) * 420, y: 440))
            world.addChild(heartSprite)
        }
        
        let passes = ["pass_12","pass_25","pass_40","pass_100"]
        
        for (index, pass) in passes.enumerated(){
            let passSprite = SKSpriteNode(texture: SKTexture(imageNamed: pass))
            passSprite.size = convertTheSize(size: passSprite.texture!.size())
            passSprite.position = convertToSize(point: CGPoint(x: 400 + (index + 8) * 420, y: 440))
            world.addChild(passSprite)
        }
        
        
        
        let buyForCoins = SKSpriteNode(texture: SKTexture(imageNamed: "heartPass"))
        buyForCoins.position = convertToSize(point: CGPoint(x: 420 + 12 * 420, y: 440))
        buyForCoins.size = convertTheSize(size: buyForCoins.texture!.size())
        world.addChild(buyForCoins)
        
        let restore = SKSpriteNode(texture: SKTexture(imageNamed: NSLocalizedString("RESTORE_PURCHASE",tableName: "LocalizableStrings", comment: "restore")))
        restore.size = convertTheSize(size: restore.texture!.size())
        restore.position = convertToSize(point: CGPoint(x: 420 + 13 * 420, y: 440))
        world.addChild(restore)
        
        
        scrollView = SpriteScroll(frame: self.view!.bounds)
        scrollView.delegate = self
        scrollView.contentSize = self.world.frame.size
        scrollView.delaysContentTouches = false
        view.addSubview(scrollView)
        
        contentView = UIView(frame: CGRect(origin: CGPoint.zero, size: self.world.size))
        print(contentView.frame.size)
        scrollView.addSubview(contentView)
        
        applyScrollViewToSpriteKitMapping()
        self.requestPaymentInfo()
    }
    
    fileprivate  func applyScrollViewToSpriteKitMapping() {
        let origin = contentView.frame.origin
        let skPosition = CGPoint(x: -scrollView.contentOffset.x + origin.x, y: -scrollView.contentSize.height + view!.bounds.height + scrollView.contentOffset.y - origin.y)
        
        
        world.position = skPosition
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
                let touchedNode = atPoint(location)
            print(touchedNode)
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
                        
                    case "levelObject":
                        firstTouchedNode = touchedNode.parent
                        touchedNode.parent!.run((SKAction.scale(to: 0.85, duration: 0.1)))
                        
                    case "product":
                        firstTouchedNode = touchedNode
                        touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                        
                    case "restore":
                        print("rESTORIF")
                        firstTouchedNode = touchedNode
                        touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                        
                    case "productLabel":
                        firstTouchedNode = touchedNode.parent
                        touchedNode.parent!.run((SKAction.scale(to: 0.85, duration: 0.1)))
                        
                    case "restoreLabel":
                        firstTouchedNode = touchedNode.parent
                        touchedNode.parent!.run((SKAction.scale(to: 0.85, duration: 0.1)))
                    case "coinsBuy":
                        firstTouchedNode = touchedNode
                        touchedNode.run(SKAction.scale(to: 0.85, duration: 0.1))
                        
                    default: break
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
                            SKPaymentQueue.default().remove(self)
                            let popTime = DispatchTime.now() + Double(Int64(0.08 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: popTime){
                                let skView = self.view as SKView!
                                let sizeRect = UIScreen.main.bounds
                                let width = sizeRect.size.width * UIScreen.main.scale
                                let height = sizeRect.size.height * UIScreen.main.scale
                                if self.previousScene == .start{
                                    
                                    let scene = StartGameScene(size: CGSize(width: width, height: height))
                                    scene.adDelegate = self.adDelegate
                                    self.scrollView.removeFromSuperview()
                                    skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                                    
                                }else if self.previousScene == .single{
                                    let scene = SinglePlayLevelSelector(size: CGSize(width: width, height: height))
                                    scene.adDelegate = self.adDelegate
                                    self.scrollView.removeFromSuperview()
                                    skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                                }else{
                                    let scene = PlayModeSelect(size: CGSize(width: width, height: height))
                                    scene.adDelegate = self.adDelegate
                                    self.scrollView.removeFromSuperview()
                                    skView?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.85))
                                }

                            }
                            
                        case "product":
                            let product = firstTouchedNode!.userData!["product"] as! SKProduct
                            showBuyWindow(product)
                        case "restore":
                            print("RESTROKJ")
                            if SKPaymentQueue.canMakePayments(){
                                SKPaymentQueue.default().restoreCompletedTransactions()
                            }
                        case "coinsBuy":
                            let coins = UserDefaults.standard.integer(forKey: "coins")
                            if coins >= 2000 {
                            showBuyWithCoins()
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
    
    func requestPaymentInfo(){
        self.setupIDs()
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: self.productIDs) as! Set<String>
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
            productRequest.delegate = self
            productRequest.start()
        }
    }
    
    func showBuyWithCoins(){
        let alert = UIAlertController(title: "Questions Boom", message: NSLocalizedString("MSG",tableName: "LocalizableStrings", comment: "message"), preferredStyle: .alert)
        
        let buyAction = UIAlertAction(title: NSLocalizedString("OK",tableName: "LocalizableStrings", comment: "ok"), style: .default, handler: { action in
            let userDefaults = UserDefaults.standard
            userDefaults.set(userDefaults.integer(forKey: "coins") - 2000, forKey: "coins")
            self.addHearts(1)
            self.addPassesAndCoins(0, passes: 3)
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL",tableName: "LocalizableStrings", comment: "cancel"), style: .cancel, handler: { action in
        })
        
        alert.addAction(buyAction)
        alert.addAction(cancelAction)
        
        adDelegate?.showAlert(alert)
        
    }
    
    
    fileprivate func setupIDs(){
        productIDs.append("Coins_5k")
        productIDs.append("Coins_12k")
        productIDs.append("Coins_27k")
        productIDs.append("Coins_60k")
        productIDs.append("Heartsx9")
        productIDs.append("Heartsx21")
        productIDs.append("Heartsx35")
        productIDs.append("Heartsx99")
        productIDs.append("Pass_12x2000_coins")
        productIDs.append("Pass_25x4000_coins")
        productIDs.append("Pass_40x6000_coins")
        productIDs.append("Pass_100x15000_coins")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        applyScrollViewToSpriteKitMapping()
        if let unwrappedNode = firstTouchedNode{
            unwrappedNode.run(SKAction.scale(to: 1, duration: 0.1))
            
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("RESPO SEEEE")
        if response.products.count != 0 {
            if response.invalidProductIdentifiers.count == 0{
            for product in response.products{
                productsArray.append(product)
                
            }
                setupButtons()
            }else{
                print(response.invalidProductIdentifiers.description)
                print("ERROR")
            }
        }
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
            print("ERROR")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        let alert = UIAlertController(title: NSLocalizedString("IAPERR",tableName: "LocalizableStrings", comment: "error"), message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        adDelegate?.showAlert(alert)
    }
    
    func setupFontWithProducts(size: CGSize) -> UIFont{
        
        var returnFont = UIFont(name: "IowanOldStyle-Italic", size: self.convertFontSize(85))
        for product in productsArray{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
            let string = NSString(string: formatter.string(from: product.price)!)
            let rect = CGRect(x: 0, y: 0, width: size.width - 10, height: size.height)
            let newFont = self.getFontFor(string, for: rect, with: returnFont!)
            if newFont.pointSize < returnFont!.pointSize{
             returnFont = newFont
            }
        }
        return returnFont!
    }
    
    func setupButtons() {
        filterProducts()
        productIDs.removeAll()
        
        var normalPriceFont: UIFont!
        
        
        for (index, product) in productsArray.enumerated(){
            if index < productsArray.count - 1{
            productIDs.append(product.productIdentifier)
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = product.priceLocale
            print(product.localizedTitle)
            print(formatter.string(from: product.price)!)
            
            let priceNode = SKSpriteNode(imageNamed: "IAPbutton")
            priceNode.size = convertTheSize(size: priceNode.texture!.size())
            priceNode.position = convertToSize(point: CGPoint(x: 400 + index * 420, y: 950))
            priceNode.zPosition = 4
            priceNode.userData = ["product": product]
            priceNode.name = "product"
            
                if index == 0{
                    normalPriceFont = setupFontWithProducts(size: priceNode.size)
                }
                
                
                
                
            let priceNodeLabel = SKLabelNode(text: formatter.string(from: product.price))
            priceNodeLabel.fontSize = normalPriceFont.pointSize
            priceNodeLabel.verticalAlignmentMode = .center
            priceNodeLabel.horizontalAlignmentMode = .center
            priceNodeLabel.position = CGPoint(x: 0, y:  0)
            priceNodeLabel.zPosition = 5
            priceNodeLabel.fontName = normalPriceFont.fontName
            priceNode.addChild(priceNodeLabel)
            priceNodeLabel.name = "productLabel"
            world.addChild(priceNode)
            }
        }
        
        let priceNode = SKSpriteNode(imageNamed: "IAPbutton")
        priceNode.size = convertTheSize(size: priceNode.texture!.size())
        priceNode.position = convertToSize(point: CGPoint(x: 400 + 13 * 420, y: 950))
        priceNode.zPosition = 4
        priceNode.name = "restore"
        
        let priceNodeLabel = SKLabelNode(text: NSLocalizedString("RESTORE_PURCHASE_LABEL",tableName: "LocalizableStrings", comment: "restore"))
        priceNodeLabel.fontSize = convertFontSize(85)
        priceNodeLabel.position = CGPoint(x: 0, y:  -priceNode.size.height * 0.2)
        priceNodeLabel.zPosition = 5
        priceNodeLabel.fontName = "IowanOldStyle-Italic"
        priceNode.addChild(priceNodeLabel)
        priceNodeLabel.name = "restoreLabel"
        world.addChild(priceNode)

        
        let coinsLabel = ImageFromText(coins: 2000, size: CGSize(width: 500, height: 250))
        
        
        
        let iapButton = UIImage(named: "IAPbutton")
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 294, height: 144), false, 1.0)
        iapButton!.draw(in: CGRect(x: 0, y: 0, width: 294, height: 144))
        coinsLabel.draw(in: CGRect(x: -216, y: -55, width: 500, height: 250))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let coinsButton = SKSpriteNode(texture: SKTexture(image: image!))
        coinsButton.size = convertTheSize(size: coinsButton.texture!.size())
        coinsButton.position = convertToSize(point: CGPoint(x: 400 + 13 * 420, y: 950))
        coinsButton.zPosition = 5
        coinsButton.name = "coinsBuy"
        world.addChild(coinsButton)
        
        
        
    }
    
    func filterProducts(){
        var coinGroup = [SKProduct]()
        var heartGroup = [SKProduct]()
        var passGroup = [SKProduct]()
        for product in self.productsArray{
            print(product.productIdentifier)
            let productName = product.productIdentifier
            if productName.hasPrefix("Coins"){
                coinGroup.append(product)
            }
            if productName.hasPrefix("Hearts") || productName.hasSuffix("Hearts "){
                heartGroup.append(product)
                print("added")
            }
            if productName.hasPrefix("Pass"){
                passGroup.append(product)
            }
        }
        coinGroup.sort(by: {$0.price < $1.price})
        heartGroup.sort(by: {$0.price < $1.price})
        passGroup.sort(by: {$0.price < $1.price})
        
        self.productsArray = coinGroup
        productsArray += heartGroup
        productsArray += passGroup
        print(productsArray.count)
    }
    
    func showBuyWindow(_ product: SKProduct){
        if transactionInProgress{
            return
        }
        let alertController = UIAlertController(title: "Questions boom", message: NSLocalizedString("MSG",tableName: "LocalizableStrings", comment: "message") + product.localizedTitle, preferredStyle: .alert)
        let buyAction = UIAlertAction(title: NSLocalizedString("OK",tableName: "LocalizableStrings", comment: "ok"), style: .default, handler: { action in
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            print("payment added")
            self.transactionInProgress = true
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL",tableName: "LocalizableStrings", comment: "cancel"), style: .cancel, handler: { action in
            self.transactionInProgress = false
        })
        
        alertController.addAction(buyAction)
        alertController.addAction(cancelAction)
        
        
        
        adDelegate?.showAlert(alertController)
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print(transactions.count)
        for transaction in transactions{
            print(transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchased:
                
                endPurchase(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                let alertController = UIAlertController(title: "Questions boom", message: NSLocalizedString("END_PURCHASE",tableName: "LocalizableStrings", comment: "message"), preferredStyle: .alert)
                
                let OK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(OK)
                
                adDelegate?.showAlert(alertController)

            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                let alertController = UIAlertController(title: "Questions boom", message: NSLocalizedString("END_FAIL_PURCHASE",tableName: "LocalizableStrings", comment: "message"), preferredStyle: .alert)
                
                let OK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(OK)
                
                adDelegate?.showAlert(alertController)
                
                
            case .restored:
                print("RESTOREDYOPT")
                SKPaymentQueue.default().finishTransaction(transaction)
                endPurchase(transaction.payment.productIdentifier)
            default:
                print(transaction.transactionState.rawValue)
            }
            
        }
        print("ENDTRANSA")
    }
    
    func endPurchase(_ productID: String){
        switch productID {
        case productIDs[0]:
            self.addCoins(5000)
        case productIDs[1]:
            self.addCoins(12000)
        case productIDs[2]:
            self.addCoins(27000)
        case productIDs[3]:
            self.addCoins(60000)
        case productIDs[4]:
            self.addHearts(9)
        case productIDs[5]:
            self.addHearts(21)
        case productIDs[6]:
            self.addHearts(35)
        case productIDs[7]:
            self.addHearts(99)
        case productIDs[8]:
            self.addPassesAndCoins(2000, passes: 12)
        case productIDs[9]:
            self.addPassesAndCoins(4000, passes: 25)
        case productIDs[10]:
            self.addPassesAndCoins(6000, passes: 40)
        case productIDs[11]:
            self.addPassesAndCoins(15000, passes: 100)
        case productIDs[12]:
            self.removAds()
        default:
            break
        }
    }
    
    func addCoins(_ quantity: Int){
        let userDefaults = UserDefaults.standard
        userDefaults.set(userDefaults.integer(forKey: "coins") + quantity, forKey: "coins")
    }
    
    func addHearts(_ quantity: Int){
        let userDefaults = UserDefaults.standard
        userDefaults.set(userDefaults.integer(forKey: "hearts") + quantity, forKey: "hearts")
        
    }
    
    func addPassesAndCoins(_ coins: Int, passes: Int){
        addCoins(coins)
        let userDefaults = UserDefaults.standard
        userDefaults.set(userDefaults.integer(forKey: "pass") + passes, forKey: "pass")
    }
    
    func removAds(){
        adDelegate?.removeAdverstiments()
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "removeAds")
    }
    
    
}

enum BackScene {
    case start
    case single
    case playMode
}
