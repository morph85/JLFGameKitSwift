//
//  GameViewController.swift
//  JLFGameKit
//
//  Ported by morph85 on 23/12/2016.
//  Copyright © 2016 test. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var choose:Int = 0
    var scene:SKScene?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        choose = 3
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.showsNodeCount = true
        skView.showsDrawCount = true
        skView.showsFPS = true
        skView.ignoresSiblingOrder = true
        
        if (choose == 1) {
            let atlas = SKTextureAtlas(named: "Characters")
            atlas.preload(completionHandler: {() -> Void in
                for name: String in atlas.textureNames {
                    //print("load texture: \(name)")
                    let texture: SKTexture = atlas.textureNamed(name)
                    texture.filteringMode = .nearest
                }
                let scene = TestJLFDemo1Scene.unarchive(from: "TestJLFDemo1Scene")
                scene.characterAtlas = atlas
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .aspectFit
                skView.presentScene(scene)
            })
        } else if (choose == 2) {
            let scene = TestJLFDemoPath1Scene.unarchive(from: "TestJLFDemoPath1Scene")
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFit
            skView.presentScene(scene)
            skView.ignoresSiblingOrder = true
        } else if (choose == 3) {
            let atlas = SKTextureAtlas(named: "Worlds")
            atlas.preload(completionHandler: {() -> Void in
                for name: String in atlas.textureNames {
                    //print("load texture: \(name)")
                    let texture: SKTexture = atlas.textureNamed(name)
                    texture.filteringMode = .nearest
                }
                let scene = TestJLFDemoPath2Scene(size: skView.bounds.size)
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .aspectFit
                skView.presentScene(scene)
                skView.ignoresSiblingOrder = true
            })
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .landscape
//        } else {
//            return .all
//        }
        return .all
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
