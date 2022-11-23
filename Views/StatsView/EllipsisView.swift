//
//  EllipsisView.swift
//  MyFlow
//
//  Created by Nate Tedesco on 9/15/22.
//

import SwiftUI

struct EllipsisView: View {
    var body: some View {
        HStack {
            Image(systemName: "ellipsis")
                .foregroundColor(.myBlue)
                .font(.headline)
                .padding()
                .background(Circle().fill(.ultraThinMaterial))
            Image(systemName: "plus")
                .foregroundColor(.myBlue)
                .font(.headline)
                .padding(11)
                .background(Circle().fill(.ultraThinMaterial))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AnimatedBlur())
    }
}

struct EllipsisView_Previews: PreviewProvider {
    static var previews: some View {
        EllipsisView()
    }
}
