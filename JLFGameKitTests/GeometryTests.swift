//
//  GeometryTests.swift
//  JLFGameKit
//
//  Ported by morph85 on 22/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import XCTest
import simd
@testable import JLFGameKit

class GeometryTests: XCTestCase {
    func testPolygonCentroid() {
        let pointsAroundOrigin: [vector_float2] =
            [
                [1, -1],
                [1, 1],
                [-1, 1],
                [-1, -1],
            ];
        let pointsAround33: [vector_float2] =
            [
                [4, 2],
                [4, 4],
                [2, 4],
                [2, 2],
            ];
        let p1 = JLFGKPolygonObstacle(points: pointsAroundOrigin, count: 4)
        let p2 = JLFGKPolygonObstacle(points: pointsAround33, count: 4)
        let centroid1: vector_float2 = p1.centroid()
        let centroid2: vector_float2 = p2.centroid()
        XCTAssertEqual(centroid1.x, 0)
        XCTAssertEqual(centroid1.y, 0)
        XCTAssertEqual(centroid2.x, 3)
        XCTAssertEqual(centroid2.y, 3)
    }
    
    func testPolygonArea() {
        let pointsAroundOrigin: [vector_float2] =
            [
                [1, -1],
                [1, 1],
                [-1, 1],
                [-1, -1],
            ];
        let pointsAround33: [vector_float2] =
            [
                [4, 2],
                [4, 4],
                [2, 4],
                [2, 2],
            ];
        let p1 = JLFGKPolygonObstacle(points: pointsAroundOrigin, count: 4)
        let p2 = JLFGKPolygonObstacle(points: pointsAround33, count: 4)
        let area1: Float = p1.area()
        let area2: Float = p2.area()
        XCTAssertEqual(area1, area2)
    }
    
    func testPolygonNodesWithRadius() {
        let pointsAroundOrigin: [vector_float2] =
            [
                [1, -1],
                [1, 1],
                [-1, 1],
                [-1, -1],
            ];
        let sampleDirection: vector_float2 = [1, 1]
        let unitDirection: vector_float2 = vector_normalize(sampleDirection)
        let expected: vector_float2 = [sampleDirection.x + unitDirection.x, sampleDirection.y + unitDirection.y]
        let p1 = JLFGKPolygonObstacle(points: pointsAroundOrigin, count: 4)
        let nodes: [JLFGKGraphNode2D] = p1.nodes(withBufferRadius: 1.0)
        XCTAssertNotNil(nodes)
        XCTAssertEqual(nodes.count, 4)
        var node: JLFGKGraphNode2D = nodes[0]
        XCTAssertEqual(node.position.x, expected.x)
        XCTAssertEqual(node.position.y, -expected.y)
        node = nodes[1]
        XCTAssertEqual(node.position.x, expected.x)
        XCTAssertEqual(node.position.y, expected.y)
        node = nodes[2]
        XCTAssertEqual(node.position.x, -expected.x)
        XCTAssertEqual(node.position.y, expected.y)
        node = nodes[3]
        XCTAssertEqual(node.position.x, -expected.x)
        XCTAssertEqual(node.position.y, -expected.y)
    }
    
    func testSimdVectorFunctions() {
        let v: vector_float2 = [0, 5.0]
        XCTAssertEqual(vector_length(v), 5.0)
        let normal: vector_float2 = vector_normalize(v)
        XCTAssertEqual(normal.x, 0.0)
        XCTAssertEqual(normal.y, 1.0)
    }
    
    func testLineIntersections() {
        // I drew out a bunch of points and polygons on a sheet of graph paper for this list. The
        // same set is used in PathfindingTests -testObstaclePathfinding
        let points: [vector_float2] =
            [
                [-4, 13],
                [-6, 7],
                [-4, 6],
                [-1, 9],
                [-6, 11],
                [-1, 4],
                [-3, -4],
                [2, 12],
                [11, 13],
                [7, 11],
                [6, 5],
                [12, 3],
                [14, 7],
                [2, -1],
                [7, -4],
                [16, -4],
                [14, -2],
                [16, 10],
                [17, 4],
                [6, 2],
                [9, -6],
            ];
        // These are just straightforward intersecting lines: make sure they give us an intersection regardless
        // of the order of the points.
        XCTAssertTrue(line_segments_intersect(points[19], points[17], points[10], points[11]))
        XCTAssertTrue(line_segments_intersect(points[17], points[19], points[10], points[11]))
        XCTAssertTrue(line_segments_intersect(points[19], points[17], points[11], points[10]))
        XCTAssertTrue(line_segments_intersect(points[17], points[19], points[11], points[10]))
        // These lines share an endpoint. For the purposes of the graph nodes, these should *not* be considered
        // to intersect.
        XCTAssertFalse(line_segments_intersect(points[19], points[10], points[10], points[9]))
        XCTAssertFalse(line_segments_intersect(points[10], points[19], points[10], points[9]))
        XCTAssertFalse(line_segments_intersect(points[19], points[10], points[9], points[10]))
        XCTAssertFalse(line_segments_intersect(points[10], points[19], points[9], points[10]))
        // These ones shouldn't intersect at all
        XCTAssertFalse(line_segments_intersect(points[5], points[6], points[14], points[15]))
        XCTAssertFalse(line_segments_intersect(points[6], points[5], points[14], points[15]))
        XCTAssertFalse(line_segments_intersect(points[5], points[6], points[15], points[14]))
        XCTAssertFalse(line_segments_intersect(points[6], points[5], points[15], points[14]))
    }
}
