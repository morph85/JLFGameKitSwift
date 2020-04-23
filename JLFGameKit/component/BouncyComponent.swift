//
//  BouncyComponent.swift
//  JLFGameKit
//
//  Ported by morph85 on 19/06/2017.
//  Copyright © 2017 test. All rights reserved.
//

import SpriteKit
import CoreGraphics

private let kDefaultBaseAnchorHeight: Float = 0.0
private let kDefaultBounceSpeed: Float = 0.18

class BouncyComponent: JLFGKComponent {
    var bounceSpeed: Float = 0.0
    var baseAnchorPoint = CGPoint.zero
    var isBouncing: Bool = false
    var bounceTime = CFTimeInterval()
    var shouldStopBouncingTime = CFTimeInterval()
    
    override init() {
        super.init()
        bounceSpeed = kDefaultBounceSpeed
        baseAnchorPoint = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
    }
    
    func startBouncing() {
        bounceTime = 0.0
        isBouncing = true
    }
    
    func stopBouncing() {
        isBouncing = false
        let sprite = (entity?.component(for: SpriteComponent.self) as? SpriteComponent)
        sprite?.sprite?.anchorPoint = baseAnchorPoint
    }
    
    override func update(withDeltaTime seconds: TimeInterval) {
        let sprite = (entity?.component(for: SpriteComponent.self) as? SpriteComponent)
        if isBouncing {
            bounceTime += seconds
            let offset: CGFloat = CGFloat(abs(sin(Float(bounceTime) / (bounceSpeed / 2.0))) / 3.0)
            sprite?.sprite?.anchorPoint = CGPoint(x: CGFloat(baseAnchorPoint.x), y: CGFloat(baseAnchorPoint.y - offset))
        }
    }
}
