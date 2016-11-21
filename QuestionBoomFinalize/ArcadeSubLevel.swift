//
//  ArcadeSubLevel.swift
//  projectQAlfa
//
//  Created by Кирилл on 03.03.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import SpriteKit

class ArcadeSubLevel: SKSpriteNode {

    var isLocked: Bool
    var subLevelNumber: Int
    init(subLevelNumber: Int, isLocked: Bool, image: String, size: CGSize, position: CGPoint){
        self.isLocked = isLocked
        self.subLevelNumber = subLevelNumber
        super.init(texture: SKTexture(imageNamed: "\(image)Planet"), color: UIColor.clear, size: size)
        self.position = position
        
        if isLocked {
            let lock = SKSpriteNode(imageNamed: "lock")
            lock.name = "levelObject"
            lock.position = CGPoint(x: 0, y: 0)
            lock.size = CGSize(width: size.width * 0.65, height: size.height * 0.755)
            lock.zPosition = 4
            addChild(lock)
        }

        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
