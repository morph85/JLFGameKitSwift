//
//  BouncyAnimationComponent.swift
//  JLFGameKit
//
//  Ported by morph85 on 19/06/2017.
//  Copyright © 2017 test. All rights reserved.
//

import SpriteKit

private let kDefaultBounceSpeed: CGFloat = 0.1

class BouncyAnimationComponent: JLFGKComponent {
    var bounceSpeed: CGFloat = 0.0
    var baseTextureName: String = ""
    var characterAtlas: SKTextureAtlas?
    var isBouncing: Bool = false
    var bounceTime = CFTimeInterval()
    var shouldStopBouncingTime = CFTimeInterval()
    
    init(baseTextureName: String, characterAtlas atlas: SKTextureAtlas) {
        super.init()
        self.baseTextureName = baseTextureName
        characterAtlas = atlas
        bounceSpeed = kDefaultBounceSpeed
    }
    
    override func update(withDeltaTime seconds: TimeInterval) {
        let move = (entity?.component(for: MoveComponent.self) as? MoveComponent)
        let sprite = (entity?.component(for: SpriteComponent.self) as? SpriteComponent)
        let startBouncing: Bool = (isBouncing == false && move?.isMoving == true)
        let stopBouncing: Bool = (isBouncing == true && move?.isMoving == false)
        if startBouncing {
            isBouncing = true
            bounceTime = 0.0
        }
        if stopBouncing {
            isBouncing = false
            sprite?.sprite?.anchorPoint = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        }
        if isBouncing {
            bounceTime += seconds
            let offset: CGFloat = fabs(sin(CGFloat(bounceTime) / (bounceSpeed / 2.0))) / 3.0
            sprite?.sprite?.anchorPoint = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5 - offset))
        }
        
        var textureName: String
        if (move?.moveDirection.x)! > CGFloat(0.0) {
            textureName = baseTextureName + ("-right")
        }
        else {
            textureName = baseTextureName + ("-left")
        }
        sprite?.sprite?.texture = characterAtlas?.textureNamed(textureName)
    }
}
