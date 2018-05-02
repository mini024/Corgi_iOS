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
    
    func addCorgiFunctionBlock(_ id: String, type: String) -> Bool {
        if functionExists(id) {
            return false
        }
        
        if type == "Corgi" {
            programName = id
        }
        currentFunc = type
        funcTable[currentFunc] = Function(type: stringToType(type: type), address: quadruples.count)
        
        return true
    }
    
    func addFunctionWith(_ id: String) {
        funcTable[id] = Function(address: quadruples.count)
        currentFunc = id
    }
    
    func addFunctionReturnType(_ id: String, type: String) {
        funcTable[id]?.returnType = stringToType(type: type)
    }
    
    func createAddressForVariable(type:String) -> Int {
        var scope: Scope = .global
        var address = 0
        if currentFunc != "Corgi" {
            scope = .local
        }
        
        switch type {
        case "Int":
            if scope == .global {
                address = virtualMemory.globalMemory.setInt(value: 99999)
            } else {
                address = virtualMemory.localMemory.setInt(value: 99999)
            }
        case "Float":
            if scope == .global {
                address = virtualMemory.globalMemory.setFloat(value: 9999.9)
            } else {
                address = virtualMemory.localMemory.setFloat(value: 9999.9)
            }
        case "Bool":
            if scope == .global {
                address = virtualMemory.globalMemory.setBool(value: false)
            } else {
                address = virtualMemory.localMemory.setBool(value: false)
            }
        default:
            if scope == .global {
                address = virtualMemory.globalMemory.setString(value: "")
            } else {
                address = virtualMemory.localMemory.setString(value: "")
            }
        }
        
        return address
    }
    
    func addVariableToTable(_ id: String, type:String, parameter:Bool) {
        
        let address = createAddressForVariable(type: type)
        var scope: Scope = .global
        if currentFunc != "Corgi" {
            scope = .local
        }
        
        if parameter {
            let type = stringToType(type: type)
            funcTable[currentFunc]?.parameters[id] = Variable(type: type , scope: scope, address: address, index: funcTable[currentFunc]?.parameters.count, arrSize: nil)
        } else {
            funcTable[currentFunc]?.variables[id] = Variable(type: stringToType(type: type), scope: scope, address: address, index: nil, arrSize: nil)
        }
    }
    
    func addArrayVariable(_ id: String, type: String, size:Int) {
        addVariableToTable(id, type: type, parameter: false)
        funcTable[currentFunc]?.variables[id]?.arrSize = size
        
        // Create size - 1 of addresses
        for _ in 0...size-1 {
            _ = createAddressForVariable(type:type)
        }
        
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
    
    func getVariableIdWith(address: Int) -> String{
        for variable in (funcTable[currentFunc]?.variables)! {
            if variable.value.address == address {
                return variable.key
            }
        }
        
        for variable in (funcTable["Corgi"]?.variables)! {
            if variable.value.address == address {
                return variable.key
            }
        }
        
        return "Error"
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
    
    func getArraySize(address: Int) -> Int {
        
        for array in (funcTable[currentFunc]?.variables)! {
            if array.value.address == address{
                return (array.value.arrSize)
            }
        }
        
        for array in (funcTable["Corgi"]?.variables)! {
            if array.value.address == address{
                return (array.value.arrSize) == nil ? 0 : (array.value.arrSize)
            }
        }
        
        return -1
    }
    
    func printTable() {
        print(funcTable)
    }

}

