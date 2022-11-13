//
//  CourtNode.swift
//  swiftPong
//
//  Created by Liothen on 11/13/22.
//

import Foundation
import SpriteKit

class CourtNode: SKSpriteNode {
    
    init(from: CGPoint, to: CGPoint) {
        super.init(texture: nil, color: .clear, size: .zero)
    
        self.physicsBody = SKPhysicsBody(edgeFrom: from, to: to).manualMovement()
        self.physicsBody?.categoryBitMask = PhysicsCategory.boundry
        self.physicsBody?.collisionBitMask = PhysicsCategory.ball
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
