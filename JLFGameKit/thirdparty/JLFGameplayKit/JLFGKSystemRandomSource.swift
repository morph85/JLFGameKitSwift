//
//  JLFGKSystemRandomSource.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 25/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class JLFGKSystemRandomSource: JLFGKRandomSource {
    
    override func nextInt() -> Int {
        return Int(arc4random()) - Int(-INT32_MAX-1)
    }
    
    override func nextInt(withUpperBound upperBound: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperBound)))
    }
}
