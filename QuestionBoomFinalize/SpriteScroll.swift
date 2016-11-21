//
//  SpriteScroll.swift
//  projectQAlfa
//
//  Created by Кирилл on 14.03.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import SpriteKit


class SpriteScroll: UIScrollView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let view = self.superview as? SKView
        let scene = view?.scene
        scene?.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let view = self.superview as? SKView
        let scene = view?.scene
        scene?.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let view = self.superview as? SKView
        let scene = view?.scene
        scene?.touchesEnded(touches, with: event)
    }
}
