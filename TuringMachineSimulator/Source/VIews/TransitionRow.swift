//
//  InstructionRow.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 07.05.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import Combine
import SwiftUI

struct TransitionRow: View {
    @ObservedObject var transition: Transition
    
    init(_ transition: Transition) {
        self.transition = transition
    }
    
    var body: some View {
        HStack {
            TextField("State", text: self.$transition.currentState)
            TextField("Symbol", text: $transition.currentSymbol)
                .onReceive(Just(transition.currentSymbol)) {
                    var newValue = ""
                    if let char = $0.last {
                        newValue = String(char)
                    }
                    if self.transition.currentSymbol != newValue {
                        self.transition.currentSymbol = newValue
                    }
            }
            Text("->")
            TextField("Symbol", text: self.$transition.writeSymbol)
                .onReceive(Just(transition.writeSymbol)) {
                    var newValue = ""
                    if let last = $0.last {
                        newValue = String(last)
                    }
                    if self.transition.writeSymbol != newValue {
                        self.transition.writeSymbol = newValue
                    }
            }
            Picker("", selection: $transition.moveTape) {
                ForEach(MoveTape.allCases) {
                    Text($0.rawValue)
                }
            }.pickerStyle(SegmentedPickerStyle()).fixedSize()
            TextField("State", text: self.$transition.nextState)
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .multilineTextAlignment(.center)
    }
}

struct TransitionRow_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            TransitionRow(.init())
        }
    }
}
