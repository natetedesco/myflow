//
//  ShowFocusByDefault.swift
//  MyFlow
//
//  Created by Nate Tedesco on 12/21/23.
//

import SwiftUI

struct ShowFocusByDefault: View {
    @State var model: FlowModel
    @AppStorage("showFocusByDefault") var showFocusByDefault = true
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            VStack {
                VStack(alignment: .center) {
                    
                    Spacer()
                    Text("Show Focus View by Default?")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    
                    Text("Focus View displays your current focus. You can change this later in settings.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                    
                    Spacer()
                    
                    Button {
                        showFocusByDefault = false
                        model.settings.focusOnStart = true
                        dismiss()
                    } label: {
                        Text("Set as Default")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.teal)
                            .cornerRadius(16)
                    }
                    
                    Button {
                        showFocusByDefault = false
                        model.settings.focusOnStart = false
                    } label: {
                        Text("Keep List View as Default")
                            .font(.footnote)
                            .padding(.top, 12)
                    }
                }
                .padding(.horizontal, 32)
            }
        }
    }
}

#Preview {
    ZStack {}
        .sheet(isPresented: .constant(true), content: {
            ShowFocusByDefault(model: FlowModel())
                .sheetMaterial()
                .presentationDetents([.fraction(3/10)])
        })
}
