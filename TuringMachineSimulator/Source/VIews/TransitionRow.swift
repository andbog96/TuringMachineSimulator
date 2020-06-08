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
    
    var body: some View {
        HStack {
            TextField("State", text: $transition.currentState)
            
            TextField("Symbol", text: $transition.currentSymbol)
                .onReceive(Just(transition.currentSymbol)) {
                    let lastSymbol = String($0.last)
                    if self.transition.currentSymbol != lastSymbol {
                        self.transition.currentSymbol = lastSymbol
                    }
            }
            
            Text("=>")
            
            TextField("Symbol", text: $transition.writeSymbol)
            .onReceive(Just(transition.writeSymbol)) {
                    let lastSymbol = String($0.last)
                    if self.transition.writeSymbol != lastSymbol {
                        self.transition.writeSymbol = lastSymbol
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
        .lineLimit(1)
        .autocapitalization(.none)
        .disableAutocorrection(true)
    }
}

extension String {
    init(_ character: Character?) {
        if let character = character {
            self.init(character)
        } else {
            self.init("")
        }
    }
}

struct TransitionRow_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            TransitionRow(transition: .init())
        }
    }
}
