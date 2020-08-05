//
//  Machine.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 04.05.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import Foundation
import SwiftUI

typealias TMState = String // Псевдоним для состояния
typealias TMSymbol = String // Псевдоним для символа

class Machine {
    // Вспомогательный костыль, так как кортежи почему-то не могут быть Hashable
    struct MapKey: Hashable {
        var state: TMState
        var symbol: TMSymbol
        init(_ state: TMState, _ symbol: TMSymbol) {
            self.state = state
            self.symbol = symbol
        }
    }
    
    // Внутренняя структура. Нужна для скорости поиска нужных переходов
    private var map = [MapKey: (TMSymbol, MoveTape, TMState)]()
    
    private var userData: UserData
    private var output: Binding<String>
    private var appState: Binding<AppState>
    
    private var tape: [TMSymbol]
    private var state: TMState
    private var position: Int
    
    init(_ userData: UserData, output: Binding<String>, appState: Binding<AppState>) {
        self.userData = userData
        self.output = output
        self.output.wrappedValue = userData.tape
        self.appState = appState
        
        for t in userData.transitions where !t.isEmpty {
            map[MapKey(t.currentState, t.currentSymbol)] = (t.writeSymbol, t.moveTape, t.nextState)
        }
        
        self.tape = Array(userData.tape).map { String($0) }
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
        var tapeLimitError = false // Флаг
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            var i = 0 // Переменная для подсчёта выполненных переходов
            while self.appState.wrappedValue == .run {
                if self.userData.slowMode {
                    Thread.sleep(forTimeInterval: 1)
                }
                
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
                        self.trimTape()
                        
                        if self.userData.slowMode || i % 10000 == 0 {
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
                
                if self.tape.count > 100 {
                    tapeLimitError = true
                    DispatchQueue.main.async {
                        self.appState.wrappedValue = .stopped
                    }
                }
                
                i += 1
            }
            
            DispatchQueue.main.async {
                if self.appState.wrappedValue == .stopped {
                    if tapeLimitError {
                        self.output.wrappedValue = "Tape limit exceeded."
                    } else {
                        self.trimTape()
                        self.output.wrappedValue = String(self.tape.map { $0.first! })
                    }
                }
            }
        }
    }
    
    private func trimTape() {
        let firstSymbolIndex = self.tape.firstIndex {
            $0 != self.userData.blankSymbol.rawValue
        }
        if let firstSymbolIndex = firstSymbolIndex {
            self.tape.removeSubrange(..<firstSymbolIndex)
            self.position -= firstSymbolIndex
        } else {
            self.tape.removeAll(keepingCapacity: true)
        }
        
        let lastSymbolIndex = self.tape.lastIndex {
            $0 != self.userData.blankSymbol.rawValue
        }
        if let lastSymbolIndex = lastSymbolIndex {
            self.tape.removeSubrange((lastSymbolIndex + 1)...)
        }
    }
}

class Transition: ObservableObject, Identifiable {
    let id = UUID() // Генерирует уникальный идентификатор
    @Published var currentState = ""
    @Published var currentSymbol = ""
    @Published var writeSymbol = ""
    @Published var moveTape = MoveTape.halt
    @Published var nextState = ""
    
    // Вычисляемое свойство, показывающее что хотя бы одно из полей не заполнено
    var isEmpty: Bool {
        currentState.isEmpty || currentSymbol.isEmpty || writeSymbol.isEmpty || nextState.isEmpty
    }
    
    // Вспомогательный конструктор (дефолтный пустой, так как всем полям присвоены значения по умолчанию
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

// Состояние эмулятора
enum AppState {
    case stopped
    case run
    case paused
}

enum StartPosition: String, CaseIterable, Identifiable  {
    case left = "Left"
    case right = "Right"
    //Вычисляемая переменная необходима для соответствия протоколу Identifiable
    var id: Self { self }
}

enum BlankSymbol: String, CaseIterable, Identifiable {
    case zero = "0"
    case underscore = "_"
    //Вычисляемая переменная необходима для соответствия протоколу Identifiable
    var id: Self { self }
}

enum MoveTape: String, CaseIterable, Identifiable {
    case left = "L"
    case halt = "H"
    case right = "R"
    
    //Вычисляемое значение, позволяющее проще передвигать управляющее устройство
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
    //Вычисляемая переменная необходима для соответствия протоколу Identifiable
    var id: Self { self }
}
