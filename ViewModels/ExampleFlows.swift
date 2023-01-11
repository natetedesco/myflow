//
//  ExampleFlows.swift
//  MyFlow
//  Created by Nate Tedesco on 1/8/23.
//

import Foundation

var exampleFlows = [
    
    Flow(
        title: "Flow"),
    
    Flow(
        title: "Workout", simple: false, blocks: [
            Block(flow: true, title: "Warm Up", minutes: 15),
            Block(flow: true, title: "Workout", minutes: 40),
            Block(flow: true, title: "Cool Down", minutes: 5)
        ]),
    
    Flow(
        title: "Creativity", simple: false, blocks: [
            Block(flow: true, title: "Brainstorm", minutes: 15),
            Block(flow: false, title: "Break", minutes: 5),
            Block(flow: true, title: "Create", minutes: 30),
            Block(flow: false, title: "Break", minutes: 5),
            Block(flow: true, title: "Revision", minutes: 15)])
]

var exampleDays = [
    Day(day: Date.from(year: 2023, month: 1, day: 9), time: 135),
    Day(day: Date.from(year: 2023, month: 1, day: 7), time: 80),
    Day(day: Date.from(year: 2023, month: 1, day: 6), time: 115),
    Day(day: Date.from(year: 2023, month: 1, day: 5), time: 95),
    Day(day: Date.from(year: 2023, month: 1, day: 4), time: 39),
    Day(day: Date.from(year: 2023, month: 1, day: 3), time: 75),
    Day(day: Date.from(year: 2023, month: 1, day: 2), time: 90),
    Day(day: Date.from(year: 2023, month: 1, day: 1), time: 50)
]

