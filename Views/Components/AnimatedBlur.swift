//
//  AnimatedBackground.swift
//  MyFlow
//  Created by Nate Tedesco on 10/20/21.
//

import SwiftUI

struct AnimatedBlur: View {
    @StateObject var theme = AppSettings()

    var opacity: CGFloat
    let blur: CGFloat = 100
    var size: CGFloat = 1
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Cloud(proxy: proxy, color: .myColor, rotationStart: 180, duration: 120, size: size)
                Cloud(proxy: proxy, color: .myColor, rotationStart: 0, duration: 60, size: size)
                Cloud(proxy: proxy, color: .brown.opacity(0.6), rotationStart: 90, duration: 80, size: size)
                Cloud(proxy: proxy, color: .teal, rotationStart: 180, duration: 80, size: size)
                Cloud(proxy: proxy, color: .myColor, rotationStart: 360, duration: 120, size: size)
                Cloud(proxy: proxy, color: .myColor, rotationStart: 360, duration: 120, size: size)

            }
            .blur(radius: blur)
            .opacity(0.2)
            .ignoresSafeArea()
            .background(.ultraThinMaterial.opacity(0.5))
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
        frameHeightRatio = CGFloat(1.5)
        offset = CGSize(width: CGFloat.random(in: -150 ..< 0),
                        height: CGFloat.random(in: -150 ..< 0))
    }
}

struct Theme {
    static var generalBackground: Color {
        Color(red: 0.043, green: 0.467, blue: 0.494)
    }
    
    static func ellipsesTopLeading(forScheme scheme: ColorScheme) -> Color {
        let any = Color(red: 0.039, green: 0.388, blue: 0.502, opacity: 0.81)
        let dark = Color(red: 0.000, green: 0.176, blue: 0.216, opacity: 80.0)
        switch scheme {
        case .light:
            return any
        case .dark:
            return dark
        @unknown default:
            return any
        }
    }
    
    static func ellipsesTopTrailing(forScheme scheme: ColorScheme) -> Color {
        let any = Color(red: 0.196, green: 0.796, blue: 0.329, opacity: 0.5)
        let dark = Color(red: 0.408, green: 0.698, blue: 0.420, opacity: 0.61)
        switch scheme {
        case .light:
            return any
        case .dark:
            return dark
        @unknown default:
            return any
        }
    }
    
    static func ellipsesBottomTrailing(forScheme scheme: ColorScheme) -> Color {
        Color.myColor
    }
    
    static func ellipsesBottomLeading(forScheme scheme: ColorScheme) -> Color {
        let any = Color(red: 0.196, green: 0.749, blue: 0.486, opacity: 0.55)
        let dark = Color(red: 0.525, green: 0.859, blue: 0.655, opacity: 0.45)
        switch scheme {
        case .light:
            return any
        case .dark:
            return dark
        @unknown default:
            return any
        }
    }
}

//class CloudProvider2: ObservableObject {
//    let offset: CGSize
//    let frameHeightRatio: CGFloat
//
//    init() {
//        frameHeightRatio = CGFloat.random(in: 0.7 ..< 1.4)
//        offset = CGSize(width: CGFloat.random(in: -150 ..< 150),
//                        height: CGFloat.random(in: -150 ..< 150))
//    }
//}
//
//struct Cloud2: View {
//    @StateObject var provider = CloudProvider2()
//    @State var move = false
//    let proxy: GeometryProxy
//    let color: Color
//    let rotationStart: Double
//    let duration: Double
//    let alignment: Alignment
//
//    var body: some View {
//        Circle()
//            .fill(color)
//            .frame(height: proxy.size.height /  provider.frameHeightRatio)
//            .offset(provider.offset)
//            .rotationEffect(.init(degrees: move ? rotationStart : rotationStart + 360) )
//            .animation(Animation.linear(duration: duration).repeatForever(autoreverses: false))
//            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
//            .opacity(0.8)
//            .onAppear {
//                move.toggle()
//            }
//    }
//}
//
//struct AnimatedBlur2: View {
//    @Environment(\.colorScheme) var scheme
//
//    var body: some View {
//        GeometryReader { proxy in
//            ZStack {
//                Theme.generalBackground
//                Cloud2(proxy: proxy,
//                      color: Theme.ellipsesBottomTrailing(forScheme: scheme),
//                      rotationStart: 0,
//                      duration: 60,
//                      alignment: .bottomTrailing)
//                Cloud2(proxy: proxy,
//                      color: Theme.ellipsesTopTrailing(forScheme: scheme),
//                      rotationStart: 240,
//                      duration: 50,
//                      alignment: .topTrailing)
//                Cloud2(proxy: proxy,
//                      color: Theme.ellipsesBottomLeading(forScheme: scheme),
//                      rotationStart: 120,
//                      duration: 80,
//                      alignment: .bottomLeading)
//                Cloud2(proxy: proxy,
//                      color: Theme.ellipsesTopLeading(forScheme: scheme),
//                      rotationStart: 180,
//                      duration: 70,
//                      alignment: .topLeading)
//            }
//            .blur(radius: 100)
//            .ignoresSafeArea()
//        }
//    }
//}
