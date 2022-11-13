//
//  ScoreBoardNode.swift
//  swiftPong
//
//  Created by Liothen on 11/13/22.
//

import Foundation
import SpriteKit

class ScoreBoardNode: SKLabelNode {
    let marginTop: CGFloat = 35
    let marginLeft: CGFloat = 70
    
    var side: CourtSide
    
    var value: Int {
        didSet {
            self.text = "\(value)"
        }
    }
    
    init(_ courtSide: CourtSide) {
        self.value = 0
        self.side = courtSide
        super.init()
        
        self.text = "0"
        self.fontSize = 60
        self.fontName = "Arial"
        self.color = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetScoreBoard() {
        self.value = 0
    }
    
    func setupScoreBoard() {
        guard let parentFrame = parent?.frame else { fatalError("node must have parent") }
        
        switch (side) {
            case .right:
                self.position = CGPointMake(parentFrame.midX + marginLeft, parentFrame.maxY - (fontSize + marginTop))
            case .left:
                self.position = CGPointMake(parentFrame.midX - marginLeft, parentFrame.maxY - (fontSize + marginTop))
            default:
                fatalError("node must be .left or .right")
        }
    }
    
    func increment() {
        self.value += 1
    }
}
