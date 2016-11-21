//
//  AnswerButton.swift
//  projectQAlfa
//
//  Created by Кирилл on 06.02.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import SpriteKit

class AnswerButton: SKSpriteNode {

    var answer: String
//    var textureChanged: Bool
    var buttonSize: CGSize
    init(answer: String, size: CGSize, image: String){
        self.answer = answer
        self.buttonSize = size
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        let image1 = UIImage(named: image)
            let textImage = ImageFromText(text: self.answer, size: CGSize(width: 660, height: 200), multipleLine: self.answer.characters.count > 20, fontSize: 48)
            let mergedImage = ImageCenteredInImage(image1, textImage)
            mergedImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let texture = SKTexture(image: image!)
//        textureChanged = false
        super.init(texture: texture, color: UIColor.clear, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeAnswer(_ answer: String){
        self.answer = answer
        UIGraphicsBeginImageContextWithOptions(buttonSize, false, 1)
        let image1 = UIImage(named: self.name!)
        let textImage = ImageFromText(text: self.answer, size: CGSize(width: 660, height: 200), multipleLine: self.answer.characters.count > 20, fontSize: 48)
        let mergedImage = ImageCenteredInImage(image1, textImage)
        mergedImage?.draw(in: CGRect(x: 0, y: 0, width: buttonSize.width, height: buttonSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.texture = SKTexture(image: image!)
    }
    func tapped(){
        UIGraphicsBeginImageContextWithOptions(buttonSize, false, 1)
        let imageTexture = UIImage(named: "\(name!)Tapped")
        let textImage = ImageFromText(text: self.answer, size: CGSize(width: 660, height: 200), multipleLine: self.answer.characters.count > 20, fontSize: 48)
        let mergedImage = ImageCenteredInImage(imageTexture, textImage)
        mergedImage?.draw(in: CGRect(x: 0, y: 0, width: buttonSize.width, height: buttonSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let texture = SKTexture(image: image!)
        self.texture = texture
    }
    
    func untapped(){
        UIGraphicsBeginImageContextWithOptions(buttonSize, false, 1)
        let imageTexture = UIImage(named: name!)
        let textImage = ImageFromText(text: self.answer, size: CGSize(width: 660, height: 200), multipleLine: self.answer.characters.count > 20, fontSize: 48)
        let mergedImage = ImageCenteredInImage(imageTexture, textImage)
        mergedImage?.draw(in: CGRect(x: 0, y: 0, width: buttonSize.width, height: buttonSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let texture = SKTexture(image: image!)
        self.texture = texture
    }
}


