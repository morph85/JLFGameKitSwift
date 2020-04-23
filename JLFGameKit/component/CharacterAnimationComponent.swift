//
//  CharacterAnimationComponent.swift
//  JLFGameKit
//
//  Ported by morph85 on 19/06/2017.
//  Copyright © 2017 test. All rights reserved.
//

import SpriteKit

enum AnimationFacing : Int {
    case facingLeft
    case facingRight
    case facingUp
    case facingDown
}

private func directionForFacing(facing: AnimationFacing) -> String {
    switch facing {
    case .facingLeft:
        return "left"
    case .facingRight:
        return "right"
    case .facingDown:
        return "down"
    case .facingUp:
        return "up"
    }
}

class CharacterAnimationComponent: JLFGKComponent {
    var baseTextureName: String = ""
    var atlas: SKTextureAtlas?
    var isWasMoving: Bool = false
    var facing = AnimationFacing(rawValue: 0)!
    var animationTime = CFTimeInterval()
    var isWaving: Bool = false
    
    init(baseTextureName: String, characterAtlas atlas: SKTextureAtlas) {
        assert((baseTextureName.count ) > 0, "Bad texture name")
        super.init()
        self.baseTextureName = baseTextureName
        self.atlas = atlas
        facing = .facingDown
    }
    
    func hasWavingAnimation() -> Bool {
        return (baseTextureName == "man")
    }
    
    func startWaving() {
        if !hasWavingAnimation() {
            return
        }
        isWaving = true
        animationTime = 0
    }
    
    func stopWaving() {
        isWaving = false
        animationTime = 0
    }
    
    override func update(withDeltaTime seconds: TimeInterval) {
        let c = (entity?.component(for: SpriteComponent.self) as? SpriteComponent)
        let m = (entity?.component(for: MoveComponent.self) as? MoveComponent)
        if c != nil && m != nil {
            let node: SKSpriteNode? = c?.sprite
            var textureName: String = "stand-down"
            if isWaving {
                animationTime += seconds
                let animationFrame = Int(floor(animationTime / 0.2)) % 2 + 1
                textureName = "wave-\(animationFrame)"
            }
            else {
                // Is the entity moving? If not, just make sure it's using the right standing texture
                if !(m?.isMoving)! {
                    isWasMoving = false
                    textureName = "stand-\(directionForFacing(facing: facing))"
                }
                else {
                    // The entity's moving. If it wasn't moving last frame, reset the movement timer.
                    if !isWasMoving {
                        animationTime = 0
                        isWasMoving = true
                    } else {
                        animationTime += seconds
                    }
                    let direction: CGPoint = (m?.moveDirection)!
                    if abs(Float(direction.x)) > abs(Float(direction.y)) {
                        facing = (direction.x > 0) ? .facingRight : .facingLeft
                    } else {
                        facing = (direction.y > 0) ? .facingUp : .facingDown
                    }
                    let dirName: String = directionForFacing(facing: facing)
                    let animationFrame = Int(floor(animationTime / 0.2)) % 4 + 1
                    textureName = "walk-\(dirName)-\(animationFrame)"
                }
            }
            textureName = "\(baseTextureName)-\(textureName)"
            node?.texture = atlas?.textureNamed(textureName)
        }
    }
}
