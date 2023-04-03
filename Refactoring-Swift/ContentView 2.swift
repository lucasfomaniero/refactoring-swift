//
//  ContentView.swift
//  Refactoring-Swift
//
//  Created by Lucas Maniero on 30/03/23.
//

import SwiftUI

struct ContentView: View {
<<<<<<< Updated upstream
    @StateObject private var fileUtils = FileUtil()
    var body: some View {
        List {
            
            ForEach(fileUtils.result, id: \.self) { text in
                Text(text)
            }
            .onAppear {
                print(fileUtils.result)
            }
            
=======
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
>>>>>>> Stashed changes
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
