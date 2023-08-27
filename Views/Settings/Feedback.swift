//
//  Feedback.swift
//  MyFlow
//  Created by Nate Tedesco on 1/20/23.
//

import SwiftUI

struct Feedback: View {
    var body: some View {
        NavigationView {
            
        VStack {
            Text("Please email feedback or support to natetedesco@icloud.com ")
                .padding(.horizontal, 32)
                .padding(.top, 64)
            Spacer()
        }
        }
        .navigationTitle("Feedback & Support")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Feedback_Previews: PreviewProvider {
    static var previews: some View {
        Feedback()
    }
}
