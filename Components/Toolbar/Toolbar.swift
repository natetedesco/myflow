//
//  Toolbar.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct Toolbar: View {
    @ObservedObject var model: FlowModel
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    
    var body: some View {
        HStack {
            
//            if model.mode != .flowRunning {
                
            // Statistics
            Button( action: { selectedTab = Tab.data },
                    label: { ToolBarButton(
                        image: "chart.bar.fill",
                        size: 25, padding: 5,
                        color: selectedTab == .data ? .myBlue : .gray.opacity(0.5)
                    )
            })
            
            Spacer()
            
            // Flow Button
            VStack {
                if selectedTab == Tab.data || selectedTab == Tab.settings {
                    Button( action: { selectedTab = Tab.home },
                            label: { FlowButton()})
                } else {
                    ButtonView(model: model)
                }
            }.padding(.bottom, 25)
            
            Spacer()
            
            // Settings
            Button( action: { selectedTab = Tab.settings },
                    label: { ToolBarButton(
                        image: "person.fill",
                        size: 30, padding: 5,
                        color: selectedTab == .settings ? .myBlue : .gray.opacity(0.5)
                    )
            })
//            }
        }
        .padding([.leading, .trailing], 30.0)
        .frame(height: 65.0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}

struct ToolBarButton: View {
    var image: String
    var size: CGFloat
    var padding: CGFloat = 5.0
    var color: Color
    
    var body: some View {
        VStack {
            Image(systemName: image)
                .font(Font.system(size: size))
        }
        .frame(width: 60, height: 20)
        .padding(.top, 40)
        .foregroundColor(color)
    }
}

