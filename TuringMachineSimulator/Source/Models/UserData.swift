//
//  UserData.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 18.05.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import Combine

final class UserData: ObservableObject {
    @Published var speed = Speed.fifty
    @Published var startPosition = StartPosition.left
    @Published var blankSymbol = BlankSymbol.zero
    @Published var startState = "q0"
    @Published var tape = ""
    @Published var output = ""
    @Published var transitions = [Transition]()
    
    init() {
        self.transitions.append(contentsOf: [Transition(currentState: self.startState), Transition()])
    }
}
