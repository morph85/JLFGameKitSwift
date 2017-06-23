//
//  JLFGKCircleObstacle.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 24/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import simd

class JLFGKCircleObstacle: JLFGKObstacle {
    var position = vector_float2()
    var radius: Float = 0.0
    
    static func obstacle(radius: Float) -> JLFGKCircleObstacle {
        return JLFGKCircleObstacle(radius: radius)
    }
    
    init(radius: Float) {
        // Interesting question here: a negative radius never makes sense, right? Should I stop that from happening?
        // TODO: Find out what the real GameplayKit does.
        super.init()
        self.radius = radius
        position = [0, 0]
    }
}
