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
            Text("""
                 Turing Machine Simulator
                 Designed by Andrey Bogdanov in 2020
                 """)
                .navigationBarTitle("About")
            
            ProgramView()
                .navigationBarTitle("Turing Machine", displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(UserData()).previewLayout(.fixed(width: 1000, height: 800))  
    }
}
