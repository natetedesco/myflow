////
////  Toolbar.swift
////  MyFlow
////  Created by Nate Tedesco on 9/22/21.
////
//
//import SwiftUI
//
//struct Toolbar: View {
//    @ObservedObject var model: FlowModel = FlowModel()
//    @AppStorage("SelectedTab") var selectedTab: Tab = .home
//
//    @Binding var showStatistics: Bool
//    @Binding var showSettings: Bool
//
//
//    var body: some View {
//        HStack(alignment: .bottom) {
//
//            // Statistics
//            Button {
//                showStatistics = true
//
//            } label: {
//                ToolBarButton(image: "chart.bar.fill", size: 25)
//            }
//
//            Spacer()
//
//            // Start
//            StartButton(model: model)
//
//            Spacer()
//
//            // Settings
//            Button {
//                showSettings = true
//            }  label: {
//                ToolBarButton(image: "person.fill",size: 30)
//            }
//        }
//        .padding(.horizontal, 40)
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
//    }
//}
//
//struct StartButton: View {
//    @AppStorage("SelectedTab") var selectedTab: Tab = .home
//    @AppStorage("Onboarding") var onboarding: Bool = true
//    @ObservedObject var model: FlowModel
//
//    var body: some View {
//
//        // Start Button
//        if selectedTab == Tab.home {
//
//            // Start
//            Button {
//                model.Start()
//            } label: {
//                Image(systemName: start ? "play.fill" : "pause.fill")
//                    .font(.system(size: 42))
////                    .foregroundColor(.myColor)
//                    .foregroundStyle(.ultraThickMaterial)
//                    .environment(\.colorScheme, .light)
//                    .fontWeight(.medium)
//                    .padding()
////                    .background(Circle().foregroundStyle(.ultraThinMaterial))
//            }
//
//        } else {
//            Button {
//                selectedTab = Tab.home
//            } label: {
//                Image(systemName: "circle")
//                    .font(.system(size: 54))
//                    .foregroundColor(.myColor)
//            }
//        }
//
//    }
//
//    var start: Bool {
//        if model.mode == .Initial || model.mode == .flowStart || model.mode == .breakStart || model.mode == .flowPaused || model.mode == .breakPaused {
//            return true
//        }
//        return false
//    }
//
//    var flow: Bool {
//        if model.mode == .flowStart {
//            return true
//        }
//        return false
//    }
//}
//
//struct ToolBarButton: View {
//    var image: String
//    var size: CGFloat
//
//
//    var body: some View {
//        Image(systemName: image)
//            .font(Font.system(size: size))
//            .frame(width: 32, height: 20)
//            .padding(.top, 36)
//            .foregroundColor(.gray)
//            .opacity(0.5)
//
//    }
//}
//
