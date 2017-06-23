//
//  JLFGKPolygonObstacle.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 22/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import simd

class JLFGKPolygonObstacle: JLFGKObstacle {
    var vertices: [vector_float2]?
    private(set) var vertexCount: Int = 0
    
    static func obstacle(points: [vector_float2]?, count numPoints: size_t) -> JLFGKPolygonObstacle {
        return JLFGKPolygonObstacle(points: points, count: numPoints)
    }
    
    init(points: [vector_float2]?, count numPoints: size_t) {
        assert(points != nil, "JLFGKPolygonObstacle -initWithPoints:count: Cannot create an obstacle with a null points array.")
        assert(numPoints > 1, "JLFGKPolygonObstacle -initWithPoints:count: Cannot create an obstacle with < 2 points.")
        super.init()
        vertexCount = numPoints
        //vertices = calloc(MemoryLayout<vector_float2>.size, numPoints)
        //memcpy(vertices, points, MemoryLayout<vector_float2>.size * numPoints)
        vertices = points
    }
    
    convenience override init() {
        assert(false, "JLFGKPolygonObstacle instances must be initialized via -initWithPoints:count:")
        self.init()
    }
    
    deinit {
        //free(vertices)
    }
    
    func vertex(at idx: Int) -> vector_float2 {
        assert(idx < vertexCount, "JLFGKPolygonObstacle -vertexAtIndex: Index is out of range.")
        return vertices![idx]
    }
}
