//
//  DistractionBlocker.swift
//  MyFlow
//  Created by Nate Tedesco on 12/29/23.
//

import SwiftUI
import FamilyControls

struct DistractionBlocker: View {
    @State var model: FlowModel
    @StateObject var settings = Settings()
    @AppStorage("ProAccess") var proAccess: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if !settings.isAuthorized {
                    Button {
                        settings.authorizeScreenTime()
                    } label: {
                        HStack {
                            Label("App Blocker", systemImage: "shield")
                            Spacer()
                            Text("Authorize")
                                .foregroundColor(.teal)
                                .font(.callout)
                        }
                    }
                } else {
                    Toggle(isOn: proAccess ? $settings.blockDistractions : $model.showPayWall) {
                        Label("App Blocker", systemImage: "shield")
                    }
                    .tint(.teal)
                    .padding(.bottom, 8)
                }
                
                if settings.isAuthorized && settings.blockDistractions {
                    Divider()
                    Button {
                        settings.activityPresented = true
                    } label: {
                        HStack {
                            Label("Blocked", systemImage: "xmark.app")
                                .foregroundStyle(.white)
                            Spacer()
                            Text(settings.activitySelection.applicationTokens.count == 0 ? "0 Apps" : "^[\(settings.activitySelection.applicationTokens.count) App](inflect: true)")
                                .foregroundStyle(.white.tertiary)
                            Image(systemName: "chevron.right")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.tertiary)
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    .familyActivityPicker(isPresented: $settings.activityPresented, selection: $settings.activitySelection)
                }
            }
            .padding()
            .background(.black.opacity(0.5))
            .background(.bar)
            .cornerRadius(24)
            .padding(.horizontal)
//            .navigationTitle("Distraction Blocker")
//            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        MainView(model: FlowModel())
    }
    .sheet(isPresented: .constant(true)) {
        DistractionBlocker(model: FlowModel())
            .sheetMaterial()
            .presentationDetents([.fraction(3/10)])
    }
}
