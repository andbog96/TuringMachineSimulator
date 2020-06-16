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
            })
            .frame(minWidth: 491)
        }
    }
}

struct ProgramView_Previews: PreviewProvider {
    static var previews: some View {
        ProgramView().environmentObject(UserData())
    }
}
