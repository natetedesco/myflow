//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct FlowView: View {
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    @ObservedObject var model: FlowModel
    @State var selectedFlow: Flow?
    
    var body: some View {
        ZStack {
            FlowMenu(model: model, selectedFlow: $selectedFlow)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top)
            
            Controls(model: model)
                .padding(.bottom, 500)
            
            ContinueButton(model: model)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top)
            
            Circles(model: model)
            
            TimerLabels(model: model)
            
            Rounds(model: model)
                .padding(.top, 110)
        }
        .modifier(CustomSheet(model: model, selectedFlow: $selectedFlow))
    }
}

struct FlowView_Previews: PreviewProvider {
    static var previews: some View {
        FlowView(model: FlowModel())
    }
}

