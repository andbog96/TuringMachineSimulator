//
//  UserData.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 18.05.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import Combine

final class UserData: ObservableObject {
    @Published var slowMode = true
    @Published var startPosition = StartPosition.left
    @Published var blankSymbol = BlankSymbol.zero
    @Published var startState = "q0"
    @Published var tape = "11111"
    @Published var output = ""
    @Published var transitions = [Transition]()
    
    init() {
        self.transitions.append(contentsOf: [
            Transition(self.startState, "0", "0", .halt, "q0"),
            Transition("q0", "1", "0", .right, "q0"),
            Transition()])
    }
}
