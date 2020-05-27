//
//  InstructionList.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 07.05.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import SwiftUI

struct TransitionList: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        List {
            Section(header: Text("Transitions")) {
                ForEach(userData.transitions.indices, id: \.self) { index in
                    TransitionRow(transition:  self.$userData.transitions[index])
                }
                .onDelete(perform: { self.userData.transitions.remove(atOffsets: $0)
                })
                HStack {
                    Spacer()
                    Button(action: addTransition) {
                        Text("Add Transition")
                    }
                    Spacer()
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
    
    private func addTransition() {
        userData.transitions.append(Transition( currentState: String(userData.transitions.count)))
    }
    
    private func onDelete(offsets: IndexSet) {
        //userData.transitions.remove(atOffsets: offsets)
    }
}

struct TransitionList_Previews: PreviewProvider {
    static var previews: some View {
        TransitionList().environmentObject(UserData())
    }
}
