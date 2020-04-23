//
//  JLFGKGraphNode2D.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 18/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import simd

class JLFGKGraphNode2D: JLFGKGraphNode {
    var position = vector_float2()
    private var lockedConnections = Set<AnyHashable>()
    
    static func node(withPoint point: vector_float2) -> JLFGKGraphNode2D {
        return JLFGKGraphNode2D(point: point)
    }
    
    convenience override init() {
        assert(false, "JLFGKGraphNode2D -init: Must use the designated initializer -initWithPoint:")
        self.init()
    }
    
    init(point: vector_float2) {
        super.init()
        position = point
        lockedConnections = Set<AnyHashable>()
    }
    
    override func estimatedCost(to node: JLFGKGraphNode) -> Float {
        return cost(to: node)
    }
    
    override func cost(to node: JLFGKGraphNode) -> Float {
        assert((node is JLFGKGraphNode2D), "JLFGKGraphNode2D -costToNode: Only works with JLFGKGraphNode2D.")
        let other: JLFGKGraphNode2D? = (node as? JLFGKGraphNode2D)
        return simd_distance((other?.position)!, position)
    }
    
    override var description:String {
        return String(format: "{%.2f, %.2f}", position.x, position.y)
    }
}
