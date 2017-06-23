//
//  JLFGKPolygonObstacle+Geometry.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 24/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import simd

extension JLFGKPolygonObstacle {
    
    func area() -> Float {
        assert(vertexCount >= 3, "JLFGKPolygonObstacle -area: A polygon must have at least 3 vertices before you can ask for its area.")
        var sum: Float = 0.0
        let numVertices: Int = vertexCount
        for i in 0..<numVertices {
            let j: Int = (i + 1) % numVertices
            let current: vector_float2 = vertex(at: i)
            let next: vector_float2 = vertex(at: j)
            sum += (current.x * next.y) - (next.x * current.y)
        }
        sum = sum / 2.0
        return (sum < 0 ? -sum : sum)
    }
    
    func centroid() -> vector_float2 {
        assert(vertexCount >= 3, "JLFGKPolygonObstacle -area: A polygon must have at least 3 vertices before you can ask for its center.")
        let area: Float = self.area()
        var sumX: Float = 0.0
        var sumY: Float = 0.0
        let numVertices: Int = vertexCount
        for i in 0..<numVertices {
            let j: Int = (i + 1) % numVertices
            let current: vector_float2 = vertex(at: i)
            let next: vector_float2 = vertex(at: j)
            let commonFactor: Float = (current.x * next.y - next.x * current.y)
            sumX += (current.x + next.x) * commonFactor
            sumY += (current.y + next.y) * commonFactor
        }
        return [sumX / (6 * area), sumY / (6 * area)]
    }
    
    func nodes(withBufferRadius radius: Float) -> [JLFGKGraphNode2D] {
        assert(vertexCount >= 3, "JLFGKPolygonObstacle -nodesWithBufferRadius: Only works with a fully polygon, not a line or point.")
        let numVertices: Int = vertexCount
        let centroid: vector_float2 = self.centroid()
        var nodes = [JLFGKGraphNode2D]() /* capacity: vertexCount */
        for i in 0..<numVertices {
            let point: vector_float2 = vertex(at: i)
            var dv: vector_float2 = [point.x - centroid.x, point.y - centroid.y]
            dv = vector_normalize(dv)
            dv = [dv.x * radius, dv.y * radius]
            let result: vector_float2 = [point.x + dv.x, point.y + dv.y]
            nodes.append(JLFGKGraphNode2D.node(withPoint: result))
        }
        return nodes
    }
}
