//
//  MultiComponentPicker.swift
//  MyFlow
//  Created by Nate Tedesco on 1/20/23.
//

import SwiftUI
import Introspect

var hours = [Int](0...12)
var minutes = [Int](0...60)
var seconds = [Int](0...60)

var columns = [
    MultiComponentPicker.Column(label: "hr", options: Array(0...12).map { MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) }),
    MultiComponentPicker.Column(label: "min", options: Array(0...59).map { MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) }),
    MultiComponentPicker.Column(label: "sec", options: Array(0...59).map { MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) }),
]

extension View {
    public func introspectUIPickerView(customize: @escaping (UIPickerView) -> ()) -> some View {
        return inject(UIKitIntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.findAncestorOrAncestorChild(ofType: UIPickerView.self, from: viewHost)
            },
            customize: customize
        ))
    }
}

struct MultiComponentPicker<Tag: Hashable>: View  {
    let columns: [Column]
    var selections: [Binding<Tag>]
    
    var body: some View {
        
        ZStack {
            
            Rectangle()
                .fill(.gray.opacity(0.15))
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
                .frame(height: 32)
//                .padding(.horizontal, 4)
            
            HStack {
                ForEach(0 ..< columns.count, id: \.self) { index in
                    let column = columns[index]
                    ZStack(alignment: Alignment.init(horizontal: .customCenter, vertical: .center)) {
                        
                        HStack {
                            Text(verbatim: column.options.last!.text)
                                .foregroundColor(.clear)
                                .alignmentGuide(.customCenter) { $0[HorizontalAlignment.center] }
                            Text(column.label)
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        Picker(column.label, selection: selections[index]) {
                            ForEach(column.options, id: \.tag) { option in
                                Text(verbatim: option.text).tag(option.tag)
                            }
                        }
                        .introspectUIPickerView { picker in
                            picker.subviews[1].backgroundColor = UIColor.clear
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                }
            }
            
            .frame(height: 128)
        }
    }
}

extension HorizontalAlignment {
    enum CustomCenter: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat { context[HorizontalAlignment.center] }
    }
    static let customCenter = Self(CustomCenter.self)
}

extension MultiComponentPicker {
    struct Column {
        struct Option {
            var text: String
            var tag: Tag
        }
        
        var label: String
        var options: [Option]
    }
}
