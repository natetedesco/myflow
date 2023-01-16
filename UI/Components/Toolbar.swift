//
//  Toolbar.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct Toolbar: View {
    @ObservedObject var model: FlowModel = FlowModel()
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    
    var body: some View {
        HStack {
            
            // Statistics
            Button { selectedTab = Tab.data }
            label: { ToolBarButton(
                image: "chart.bar.fill",
                size: 25, padding: 5,
                selected: selectedTab == .data ? true : false)
            }
            
            Spacer()
            
            // Home Button
            StartButton(model: model)
                .padding(.bottom, 25)
            
            Spacer()
            
            // Settings
            Button { selectedTab = Tab.settings }
            label: { ToolBarButton(
                image: "person.fill",
                size: 30, padding: 5,
                selected: selectedTab == .settings ? true : false)
            }
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
    var selected: Bool
    
    var body: some View {
        if selected {
            Image(systemName: image)
                .font(Font.system(size: size))
        .frame(width: 60, height: 20)
        .padding(.top, 40)
        .myBlue()
    }
        else {
            Image(systemName: image)
                .font(Font.system(size: size))
        .frame(width: 60, height: 20)
        .padding(.top, 40)
        .foregroundStyle(.thinMaterial)
        }
    }
}

