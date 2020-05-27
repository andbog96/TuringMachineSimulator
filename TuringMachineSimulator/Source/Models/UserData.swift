//
//  UserData.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 18.05.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import Combine

final class UserData: ObservableObject {
    @Published var blankSymbol = BlankSymbol.zero
    @Published var tape = ""
    @Published var transitions = [Transition]()
}
