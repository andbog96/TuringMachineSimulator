//
//  FormView.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 17.06.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import SwiftUI

struct FormView: View {
    @EnvironmentObject private var userData: UserData
    @Binding var appState: AppState

    var body: some View {
        Form {
            Section(header: Text("MACHINE PROPERTIES")) {
                HStack {
                    Text("Blank Symbol")
                    Spacer()
                    Picker("", selection: $userData.blankSymbol) {
                        ForEach(BlankSymbol.allCases) {
                            Text($0.rawValue)
                        }
                    }
                            .pickerStyle(SegmentedPickerStyle())
                            .fixedSize()
                }
                HStack {
                    Text("Start Position")
                    Spacer()
                    Picker("", selection: $userData.startPosition) {
                        ForEach(StartPosition.allCases) {
                            Text($0.rawValue)
                        }
                    }
                            .pickerStyle(SegmentedPickerStyle())
                            .fixedSize()
                }
                HStack {
                    Text("Start State")
                    Spacer()
                    Text(userData.startState).foregroundColor(.secondary)
                }
            }
            .disabled(appState != .stopped)

            Section(header: Text("TAPE")) {
                HStack {
                    Text("Input")
                    Spacer()
                    TextField(userData.blankSymbol.rawValue, text: $userData.tape)
                            .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Output")
                    Spacer()
                    Text(userData.output)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.secondary)
                }
            }
            .disabled(appState != .stopped)

            Section(header: Text("SPEED"), footer: Text("Halt machine for a second before every transition.")) {
                Toggle(isOn: $userData.slowMode) {
                    Text("Slow Mode")
                }
            }
 
            Section(header: Text("TRANSITIONS")) {
                ForEach(userData.transitions) {
                    TransitionRow(transition: $0)
                }
                .onMove {
                    self.userData.transitions.move(fromOffsets: $0, toOffset: $1)
                }
                .onDelete {
                    self.userData.transitions.remove(atOffsets: $0)
                }

                HStack {
                    Spacer()
                    Button(action: { self.userData.transitions.append(Transition()) }) {
                        Text("Add Transition")
                    }
                    Spacer()
                }
            }
            .disabled(appState != .stopped)
        }
    }
}


struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView(appState: .constant(.stopped)).environmentObject(UserData())
    }
}
