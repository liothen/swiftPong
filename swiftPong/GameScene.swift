//
//  GameScene.swift
//  swiftPong
//
//  Created by Liothen on 11/4/22.
//

import SpriteKit
import GameplayKit

// Game ends after 10
let maxScore = 10

// Enum for Which side of the Court
enum CourtSide {
    case none, right, left
}

// Game State :P
enum GameState {
    case stopped, started, gameOver
}

// Setup the physical property category
struct PhysicsCategory {
    static let ball         : UInt32 = 0x1 << 1
    static let paddle       : UInt32 = 0x1 << 2
    static let boundry      : UInt32 = 0x1 << 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var state = GameState.stopped
    var stateLabel = SKLabelNode(fontNamed: "Arial")
    var paddleSize = CGFloat(150)
    
    var rightScore = ScoreBoardNode(.right)
    var leftScore = ScoreBoardNode(.left)
    
    var rightPaddle = PaddleNode(.right, CGFloat(150))
    var leftPaddle = PaddleNode(.left, CGFloat(150))
    
    var ball = BallNode()
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard contact.bodyA.categoryBitMask == PhysicsCategory.paddle,
              contact.bodyB.categoryBitMask == PhysicsCategory.ball
        else { return }
        
        if let paddle = contact.bodyA.node as? PaddleNode {
            let vector = paddle.getContactReflectionVector(atContactPoint: contact.contactPoint)
            ball.setVelocity(vector)
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self

        // Add the fence in the middle
        addChild(FenceNode(
            from: CGPointMake(frame.midX, frame.minY),
            to: CGPointMake(frame.midX, frame.maxY)
        ))
        
        // Right Side
        addChild(CourtNode(
            from: CGPointMake(frame.minX, frame.maxY),
            to: CGPointMake(frame.maxX, frame.maxY)
        ))
        // Left Side
        addChild(CourtNode(
            from: CGPointMake(frame.minX, frame.minY),
            to: CGPointMake(frame.maxX, frame.minY)
        ))
        
        addChild(rightScore)
        rightScore.setupScoreBoard()
        
        addChild(leftScore)
        leftScore.setupScoreBoard()
        
        addChild(rightPaddle)
        rightPaddle.setupPosition()
        
        addChild(leftPaddle)
        leftPaddle.setupPosition()
        
        addChild(ball)
        ball.setupPosition()
        
        stateLabel.text = "⚽️ GAME OVER ⚽️"
        stateLabel.position = CGPointMake(frame.midX, frame.midY)
        
    }
    
    func start() {
        state = .started
        ball.serve()
    }
    
    func stop() {
        state = .stopped
        ball.stop()
    }
    
    func gameOver() {
        state = .gameOver
        addChild(stateLabel)
    }
    
    func reset() {
        stateLabel.removeFromParent()
        
        rightScore.resetScoreBoard()
        leftScore.resetScoreBoard()
        
        rightPaddle.resetPosition()
        leftPaddle.resetPosition()
        
        ball.resetPosition()
        
        stop()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if state == .stopped {
            start()
        } else if state == .gameOver {
            reset()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: scene!)
            if touchLocation.x < frame.midX {
                leftPaddle.position.y = touchLocation.y;
            } else {
                rightPaddle.position.y = touchLocation.y;
            }

        }
    }

    override func update(_ currentTime: TimeInterval) {
        let side = ball.getSide()
        
        if side != .none {
            stop()
            ball.setupPosition()
            
            let targetScore = side == .right ? leftScore : rightScore
            targetScore.increment()
            
            if targetScore.value == maxScore {
                gameOver()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.start()
                }
            }
        }
    }
}
