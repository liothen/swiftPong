//
//  PaddleNode.swift
//  swiftPong
//
//  Created by Liothen on 11/13/22.
//

import SpriteKit

class PaddleNode: SKSpriteNode {
    let courtSide: CourtSide
    var paddleSize = CGFloat(150)
    
    init(_ courtSide: CourtSide, _ paddleSize: CGFloat) {
        self.courtSide = courtSide
    
        // Initialize the paddle
        super.init(texture: nil, color: .white, size: CGSizeMake(20, paddleSize))
    
        // Set the physics of paddle
        self.physicsBody = SKPhysicsBody(rectangleOf: size).manualMovement()
        self.physicsBody?.categoryBitMask = PhysicsCategory.paddle
        self.physicsBody?.collisionBitMask = PhysicsCategory.ball
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Initial positions
    func setupPosition() {
        guard let parentFrame = parent?.frame else { fatalError("node must have parent") }
                
        resetPosition()
        
        let movementConstraint = SKConstraint.positionY(
            SKRange(
                lowerLimit: parentFrame.minY + size.height/2,
                upperLimit: parentFrame.maxY - size.height/2
            )
        )
        
        self.constraints = [movementConstraint]
    }
    
    // Reset position
    func resetPosition() {
        guard let parentFrame = parent?.frame else { fatalError("node must have parent") }
        
        switch (courtSide) {
            case .right:
                self.position = CGPointMake(parentFrame.maxX - (size.width/2), parentFrame.midY)
            case .left:
                self.position = CGPointMake(parentFrame.minX + (size.width/2), parentFrame.midY)
            case .none:
                fatalError("You need to either be left or right CourtSide")
        }
    }

    // Source: https://gamedev.stackexchange.com/a/4255
    func getContactReflectionVector(atContactPoint: CGPoint) -> CGVector {
        let convertedPoint = convert(atContactPoint, from: parent!)
        let relIntersectY = anchorPoint.y - convertedPoint.y
        let normRelIntersectY = relIntersectY / (size.height / 2)
        
        var bounceAngle = normRelIntersectY * 60 * CGFloat.pi / 180
        if self.courtSide == .right {
            bounceAngle = CGFloat.pi - bounceAngle
        }
        
        let ballVectorX = 500 * cos(bounceAngle);
        let ballVectorY = 500 * -sin(bounceAngle);
        
        return CGVectorMake(ballVectorX, ballVectorY)
    }
}
