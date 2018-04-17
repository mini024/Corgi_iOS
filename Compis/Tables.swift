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
    
    func addCorgiFunctionBlock(_ id: String, type: String) {
        currentFunc = type
        funcTable[currentFunc] = Function(type: stringToType(type: type), address: quadruples.count)
    }
    
    func addFunctionWith(_ id: String) {
        funcTable[id] = Function(address: quadruples.count)
        currentFunc = id
    }
    
    func addFunctionReturnType(_ id: String, type: String) {
        funcTable[id]?.returnType = stringToType(type: type)
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
        case "Bool":
            if scope == .global {
                address = virtualMemory.globalMemory.setBool(value: nil)
            } else {
                address = virtualMemory.localMemory.setBool(value: nil)
            }
        default:
            if scope == .global {
                address = virtualMemory.globalMemory.setString(value: nil)
            } else {
                address = virtualMemory.localMemory.setString(value: nil)
            }
        }
        
        if parameter {
            let type = stringToType(type: type)
            funcTable[currentFunc]?.parameters[id] = Symbol(type: type , scope: scope, address: address, index: funcTable[currentFunc]?.parameters.count)
        } else {
            funcTable[currentFunc]?.variables[id] = Symbol(type: stringToType(type: type), scope: scope, address: address, index: nil)
        }
    }
    
    func addArrayVariable(_ id: String, type: String, size:Int) {
        //addVariable(id, type: type, parameter: false)
        //funcTable[currentFunc]?.variables[id]
    }
    
    func functionExists(_ id: String) -> Bool{
        if funcTable[id] != nil {
            return true
        }
        return false
    }
    
    func getFunctionStartAddressWith(id: String) -> Int {
        let function = funcTable[id]
        
        guard function != nil else {
          return -1
        }
        
        return function!.startAddress
    }
    
    func getFunctionNameWith(address: Int) -> String {
        for function in funcTable {
            if function.value.startAddress == address {
                return function.key
            }
        }
        
        return "Error"
    }
    
    func variableExists(_ id: String) -> Bool {
        if funcTable[currentFunc]?.variables[id] != nil {
            return true
        } else if funcTable["Corgi"]?.variables[id] != nil {
            return true
        } else if funcTable[currentFunc]?.parameters[id] != nil {
            return true
        }
        
        return false
    }
    
    func getVariableType(_ id:String) -> Type {
        if funcTable[currentFunc]?.variables[id] != nil {
            return (funcTable[currentFunc]?.variables[id]?.type)!
        } else if funcTable["Corgi"]?.variables[id] != nil {
            return (funcTable["Corgi"]?.variables[id]?.type)!
        } else if funcTable[currentFunc]?.parameters[id] != nil {
            return (funcTable[currentFunc]?.parameters[id]?.type)!
        }
        
        return Type.ERROR
    }
    
    func getVariableAddress(id: String) -> Int {
        if let variable = funcTable[currentFunc]?.variables[id] {
            return variable.address
        }
        
        if let variable = funcTable[currentFunc]?.parameters[id] {
            return variable.address
        }
        
        if let variable = funcTable["Corgi"]?.variables[id] {
            return variable.address
        }
        
        return -1
    }
    
    func parameterExists(_ id: String) -> Bool{
        if funcTable[currentFunc]?.parameters[id] != nil {
            return true
        } else if funcTable["global"]?.variables[id] != nil {
            return true
        }
        
        return false
    }
    
    func getParameterTypeAndAddressWith(index: Int, function: String) -> (Type, Int) {
        for parameter in (funcTable[function]?.parameters)! {
            if parameter.value.index == index {
                return (parameter.value.type, parameter.value.address)
            }
        }
        
        return (Type.ERROR, -1)
    }
    
    func printTable() {
        print(funcTable)
    }
}
