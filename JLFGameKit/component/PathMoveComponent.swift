//
//  PathMoveComponent.swift
//  JLFGameKit
//
//  Ported by morph85 on 21/06/2017.
//  Copyright © 2017 test. All rights reserved.
//

import SpriteKit

typealias WaypointReached = ((JLFGKGridGraphNode) -> (Void))?
let kPathMoveComponentDefaultDistanceBetweenWaypoints: Float = 32.0
let kPathMoveComponentDefaultMoveSpeed: Float = 140.0
private let kMoveStopThreshold: CGFloat = 8.0

class PathMoveComponent: JLFGKComponent {
    var waypointCallback: WaypointReached
    var distanceBetweenWaypoints: Float = 0.0
    var moveSpeed: Float = 0.0
    var isMoving: Bool = false
    var remainingWaypoints: [JLFGKGridGraphNode]? = [JLFGKGridGraphNode]()
    var destination = CGPoint.zero
    private weak var _sprite: SpriteComponent?
    weak var sprite: SpriteComponent? {
        if _sprite == nil {
            _sprite = (entity?.component(for: SpriteComponent.self) as? SpriteComponent)
        }
        return _sprite
    }
    private weak var _bouncy: BouncyComponent?
    weak var bouncy: BouncyComponent? {
        if _bouncy == nil {
            _bouncy = (entity?.component(for: BouncyComponent.self) as? BouncyComponent)
        }
        return _bouncy
    }
    
    func followPath(_ path: [JLFGKGridGraphNode]?) {
        let bouncy = (entity?.component(for: BouncyComponent.self) as? BouncyComponent)
        if path == nil || path?.count == 0 {
            bouncy?.stopBouncing()
            isMoving = false
            remainingWaypoints?.removeAll()
            remainingWaypoints = nil
        } else {
            remainingWaypoints = path
            isMoving = true
            setNextDestination()
            bouncy?.startBouncing()
        }
    }
    
    override init() {
        super.init()
        distanceBetweenWaypoints = kPathMoveComponentDefaultDistanceBetweenWaypoints
        moveSpeed = kPathMoveComponentDefaultMoveSpeed
    }
    
    func setNextDestination() {
        let nextWaypoint: JLFGKGridGraphNode? = remainingWaypoints?[0]
        destination = CGPoint(x: CGFloat((nextWaypoint?.position.x)!) * CGFloat(distanceBetweenWaypoints), y: CGFloat((nextWaypoint?.position.y)!) * CGFloat(distanceBetweenWaypoints))
    }
    
    override func update(withDeltaTime seconds: TimeInterval) {
        if !isMoving {
            return
        }
        if sprite != nil {
            var deltaV: CGPoint? = CGPointSubtract(destination, (sprite?.sprite?.position)!)
            if CGPointMagnitude(deltaV!) < kMoveStopThreshold {
                let nodeReached: JLFGKGridGraphNode? = remainingWaypoints?[0]
                remainingWaypoints?.remove(at: 0)
                if waypointCallback != nil {
                    waypointCallback!(nodeReached!)
                }
                if remainingWaypoints?.count == 0 {
                    // Done, stop moving, make sure the sprite is in exactly the
                    // right place, etc.
                    sprite?.sprite?.position = destination
                    bouncy?.stopBouncing()
                    isMoving = false
                    remainingWaypoints?.removeAll()
                    remainingWaypoints = nil
                    return
                }
                setNextDestination()
            }
            deltaV = CGPointNormalize(deltaV!)
            deltaV = CGPointScale(deltaV!, CGFloat(moveSpeed) * CGFloat(seconds))
            sprite?.sprite?.position = CGPointAdd((sprite?.sprite?.position)!, deltaV!)
        }
    }
}
