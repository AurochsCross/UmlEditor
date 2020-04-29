//
//  NodeView.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import SwiftUI

struct NodeView: View {
    var node: Node
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 0) {
                Text("\(node.content.name ?? "-"): ")
                Text("\(node.content.typeString.rawValue)")
                    .italic()
            }
                .font(.system(.title))
            
            if (node.content.properties?.count ?? 0) > 0 {
                Divider()
                    .frame(width: 200)
                
                Text("Properties")
                    .bold()
                VStack(alignment: .leading) {
                    ForEach(node.content.properties!) { property in
                        Text("\(property.accessLevelSymbol) \(property.name)")
                    }
                }
            }
            
            if (node.content.methods?.count ?? 0) > 0 {
                Divider()
                    .frame(width: 200)
                
                
                Text("Methods")
                    .bold()
                VStack(alignment: .leading) {
                    ForEach(node.content.methods!) { property in
                        Text("\(property.accessLevelSymbol) \(property.name)")
                    }
                }
            }
        }
        .foregroundColor(.black)
        .padding(10)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 2)
        )
        .overlay(
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear {
                        self.node.rendering.width = geometry.size.width
                        self.node.rendering.height = geometry.size.height
                    }
            }
        )
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView(node: MockData.nodes[0])
            .padding(20)
            .previewLayout(.sizeThatFits)
    }
}
