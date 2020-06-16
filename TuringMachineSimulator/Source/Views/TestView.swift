//
//  TestView.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 19.05.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import SwiftUI

struct TestView: View {
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Go to detail", destination: Text("New Detail"))
            }
            .navigationBarTitle("Programms")
                
            Text("Placeholder for Detail")
                .navigationBarTitle("Program")
                .navigationBarItems(trailing:
                    Button(action: {}, label: {
                        Image(systemName: "play.fill")
                    })
                )
            .navigationBarBackButtonHidden(true)
        }
        //.navigationViewStyle(DefaultNavigationViewStyle())
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
