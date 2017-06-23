//
//  JLFGKObstacleGraphUserNode.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 24/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class JLFGKObstacleGraphUserNode: NSObject {
    private(set) var node: JLFGKGraphNode2D
    private(set) var ignoredObstacles = [JLFGKObstacle]()
    
    init(node: JLFGKGraphNode2D, ignoredObstacles obstacles: [JLFGKObstacle]) {
        self.node = node
        super.init()
        ignoredObstacles = obstacles
    }
}
