//
//  ContentView.swift
//  OnePageApplication
//
//  Created by T D on 2022/4/11.
//

import SwiftUI

struct ContentView: View {
    // the size of ContentView is exactly and always the size of its body
    @State var number:Int = 10
    var body: some View {
        Text("hello")

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
