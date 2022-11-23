//
//  Refractor.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/22.
//

import SwiftUI


struct VersionNumber: View {
    var text: String
    
    var body: some View {
        
        Text(text)
            .foregroundColor(.myBlue)
            .padding(32)
            .kerning(2.0)
    }
}


