//
//  ControlBar.swift
//  MyFlow
//  Created by Nate Tedesco on 1/19/23.
//

import SwiftUI

struct ControlBar: View {
    @AppStorage("showYourFlowHasBeenAdded") var showYourFlowHasBeenAdded: Bool = false
    @ObservedObject var model: FlowModel
    @Binding var mode: TimerMode
    @Binding var disable: Bool
    
    var body: some View {
        ZStack {
            
            // Create Button
            if mode == .Initial {
                Button {
                    model.createFlow()
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                }
                .padding(.vertical, 12) // perfect circle
                .padding(.horizontal, 10)
                .background(.ultraThinMaterial.opacity(0.55))
                .disabled(mode != .Initial)
            }
            
            else {
                HStack(spacing: 72) {
                    Button { model.Restart()
                    } label: {
                        Chevron(image: "chevron.left")
                    }
                    
                    Button { model.Reset()
                    } label: {
                        Image(systemName: "gobackward")
                            .font(Font.system(size: 20))
                    }
                    
                    Button { model.Skip()
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

