//
//  MockData.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import Foundation

class MockData {
    static let nodes: [Node] = [
    Node(x: 0, y: 0,
         content: UMLElement(
            id: 0,
            typeString: .typeStringClass,
            properties: [],
            methods: [],
            name: "Test 1",
            superClass: 0,
            cases: [],
            containedEntities: nil,
            protocols: nil,
            extensions: nil)),
        Node(x: 0, y: 0,
             content: UMLElement(
                id: 1,
                typeString: .typeStringClass,
                properties: [],
                methods: [],
                name: "Test Child",
                superClass: 0,
                cases: [],
                containedEntities: nil,
                protocols: nil,
                extensions: nil)),
        Node(x: 0, y: 0,
             content: UMLElement(
                id: 2,
                typeString: .typeStringClass,
                properties: [],
                methods: [],
                name: "Test Other",
                superClass: nil,
                cases: [],
                containedEntities: nil,
                protocols: nil,
                extensions: nil)),
    
    ]
}
