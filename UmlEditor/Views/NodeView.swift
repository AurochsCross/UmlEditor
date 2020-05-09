//
//  NodeView.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import Foundation
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
            
            if (node.content.protocolNames?.count ?? 0) > 0 {
                Divider()
                    .frame(width: 200)
                
                HStack {
                    Text("Protocols")
                        .bold()
                    Button(action: { self.copyProperties() }) {
                        Text("Copy")
                    }
                }
                VStack(alignment: .leading) {
                    ForEach(node.content.protocolNames!, id: \.self) { property in
                        Text("\(property)")
                    }
                }
            }
            
            if (node.content.properties?.count ?? 0) > 0 {
                Divider()
                    .frame(width: 200)
                
                HStack {
                    Text("Properties")
                        .bold()
                    Button(action: { self.copyProperties() }) {
                        Text("Copy")
                    }
                }
                VStack(alignment: .leading) {
                    ForEach(node.content.properties!) { property in
                        Text("\(property.accessLevelSymbol) \(property.nameWithoutIdentifier)")
                    }
                }
            }
            
            if (node.content.methods?.count ?? 0) > 0 {
                Divider()
                    .frame(width: 200)
                
                
                HStack {
                    Text("Methods")
                        .bold()
                    Button(action: { self.copyMethods() }) {
                        Text("Copy")
                    }
                }
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
    
    func copyProtocols() {
        let properties = node.content.properties?.reduce(into: "") { result, property in
            result += "\(property.accessLevelSymbol) \(property.name)\n"
        }
        
        //writeToClipBoard(properties)
    }
    
    func copyProperties() {
        let properties = node.content.properties?.reduce(into: "") { result, property in
            result += "\(property.accessLevelSymbol) \(property.nameWithoutIdentifier)\n"
        }
        
        writeToClipBoard(properties)
    }
    
    func copyMethods() {
        let methods = node.content.methods?.reduce(into: "") { result, method in
            result += "\(method.accessLevelSymbol) \(method.name)\n"
        }
        
        writeToClipBoard(methods)
    }
    
    private func writeToClipBoard(_ value: String?) {
        guard let value = value else { return }
        
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(value, forType: NSPasteboard.PasteboardType.string)
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView(node: MockData.nodes[0])
            .padding(20)
            .previewLayout(.sizeThatFits)
    }
}
