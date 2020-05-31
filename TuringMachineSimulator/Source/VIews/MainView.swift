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
            List {
                Text("qq)")
            }
            
            ProgramView()
                    .navigationBarTitle("Program", displayMode: .inline)
                    .navigationBarItems(trailing:
                        Button(action: {}) {
                            Image(systemName: "play.fill")
                                .font(.headline)
                        }
            )
            }
        .padding(.leading, 0.25)
    }
}

struct ProgramView: View {
    @EnvironmentObject private var userData: UserData
    @State private var tabSelection = Tabs.graph
    
    var body: some View {
        VStack {
            Divider()
            TapeView().padding([.horizontal, .top])
            HStack {
                TabView(selection: $tabSelection) {
                    GeometryReader { geometry in
                        Text("Graph")
                    }
                    .tabItem { Text("Graph") }.tag(Tabs.graph)
                    TraceView().tabItem { Text("Trace") }.tag(Tabs.trace)
                }
                
                TransitionList().frame(minWidth: 500)
            }
        }
    }
    
    enum Tabs {
        case graph
        case trace
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(UserData()).previewLayout(.fixed(width: 1000, height: 800))  
    }
}
