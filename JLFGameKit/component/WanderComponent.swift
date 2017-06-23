//
//  WanderComponent.swift
//  JLFGameKit
//
//  Ported by morph85 on 19/06/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

private func waitTime() -> CGFloat {
    // Minimum 1 second, maximum 4 seconds
    let time = 1.0 + (CGFloat(arc4random_uniform(3000)) / 1000.0)
    return time
}

extension JLFGKEntity {
    func characterAnimComponent() -> CharacterAnimationComponent? {
        return component(for: CharacterAnimationComponent.self) as? CharacterAnimationComponent
    }
    
    func moveComponent() -> MoveComponent {
        return (component(for: MoveComponent.self) as? MoveComponent)!
    }
}

class WaitingState: JLFGKState {
    weak var component: JLFGKComponent?
    var timeRemaining = CFTimeInterval()
    
    init(component: JLFGKComponent) {
        super.init()
        self.component = component
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    override func isValidNextState(_ stateClass: NSString) -> Bool {
        let charAnim:CharacterAnimationComponent? = component?.entity?.characterAnimComponent()
        if (charAnim != nil) && (charAnim!.hasWavingAnimation()) {
            return stateClass == className(forClass: WalkingState.self) || stateClass == className(forClass: WavingState.self)
        } else {
            return stateClass == className(forClass: WalkingState.self)
        }
    }
    
    override func didEnter(withPreviousState previousState: JLFGKState?) {
        timeRemaining = CFTimeInterval(waitTime())
    }
    
    override func update(withDeltaTime seconds: CFTimeInterval) {
        timeRemaining -= seconds
        if timeRemaining <= 0.0 {
            let charAnim: CharacterAnimationComponent? = component?.entity?.characterAnimComponent()
            let shouldWave: Bool = (arc4random_uniform(3) % 3) == 0
            if shouldWave && (charAnim != nil) && charAnim!.hasWavingAnimation() {
                let _ = stateMachine?.enterState(className(forClass: WavingState.self))
            } else {
                let _ = stateMachine?.enterState(className(forClass: WalkingState.self))
            }
        }
    }
}

class WalkingState: JLFGKState {
    weak var component: JLFGKComponent?
    var timeRemaining = CFTimeInterval()
    var direction = CGPoint.zero
    
    init(component: JLFGKComponent) {
        super.init()
        self.component = component
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    override func isValidNextState(_ stateClass: NSString) -> Bool {
        return stateClass == className(forClass: WaitingState.self)
    }
    
    override func didEnter(withPreviousState previousState: JLFGKState?) {
        timeRemaining = CFTimeInterval(waitTime())
        let degrees: Int = Int(arc4random_uniform(360))
        direction = CGPoint(x: CGFloat(cosf(Float(degrees) * .pi / 180.0)), y: CGFloat(sinf(Float(degrees) * .pi / 180.0)))
    }
    
    override func update(withDeltaTime seconds: CFTimeInterval) {
        timeRemaining -= seconds
        if timeRemaining <= 0.0 {
            let _ = stateMachine?.enterState(className(forClass: WaitingState.self))
            return
        }
        let move: MoveComponent = (component?.entity?.moveComponent())!
        let offset: CGPoint = CGPointScale(direction, 50.0)
        move.moveTarget = CGPointAdd(offset, move.lastLocation)
        move.isMoving = true
    }
    
    override func willExit(withNextState nextState: JLFGKState) {
        let move: MoveComponent = (component?.entity?.moveComponent())!
        move.isMoving = false
    }
}

class WavingState: JLFGKState {
    weak var component: JLFGKComponent?
    var timeRemaining = CFTimeInterval()
    
    init(component: JLFGKComponent) {
        super.init()
        self.component = component
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    override func isValidNextState(_ stateClass: NSString) -> Bool {
        return stateClass == className(forClass: WaitingState.self)
    }
    
    override func didEnter(withPreviousState previousState: JLFGKState?) {
        timeRemaining = CFTimeInterval(waitTime())
        component?.entity?.characterAnimComponent()?.startWaving()
    }
    
    override func willExit(withNextState nextState: JLFGKState) {
        component?.entity?.characterAnimComponent()?.stopWaving()
    }
    
    override func update(withDeltaTime seconds: CFTimeInterval) {
        timeRemaining -= seconds
        if timeRemaining <= 0.0 {
            let _ = stateMachine?.enterState(className(forClass: WaitingState.self))
        }
    }
}

class WanderComponent: JLFGKComponent {
    var isCanWave: Bool = false
    var stateMachine: JLFGKStateMachine?
    
    override init() {
        super.init()
        let wait = WaitingState(component: self)
        let walk = WalkingState(component: self)
        let wave = WavingState(component: self)
        stateMachine = JLFGKStateMachine(states: [wait, walk, wave])
        let _ = stateMachine?.enterState(className(forClass: WaitingState.self))
    }
    
    override func update(withDeltaTime seconds: TimeInterval) {
        stateMachine?.update(withDeltaTime: seconds)
    }
}

