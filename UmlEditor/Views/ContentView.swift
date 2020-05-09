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
    
    private let canvasSize: CGFloat = 1000000
    
    var body: some View {
        HStack {
            ZStack {
                GeometryReader { geometry in
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                        
                        ForEach(self.viewModel.connections, id: \.randomId) { connection in
                            ConnectionView(connection: connection, offset: CGPoint(x: self.canvasSize / 2, y: self.canvasSize / 2))
                        }
                        
                        ForEach(self.viewModel.visibleNodes) { node in
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
                    .offset(x: self.viewModel.canvasLocation.x, y: self.viewModel.canvasLocation.y)
                    .frame(width: self.canvasSize, height: self.canvasSize, alignment: .center)
                    .scaleEffect(self.viewModel.zoomLevel)
                    .gesture(DragGesture()
                        .onChanged { value in
                            self.viewModel.setCanvasLocation(value.location)
                        }
                        .onEnded { _ in
                            self.viewModel.finishedDragging()
                        })
                }
            }
            .clipped()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color(white: 1))
            
            CanvasSettingsView(
                zoom: $viewModel.zoomLevel,
                searchText: $viewModel.searchText,
                onArrange: { self.viewModel.arrangeNodes() },
                onSave: { self.viewModel.saveScheme() },
                nodeGroups: self.viewModel.visibleNodeGroups,
                selectedGroupId: self.$viewModel.selectedGroupId)
        }
        .frame(minWidth: 300, minHeight: 300, alignment: .topLeading)
        .onDrop(of: [(kUTTypeFileURL as String)], delegate: viewModel)
        .onAppear { self.viewModel.setup() }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
