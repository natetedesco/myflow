//
//  Model Input.swift
//  MyFlow
//  Created by Nate Tedesco on 6/19/22.
//

import SwiftUI

func lightHaptic() {
    let impactLit = UIImpactFeedbackGenerator(style: .light)
    impactLit.impactOccurred()
}

func mediumHaptic() {
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    impactMed.impactOccurred()
}

func heavyHaptic() {
    let impactHev = UIImpactFeedbackGenerator(style: .heavy)
    impactHev.impactOccurred()
}

