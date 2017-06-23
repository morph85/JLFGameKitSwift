//
//  Math.swift
//  JLFGameKit
//
//  Ported by morph85 on 23/12/2016.
//  Copyright © 2016 test. All rights reserved.
//

import SpriteKit

func clamp(point: inout CGPoint, minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
    clamp(&point.x, minX, maxX)
    clamp(&point.y, minY, maxY)
}

func clamp(_ num: inout CGFloat, _ min: CGFloat, _ max: CGFloat) {
    if num < min {
        num = min
    }
    if num > max {
        num = max
    }
}

func randomInt(min: Int, max: Int) -> Int {
    var offset = 0
    if min < 0 {
        offset = abs(min)
    }
    
    let minimum = UInt32(min + offset)
    let maximum = UInt32(max + offset)
    return Int(minimum + arc4random_uniform(maximum - minimum)) - offset
}

extension CGSize {
    func halfWidth() -> CGFloat {
        return self.width * 0.5
    }
    func halfHeight() -> CGFloat {
        return self.height * 0.5
    }
}

extension CGPoint {
    static func sub(p1: CGPoint, _ p2: CGPoint) -> CGPoint {
        return CGPoint(x: p2.x - p1.x, y: p2.y - p1.y)
    }
    
    static func add(p1: CGPoint, _ p2: CGPoint) -> CGPoint {
        return CGPoint(x: p2.x + p1.x, y: p2.y + p1.y)
    }
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x * scalar.x, y: point.y * scalar.y)
}

func / (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x / scalar.x, y: point.y / scalar.y)
}

// common function from JKFGK

func CGPointAdd(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
    return CGPoint(x: CGFloat(a.x + b.x), y: CGFloat(a.y + b.y))
}
    
func CGPointSubtract(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
    return CGPoint(x: CGFloat(a.x - b.x), y: CGFloat(a.y - b.y))
}
    
func CGPointScale(_ point: CGPoint, _ scalar: CGFloat) -> CGPoint {
    return CGPoint(x: CGFloat(point.x * scalar), y: CGFloat(point.y * scalar))
}
    
func CGPointMagnitude(_ a: CGPoint) -> CGFloat {
    let magnitudeSquared: CGFloat = a.x * a.x + a.y * a.y
    if magnitudeSquared != 0 {
        return sqrt(magnitudeSquared)
    } else {
        return 0
    }
}
    
func CGPointNormalize(_ a: CGPoint) -> CGPoint {
    let magnitude: CGFloat = CGPointMagnitude(a)
    if magnitude != 0 {
        return CGPointScale(a, 1.0 / magnitude)
    } else {
        return a
    }
}
