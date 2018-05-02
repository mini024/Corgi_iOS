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
    
    /**
     Adds Corgi function to function table
     @param id - program name
     @param type - program type Corgi or corgiRun
     @return type - boolean
     */
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
    
    /**
     Adds fucntio to function table
     @param id - function name
     */
    func addFunctionWith(_ id: String) {
        funcTable[id] = Function(address: quadruples.count)
        currentFunc = id
    }
    
    /**
     Adds function return type
     @param id - function name
     @param type - function return type
     */
    func addFunctionReturnType(_ id: String, type: String) {
        funcTable[id]?.returnType = stringToType(type: type)
    }
    
    /**
     Creates address space for variable
     @param type - variable type
     @return - new address
     */
    func createAddressForVariable(type:String) -> Int {
        var scope: Scope = .global
        var address = 0
        if currentFunc != "Corgi" {
            scope = .local
        }
        
        // Check variable type
        switch type.lowercased() {
        case "int":
            if scope == .global {
                address = virtualMemory.globalMemory.setInt(value: 99999)
            } else {
                address = virtualMemory.localMemory.setInt(value: 99999)
            }
        case "float":
            if scope == .global {
                address = virtualMemory.globalMemory.setFloat(value: 9999.9)
            } else {
                address = virtualMemory.localMemory.setFloat(value: 9999.9)
            }
        case "bool":
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
    
    /**
     Adds variable or parameter to function table
        @param id - variable name
        @param type - variable type
        @param parameter - boolian declaring if value is a parameter
     */
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
    
    /**
     Adds array to function table
     @param id - variable name
     @param type - variable type
     @param size - array size
     */
    func addArrayVariable(_ id: String, type: String, size:Int) {
        addVariableToTable(id, type: type, parameter: false)
        funcTable[currentFunc]?.variables[id]?.arrSize = size
        
        // Create size - 1 of addresses
        for _ in 0...size-1 {
            _ = createAddressForVariable(type:type)
        }
        
    }
    
    /**
     Checks if fucntions exists
     @param id - variable name
     @return - true or false
     */
    func functionExists(_ id: String) -> Bool{
        if funcTable[id] != nil {
            return true
        }
        return false
    }
    
    /**
     Gets function start address
     @param id - variable name
     @return - start address or -1 if it doesn't exist
     */
    func getFunctionStartAddressWith(id: String) -> Int {
        let function = funcTable[id]
        
        guard function != nil else {
          return -1
        }
        
        return function!.startAddress
    }
    
    /**
     Gets function name with start address
     @param addres - start address
     @return - function name
     */
    func getFunctionNameWith(address: Int) -> String {
        // Check all functions in func table
        for function in funcTable {
            // Check if it has address that we are looking for
            if function.value.startAddress == address {
                return function.key
            }
        }
        
        return "Error"
    }
    
    /**
     checks if variable exists
     @param id - variable name
     @return - true or false
     */
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
    
    /**
     Get variable type
     @param id - variable name
     @return - Type
     */
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
    
    /**
     Get variable address
     @param id - variable name
     @return - variable address Int
     */
    func getVariableAddress(id: String) -> Int {
        //Check in current fuction varialbes
        if let variable = funcTable[currentFunc]?.variables[id] {
            return variable.address
        }
        
        //Check in current fuction parameters
        if let variable = funcTable[currentFunc]?.parameters[id] {
            return variable.address
        }
        
        // Check in global fucntion
        if let variable = funcTable["Corgi"]?.variables[id] {
            return variable.address
        }
        
        return -1
    }
    
    /**
     Get variable id with address
     @param address - variable address
     @return - variable name
     */
    func getVariableIdWith(address: Int) -> String{
        //Check in current fuction varialbes
        for variable in (funcTable[currentFunc]?.variables)! {
            if variable.value.address == address {
                return variable.key
            }
        }
        
        //Check in current fuction parameter
        for variable in (funcTable[currentFunc]?.parameters)! {
            if variable.value.address == address {
                return variable.key
            }
        }
        
        // Check in global fucntion
        for variable in (funcTable["Corgi"]?.variables)! {
            if variable.value.address == address {
                return variable.key
            }
        }
        
        return "Error"
    }
    
    /**
     Check if parameter exists
     @param id - variable name
     @return - true or false
     */
    func parameterExists(_ id: String) -> Bool{
        if funcTable[currentFunc]?.parameters[id] != nil {
            return true
        } else if funcTable["global"]?.variables[id] != nil {
            return true
        }
        
        return false
    }
    
    /**
     Get parameter type and address with index
     @param index - parameter index
     @param function - function where we need to look
     @return - Tuple with type and Address
     */
    func getParameterTypeAndAddressWith(index: Int, function: String) -> (Type, Int) {
        for parameter in (funcTable[function]?.parameters)! {
            if parameter.value.index == index {
                return (parameter.value.type, parameter.value.address)
            }
        }
        
        return (Type.ERROR, -1)
    }
    
    /**
     Get array size with address
     @param address - array address
     @return - Size or -1 if error
     */
    func getArraySize(address: Int) -> Int {
        
        for array in (funcTable[currentFunc]?.variables)! {
            if array.value.address == address{
                return (array.value.arrSize)
            }
        }
        
        for array in (funcTable["Corgi"]?.variables)! {
            if array.value.address == address{
                return (array.value.arrSize) == nil ? -1 : (array.value.arrSize)
            }
        }
        
        return -1
    }
    
    // Print function table
    func printTable() {
        print(funcTable)
    }

}

