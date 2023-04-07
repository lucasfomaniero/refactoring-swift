//
//  FileUtil.swift
//  Refactoring-Swift
//
//  Created by Lucas Maniero on 30/03/23.
//

import Foundation
import Combine

class FileUtil: ObservableObject {
    @Published var result: [String] = []
    var plays: [String : Play] = [:]
    var invoices: [Invoice] = []
    
    let format: NumberFormatter = {
        let format = NumberFormatter()
        //        format.locale = Locale.current
        //        format.numberStyle = .currency
        //        format.currencyCode = "USD"
        format.maximumFractionDigits = 2
        format.minimumFractionDigits = 2
        format.roundingMode = .halfUp
        return format
    }()
    
    init() {
    }
    
    func loadFiles() {
        plays = loadDictionary(ofType: Play.self, ofFileWithName: "plays.json") ?? [:]
        invoices = loadItems(ofType: Invoice.self, ofFileWithName: "invoices.json") ?? []
    }
    
    func resetResultData() {
        if self.result.count > 0 {
            self.result.removeAll(keepingCapacity: true)
        }
    }
    
    func getHTMLContent() {
        resetResultData()
        self.invoices.forEach { invoice in
            result.append(( renderHTML(data: .init(invoice: invoice, plays: self.plays))))
         }
    }
    
    func getPlainContent() {
        resetResultData()
         invoices.forEach { invoice in
             result.append(( renderPlainStatement(data: .init(invoice: invoice, plays: self.plays))))
         }
    }
    
    func loadFileWith(name: String) -> URL? {
        let fileParts = name.split(separator: ".").map{String($0)}
        let (fileName, fileType) = (fileParts[0], fileParts[1])
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileType) else {
            return nil}
        return url
    }
    
    func loadDictionary<T: Decodable>(ofType type: T.Type, ofFileWithName name: String) -> [String: T]? {
        var result = [String:T]()
        let url = loadFileWith(name: name)
        guard let url = url, let data = try? Data(contentsOf: url) else {return nil}
        let decoder = JSONDecoder()
        if let objects = try? decoder.decode([String : T].self, from: data) {
            result = objects
        }
        return result
    }

    
    func loadItems<T: Decodable>(ofType type: T.Type, ofFileWithName name: String) -> [T]? {
        var result = [T]()
        let url = loadFileWith(name: name)
        guard let url = url, let data = try? Data(contentsOf: url) else {return nil}
        let decoder = JSONDecoder()
        if let objects = try? decoder.decode([T].self, from: data) {
            result = objects.sorted(by: { value1, value2 in
                String(describing: value1) < String(describing: value2)
            })
        }
        return result
    }

    
    fileprivate func amountFor(_ aPerformance: Performance) throws -> Int {
        var result: Int = 0
        switch playFor(aPerformance).genre {
        case .tragedy:
            result = 40_000
            if aPerformance.audience > 30 {
                result += 1000 * (aPerformance.audience - 30)
            }
        case .comedy:
            result = 30_000
            if aPerformance.audience > 20 {
                result += 10_000 + 500 * (aPerformance.audience - 20)
            }
            result += 300 * aPerformance.audience
        case .animation:
            return 0
        case .unknown:
            return 0
        }
        return result
    }
    
    func usd(_ number: Int) -> String {
        let format = NumberFormatter()
        format.locale = Locale(identifier: "en-US")
        format.numberStyle = .currency
        return format.string(from: NSNumber(value: number/100)) ?? "N/A"
    }

    
    func statement(invoice: Invoice, plays:[String:Play]) throws -> String {
        let statementData = StatementData(invoice: invoice, plays: plays)
        return try renderPlainStatement(data: statementData)
    }
    
    func renderPlainStatement(data: StatementData) -> String {
        var result = "Statement for \(data.customer)\n"
        for perf in data.performances {
            // Exibe a linha para esta requisição
            result += "|-\(perf.play.name): \(usd(perf.amount)) (\(perf.audience) seats)\n"
        }
        //Slide statement
        let totalAmount = data.totalAmount
        result += "Amount owed is \(usd(totalAmount))\n"
        
        //Deslocar instruções - Slide statements
//        let volumeCredits: Double = totalVolumeCredits(invoice: data.invoice)
        result += "Your earned \(data.totalVolumeCredits) credit"
        
        return result
    }
    
    func htmlStatement(invoice: Invoice, plays: Catalog) -> String {
        return renderHTML(data: StatementData(invoice: invoice, plays: plays))
    }
    
    func renderHTML(data: StatementData) -> String {
        var result = "<h1>Statement for \(data.customer)</h1>\n"
        result += "<table>\n"
        result += "<tr><th>play</th><th>seats</th><th>cost</th></tr>\n"
        for performance in data.performances {
            result += "<tr><td>\(performance.play.name)</td>"
            result += "<td>\(performance.audience)</td>"
            result += "<td>\(usd(performance.amount))</td></tr>\n"
        }
        result += "</table>\n"
        result += "<p>Amount owed is <em>\(usd(data.totalAmount))</em></p>\n"
        result += "<p>You earned <em>\(data.totalVolumeCredits)</em> credits</p>\n"
        return result
    }
    
    func totalAmount(_ invoice: Invoice) throws -> Int {
        var totalAmount = 0
        for perf in invoice.performances {
            totalAmount += try amountFor(perf)
        }
        return totalAmount
    }
    
    func totalVolumeCredits(invoice: Invoice) -> Double{
        var result = 0.0
        //Dividir o laço - Split Loop
        for perf in invoice.performances {
            result += volumeCreditsFor(perf)
        }
        return result
    }
    
    fileprivate func volumeCreditsFor(_ aPerformance: Performance) -> Double{
        var result = 0.0
        //Soma créditos por volume
        result += Double(max(aPerformance.audience - 30, 0))
        
        //Soma um crédito extra para cada dez espectadores de comédia
        if (playFor(aPerformance).genre == .comedy) {
            result += Double(aPerformance.audience / 5)
        }
        return result
    }
    
    func playFor(_ aPerformance: Performance) -> Play {
        plays[aPerformance.playID]!
    }

    
}
