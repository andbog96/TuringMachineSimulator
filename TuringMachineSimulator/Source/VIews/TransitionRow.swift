//
//  InstructionRow.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 07.05.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import SwiftUI

struct TransitionRow: View {
    @EnvironmentObject var userData: UserData
    @Binding var transition: Transition
    
    var body: some View {
        HStack {
            TextField("State", text: self.$transition.currentState)
            TextField("Symbol", text: self.$transition.currentSymbol)
            Text("->")
            TextField("Symbol", text: self.$transition.writeSymbol)
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
        let userData = UserData()
        return Group {
            TransitionRow(transition: .constant(.init())).environmentObject(userData)
            
        }
    }
}
