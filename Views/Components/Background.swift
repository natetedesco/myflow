//
//  Backgrounds.swift
//  MyFlow
//
//  Created by Nate Tedesco on 8/30/23.
//


import SwiftUI

extension View {
        func FlowViewBackGround() -> some View {
            let settings = AppSettings()

            return self
                .background(AnimatedBlur(opacity: settings.background ? 1.0 : 0.0).ignoresSafeArea(.keyboard))
        }
}

struct AnimatedBlur: View {
    @StateObject var theme = AppSettings()
    
    var offset: Bool = false

    var opacity: CGFloat
    let blur: CGFloat = 100
    var size: CGFloat = 1
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Cloud(proxy: proxy, color: .myColor, rotationStart: 0, duration: 100, size: size)
            }
            .blur(radius: blur)
            .ignoresSafeArea()
            .opacity(opacity)
        }
    }
}

struct Cloud: View {
    @StateObject var provider = CloudProvider()
    @State var move = false
    let proxy: GeometryProxy
    let color: Color
    let rotationStart: Double
    let duration: Double
    var size: CGFloat
    
    
    var body: some View {
        Circle()
//            .fill(color)
            .fill(Gradient(colors: [.cyan, .mint]))
            .frame(height: proxy.size.height /  provider.frameHeightRatio/size)
            .offset(provider.offset)

            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(0.3)
    }
}

class CloudProvider: ObservableObject {
    let offset: CGSize
    let frameHeightRatio: CGFloat
    
    
    init() {
        frameHeightRatio = CGFloat(1.5)
//        offset = CGSize(width: 0, height: 500)
        offset = CGSize(width: -100, height: -400)
    }
}
