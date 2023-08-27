//
//  ControlBar.swift
//  MyFlow
//  Created by Nate Tedesco on 1/19/23.
//

import SwiftUI

struct ControlBar: View {
    @AppStorage("showCreateFlow") var showCreateFlow: Bool = true
    @ObservedObject var model: FlowModel
    @Binding var mode: TimerMode
    @Binding var disable: Bool
    @AppStorage("ProAccess") var proAccess: Bool = false
    @AppStorage("showPayWall") var showPayWall = false
    
    var body: some View {
        ZStack {
            
            // Create Button
            if mode == .Initial {
                Button {
                    model.createFlow()
                    showCreateFlow = false
                } label: {
                    
                    ZStack {
                        Circle()
                            .frame(height: 48)
                            .foregroundStyle(.ultraThinMaterial.opacity(0.55))
                        Image(systemName: "plus")
                            .font(.title)
                    }
                }
                .background(.ultraThinMaterial.opacity(0.55))
                .disabled(mode != .Initial)
            }
            
            else {
                HStack(spacing: 72) {
                    Button {
                        if proAccess {
                            model.Restart()
                        }
                        else {
                            showPayWall = true
                        }
                    } label: {
                        Chevron(image: "chevron.left")
                    }
                    
                    Button { model.Reset()
                    } label: {
                        Image(systemName: "gobackward")
                            .font(Font.system(size: 20))
                    }
                    
                    Button {
                        if proAccess {
                            model.Skip()
                        }
                        else {
                            showPayWall = true
                        }
                    } label: {
                        Chevron(image: "chevron.right")
                    }
                }
                .padding(.top, 8)
            }
        }
        .cornerRadius(mode == .Initial ? 50 : 40)
        .myBlue()
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }
}

