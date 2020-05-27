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
                ForEach(userData.transitions) { transition in
                    TransitionRow(transition)
                }
                .onDelete {
                    self.userData.transitions.remove(atOffsets: $0)
                }
                .onMove {
                    self.userData.transitions.move(fromOffsets: $0, toOffset: $1)
                }
                HStack {
                    Spacer()
                    Button(action: {self.userData.transitions.append(Transition())}) {
                        Text("Add Transition")
                    }
                    Spacer()
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct TransitionList_Previews: PreviewProvider {
    static var previews: some View {
        TransitionList().environmentObject(UserData())
    }
}
