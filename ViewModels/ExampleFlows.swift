//
//  ExampleFlows.swift
//  MyFlow
//  Created by Nate Tedesco on 1/8/23.
//

import Foundation

var exampleFlows = [
    
    Flow(
        title: "Flow", flowMinutes: 20, breakMinutes: 5, rounds: 5
        ),
    
    Flow(
        title: "Workout", simple: false, blocks: [
            Block(flow: true, title: "Warm Up", minutes: 15),
            Block(flow: true, title: "Workout", minutes: 40),
            Block(flow: true, title: "Cool Down", minutes: 5)
        ]),
    
    Flow(
        title: "Creative Writing", simple: false, blocks: [
            Block(flow: true, title: "Brainstorm", minutes: 15),
            Block(flow: false, title: "Break", minutes: 5),
            Block(flow: true, title: "Creative Writing", minutes: 30),
            Block(flow: false, title: "Break", minutes: 5),
            Block(flow: true, title: "Revision", minutes: 15)])
    
]
