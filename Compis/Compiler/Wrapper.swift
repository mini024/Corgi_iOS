//
//  Conditional-ControlExpresions.swift
//  Compis
//
//  Created by Luis Alfonso Arriaga Quezada on 3/25/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.


import UIKit

@objc class Helper: NSObject{
    static var singleton = Helper()
    
    // Program
    var programName = ""
    
    // Virtual Memory
    let virtualMemory = VirtualMemory()
    
    // Operations
    var operationTable: NSDictionary?
    var operators: [Operator] = []
    var idTypes: [Type] = []
    var idAddresses: [Int] = []
    var callingFunction: [String] = []
    var pendingArray: [Int] = []
    var returnValues: [Int] = []
    
    // Quadruple
    var pendingQuadruples: [Int] = [] // jumps stack
    var quadruples: [Quadruple] = []
    var temporalVariables: [Any] = []
    var indexTempVars = 0
    
    // Function
    var funcTable = [String:Function]()
    var currentFunc: String = "global"
    
    override init() {
        //Get operation table
        if let path = Bundle.main.path(forResource: "OperationTable", ofType: "plist") {
            operationTable = NSDictionary(contentsOfFile: path)
        }
    }
    
    func clear() {
        Helper.singleton = Helper()
    }
    
    func printQuadruples() {
        var index = 0;
        for quadruple in quadruples {
            print(String(index), terminator:" ")
            print(quadruple)
            index += 1
        }
    }
    
    func getNextOp() -> String {
        guard operators.count > 0 else {return "EMPTY"}
        guard operators[operators.count-1] != Operator.Par else {return "EMPTY"}
        return operators[operators.count-1].description
    }
        
    func stringToOperator(oper: String) -> Operator {
        switch oper {
        case "+":
            return Operator.Sum
        case "-":
            return Operator.Subtract
        case "/":
            return Operator.Division
        case "*":
            return Operator.Product
        case "%":
            return Operator.Mod
        case "^":
            return Operator.Pow
        case ">":
            return Operator.Greater
        case "<":
            return Operator.Lower
        case "!=":
            return Operator.NotEqual
        case ">=":
            return Operator.GreaterEqual
        case "<=":
            return Operator.LowerEqual
        case "==":
            return Operator.Equal
        case "&&":
            return Operator.And
        case "||":
            return Operator.Or
        case "=":
            return Operator.EqualSign
        default:
            return Operator.Par
        }
    }
    
    func stringToType(type: String) -> Type {
        switch type.lowercased() {
        case "string":
            return .String
        case "int":
            return .Int
        case "float":
            return .Float
        case "bool":
            return .Bool
        case "void":
            return .Void
        default:
            return .Corgi
        }
    }
}
