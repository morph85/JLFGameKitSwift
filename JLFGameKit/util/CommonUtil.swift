//
//  CommonUtil.swift
//  JLFGameKit
//
//  Ported by morph85 on 26/05/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

func className(forClass objectClass: AnyClass) -> NSString {
    let name = String(describing: objectClass) as NSString
    //print("-->> get class name: \(name)")
    return name
}

func className(forObject object: AnyObject) -> NSString {
    let name = String(describing: type(of: object.self)) as NSString
    //print("-->> get class name from: \(name)")
    return name
}

class CommonUtil: NSObject {

}
