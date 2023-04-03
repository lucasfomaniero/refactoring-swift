//
//  ContentView.swift
//  Refactoring-Swift
//
//  Created by Lucas Maniero on 30/03/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var fileUtils = FileUtil()
    var body: some View {
        List {
            
            ForEach(fileUtils.result, id: \.self) { text in
                Text(text)
            }
            .onAppear {
                print(fileUtils.result)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
