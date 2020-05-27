//
//  Tape.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 07.05.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import Combine
import SwiftUI

struct TapeView: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        HStack {
            Text("Tape:")
            TextField(userData.blankSymbol.rawValue, text: $userData.tape)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .multilineTextAlignment(.center)
            
            Text("Blank:")
            Picker("", selection: $userData.blankSymbol) {
                ForEach(BlankSymbol.allCases) {
                    Text($0.rawValue)
                }
            }.pickerStyle(SegmentedPickerStyle()).fixedSize()
        }
    }
}

struct TapeView_Previews: PreviewProvider {
    static var previews: some View {
        TapeView().environmentObject(UserData())
    }
}
