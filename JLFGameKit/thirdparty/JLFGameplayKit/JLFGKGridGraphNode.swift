//
//  JLFGKGridGraphNode.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 18/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import simd

class JLFGKGridGraphNode: JLFGKGraphNode {
    var position = vector_int2()
    
    static func node(gridPosition position: vector_int2) -> JLFGKGridGraphNode {
        return JLFGKGridGraphNode(gridPosition: position)
    }
    
    init(gridPosition position: vector_int2) {
        super.init()
        self.position = position
    }
    
    override func estimatedCost(to node: JLFGKGraphNode) -> Float {
        assert((node is JLFGKGridGraphNode), "JLFGKGridGraphNode -estimatedCostToNode: Only works with grid graph nodes, not general graph nodes.")
        let goal: JLFGKGridGraphNode = (node as! JLFGKGridGraphNode)
        // Using Chebyshev distance at the moment. See:
        // http://theory.stanford.edu/~amitp/GameProgramming/Heuristics.html#heuristics-for-grid-maps
        //
        // for details.
        let dx: Float = abs(Float(position.x - goal.position.x))
        let dy: Float = abs(Float(position.y - goal.position.y))
        return (dx + dy) - 1 * min(dx, dy)
    }
    
    override var description: String {
        return "JLFGKGridGraphNode {\(position.x), \(position.y)}"
    }
}
