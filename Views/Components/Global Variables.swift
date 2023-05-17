//
//  Global Variables.swift
//  MyFlow
//  Created by Nate Tedesco on 12/28/22.
//

import Foundation

var Initial = TimerMode.Initial
var flowStart = TimerMode.flowStart
var breakStart = TimerMode.breakStart
var flowRunning = TimerMode.flowRunning
var breakRunning = TimerMode.breakRunning
var flowPaused = TimerMode.flowPaused
var breakPaused = TimerMode.breakPaused

var minutes = [Int](0...60)
var seconds = [Int](0...60)
var rounds = [Int](0...10)
var roundsStrings = ["∞", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

var columns = [
    MultiComponentPicker.Column(label: "min", options: Array(0...60).map { MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) }),
//    MultiComponentPicker.Column(label: "sec", options: Array(0...59).map { MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) }),
]
