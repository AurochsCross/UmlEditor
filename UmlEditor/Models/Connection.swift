//
//  Connection.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import Foundation
import Combine

class Connection: ObservableObject, Identifiable {
    var randomId: UUID { UUID() }
    let id = UUID()
    @Published var from: Node
    @Published var to: Node
    
    init(from: Node, to: Node) {
        self.from = from
        self.to = to
    }
    
    func centerPoint() -> CGPoint {
        pointBetween(value: 0.5)
    }
    
    func pointBetween(value: CGFloat) -> CGPoint {
        
        var clampedValue: CGFloat = value > 1 ? 1 : value
        clampedValue = clampedValue < 0 ? 0 : clampedValue
        
        let x = from.rendering.x * (1.0 - clampedValue) + to.rendering.x * clampedValue
        let y = from.rendering.y * (1.0 - clampedValue) + to.rendering.y * clampedValue
        
        return CGPoint(x: x, y: y)
    }
    
    
    
    func pointOnBounds() -> CGPoint {
        let direction = CGVector(dx: from.rendering.x - to.rendering.x, dy: from.rendering.y - to.rendering.y).normalized
        let size = CGSize(width: to.rendering.width / 2.0, height: to.rendering.height / 2.0)
        let y = size.width * direction.dy / direction.dx
        if abs(y) < size.height {
            return CGPoint(x: to.rendering.x + (size.width * (direction.dx > 0 ? 1 : -1)), y: to.rendering.y + (y * (direction.dx > 0 ? 1 : -1)))
        }
        let x = size.height * direction.dx / direction.dy
        return CGPoint(x: to.rendering.x + x * (direction.dy > 0 ? 1 : -1), y: to.rendering.y + size.height * (direction.dy > 0 ? 1 : -1))
    }
}

extension CGVector {
    var magnitude: CGFloat { sqrt((dx * dx) + (dy * dy)) }
    var normalized: CGVector {
        CGVector(dx: dx / magnitude, dy: dy / magnitude)
    }
}
