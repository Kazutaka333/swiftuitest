//
//  ContentView.swift
//  swiftuitest
//
//  Created by Kazutaka Homma on 2023/03/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
        }
        .padding()
        .onAppear(perform: {
            let temp = VM()
            Task {
                await temp.myActor.start()
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
