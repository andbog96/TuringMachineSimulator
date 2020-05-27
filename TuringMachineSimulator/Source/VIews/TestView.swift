//
//  TestView.swift
//  TuringMachineSimulator
//
//  Created by Andrey Bogdanov on 19.05.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import SwiftUI

struct TestView: View {
    @State var isModal: Bool = false

    var modal: some View {
        Text("Modal")
    }

    
    
    var body: some View {
        Button("Modal") {
            self.isModal = true
        }.sheet(isPresented: $isModal, content: {
            self.modal
        })
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
