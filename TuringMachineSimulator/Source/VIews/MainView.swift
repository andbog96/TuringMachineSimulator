//
//  ContentView.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 26.04.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            Text("Разработал студент группы 6311. Богданов А.В.")
                .navigationBarTitle("About")
            
            ProgramView()
                .navigationBarTitle("Turing Machine", displayMode: .inline)
        }
        .padding(.leading, 1)
    }
}

struct ProgramView: View {
    @EnvironmentObject private var userData: UserData
    @State private var tabSelection = Tabs.trace
    @State private var machineState = MachineState.stopped
    @State private var currentState = ""
    @State private var currentPosition = 0
    
    var body: some View {
        VStack {
            Divider()
            HStack {
                TabView(selection: $tabSelection) {
                    TraceView().tabItem { Text("Trace") }.tag(Tabs.trace)
                    GeometryReader { geometry in
                        Text("Graph")
                    }
                    .tabItem { Text("Graph") }.tag(Tabs.graph)
                }
                
                FormView().navigationBarItems(trailing:
                    HStack {
                        Button(action: {
                            self.machineState = .stopped
                            
                            
                        }) {
                            Text("Stop")
                        }
                        .disabled(machineState == .stopped)
                        .opacity(machineState == .stopped ? 0 : 1)
                        Button(action: {
                            if self.machineState == .runned {
                                self.machineState = .paused
                                
                                
                            } else {
                                self.machineState = .runned
                            }
                        }) {
                            Text(machineState != .runned ? "Run" : "Pause")
                        }
                    }
                )
            }
        }
    }
    
    enum MachineState {
        case stopped
        case runned
        case paused
    }
    
    enum Tabs {
        case graph
        case trace
    }
}

struct FormView: View {
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        Form {
            Section(header: Text("EXECUTION SPEED")) {
                HStack {
                    Text("Operations / sec")
                    Spacer()
                    Picker("", selection: $userData.speed) {
                        ForEach(Speed.allCases) {
                            Text(String($0.rawValue))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .fixedSize()
                }
            }
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
            Section(header: Text("TAPE")) {
                HStack {
                    Text("Input")
                    Spacer()
                    TextField(userData.blankSymbol.rawValue, text: $userData.tape)
                        .multilineTextAlignment(.trailing)
                    //                    Button(action: {
                    //                        self.userData.tape = ""
                    //                    }) {
                    //                        Image(systemName: "multiply.circle.fill")
                    //                            .foregroundColor(.secondary)
                    //                    }
                    //                    .opacity(userData.tape.isEmpty ? 0 : 1)
                }
                HStack {
                    Text("Output")
                    Spacer()
                    Text(userData.output)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.secondary)
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(UserData()).previewLayout(.fixed(width: 1000, height: 800))  
    }
}


struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView().environmentObject(UserData()).previewLayout(.fixed(width: 1000, height: 800))
    }
}
