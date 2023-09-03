//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct FlowView: View {
    @ObservedObject var model: FlowModel
    
    @AppStorage("ProAccess") var proAccess: Bool = false
    @AppStorage("showCreateFlow") var showCreateFlow: Bool = true
    @AppStorage("showPayWall") var showPayWall = false
    
    @FocusState var focusedField: Field?
    
    @State var disable = false
    @State var showStatistics = false
    @State var showSettings = false
    @State var showFlowSheet = false
    
    
    // put in model
    @State var selectedIndex = 0
    @State var selectedBlock = false
    @State var showBlockEditor = false
    @State var draggingItem: Block?
    @State var dragging = false
    
    
    init(model: FlowModel) { self.model = model }
    
    var body: some View {
        
        ZStack {
            
            Menu {
                FlowList
                CreateFlow
                EditFlowButton
                DeleteFlowButton
                
            } label: {
                HStack {
                    Text(model.flow.title)
                        .font(.system(size: 34))
                        .padding(.leading, initial ? 24 : 0)
                    if initial {
                        Image(systemName: "chevron.down")
                    }
                }
                .foregroundColor(.white)
                .animation(.default, value: model.flow.title)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .kerning(1.0)
                    .menuOrder(.fixed)
                    .transaction { transaction in
                        transaction.animation = nil // disables ...
                    }
                    .disabled(model.mode != .Initial)
            }
            .onTapGesture { disable = true }
            .top()
            .padding(.top, 12)
            
            
            // Circle
            Circles(model: model)
                .frame(width: 312)
            
            
            
            // Labels
            VStack(spacing: 16) {
                
                BlockLabel
                
                TimerLabel
                
                
                // Control Bar
                HStack(spacing: 48) {
                    
                    //                    if !initial {
                    //                        // Restart
                    //                        Button {
                    //                            model.Restart()
                    //                            rigidHaptic()
                    //                        } label: {
                    //                            Image(systemName: "chevron.left")
                    //                        }
                    //                    }
                    
                    Button {
                        model.Start()
                        rigidHaptic()
                    } label: {
                        Image(systemName: start ? "play.fill" : "pause.fill")
                        //                            .foregroundStyle(.ultraThickMaterial)
                        //                            .environment(\.colorScheme, .light)
                            .foregroundColor(.myColor)
                            .font(.system(size: 38))
                    }
                    
                    //                    if !initial {
                    //                        // Skip
                    //                        Button {
                    //                            model.Skip()
                    //                            rigidHaptic()
                    //                        } label: {
                    //                            Image(systemName: "chevron.right")
                    //                        }
                    //                    }
                }
                //                .padding(.top)
                .foregroundStyle(.ultraThickMaterial)
                .environment(\.colorScheme, .light)
                .font(.system(size: 20))
                
                
                
            }
            
            if model.mode == .flowRunning {
                // Extend
                Button {
                    
                } label: {
                    HStack {
                        Text("Complete")
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(.ultraThinMaterial)
                    .cornerRadius(30)
                    
                }
                .padding(.top, 480) // fix later
            }
            
            HStack(alignment: .bottom) {
                
                // Statistics
                Button {
                    showStatistics = true
                    
                } label: {
                    ToolBarButton(image: "chart.bar.fill", size: 20)
                }
                
                Spacer()
                
                // Start
                // Show Flow Sheet
                Button {
                    showFlowSheet = true
                    softHaptic()
                } label: {
                    Image(systemName: "circle")
                        .font(.system(size: 50))
                        .fontWeight(.medium)
                        .foregroundColor(.myColor)
                    //                        .foregroundStyle(.ultraThickMaterial)
                    //                        .environment(\.colorScheme, .light)
                    //                        .padding(.bottom)
                    
                }.disabled(disable)
                
                Spacer()
                
                // Settings
                Button {
                    showSettings = true
                }  label: {
                    ToolBarButton(image: "person.fill",size: 25)
                }
            }
            .padding(.horizontal, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        
        
        
        
        .FlowViewBackGround()
        .ignoresSafeArea(.keyboard)
        .onTapGesture { disable = false }
        FlowCompleted(model: model, show: $model.completed)
            .sheet(isPresented: $showPayWall) {
                PayWall()
            }
            .sheet(isPresented: $showStatistics) {
                StatsView()
                    .presentationBackground(Color.clear)
            }
        
            .sheet(isPresented: $showSettings) {
                SettingsView(model: model)
                    .presentationBackground(Color.clear)
            }
            .sheet(isPresented: $showFlowSheet) {
                FlowSheet(model: model)
                    .presentationBackground(Color.clear)
            }
        
        
    }
    
    var initial: Bool {
        if model.mode == .Initial {
            return true
        }
        return false
    }
    
    var timerValue: Double {
        return Double(format360(time: model.flowTime, timeLeft: model.flowTimeLeft))
    }
    
    var block: Block {
        return model.flow.blocks[model.blocksCompleted]
    }
    
    var timerLabel: String {
        if model.type == .Flow {
            return formatTime(seconds: model.flowTimeLeft)
        }
        return formatTime(seconds: model.breakTimeLeft)
    }
    
    var CreateFlow: some View {
        Button {
            softHaptic()
            model.createFlow()
            model.showFlowSheet()
            disable = false
        } label: {
            Label("Create", systemImage: "plus")
        }
    }
    
    var EditFlowButton: some View {
        Button {
            model.showingFlowSheet = true
            disable = false
        } label: {
            Label("Edit", systemImage: "pencil")
        }
    }
    
    var DeleteFlowButton: some View {
        Button {
            model.deleteFlow(id: model.flow.id)
            disable = false
            successHaptic()
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    var FlowList: some View {
        Picker("", selection: $model.selection) {
            ForEach(0..<$model.flowList.count, id: \.self) { i in
                Text(model.flowList[i].title)
                    .onChange(of: model.selection) { newValue in
                        disable = false
                    }
            }
        }
    }
    
    
    var TimerLabel: some View {
        HStack {
            
            if model.flowContinue {
                Image(systemName: "plus")
                    .foregroundColor(.myColor)
                    .font(.largeTitle)
            }
            
            Text(timerLabel)
                .font(.system(size: 72))
                .fontWeight(.light)
                .foregroundColor(.white)
                .kerning(5.0)
                .monospacedDigit()
        }
    }
    
    var BlockLabel: some View {
        HStack {
            //            Circle()
            //                .foregroundColor(block.flow ? .myColor : .gray)
            //                .frame(height: 12)
            Text(block.title)
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(.white)
            //            .foregroundColor(block.flow ? .myColor : .gray)
            //            .opacity(0.8)
                .lineLimit(1)
        }
    }
    
    
    var menuLabel: some View {
        Image(systemName: "chevron.down")
            .font(.title2)
            .padding(.leading)
        
    }
    
    
    var createYourFlow: some View {
        VStack {
            Text("Create your first flow")
                .foregroundColor(.white)
                .padding(.top, 112)
                .font(.title2)
                .fontWeight(.light)
            Spacer()
        }
    }
    
    var start: Bool {
        if model.mode == .Initial || model.mode == .flowStart || model.mode == .breakStart || model.mode == .flowPaused || model.mode == .breakPaused {
            return true
        }
        return false
    }
    
    var flow: Bool {
        if model.mode == .flowStart {
            return true
        }
        return false
    }
    
}

struct I: PreviewProvider {
    @State static var model = FlowModel()
    static var previews: some View {
        FlowView(model: model)
    }
}
struct P: PreviewProvider {
    @State static var model = FlowModel(mode: .flowPaused)
    static var previews: some View {
        FlowView(model: model)
    }
}

struct FS: PreviewProvider {
    @State static var model = FlowModel(mode: .flowStart)
    static var previews: some View {
        FlowView(model: model)
    }
}
struct FR: PreviewProvider {
    @State static var model = FlowModel(mode: .flowRunning)
    static var previews: some View {
        FlowView(model: model)
    }
}

struct BS: PreviewProvider {
    @State static var model = FlowModel(mode: .breakStart)
    static var previews: some View {
        FlowView(model: model)
    }
}
struct BR: PreviewProvider {
    @State static var model = FlowModel(mode: .breakRunning)
    static var previews: some View {
        FlowView(model: model)
    }
}

enum Field: Hashable {
    case flowName
    case blockName
    case time
}

extension Flow {
    func totalFlowTimeInSeconds() -> TimeInterval {
        var totalSeconds: TimeInterval = 0
        
        for block in blocks {
            totalSeconds += block.totalTimeInSeconds
        }
        return totalSeconds
    }
    
    func totalFlowTimeFormatted() -> String {
        let totalSeconds = totalFlowTimeInSeconds()
        let hours = Int(totalSeconds) / 3600
        let minutes = (Int(totalSeconds) % 3600) / 60
        let seconds = Int(totalSeconds) % 60
        
        var formattedTime = ""
        if hours > 0 {
            formattedTime += "\(hours):"
        }
        formattedTime += String(format: "%02d:%02d", minutes, seconds)
        
        return formattedTime
    }}

extension Block {
    var totalTimeInSeconds: TimeInterval {
        let totalSeconds = TimeInterval(hours * 3600 + minutes * 60 + seconds)
        return totalSeconds
    }
}






struct ToolBarButton: View {
    var image: String
    var size: CGFloat
    
    
    var body: some View {
        Image(systemName: image)
            .font(Font.system(size: size))
            .frame(width: 32, height: 20)
            .padding(.top, 36)
            .foregroundColor(.gray)
            .opacity(0.6)
        //            .foregroundStyle(.ultraThickMaterial)
        //            .environment(\.colorScheme, .light)
        
    }
}



//            AngularGradient(gradient: Gradient(stops: [
//                .init(color: .myColor, location: 0),
//                .init(color: .black.opacity(0.0), location: CGFloat(timerValue / 360))
//            ]), center: .center)
//            .rotationEffect(.degrees(-timerValue - 90))
//            .frame(width: 312, height: 312)
//            .clipShape(Circle())
//            .scaleEffect(x: -1, y: 1)  // flip horizontally
