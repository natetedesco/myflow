//
//  Waves.swift
//  MyFlow
//
//  Created by Nate Tedesco on 10/22/22.
//
//
//import SwiftUI
//
//struct Waves: View {
//    let universalSize = UIScreen.main.bounds
//    @State var isAnimated = false
//
//    var body: some View {
//
//        ZStack {
//            AnimatedBlur()
//
//            getSinWave(interval: universalSize.width,
//                       amplitude: 100,
//                       baseline: universalSize.height/1.4)
//            .myBlue
//
//            .opacity(0.2)
//            .offset(x: isAnimated ? -1*universalSize.width: 0)
//            .animation(Animation.linear(duration: 10)
//                .repeatForever(autoreverses: false))
//
//            getSinWave(interval: universalSize.width*1.2,
//                       amplitude: 160,
//                       baseline: 50 + universalSize.height/1.7)
//            .myBlue
//            .opacity(0.2)
//            .offset(x: isAnimated ? -1*universalSize.width*1.2: 0)
//            .animation(Animation.linear(duration: 12)
//                .repeatForever(autoreverses: false))
//
//            getSinWave(interval: universalSize.width*1.5,
//                       amplitude: 130,
//                       baseline: 50 + universalSize.height/1.8)
//            .myBlue
//            .opacity(0.2)
//            .offset(x: isAnimated ? -1*universalSize.width*1.5: 0)
//            .animation(Animation.linear(duration: 15)
//                .repeatForever(autoreverses: false))
//        }
//        .onAppear(){self.isAnimated = true}
//    }
//
//    func getSinWave(interval: CGFloat, amplitude: CGFloat = 100, baseline:CGFloat = UIScreen.main.bounds.height/2) -> Path { Path{path in
//        
//        path.move(to: CGPoint(x: 0, y: baseline))
//
//        path.addCurve(to: CGPoint(x: 1*interval,y: baseline),
//                      control1: CGPoint(x: interval * (0.35),y: amplitude + baseline),
//                      control2: CGPoint(x: interval * (0.65),y: -amplitude + baseline))
//
//        path.addCurve(to: CGPoint(x: 2*interval ,y: baseline),
//                      control1: CGPoint(x: interval * (1.35) ,y: amplitude + baseline),
//                      control2: CGPoint(x: interval * (1.65) ,y: -amplitude + baseline))
//
//        path.addLine(to: CGPoint(x: 2*interval, y: universalSize.height))
//        path.addLine(to: CGPoint(x: 0, y: universalSize.height))
//    }
//    }
//}
//
//extension View {
//
//    func animateForever(using animation: Animation = .easeInOut(duration: 1), autoreverses: Bool = false, _ action: @escaping () -> Void) -> some View {
//        let repeated = animation.repeatForever(autoreverses: autoreverses)
//
//        return onAppear {
//            withAnimation(repeated) {
//                action()
//            }
//        }
//    }
//}
//
//
//struct Waves_Previews: PreviewProvider {
//    static var previews: some View {
//        Waves()
//    }
//}
