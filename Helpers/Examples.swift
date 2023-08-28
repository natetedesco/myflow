//
//  Examples.swift
//  MyFlow
//  Created by Nate Tedesco on 1/24/23.
//

import Foundation

var exampleFlows = [
    Flow(
        title: "Workout", blocks: [
            Block(flow: true, title: "Warm Up", minutes: 20),
            Block(flow: true, title: "Strength", minutes: 15),
            Block(flow: true, title: "Conditioning", minutes: 15),
            Block(flow: true, title: "Cool Down", minutes: 10)
        ]),
    Flow(
        title: "Creativity", blocks: [
            Block(flow: true, title: "Brainstorm", minutes: 15),
            Block(flow: false, title: "Break", minutes: 5),
            Block(flow: true, title: "Create", minutes: 30),
            Block(flow: false, title: "Break", minutes: 5),
            Block(flow: true, title: "Revision", minutes: 15)])
]
//
//var exampleDays = [
//    Day(day: Date.from(year: 2023, month: 8, day: 27), time: 80),
//    Day(day: Date.from(year: 2023, month: 8, day: 26), time: 60),
//    Day(day: Date.from(year: 2023, month: 8, day: 25), time: 180),
//    Day(day: Date.from(year: 2023, month: 8, day: 24), time: 160),
//    Day(day: Date.from(year: 2023, month: 8, day: 23), time: 75),
//    Day(day: Date.from(year: 2023, month: 8, day: 22), time: 90),
//    Day(day: Date.from(year: 2023, month: 8, day: 21), time: 120),
//    Day(day: Date.from(year: 2023, month: 8, day: 20), time: 80),
//    Day(day: Date.from(year: 2023, month: 8, day: 19), time: 115),
//
//    Day(day: Date.from(year: 2023, month: 8, day: 17), time: 120),
//    Day(day: Date.from(year: 2023, month: 8, day: 16), time: 130),
//    Day(day: Date.from(year: 2023, month: 8, day: 15), time: 90),
//    Day(day: Date.from(year: 2023, month: 8, day: 14), time: 120),
//    Day(day: Date.from(year: 2023, month: 8, day: 13), time: 180),
//    Day(day: Date.from(year: 2023, month: 8, day: 12), time: 130),
//    Day(day: Date.from(year: 2023, month: 8, day: 11), time: 95),
//    Day(day: Date.from(year: 2023, month: 8, day: 10), time: 120),
//
//    Day(day: Date.from(year: 2023, month: 8, day: 8), time: 90),
//    Day(day: Date.from(year: 2023, month: 8, day: 7), time: 120),
//    Day(day: Date.from(year: 2023, month: 8, day: 6), time: 115),
//    Day(day: Date.from(year: 2023, month: 8, day: 4), time: 120),
//    Day(day: Date.from(year: 2023, month: 8, day: 3), time: 130),
//    Day(day: Date.from(year: 2023, month: 8, day: 2), time: 90),
//    Day(day: Date.from(year: 2023, month: 8, day: 1), time: 120)
//]
