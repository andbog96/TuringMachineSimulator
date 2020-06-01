//
//  Machine.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 04.05.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import Foundation

class Transition: ObservableObject, Identifiable {
    let id = UUID()
    @Published var currentState = ""
    @Published var currentSymbol = ""
    @Published var writeSymbol = ""
    @Published var nextState = ""
    @Published var moveTape = MoveTape.halt
    
    convenience init(currentState: String) {
        self.init()
        self.currentState = currentState
    }
}

enum Speed: Int, CaseIterable, Identifiable {
    case one = 1
    case ten = 10
    case fifty = 50
    
    var id: Self { self }
}

enum StartPosition: String, CaseIterable, Identifiable  {
    case left = "Left"
    case right = "Right"
    
    var id: Self { self }
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
