//
//  AnimatedBackground.swift
//  MyFlow
//  Created by Nate Tedesco on 10/20/21.
//

import SwiftUI

struct AnimatedBlur: View {
    var opacity: CGFloat
    let blur: CGFloat = 100
    var size: CGFloat = 1
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ZStack {
                    Cloud(proxy: proxy, color: .myBlue, rotationStart: 0, duration: 60, size: size)
                    Cloud(proxy: proxy, color: .brown.opacity(0.7), rotationStart: 90, duration: 80, size: size)
                    Cloud(proxy: proxy, color: .teal, rotationStart: 180, duration: 80, size: size)
                    Cloud(proxy: proxy, color: .myBlue, rotationStart: 360, duration: 120, size: size)
                }
                .blur(radius: blur)
            }
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
            .fill(color)
            .frame(height: proxy.size.height /  provider.frameHeightRatio/size)
            .offset(provider.offset)
            .rotationEffect(.init(degrees: move ? rotationStart : rotationStart + 360) )
            .animation(Animation.linear(duration: duration).repeatForever(autoreverses: false), value: move)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(0.8)
            .onAppear {
                move.toggle()
            }
        
    }
}

class CloudProvider: ObservableObject {
    let offset: CGSize
    let frameHeightRatio: CGFloat
    
    init() {
        frameHeightRatio = CGFloat.random(in: 1.0 ..< 2.0)
        offset = CGSize(width: CGFloat.random(in: -150 ..< 150),
                        height: CGFloat.random(in: -150 ..< 150))
    }
}
