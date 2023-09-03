// ThemePicker.swift
// MyFlow
//
// Created by Nate Tedesco on 8/30/23.
//

import SwiftUI

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
    
    @Published var selectedColor: Color = .clear {
        didSet {
            saveColor()
        }
    }
    
    init() {
            if let color = Color(data: colorData) {
                selectedColor = color
            } else {
                selectedColor = .black
            }
        }
    
    func saveColor() {
        colorData = selectedColor.toData() ?? Data()
    }
}

struct ThemePicker: View {
    var imageNames = [
        "papers.co-vs13-blue-paint-rainbow-art-pattern-41-iphone-wallpaper",
        "-3",
        "no_se"
    ]
    
    var predefinedColors: [Color] = [
        .red, .green, .blue, .orange, .purple,
        .pink, .yellow, .teal, .gray, .myBlue
    ]
    
    @ObservedObject var appSettings = AppSettings.shared
    
    var body: some View {
        ScrollView {
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
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                Button {
                    appSettings.theme = "default"
                } label: {
                    Text("default")
                }
                
                ForEach(imageNames, id: \.self) { imageName in
                    Button(action: {
                        appSettings.theme = imageName
                        // Set the selected image as the background of your app here
                    }) {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 125)
                            .cornerRadius(10)
                            .padding(10)
                            .overlay(appSettings.theme == imageName ? RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2) : nil)
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
