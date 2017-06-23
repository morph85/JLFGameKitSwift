//
//  MoveComponent.swift
//  JLFGameKit
//
//  Ported by morph85 on 19/06/2017.
//  Copyright © 2017 test. All rights reserved.
//

import SpriteKit

private let kDefaultPlayerMoveSpeed: CGFloat = 150.0
private let kMoveStopThreshold: CGFloat = 4.0

class MoveComponent: JLFGKComponent {
    var isMoving: Bool = false
    var moveTarget = CGPoint.zero
    var moveSpeed: CGFloat = 0.0
    var lastLocation = CGPoint.zero
    var moveDirection = CGPoint.zero
    
    override init() {
        super.init()
        moveSpeed = kDefaultPlayerMoveSpeed
    }
    
    override func update(withDeltaTime seconds: TimeInterval) {
        if isMoving == false {
            return
        }
        let spriteComp = (entity?.component(for: SpriteComponent.self) as? SpriteComponent)
        let sprite: SKSpriteNode? = spriteComp?.sprite
        if sprite != nil {
            lastLocation = (sprite?.position)!
            var deltaV: CGPoint = CGPointSubtract(moveTarget, lastLocation)
            if CGPointMagnitude(deltaV) < kMoveStopThreshold {
                isMoving = false
                return
            }
            deltaV = CGPointNormalize(deltaV)
            moveDirection = deltaV
            deltaV = CGPointScale(deltaV, moveSpeed * CGFloat(seconds))
            sprite?.position = CGPointAdd((sprite?.position)!, deltaV)
        }
    }
}
