//
//  Machine.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 04.05.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import Foundation
import SwiftUI

typealias TMState = String
typealias TMSymbol = String

class Machine {
    struct MapKey: Hashable {
        var state: TMState
        var symbol: TMSymbol
        init(_ state: TMState, _ symbol: TMSymbol) {
            self.state = state
            self.symbol = symbol
        }
    }
    private var map = [MapKey: (TMSymbol, MoveTape, TMState)]()
    
    private var userData: UserData
    private var output: Binding<String>
    private var appState: Binding<AppState>
    
    private var tape: [String]
    private var state: TMState
    private var position: Int
    
    init(_ userData: UserData, output: Binding<String>, appState: Binding<AppState>) {
        self.userData = userData
        self.output = output
        self.appState = appState
        
        for t in userData.transitions {
            map[MapKey(t.currentState, t.currentSymbol)] = (t.writeSymbol, t.moveTape, t.nextState)
        }
        
        if userData.tape.count == 0 {
            self.tape = [userData.blankSymbol.rawValue]
        } else {
            self.tape = Array(userData.tape).map { String($0) }
        }
        
        self.state = userData.startState
        
        switch userData.startPosition {
        case .left:
            self.position = 0
        case .right:
            self.position = self.tape.count - 1
        }
        
        resume()
    }
    
    func resume() {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            var i = 0
            while self.appState.wrappedValue == .runned {
                if self.position >= self.tape.count {
                    self.tape.append(contentsOf:
                        Array(repeating: self.userData.blankSymbol.rawValue,
                              count: 1 + self.position - self.tape.count))
                } else if self.position < 0 {
                    self.tape.insert(contentsOf:
                        Array(repeating: self.userData.blankSymbol.rawValue,
                              count: -self.position), at: 0)
                    self.position = 0
                }
                
                let value = self.map[MapKey(self.state, self.tape[self.position])]
                if let (symbol, move, state) = value {
                    if move == .halt && state == self.state
                        && symbol == self.tape[self.position] {
                        DispatchQueue.main.async {
                            self.appState.wrappedValue = .stopped
                        }
                    } else {
                        self.tape[self.position] = symbol
                        self.position += move.intValue
                        self.state = state
                        
                        if i % 100 == 0 {
                            DispatchQueue.main.async {
                                self.output.wrappedValue = String(self.tape.map { $0.first! })
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.appState.wrappedValue = .stopped
                    }
                }
                
                i += 1
            }
            
            DispatchQueue.main.async {
                self.output.wrappedValue = String(self.tape.map { $0.first! })
            }
        }
    }
}

class Transition: ObservableObject, Identifiable {
    let id = UUID()
    @Published var currentState = ""
    @Published var currentSymbol = ""
    @Published var writeSymbol = ""
    @Published var moveTape = MoveTape.halt
    @Published var nextState = ""
    
    convenience init(_ currentState: TMState, _ currentSymbol: TMSymbol,
                     _ writeSymbol: TMSymbol, _ moveTape: MoveTape,
                     _ nextState: TMState) {
        self.init()
        self.currentState = currentState
        self.currentSymbol = currentSymbol
        self.writeSymbol = writeSymbol
        self.moveTape = moveTape
        self.nextState = nextState
    }
}

enum AppState {
    case stopped
    case runned
    case paused
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
    
    var intValue: Int {
        switch self {
        case .left:
            return -1
        case .halt:
            return 0
        case .right:
            return 1
        }
    }
    
    var id: Self { self }
}
