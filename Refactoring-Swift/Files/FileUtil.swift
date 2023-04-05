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
    
    let format: NumberFormatter = {
        let format = NumberFormatter()
        format.numberStyle = .decimal
        format.maximumFractionDigits = 2
        format.minimumFractionDigits = 2
        format.roundingMode = .halfUp
        return format
    }()
    
    init() {
        let plays = loadDictionary(ofType: Play.self, ofFileWithName: "plays.json") ?? [:]
        let invoices = loadItems(ofType: Invoice.self, ofFileWithName: "invoices.json") ?? []
        do {
            try self.calculate(invoices: invoices, plays: plays)
        } catch let err as Errors {
            print(err)
        } catch {
            
        }
    }
    
    func calculate(invoices: [Invoice], plays: [String: Play]) throws {
        try invoices.forEach { invoice in
            result.append((try statement(invoice: invoice, plays: plays)))
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
    
    fileprivate func extractedFunc(_ play: Play, _ thisAmount: inout Int, _ perf: Performance) throws {
        switch play.type {
        case "tragedy":
            thisAmount = 40_000
            if perf.audience > 30 {
                thisAmount += 1000 * (perf.audience - 30)
            }
        case "comedy":
            thisAmount = 30_000
            if perf.audience > 20 {
                thisAmount += 10_000 + 500 * (perf.audience - 20)
            }
            thisAmount += 300 * perf.audience
        default:
            throw Errors.unknownTypeError(message: "Unknown Type")
        }
    }
    
    func statement(invoice: Invoice, plays: [String: Play]) throws -> String {
        
        var totalAmount: Double = 0.0;
        var volumeCredits: Double = 0.0
        var result = "Statement for \(invoice.customer)\n"
        
        for perf in invoice.performances {
            if let play  = plays[perf.playID]{
                var thisAmount = 0
                try extractedFunc(play, &thisAmount, perf)
    //Soma créditos por volume
                volumeCredits += Double(max(perf.audience - 30, 0))
    //Soma um crédito extra para cada dez espectadores de comédia
                if (play.type == "comedy") {
                    volumeCredits += Double(perf.audience / 5)
                }
                
                // Exibe a linha para esta requisição
                result += "|-\(play.name): \(format.string(from: NSNumber(value: thisAmount / 100)) ?? "0.0") (\(perf.audience) seats)\n"
                totalAmount += Double(thisAmount)
                
            }
                
        }
        result += "Amount owed is \(format.string(from: totalAmount/100 as NSNumber) ?? "0.0")\n"
        result += "Your earned \(volumeCredits) credit"
        return result
    }

    
}
