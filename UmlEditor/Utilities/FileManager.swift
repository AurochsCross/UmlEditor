//
//  FileManager.swift
//  UmlEditor
//
//  Created by Petras Malinauskas on 2020-04-29.
//  Copyright © 2020 AurochsDigital. All rights reserved.
//

import Foundation
import Cocoa

class FileManager {
    func save(puml: PumlData, preferedPath: URL? = nil, preferedName: String? = nil) {
        let dialog = NSSavePanel()
        
        dialog.title                   = "Choose a file| Our Code World";
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.directoryURL = preferedPath
        dialog.nameFieldStringValue = preferedName ?? "New Schema.puml"

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url

            if (result != nil) {
                do {
                    let data = try JSONEncoder().encode(puml)
                    try data.write(to: result!)
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        } else {
            // User clicked on "Cancel"
            return
        }
        
        
    }
}
