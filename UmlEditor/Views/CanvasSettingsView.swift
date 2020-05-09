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
    @Binding var searchText: String
    var onArrange: () -> () = { }
    var onSave: () -> () = { }
    var onNodeGroupSelected: (NodeGroup) -> () = { _ in }
    
    var nodeGroups: [NodeGroup]
    
    @Binding var selectedGroupId: UUID
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Groups")
                .padding(.horizontal)
            
            HStack {
                TextField("Filter", text: $searchText)
            }
            
            List {
                ForEach(nodeGroups) { group in
                    Text("\(group.name)").tag(group.id)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture { self.selectedGroupId = group.id }
                        .listRowBackground(group.id == self.selectedGroupId ? Color.blue : Color.clear)
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
            HStack(alignment: .center) {
                Button(action: { self.onSave() }) {
                    Text("Save")
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            Spacer()
        }
        .padding(.vertical)
        .padding(.horizontal)
        .frame(maxWidth: 400)
    }
}

struct CanvasSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasSettingsView(zoom: .constant(0.2), searchText: .constant(""), nodeGroups: [
            NodeGroup(name: "Lol", nodes: []),
            NodeGroup(name: "Big one", nodes: [])
        ],
           selectedGroupId: .constant(UUID()))
            .previewLayout(.fixed(width: 200, height: 400))
    }
}
