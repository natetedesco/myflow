//
//  SegmentedPicker.swift
//  MyFlow
//  Created by Nate Tedesco on 1/20/23.
//

import SwiftUI

struct SegmentedPicker: View {
    @Binding var simple: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            activeSegmentView
            HStack {
                FootNote(text: "Simple")
                    .foregroundColor(.white.opacity(0.95))
                    .padding(.vertical, 6)
                    .maxWidth()
                    .modifier(SizeAwareViewModifier(viewSize: self.$segmentSize))
                    .onTapGesture {
                        simple = true
//                        preventCrashFunc()
                    }
                FootNote(text: "Custom")
                    .foregroundColor(.white.opacity(0.95))
                    .padding(.vertical, 6)
                    .maxWidth()
                    .modifier(SizeAwareViewModifier(viewSize: self.$segmentSize))
                    .onTapGesture {
                        simple = false
//                        preventCrashFunc()
                    }
            }
        }
        .animation(.easeOut(duration: 0.3), value: simple)
        .padding(3.0)
        .background(.ultraThinMaterial.opacity(0.55))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.bottom, 8)
    }
    
    @State var segmentSize: CGSize = .zero
    private var activeSegmentView: AnyView {
        let isInitialized: Bool = segmentSize != .zero
        if !isInitialized { return EmptyView().eraseToAnyView() }
        return
            RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.black.opacity(0.55))
            .frame(width: self.segmentSize.width, height: self.segmentSize.height)
            .offset(x: CGFloat(simple ? 0 : 1) * (self.segmentSize.width + 16 / 2), y: 0)
            .eraseToAnyView()
    }
}

struct SizeAwareViewModifier: ViewModifier {
    @Binding var viewSize: CGSize
    init(viewSize: Binding<CGSize>) {
        self._viewSize = viewSize
    }
    
    func body(content: Content) -> some View {
        content
            .background(BackgroundGeometryReader())
            .onPreferenceChange(SizePreferenceKey.self, perform: { if self.viewSize != $0 { self.viewSize = $0 }})
    }
}

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    }
}

struct BackgroundGeometryReader: View {
    var body: some View {
        GeometryReader { geometry in
            return Color
                .clear
                .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}
