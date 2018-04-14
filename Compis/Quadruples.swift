//
//  Quadruples.swift
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 3/16/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

import UIKit

// Aritmetic Expresions - Semantic Cube, Quadruples.
extension Helper {
    
    // Punto 1
    func pushIdAddress(_ name: String, type: String) {
        if variableExists(name) && type != "Function" {
            idAddresses.append(getVariableAddress(id: name))
            idTypes.append(getVariableType(name))
        } else {
            switch type {
            case "Int":
                let address = virtualMemory.constantsMemory.setInt(value: Int(name)!)
                idAddresses.append(address)
                idTypes.append(Type.Int)
            case "Float":
                let address = virtualMemory.constantsMemory.setFloat(value: Float(name)!)
                idAddresses.append(address)
                idTypes.append(Type.Float)
            case "String":
                
                let address = virtualMemory.constantsMemory.setString(value: name)
                idAddresses.append(address)
                idTypes.append(Type.String)
            case "Bool":
                let address = virtualMemory.constantsMemory.setBool(value: name.toBool())
                idAddresses.append(address)
                idTypes.append(Type.Bool)
            default:
                // ERROR or Corgi
                break
            }
        }
    }
    
    // Punto 2, 3 y 6
    func pushOperator(_ op: String) {
        operators.append(stringToOperator(oper: op))
    }
    
    // Punto 7
    func popPar() {
        guard operators[operators.count-1] != Operator.Par else {return}
        operators.removeLast()
    }
    
    // Punto 4 y 5
    func generateQuadruple() -> Bool {
        let rightType = idTypes.popLast()
        let leftType = idTypes.popLast()
        let rightOperand = idAddresses.popLast()
        let leftOperand = idAddresses.popLast()
        let oper = operators.popLast()
        
        let operArray = operationTable!.value(forKey: (oper?.description)!) as! [[Int]]
        let resultType = Type(rawValue: operArray[(leftType?.rawValue)!][(rightType?.rawValue)!])
        guard resultType != .ERROR else {
            print("Error No possible ")
            return false
        }
        
        var resultAddress = 0
        
        switch resultType! {
        case .Int:
            resultAddress =  virtualMemory.temporalMemory.setInt(value: nil)
            quadruplesAddress.append(QuadrupleDir(leftOperand: leftOperand!, rightOperand: rightOperand, oper: oper!, resultVar: resultAddress))
        case .Float:
            resultAddress = virtualMemory.temporalMemory.setFloat(value: nil)
            quadruplesAddress.append(QuadrupleDir(leftOperand: leftOperand!, rightOperand: rightOperand, oper: oper!, resultVar: resultAddress))
        case .String:
            resultAddress = virtualMemory.temporalMemory.setString(value: nil)
            quadruplesAddress.append(QuadrupleDir(leftOperand: leftOperand!, rightOperand: rightOperand, oper: oper!, resultVar: resultAddress))
        case .Bool:
            resultAddress = virtualMemory.temporalMemory.setBool(value: nil)
            quadruplesAddress.append(QuadrupleDir(leftOperand: leftOperand!, rightOperand: rightOperand, oper: oper!, resultVar: resultAddress))
        default:
            return false
        }
        
        idAddresses.append(resultAddress) // push temporal variable to operands stack
        idTypes.append(resultType!) // push temporal variable type to types stack
        printQuadruples()
        return true
    }
    
    func generateAssignationQuadruple() -> Bool {
        let oper = operators.popLast()
        let temporalType = idTypes.popLast()
        let temporalVariable = idAddresses.popLast()
        let resultVariable = idAddresses.popLast()
        let resultType = idTypes.popLast()

        guard temporalType == resultType else {
            return false
        }
        
        quadruplesAddress.append(QuadrupleDir(leftOperand: temporalVariable, rightOperand: nil, oper: oper!, resultVar: resultVariable!))
        printQuadruples()
        return true
    }
    
    func generateGOTOFquadruple() {
        // Step 1 result = pilaO.pop()
        let temporalVariableAddress = idAddresses.popLast()
        
        // Step 2 generate GOTOF quad
        let oper = Operator.GOTOF
        let nextQuadruple = 99999
        quadruplesAddress.append(QuadrupleDir(leftOperand: temporalVariableAddress, rightOperand: nil, oper: oper, resultVar: nextQuadruple))
        
        // Step 2 pjumps.push(cont-1)
        let pendingIndex = quadruplesAddress.count
        
        pendingQuadruples.append(pendingIndex - 1)
    }
    
    func generateGOTOquadruple() {
        // Generate GOTO Quadruple
        let oper = Operator.GOTO
        let nextQuadruple = 99999
        quadruplesAddress.append(QuadrupleDir(leftOperand: nil, rightOperand: nil, oper: oper, resultVar: nextQuadruple))
        
        // Check if there is pending quadruples -> end of case condition
        if let end = pendingQuadruples.popLast() {
            // Fill goTo addresses in other quadruple
            quadruplesAddress[end].resultVar = quadruplesAddress.count + 1
        }
        
        // Add index to pending quadruples to fill later.
        let pendingIndex = quadruplesAddress.count
        pendingQuadruples.append(pendingIndex)
    }
    
