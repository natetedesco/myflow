//
//  Examples.swift
//  MyFlow
//  Created by Nate Tedesco on 1/24/23.
//

import Foundation

var exampleFlows = [
    Flow(
        title: "Flow", blocks: [
            Block(title: "Focus", minutes: 30),
            Block(title: "Break", minutes: 5),
            Block(title: "Focus", minutes: 30),
            Block(title: "Break", minutes: 5)
        ])
]

var exampleDays = [
    Day(day: Date.from(year: 2023, month: 10, day: 7), time: 45),
    Day(day: Date.from(year: 2023, month: 10, day: 6), time: 83),
    Day(day: Date.from(year: 2023, month: 10, day: 5), time: 135),
    Day(day: Date.from(year: 2023, month: 10, day: 4), time: 230),
    Day(day: Date.from(year: 2023, month: 10, day: 3), time: 60),
    Day(day: Date.from(year: 2023, month: 10, day: 2), time: 135),
    Day(day: Date.from(year: 2023, month: 10, day: 1), time: 250)
]
