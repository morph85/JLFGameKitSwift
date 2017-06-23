//
//  JLFGKRandom.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 24/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

protocol JLFGKRandom: NSObjectProtocol {
    
    func nextInt() -> Int
    
    func nextInt(withUpperBound upperBound: Int) -> Int
    
    func nextUniform() -> Float
    
    func nextBool() -> Bool
}

//class JLFGKRandom: NSObject {
//
//}
