//
//  SpriteComponent.swift
//  JLFGameKit
//
//  Ported by morph85 on 19/06/2017.
//  Copyright © 2017 test. All rights reserved.
//

import SpriteKit

class SpriteComponent: JLFGKComponent {
    var sprite: SKSpriteNode?
    
    override func update(withDeltaTime seconds: TimeInterval) {
        // This is a silly fudge to get things drawing in the order I want.
        // Doing it properly means I'd need to let this component know the full height of the scene.
        sprite?.zPosition = 10000 - (sprite?.position.y)!
    }
}
