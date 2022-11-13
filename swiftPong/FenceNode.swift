//
//  FenceNode.swift
//  swiftPong
//
//  Created by Liothen on 11/13/22.
//

import Foundation
import SpriteKit

class FenceNode: SKShapeNode {
    override init() {
        super.init()
    }
    
    convenience init(from: CGPoint, to: CGPoint) {
        self.init()
        
        let shapePath = CGMutablePath()
        shapePath.move(to: from)
        shapePath.addLine(to: to)
        
        self.path = shapePath.copy(dashingWithPhase: 1, lengths: [20, 6])
        self.strokeColor = .gray
        self.lineWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
