//
//  ProgramView.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 04.06.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import SwiftUI

struct ProgramView: View {
    @EnvironmentObject private var userData: UserData
    @State var appState = AppState.stopped
    @State private var currentState = ""
    @State private var currentPosition = 0
    
    @State private var machine: Machine?
    
    var body: some View {
        VStack {
            Divider()
            FormView(appState: $appState)
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        self.appState = .stopped
                    }) {
                        Text("Stop")
                    }
                    .disabled(appState == .stopped)
                    .opacity(appState == .stopped ? 0 : 1)
                    
                    Button(action: {
                        switch self.appState {
                        case .runned:
                            self.appState = .paused
                        case .paused:
                            self.appState = .runned
                            
                            self.machine!.resume()
                        case .stopped:
                            self.appState = .runned
                            
                            self.machine = Machine(self.userData, output: self.$userData.output, appState: self.$appState)
                        }
                    }) {
                        Text(appState != .runned ? "Run" : "Pause")
                    }
                }
            )
            .frame(minWidth: 491)
        }
    }
}

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
            .disabled(appState != .stopped)
        }
    }
}


struct ProgramView_Previews: PreviewProvider {
    static var previews: some View {
        ProgramView().environmentObject(UserData())
    }
}
