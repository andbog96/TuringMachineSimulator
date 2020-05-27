//
//  Machine.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 04.05.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import Foundation

struct Transition: Identifiable {
    var id = UUID()
    var currentState = ""
    var currentSymbol = ""
    var writeSymbol = ""
    var nextState = ""
    var moveTape = MoveTape.halt
}

enum BlankSymbol: String, CaseIterable, Identifiable {
    case zero = "0"
    case underscore = "_"
    
    var id: Self { self }
}

enum MoveTape: String, CaseIterable, Identifiable {
    case left = "L"
    case halt = "H"
    case right = "R"
    
    var id: Self { self }
}
