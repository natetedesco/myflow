//
//  DistractionBlocker.swift
//  MyFlow
//  Created by Nate Tedesco on 12/29/23.
//

import SwiftUI
import FamilyControls

struct DistractionBlocker: View {
    @State var model: FlowModel
    @State var activityPresented = false
    
    @State var showPayWall = false
    @State var detent = PresentationDetent.fraction(6/10)
    
    @AppStorage("ProAccess") var proAccess: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                Spacer()
                
                if !model.settings.isAuthorized {
                    Text("Authorize ScreenTime")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    Text("MyFlow does not collect any user data.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                } else {
                    
                    VStack {
                        Toggle(isOn: proAccess ? $model.settings.blockDistractions : $showPayWall) {
                            Label("App Blocker", systemImage: "shield.fill")
                        }
                        .tint(.teal)
                        .padding(.bottom, 8)
                        
                        Divider()
                            .padding(.horizontal, -16)
                        
                        Button {
                            activityPresented = true
                        } label: {
                            HStack {
                                Label("Blocked Apps", systemImage: "xmark.app.fill")
                                    .foregroundStyle(.white)
                                Spacer()
                                Text(model.settings.activitySelection.applicationTokens.count == 0 ? "0 Apps" : "^[\(model.settings.activitySelection.applicationTokens.count) App](inflect: true)")
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
                        .familyActivityPicker(isPresented: $activityPresented, selection: $model.settings.activitySelection)
                        .onChange(of: model.settings.activitySelection) { oldValue, newValue in
                            model.settings.saveActivitySelection()
                        }
                    }
                    .padding()
                    .background(.black.opacity(0.3))
                    .cornerRadius(24)
                    
                    Text("These apps will be blocked during focus blocks and cannot be changed during flow.")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                Button {
                    if !model.settings.isAuthorized {
                        model.settings.authorizeScreenTime()
                    } else {
                        model.settings.saveActivitySelection()
                        dismiss()
                    }
                } label: {
                    Text(model.settings.isAuthorized ? "Done" : "Authorize")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.teal)
                        .cornerRadius(20)
                        .padding(.horizontal, 4)
                }
            }
            .padding(.horizontal, 24)
            .navigationTitle("Distraction Blocker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {}
        }
        .sheet(isPresented: $showPayWall) {
            PayWall(detent: $detent)
                .sheetMaterial()
                .presentationDetents([.large, .fraction(6/10)], selection: $detent)
                .interactiveDismissDisabled(detent == .large)
                .presentationDragIndicator(.hidden)
                .presentationBackgroundInteraction(.enabled)
        }
    }
}

#Preview {
    ZStack {
        FlowView(model: FlowModel())
    }
    .sheet(isPresented: .constant(true)) {
        DistractionBlocker(model: FlowModel())
            .sheetMaterial()
            .presentationDetents([.medium])
    }
}
