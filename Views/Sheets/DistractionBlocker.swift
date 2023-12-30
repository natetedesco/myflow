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
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            NavigationStack {
                List {
                    Section {
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
                        }
                        
                        if settings.isAuthorized && settings.blockDistractions {
                            Button {
                                settings.activityPresented = true
                            } label: {
                                HStack {
                                    Label("Blocked", systemImage: "xmark.app")
                                    Spacer()
                                    Text(settings.activitySelection.applicationTokens.count == 0 ? "0 Apps" : "^[\(settings.activitySelection.applicationTokens.count) App](inflect: true)")
                                        .foregroundStyle(.tertiary)
                                    Image(systemName: "chevron.right")
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.tertiary)
                                        .foregroundStyle(.white)
                                }
                            }
                            .familyActivityPicker(isPresented: $settings.activityPresented, selection: $settings.activitySelection)
                        }
                    } footer: {
                        Text("You will not have access to these apps during flow")
                    }
                }
                .navigationTitle("Distraction Blocker").navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Done")
                        }
                    }
                }
                .listStyle(.inset)
                .environment(\.defaultMinListRowHeight, 52)
                .background(Color.clear)
            }
        }
        .tint(.teal)
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
