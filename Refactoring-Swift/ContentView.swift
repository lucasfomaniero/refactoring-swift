//
//  ContentView.swift
//  Refactoring-Swift
//
//  Created by Lucas Maniero on 30/03/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var fileUtils = FileUtil()
    var statementTypes: [StatementType] {
        return StatementType.allCases.map({$0})
    }
    @State var selectedStyle: StatementType = StatementType.plain
    var body: some View {
        VStack {
            Picker(selection: $selectedStyle) {
                ForEach(statementTypes, id: \.self) { type in
                    Text(type.rawValue)
                }
            } label: {
                Text("Statement Type")
            }
            .onChange(of: selectedStyle, perform: { newValue in
                fileUtils.renderContent(type: newValue)
            })
            .pickerStyle(.segmented)
            .padding(.horizontal)
            List {
                
                ForEach(fileUtils.result, id: \.self) { text in
                    if let text = text as? AttributedString {
                        Text(text)
                    } else if let text = text as? String {
                        Text(text)
                    }
                }
            }
        }.onAppear{
            fileUtils.renderContent(type: selectedStyle)
        }
     
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
