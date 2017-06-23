//
//  JLFGKObstacleGraphConnection.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 24/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class JLFGKObstacleGraphConnection: NSObject {
    private(set) var from: JLFGKGraphNode2D
    private(set) var to: JLFGKGraphNode2D
    
    class func fromNode(_ from: JLFGKGraphNode2D, toNode to: JLFGKGraphNode2D) -> JLFGKObstacleGraphConnection {
        return JLFGKObstacleGraphConnection(fromNode: from, toNode: to)
    }
    
    init(fromNode from: JLFGKGraphNode2D, toNode to: JLFGKGraphNode2D) {
        self.from = from
        self.to = to
        super.init()
    }
}
