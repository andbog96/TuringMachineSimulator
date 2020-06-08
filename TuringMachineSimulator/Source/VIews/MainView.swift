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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(UserData()).previewLayout(.fixed(width: 1000, height: 800))  
    }
}
