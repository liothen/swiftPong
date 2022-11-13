//
//  BallNode.swift
//  swiftPong
//
//  Created by Liothen on 11/13/22.
//

import Foundation
import SpriteKit

class BallNode: SKSpriteNode {
    var lastMissed: CourtSide = .none
    
    init() {
        let texture = SKTexture(imageNamed: "soccerBall")
        super.init(texture: texture, color: .white, size: CGSizeMake(25, 25))
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: frame.width / 2).ideal()
        self.physicsBody?.categoryBitMask = PhysicsCategory.ball
        self.physicsBody?.contactTestBitMask = PhysicsCategory.paddle
        self.physicsBody?.collisionBitMask = PhysicsCategory.paddle | PhysicsCategory.boundry
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetPosition() {
        lastMissed = .none
    }
    
    func setupPosition() {
        position = CGPoint(
            x: parent!.frame.midX,
            y: CGFloat.random(in: (0 + frame.width * 2)..<(parent!.frame.maxY - frame.width * 2))
        )
    }
    
    func serve() {
        let serveVector = lastMissed == .right ? CGVectorMake(-3, -3) : CGVectorMake(3, 3)
        physicsBody?.applyImpulse(serveVector)
    }
    
    func stop() {
        physicsBody?.velocity = CGVectorMake(0, 0)
    }
    
    func getSide() -> CourtSide {
        if position.x < 0 {
            lastMissed = .left
            return .left
        } else if position.x > CGRectGetMaxX(parent!.frame) {
            lastMissed = .right
            return .right
        } else {
            return .none
        }
    }
    
    func setVelocity(_ velocity: CGVector) {
        physicsBody?.velocity = velocity
    }
}
