//
//  TestJLFDemo1Scene.swift
//  JLFGameKit
//
//  Ported by morph85 on 19/06/2017.
//  Copyright © 2017 test. All rights reserved.
//

import SpriteKit

class TestJLFDemo1Scene: SKScene {
    
    static func unarchive(from file: String) -> TestJLFDemo1Scene {
        /* Retrieve scene file path from the application bundle */
        let nodePath: String = Bundle.main.path(forResource: file, ofType: "sks")!
        let nodeUrl: URL = URL.init(fileURLWithPath: nodePath)
        /* Unarchive the file to an SKScene object */
        let data = try? Data(contentsOf: nodeUrl, options: .mappedIfSafe)
        let arch = NSKeyedUnarchiver(forReadingWith: data!)
        arch.setClass(TestJLFDemo1Scene.self, forClassName: "TestJLFDemo1Scene")
        let scene: TestJLFDemo1Scene = arch.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! TestJLFDemo1Scene
        arch.finishDecoding()
        return scene
    }
    
    var characterAtlas: SKTextureAtlas?
    var playerEntity: JLFGKEntity?
    var otherCharacters = [JLFGKEntity]()
    var isClickActive: Bool = false
    var clickLocation = CGPoint.zero
    var lastUpdateTime = CFTimeInterval()
    
    override func didMove(to view: SKView) {
        playerEntity = makeCharacterEntity(withBaseTextureName: "woman")
        let playerSprite: SKSpriteNode = ((playerEntity?.component(for: SpriteComponent.self) as? SpriteComponent)?.sprite)!
        let playerStart: SKNode = childNode(withName: "player_start")!
        playerSprite.position = playerStart.position
        addChild(playerSprite)
        playerStart.removeFromParent()
        // Create the other characters
        otherCharacters = [JLFGKEntity]()
        self.enumerateChildNodes(withName: "character*", using: {(_ node: SKNode, _ stop: UnsafeMutablePointer <ObjCBool>) in
            let baseTexture: String = node.name!.replacingOccurrences(of: "character_", with: "")
            let entity: JLFGKEntity = self.makeCharacterEntity(withBaseTextureName: baseTexture)
            entity.add(WanderComponent())
            self.otherCharacters.append(entity)
            let sprite: SKSpriteNode? = (entity.component(for: SpriteComponent.self) as? SpriteComponent)?.sprite
            sprite?.position = node.position
            self.addChild(sprite!)
            node.removeFromParent()
        })
        self.enumerateChildNodes(withName: "bouncer", using: {(node: SKNode, _ stop: UnsafeMutablePointer <ObjCBool>) in
            let entity: JLFGKEntity = self.makeBouncer()
            self.otherCharacters.append(entity)
            let sprite: SKSpriteNode? = (entity.component(for: SpriteComponent.self) as? SpriteComponent)?.sprite
            sprite?.position = node.position
            self.addChild(sprite!)
            node.removeFromParent()
        })
    }
    
//    func mouseDown(with theEvent: NSEvent) {
//        let component = (playerEntity?.component(for: MoveComponent.self) as? MoveComponent)
//        if component != nil {
//            let location: CGPoint = theEvent.location(inNode: self)
//            component?.isMoving = true
//            component?.moveTarget = location
//        }
//        else {
//            print("mouseDown: Missing player movement component.")
//        }
//    }
//    
//    func mouseDragged(with theEvent: NSEvent) {
//        let component = (playerEntity?.component(for: MoveComponent.self) as? MoveComponent)
//        if component != nil {
//            let location: CGPoint = theEvent.location(inNode: self)
//            component?.isMoving = true
//            component?.moveTarget = location
//        }
//    }
//    
//    func mouseUp(with theEvent: NSEvent) {
//        let component = (playerEntity?.component(for: MoveComponent.self) as? MoveComponent)
//        if component != nil {
//            component?.isMoving = false
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.count <= 0) {
            return;
        }
        
        let touch: UITouch = touches.first!
        let location = touch.location(in: self)
        
        let component = (playerEntity?.component(for: MoveComponent.self) as? MoveComponent)
        if component != nil {
            component?.isMoving = true
            component?.moveTarget = location
        }
        else {
            print("mouseDown: Missing player movement component.")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.count <= 0) {
            return;
        }
        
        let touch: UITouch = touches.first!
        let location = touch.location(in: self)
        
        let component = (playerEntity?.component(for: MoveComponent.self) as? MoveComponent)
        if component != nil {
            component?.isMoving = true
            component?.moveTarget = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.count <= 0) {
            return;
        }
        
        let touch: UITouch = touches.first!
        let _ = touch.location(in: self)
        
        let component = (playerEntity?.component(for: MoveComponent.self) as? MoveComponent)
        if component != nil {
            component?.isMoving = false
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        let lastUpdate: CFTimeInterval = lastUpdateTime
        lastUpdateTime = currentTime
        let deltaTime: CFTimeInterval = currentTime - lastUpdate
        if deltaTime < 1.0 {
            playerEntity?.update(withDeltaTime: deltaTime)
            for entity: JLFGKEntity in otherCharacters {
                entity.update(withDeltaTime: deltaTime)
            }
        }
    }
    
    func makeCharacterEntity(withBaseTextureName baseTextureName: String) -> JLFGKEntity {
        let sprite = SKSpriteNode(imageNamed: "\(baseTextureName)-stand-down")
        let sizeBeforeScale: CGSize = sprite.size
        sprite.xScale = 2.5
        sprite.yScale = 2.5
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(sprite.size.width), height: CGFloat(sprite.size.height / 2.0)), center: CGPoint(x: CGFloat(0.0), y: CGFloat(-sizeBeforeScale.height * 0.75)))
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.allowsRotation = false
        let spriteComponent = SpriteComponent()
        spriteComponent.sprite = sprite
        let moveComponent = MoveComponent()
        let animComponent = CharacterAnimationComponent(baseTextureName: baseTextureName, characterAtlas: characterAtlas!)
        let entity = JLFGKEntity.entity()
        entity.add(spriteComponent)
        entity.add(moveComponent)
        entity.add(animComponent)
        return entity
    }
    
    func makeBouncer() -> JLFGKEntity {
        let sprite = SKSpriteNode(imageNamed: "ranger-right")
        let sizeBeforeScale: CGSize = sprite.size
        sprite.xScale = 2.5
        sprite.yScale = 2.5
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(sprite.size.width), height: CGFloat(sprite.size.height / 2.0)), center: CGPoint(x: CGFloat(0.0), y: CGFloat(-sizeBeforeScale.height * 0.75)))
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.allowsRotation = false
        let spriteComponent = SpriteComponent()
        spriteComponent.sprite = sprite
        let bounceComponent = BouncyAnimationComponent(baseTextureName: "ranger", characterAtlas: characterAtlas!)
        let entity = JLFGKEntity.entity()
        entity.add(spriteComponent)
        entity.add(MoveComponent())
        entity.add(bounceComponent)
        entity.add(WanderComponent())
        return entity
    }
}
