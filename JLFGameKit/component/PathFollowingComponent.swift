//
//  PathFollowingComponent.swift
//  JLFGameKit
//
//  Ported by morph85 on 21/06/2017.
//  Copyright © 2017 test. All rights reserved.
//

import SpriteKit

private let kDefaultPlayerMoveSpeed: CGFloat = 150.0

class PathFollowingComponent: JLFGKComponent {
    var moveSpeed: CGFloat = 0.0
    var waypointCount: Int = 0
    var waypoints: Array<CGPoint>
    var stateMachine: JLFGKStateMachine?
    
    override init() {
        waypointCount = 0
        waypoints = Array<CGPoint>()
        super.init()
        moveSpeed = kDefaultPlayerMoveSpeed
        let idle = IdleState.state() as! IdleState
        let pause = PauseState.state() as! PauseState
        let move = MoveState.state() as! MoveState
        idle.owner = self
        pause.owner = self
        move.owner = self
        let states: [JLFGKState] = [idle, pause, move]
        stateMachine = JLFGKStateMachine(states: states)
        let _ = stateMachine?.enterState(className(forClass: IdleState.self))
    }
    
    func followPath(_ pathIn: [SKNode]?) {
        assert(pathIn != nil, "PathFollowingComponent -followPath: Called with a nil path.")
        let path = pathIn!
        waypointCount = path.count
        waypoints.removeAll()
        let pathEnum: NSEnumerator = (path as NSArray).reverseObjectEnumerator()
        var node: SKNode? = pathEnum.nextObject() as? SKNode
        while node != nil {
            waypoints.append((node?.position)!)
            node = pathEnum.nextObject() as? SKNode
        }
        let _ = stateMachine?.enterState(className(forClass: IdleState.self))
    }
    
    func takeNextWaypoint() -> CGPoint {
        assert(waypointCount > 0, "Out of waypoints.")
        waypointCount -= 1
        return waypoints[waypointCount]
    }
    
    deinit {
        waypoints.removeAll()
    }
    
    override func update(withDeltaTime seconds: TimeInterval) {
        stateMachine?.update(withDeltaTime: seconds)
    }
}
