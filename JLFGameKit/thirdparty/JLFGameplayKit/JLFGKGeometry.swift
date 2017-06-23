//
//  JLFGKGeometry.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 24/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import simd

// This is adapted from the wonderful StackOverflow answer here:'
// http://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect

func line_segments_intersect(_ p1: vector_float2, _ p2: vector_float2, _ q1: vector_float2, _ q2: vector_float2) -> Bool {
    let r: vector_float2 = [p2.x - p1.x, p2.y - p1.y]
    let s: vector_float2 = [q2.x - q1.x, q2.y - q1.y]
    let q_minus_p: vector_float2 = [q1.x - p1.x, q1.y - p1.y]
    let r_cross_s: Float = vector_cross(r, s).z
    let q_minus_p_cross_r: Float = vector_cross(q_minus_p, r).z
    let q_minus_p_cross_s: Float = vector_cross(q_minus_p, s).z
    if q_minus_p_cross_r == 0 && r_cross_s == 0 {
        // The lines are colinear
        let magnitude_r: Float = vector_length(r)
        let s_dot_r: Float = vector_dot(s, r)
        let t0: Float = vector_dot(q_minus_p, r) / magnitude_r
        let t1: Float = t0 + s_dot_r / magnitude_r
        return (t0 >= 0 && t0 <= 1) || (t1 >= 0 && t1 <= 1)
    }
    else if r_cross_s == 0 && q_minus_p_cross_r != 0 {
        // The lines are parallel and non-intersecting
        return false
    }
    else if r_cross_s != 0 {
        let t: Float = q_minus_p_cross_s / r_cross_s
        let u: Float = q_minus_p_cross_r / r_cross_s
        // Normally you'd want to test for 0 <= t <= 1 && 0 <= u <= 1, but
        // that would mean that two lines that share the same endpoint are
        // marked as intersecting, which isn't what we want for our use case.
        return t > 0 && t < 1 && u > 0 && u < 1
    }
    return false
}
