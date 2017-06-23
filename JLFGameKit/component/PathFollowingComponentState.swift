//
//  PathFollowingComponentState.swift
//  JLFGameKit
//
//  Ported by morph85 on 21/06/2017.
//  Copyright © 2017 test. All rights reserved.
//

import SpriteKit

private let kMoveStopThreshold: CGFloat = 2.0
private let kPauseTime: CGFloat = 0.15

class PathFollowingComponentState: JLFGKState {
    weak var owner: PathFollowingComponent?
    private var _entity: JLFGKEntity?
    var entity: JLFGKEntity? {
        return owner?.entity!
    }
}

class IdleState: PathFollowingComponentState {
    override func update(withDeltaTime seconds: CFTimeInterval) {
        if (owner?.waypointCount)! > 0 {
            let _ = stateMachine?.enterState(className(forClass: MoveState.self))
        }
    }
}

class PauseState: PathFollowingComponentState {
    var timeRemaining = CFTimeInterval()
    
    override func didEnter(withPreviousState previousState: JLFGKState?) {
        timeRemaining = CFTimeInterval(kPauseTime)
    }
    
    override func update(withDeltaTime seconds: CFTimeInterval) {
        if owner?.waypointCount == 0 {
            let _ = stateMachine?.enterState(className(forClass: IdleState.self))
        }
        timeRemaining -= seconds
        if timeRemaining <= 0.0 {
            let _ = stateMachine?.enterState(className(forClass: MoveState.self))
        }
    }
}

class MoveState: PathFollowingComponentState {
    var destination = CGPoint.zero
    
    override func didEnter(withPreviousState previousState: JLFGKState?) {
        destination = (owner?.takeNextWaypoint())!
        let bouncy = (entity?.component(for: BouncyComponent.self) as? BouncyComponent)
        bouncy?.startBouncing()
    }
    
    override func willExit(withNextState nextState: JLFGKState) {
        let bouncy = (entity?.component(for: BouncyComponent.self) as? BouncyComponent)
        bouncy?.stopBouncing()
    }
    
    override func update(withDeltaTime seconds: CFTimeInterval) {
        let spriteComp = (entity?.component(for: SpriteComponent.self) as? SpriteComponent)
        let sprite: SKSpriteNode? = spriteComp?.sprite
        if sprite != nil {
            var deltaV: CGPoint = CGPointSubtract(destination, (sprite?.position)!)
            if CGPointMagnitude(deltaV) < kMoveStopThreshold {
                let _ = stateMachine?.enterState(className(forClass: PauseState.self))
                return
            }
            deltaV = CGPointNormalize(deltaV)
            deltaV = CGPointScale(deltaV, owner!.moveSpeed * CGFloat(seconds))
            sprite?.position = CGPointAdd((sprite?.position)!, deltaV)
        }
    }
}
