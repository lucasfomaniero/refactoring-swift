//
//  ContentView.swift
//  Refactoring-Swift
//
//  Created by Lucas Maniero on 30/03/23.
//

import SwiftUI

struct ContentView: View {
    @State private var result: String = "teste"
    @StateObject private var fileUtils = FileUtil()
    
    func logData() {
        let plays = fileUtils.loadDictionary(ofType: Play.self, ofFileWithName: "plays.json") ?? [:]
        let invoices = fileUtils.loadItems(ofType: Invoice.self, ofFileWithName: "invoices.json") ?? []
        
        
        result = try! fileUtils.statement(invoice: invoices[0], plays: plays)
    }
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(fileUtils.result)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
