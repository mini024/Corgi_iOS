//
//  Helper.swift
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 3/9/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

import UIKit

// Function & Variable Tables
extension Helper {
    
    func addFunction(_ id: String, type: String) {
        if type == "Corgi" || type == "corgiRun" {
            currentFunc = type
            funcTable[currentFunc] = Function(returnType: stringToType(type: type), variables: [:], parameters: [:], startAddress: quadruplesAddress.count - 1)
        } else {
            funcTable[id] = Function(returnType: stringToType(type: type), variables: [:], parameters: [:], startAddress: quadruplesAddress.count - 1)
            currentFunc = id
        }
    }
    
    func addVariable(_ id: String, type:String, parameter:Bool) {
        var scope: Scope = .global
        var address = 0
        if currentFunc != "Corgi" {
            scope = .local
        }
        
        switch type {
        case "Int":
            if scope == .global {
                address = virtualMemory.globalMemory.setInt(value: nil)
            } else {
                address = virtualMemory.localMemory.setInt(value: nil)
            }
        case "Float":
            if scope == .global {
                address = virtualMemory.globalMemory.setFloat(value: nil)
            } else {
                address = virtualMemory.localMemory.setFloat(value: nil)
            }
        default:
            if scope == .global {
                address = virtualMemory.globalMemory.setString(value: nil)
            } else {
                address = virtualMemory.localMemory.setString(value: nil)
            }
        }
        
        if parameter {
            funcTable[currentFunc]?.parameters[id] = Symbol(type: stringToType(type: type), scope: scope, address: address)
        } else {
            funcTable[currentFunc]?.variables[id] = Symbol(type: stringToType(type: type), scope: scope, address: address)
        }
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
    
    func printTable() {
        print(funcTable)
    }
}
