//
//  Helper.swift
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 3/9/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

import UIKit

enum  Scope {
    case global
    case local
}

enum Type: Int {
    case Corgi = 0
    case Float = 1
    case String = 2
    case Bool = 3
    case Int = 4
    case ERROR = 999
}

struct Symbol {
    var type: Type!
    var scope: Scope!
}

struct Function {
    var returnType: Type!
    var varTable = [String: Symbol]()
}

// Function & Variable Tables
@objc class Helper: NSObject{
    static let singleton = Helper()
    // Operations
    var operationTable:NSDictionary?
    var operators:[Operator] = []
    var idTypes:[Type] = []
    var idValues:[Any] = []
    
    // Quadruple
    var quadruples: [Quadruple] = []
    var temporalVariables: [Any] = []
    var indexTempVars = 0
    
    //Function
    var funcTable = [String:Function]()
    var currentFunc: String = "global"
    
    override init() {
        //Get operation table
        if let path = Bundle.main.path(forResource: "OperationTable", ofType: "plist") {
            operationTable = NSDictionary(contentsOfFile: path)
        }
    }
    
    func addFunction(_ id: String, type: String) {
        if type == "Corgi" || type == "corgiRun" {
            currentFunc = type
            funcTable[currentFunc] = Function(returnType: stringToType(type: type), varTable: [:])
        } else {
            funcTable[id] = Function(returnType: stringToType(type: type), varTable: [:])
            currentFunc = id
        }
    }
    
    func addVariable(_ id: String, type:String) {
        var scope: Scope = .global
        if currentFunc != "Corgi" {
            scope = .local
        }
        
        funcTable[currentFunc]?.varTable[id] = Symbol(type: stringToType(type: type), scope: scope)
    }
    
    func functionExists(_ id: String) -> Bool{
        if funcTable[id] != nil {
            return true
        }
        return false
    }
    
    func variableExists(_ id: String) -> Bool{
        if funcTable[currentFunc]?.varTable[id] != nil {
            return true
        } else if funcTable["global"]?.varTable[id] != nil {
            return true
        }
        
        return false
    }
    
    func stringToType(type: String) -> Type {
        switch type {
        case "String":
            return .String
        case "Int":
            return .Int
        case "Float":
            return .Float
        case "Bool":
            return .Bool
        default:
            return .Corgi
        }
    }
    
    func printTable() {
        print(funcTable)
    }
}
