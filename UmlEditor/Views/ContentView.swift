//
//  ContentView.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        HStack {
            ScrollView([.horizontal, .vertical]) {
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .border(Color.black, width: 1.0)
                        
                    ForEach(viewModel.connections, id: \.randomId) { connection in
                        ConnectionView(connection: connection, offset: CGPoint(x: 5000, y: 5000))
                    }
                    
                    ForEach(viewModel.nodes) { node in
                        NodeView(node: node)
                            .offset(x: node.rendering.x, y: node.rendering.y)
                            .onTapGesture {
                                self.viewModel.selectNode(node)
                            }
                            .gesture(DragGesture()
                                .onChanged { value in
                                    self.viewModel.setLocation(ofNode: node, x: value.location.x, y: value.location.y)
                                }
                                .onEnded { _ in
                                    self.viewModel.finishedDragging()
                                })
                    }
                }
                .frame(width: 10000, height: 10000, alignment: .center)
                .scaleEffect(viewModel.zoomLevel)
                .background(Color(white: 1))
            }
            
            CanvasSettingsView(
                zoom: $viewModel.zoomLevel,
                onArrange: { self.viewModel.arrangeNodes() },
                onSave: { self.viewModel.saveScheme() })
        }
        .frame(minWidth: 300, minHeight: 300, alignment: .topLeading)
        .onDrop(of: [(kUTTypeFileURL as String)], delegate: viewModel)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
