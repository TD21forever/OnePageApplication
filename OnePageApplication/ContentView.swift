//
//  ContentView.swift
//  OnePageApplication
//
//  Created by T D on 2022/4/11.
//

import SwiftUI

struct ContentView: View {
    // the size of ContentView is exactly and always the size of its body
    var body: some View {
        
        Text("hello world")
            .background(.red)
            .offset(x: 100, y: 100)
            .background(.green)
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
