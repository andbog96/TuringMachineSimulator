//
//  ContentView.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 26.04.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        VStack {
            TapeView()
            HStack {
                GeometryReader { geometry in
                    Text("Graph")
                }.overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                TransitionList()
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(UserData())
    }
}
