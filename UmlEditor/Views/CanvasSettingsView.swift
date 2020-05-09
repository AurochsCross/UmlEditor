//
//  CanvasSettingsView.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import SwiftUI

struct CanvasSettingsView: View {
    @Binding var zoom: CGFloat
    var onArrange: () -> () = { }
    var onSave: () -> () = { }
    var onNodeGroupSelected: (NodeGroup) -> () = { _ in }
    
    var nodeGroups: [NodeGroup]
    
    @Binding var selectedGroupId: UUID
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Canvas")
                .font(.system(.title))
                .padding(.horizontal)
                .padding(.bottom)
            
            Text("Groups")
                .padding(.horizontal)
            Picker(selection: $selectedGroupId, label: Text("Group")) {
                ForEach(nodeGroups) { group in
                    Text("\(group.name)").tag(group.id)
                }
            }
            
            Text("Zoom")
                .padding(.horizontal)
            HStack {
                Slider(value: $zoom, in: 0...2)
                TextField("0 - 2", text: Binding(get: { "\(self.zoom)"}, set: { self.zoom = CGFloat(Double($0) ?? 1.0) }))
                    .multilineTextAlignment(.trailing)
                    .frame(width: 50)
            }
            .padding(.horizontal)
            Divider()
            Button(action: { self.onArrange() }) {
                Text("Arrange")
            }
            .frame(maxWidth: .infinity)
            
            
            Divider()
            HStack(alignment: .center) {
                Button(action: {  }) {
                    Text("Load")
                }
                Button(action: { self.onSave() }) {
                    Text("Save")
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            Spacer()
        }
        .padding(.vertical)
        .frame(maxWidth: 200)
    }
}

struct CanvasSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasSettingsView(zoom: .constant(0.2), nodeGroups: [
            NodeGroup(name: "Lol", nodes: []),
            NodeGroup(name: "Big one", nodes: [])
        ],
           selectedGroupId: .constant(UUID()))
            .previewLayout(.fixed(width: 200, height: 400))
    }
}
