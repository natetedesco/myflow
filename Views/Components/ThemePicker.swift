// ThemePicker.swift
// MyFlow
//
// Created by Nate Tedesco on 8/30/23.
//

import SwiftUI

class Settings: ObservableObject {
    @AppStorage("NotificationsOn") var notificationsOn: Bool = true
    @AppStorage("BlockDistractions") var blockDistractions: Bool = false
    @AppStorage("LiveActivities") var liveActivities: Bool = true
}

extension Color {
    static func rgb(r: Double, g: Double, b: Double ) -> Color {
        return Color(red: r / 255, green: g / 255, blue: b / 255)
    }

    static let myBlue = Color(#colorLiteral(red: 0, green: 0.8217858727, blue: 1, alpha: 1))
    
    static var myColor: Color {
        return AppSettings.shared.selectedColor
    }
    
}

class AppSettings: ObservableObject {
    static let shared = AppSettings() // Singleton instance
    
    @AppStorage("theme") var theme: String = ""
    @AppStorage("colorData") var colorData: Data = Data()
    @AppStorage("background") var background = false

    
    @Published var selectedColor: Color = .cyan {
        didSet {
            saveColor()
        }
    }
    
    init() {
            if let color = Color(data: colorData) {
                selectedColor = .teal
            } else {
                selectedColor = .teal
            }
        }
    
    func saveColor() {
        colorData = selectedColor.toData() ?? Data()
    }
}

struct ThemePicker: View {
    var predefinedColors: [Color] = [
        .red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .pink
    ]
    
    @ObservedObject var appSettings = AppSettings.shared
    
    var body: some View {
        ScrollView {
            ToggleBar(text: "Background", icon: "circle.lefthalf.filled", isOn: $appSettings.background)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                // Predefined color buttons
                ForEach(predefinedColors, id: \.self) { color in
                    Button(action: {
                        appSettings.selectedColor = color
                    }) {
                        color
                            .frame(width: 25, height: 25)
                            .cornerRadius(10)
                            .overlay(appSettings.selectedColor == color ? RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2) : nil)
                    }
                }
            }
        }
    }
}

extension Color {
    func toData() -> Data? {
        do {
            let colorData = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: true)
            return colorData
        } catch {
            print(error)
            return nil
        }
    }
    
    init?(data: Data) {
        do {
            if let uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) {
                self.init(uiColor)
            } else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
}


struct ThemePicker_Previews: PreviewProvider {
    static var previews: some View {
        ThemePicker()
    }
}
