//
//  FlowData.swift
//  MyFlow
//  Created by Nate Tedesco on 12/2/22.
//

import Foundation
import SwiftUI

struct Day: Codable, Identifiable, Equatable {
    let day: Date
    var time: Int
    var today: Bool = false
    var id: Date { day }
}
