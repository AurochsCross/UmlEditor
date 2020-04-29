//
//  ConnectionView.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import SwiftUI

struct ConnectionView: View {
    @ObservedObject var connection: Connection
    var offset: CGPoint = CGPoint()
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: connection.from.rendering.x + offset.x, y: connection.from.rendering.y + offset.y))
            path.addLine(to: CGPoint(x: connection.to.rendering.x + offset.x, y: connection.to.rendering.y + offset.y))
            
            path.addEllipse(in: centerRect())
        }
        .stroke(Color.black, lineWidth: 5)
    }
    
    private func centerRect() -> CGRect {
        let center = connection.pointOnBounds()
        return CGRect(origin: CGPoint(x: center.x + offset.x - 8, y: center.y + offset.y - 8), size: CGSize(width: 16, height: 16))
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView(
            connection: Connection(from: MockData.nodes[0], to: MockData.nodes[1])
        )
            .previewLayout(.sizeThatFits)
    }
}
