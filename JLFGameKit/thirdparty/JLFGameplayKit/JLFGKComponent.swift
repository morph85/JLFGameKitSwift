//
//  JLFComponent.swift
//  JLFGameKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//  Ported by morph85 on 14/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class JLFGKComponent: NSObject {
    weak var entity: JLFGKEntity?
    
    func update(withDeltaTime seconds: TimeInterval) {
        // default implementation does nothing
    }
}