    func generateWriteQuadruple(_ id:String) {
        let variableAddress = getVariableAddress(id: id)
        
        if variableAddress != 0 {
            quadruplesAddress.append(QuadrupleDir(leftOperand: nil, rightOperand: nil, oper: Operator(rawValue: 18)!, resultVar: variableAddress))
            return
        }
        
        // Add string to temporal variable
        let temporalAddress =  virtualMemory.temporalMemory.setString(value: id)
        
        // Create quadruple with temoral value
        quadruplesAddress.append(QuadrupleDir(leftOperand: nil, rightOperand: nil, oper: Operator(rawValue: 18)!, resultVar: temporalAddress))
        
    }
    
    func generateLoopConditionQuadruples(_ id:String, min:Int, max:Int, by:Int) {
        let maxAddress = idAddresses[idAddresses.count - 1]
        let minAddress = idAddresses[idAddresses.count - 2]
        let variableAddress = idAddresses[idAddresses.count - 3]
        
        pendingQuadruples.append(quadruplesAddress.count + 1)
        
        // Conditional Quadruple
        let lessThanMaxAddress = virtualMemory.temporalMemory.setBool(value: nil)
        quadruplesAddress.append(QuadrupleDir(leftOperand: variableAddress, rightOperand: maxAddress, oper: Operator(rawValue: 10)!, resultVar: lessThanMaxAddress))
        
        let greaterThanMinAddress = virtualMemory.temporalMemory.setBool(value: nil)
        quadruplesAddress.append(QuadrupleDir(leftOperand: variableAddress, rightOperand: minAddress, oper: Operator(rawValue: 9)!, resultVar: greaterThanMinAddress))
        
        let conditionAddress = virtualMemory.temporalMemory.setBool(value: nil)
        quadruplesAddress.append(QuadrupleDir(leftOperand: lessThanMaxAddress, rightOperand: greaterThanMinAddress, oper: Operator(rawValue: 12)!, resultVar: conditionAddress))
        
        // Push temporal with result to address stack
        idAddresses.append(conditionAddress)
    }
    
    func generateByQuadruple() {
        let byAddress = idAddresses[idAddresses.count - 1]
        let variableAddress = idAddresses[idAddresses.count - 4]
        
        quadruplesAddress.append(QuadrupleDir(leftOperand: byAddress, rightOperand: variableAddress, oper: Operator(rawValue: 0)!, resultVar: variableAddress))
    }
    
    func generateERAQuadruple(_ name: String) {
        let functionStartQuadruple = getFunctionStartAddressWith(id: name)
        
        guard functionStartQuadruple > 0 else {print("Error No function declared" + name); return}
        
        quadruplesAddress.append(QuadrupleDir(leftOperand: functionStartQuadruple, rightOperand: nil, oper: Operator(rawValue: 20)!, resultVar: nil))
        callingFunction.append(name)
    }
    
    func generateEndOfFunctionQuadruple() {
        quadruplesAddress.append(QuadrupleDir(leftOperand: nil, rightOperand: nil, oper: Operator(rawValue: 23)!, resultVar: nil))
    }
    
    func generateEndOfProgramQuadruple() {
        quadruplesAddress.append(QuadrupleDir(leftOperand: nil, rightOperand: nil, oper: Operator(rawValue: 24)!, resultVar: nil))
        let firstGoTo = pendingQuadruples.popLast()
        let corgiRunQuadruple = funcTable["corgiRun"]?.startAddress
        quadruplesAddress[firstGoTo!].resultVar = corgiRunQuadruple
    }
    
    func generateGoSubQuadruple() {
        let functionName = callingFunction.popLast()
        let functionAddress = getFunctionStartAddressWith(id: functionName!)
        
        quadruplesAddress.append(QuadrupleDir(leftOperand: functionAddress, rightOperand: nil, oper: Operator(rawValue: 21)!, resultVar: nil))
        funcTable[functionName!]?.currentParameter = 0
    }
    
    func generateParameterQuadruple() -> Bool {
        let argumentAddress = idAddresses.popLast()
        let argumentType = idTypes.popLast()
        let functionName = callingFunction[callingFunction.count - 1]
        let parameterIndex = funcTable[functionName]?.currentParameter
        let parameterTuple = getParameterTypeAndAddressWith(index: parameterIndex!, function: functionName)
        
        guard parameterTuple.0 != .ERROR else {
            print("No parameter on index")
            return false
        }
        
        let parameterType = parameterTuple.0
        let parameterID = parameterTuple.1
        
        guard argumentType == parameterType else {
            print("Error Wrong parameter type")
            return false
        }
        
        quadruplesAddress.append(QuadrupleDir(leftOperand: argumentAddress, rightOperand: nil, oper: Operator(rawValue: 22)!, resultVar: parameterID))
        
        funcTable[currentFunc]?.currentParameter += 1
        
        return true
    }
    
    func fillEndLoopQuadruple() {
        // Step 2 end = pjumps.pop()
        let end = pendingQuadruples.popLast()
        
        if let next = pendingQuadruples.popLast() {
            quadruplesAddress[end!].resultVar = next
        }
        
        printQuadruples()
    }
    
    func fillEndConditionQuadruple() {
        // Step 2 end = pjumps.pop()
        let end = pendingQuadruples.popLast()
        
        let nextQuadruple = quadruplesAddress.count + 1
        quadruplesAddress[end!].resultVar = nextQuadruple
        
        printQuadruples()
    }
    
}
