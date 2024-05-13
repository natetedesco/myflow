//
//  SendFeedbackView.swift
//  MyFlow
//
//  Created by Developer on 5/5/24.
//

import SwiftUI

struct SendFeedbackView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ZStack {}
        .sheet(isPresented: .constant(true)) {
            SendFeedbackView()
                .sheetMaterial()
                .presentationDetents([.medium])
        }
}
