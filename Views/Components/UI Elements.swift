//
//  Title.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI




struct CustomHeadline: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.white)
            .fontWeight(.semibold)
            .padding(.leading)
            .padding(.top)
            .leading()
    }
}

struct Chevron: View {
    var image: String
    var body: some View {
        Image(systemName: image)
            .font(Font.system(size: 20))
            .padding(.horizontal, 4)
    }
}

//struct MaterialBackGround: View {
//    var body: some View {
//        Toolbar(model: FlowModel())
//        Color.clear.opacity(0.0).ignoresSafeArea()
//            .background(.ultraThinMaterial)
//    }
//}
