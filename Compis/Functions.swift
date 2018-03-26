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
    var address: Int!
}

struct Function {
    var returnType: Type!
    var variables = [String: Symbol]()
    var parameters = [String: Symbol]()
    var startAddress: Int // Quadruple index
}

// Function & Variable Tables
@objc class Helper: NSObject{
    static let singleton = Helper()
    // Virtual Memory
    let virtualMemory = VirtualMemory()
    
    // Operations
    var operationTable: NSDictionary?
    var operators: [Operator] = []
    var idTypes: [Type] = []
    var idAddresses: [Int] = []
    
    // Quadruple
    var quadruples: [Quadruple] = []
    var quadruplesAddress: [QuadrupleDir] = []
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
    
    func addFunction(_ id: String, type: String) {
        if type == "Corgi" || type == "corgiRun" {
            currentFunc = type
            funcTable[currentFunc] = Function(returnType: stringToType(type: type), variables: [:], parameters: [:], startAddress: quadruplesAddress.count - 1)
        } else {
            funcTable[id] = Function(returnType: stringToType(type: type), variables: [:], parameters: [:], startAddress: quadruplesAddress.count - 1)
            currentFunc = id
        }
    }
    
    func addVariable(_ id: String, type:String) {
        var scope: Scope = .global
        var address = 0
        if currentFunc != "Corgi" {
            scope = .local
        }
        
        switch type {
        case "Int":
            if scope == .global {
                virtualMemory.globalMemory.setInt(value: nil)
                address = virtualMemory.globalMemory.intStartAddress
            } else {
                virtualMemory.localMemory.setInt(value: nil)
                address = virtualMemory.localMemory.intStartAddress
            }
        case "Float":
            if scope == .global {
                virtualMemory.globalMemory.setFloat(value: nil)
                address = virtualMemory.globalMemory.floatStartAddress
            } else {
                virtualMemory.localMemory.setFloat(value: nil)
                address = virtualMemory.localMemory.floatStartAddress
            }
        default:
            if scope == .global {
                virtualMemory.globalMemory.setString(value: nil)
                address = virtualMemory.globalMemory.stringStartAddress
            } else {
                virtualMemory.localMemory.setString(value: nil)
                address = virtualMemory.localMemory.stringStartAddress
            }
        }
        
        funcTable[currentFunc]?.variables[id] = Symbol(type: stringToType(type: type), scope: scope, address: address)
    }
    
    func addParameter(_ id: String, type:String) {
        var scope: Scope = .global
        var address = 0
        if currentFunc != "Corgi" {
            scope = .local
        }
        
        switch type {
        case "Int":
            if scope == .global {
                virtualMemory.globalMemory.setInt(value: nil)
                address = virtualMemory.globalMemory.intStartAddress
            } else {
                virtualMemory.localMemory.setInt(value: nil)
                address = virtualMemory.localMemory.intStartAddress
            }
        case "Float":
            if scope == .global {
                virtualMemory.globalMemory.setFloat(value: nil)
                address = virtualMemory.globalMemory.floatStartAddress
            } else {
                virtualMemory.localMemory.setFloat(value: nil)
                address = virtualMemory.localMemory.floatStartAddress
            }
        default:
            if scope == .global {
                virtualMemory.globalMemory.setString(value: nil)
                address = virtualMemory.globalMemory.stringStartAddress
            } else {
                virtualMemory.localMemory.setString(value: nil)
                address = virtualMemory.localMemory.stringStartAddress
            }
        }
        
        funcTable[currentFunc]?.parameters[id] = Symbol(type: stringToType(type: type), scope: scope, address: address)
    }
    
    func functionExists(_ id: String) -> Bool{
        if funcTable[id] != nil {
            return true
        }
        return false
    }
    
    func variableExists(_ id: String) -> Bool {
        if funcTable[currentFunc]?.variables[id] != nil {
            return true
        } else if funcTable["Corgi"]?.variables[id] != nil {
            return true
        }
        
        return false
    }
    
    func getVariableType(_ id:String) -> Type {
        if funcTable[currentFunc]?.variables[id] != nil {
            return (funcTable[currentFunc]?.variables[id]?.type)!
        } else if funcTable["Corgi"]?.variables[id] != nil {
            return (funcTable["Corgi"]?.variables[id]?.type)!
        }
        
        return Type.ERROR
    }
    
    func getVariableAddress( id: String) -> Int {
        if let variable = funcTable[currentFunc]?.variables[id] {
            return variable.address
        }
        
        if let variable = funcTable["Corgi"]?.variables[id] {
            return variable.address
        }
        
        return 0
    }
    
    func parameterExists(_ id: String) -> Bool{
        if funcTable[currentFunc]?.parameters[id] != nil {
            return true
        } else if funcTable["global"]?.variables[id] != nil {
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
