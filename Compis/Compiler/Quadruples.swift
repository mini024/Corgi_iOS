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
            switch type.lowercased() {
            case "int":
                let address = virtualMemory.constantsMemory.setInt(value: Int(name)!)
                idAddresses.append(address)
                idTypes.append(Type.Int)
            case "float":
                let address = virtualMemory.constantsMemory.setFloat(value: Float(name)!)
                idAddresses.append(address)
                idTypes.append(Type.Float)
            case "string":
                var value = name
                value = String(value.dropLast())
                value = String(value.dropFirst())
                let address = virtualMemory.constantsMemory.setString(value: value)
                idAddresses.append(address)
                idTypes.append(Type.String)
            case "bool":
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
            resultAddress =  virtualMemory.localMemory.setInt(value: 9999)
            quadruples.append(Quadruple(leftOperand: leftOperand!, rightOperand: rightOperand, oper: oper!, resultVar: resultAddress))
        case .Float:
            resultAddress = virtualMemory.localMemory.setFloat(value: 9999.9)
            quadruples.append(Quadruple(leftOperand: leftOperand!, rightOperand: rightOperand, oper: oper!, resultVar: resultAddress))
        case .String:
            resultAddress = virtualMemory.localMemory.setString(value: "")
            quadruples.append(Quadruple(leftOperand: leftOperand!, rightOperand: rightOperand, oper: oper!, resultVar: resultAddress))
        case .Bool:
            resultAddress = virtualMemory.localMemory.setBool(value: false)
            quadruples.append(Quadruple(leftOperand: leftOperand!, rightOperand: rightOperand, oper: oper!, resultVar: resultAddress))
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
        
        quadruples.append(Quadruple(leftOperand: temporalVariable, rightOperand: nil, oper: oper!, resultVar: resultVariable!))
        printQuadruples()
        return true
    }
    
    func generateGOTOFquadruple(_ code:Int) {
        // Step 1 result = pilaO.pop()
        let temporalVariableAddress = idAddresses.popLast()
        let temporalType = idTypes.popLast()
        
        guard temporalType == Type.Bool else {
            print("ERROR GOTOF - Wrong condition type")
            return
        }
        
        // Step 2 generate GOTOF quad
        let oper = Operator.GOTOF
        let nextQuadruple = 99999
        quadruples.append(Quadruple(leftOperand: temporalVariableAddress, rightOperand: nil, oper: oper, resultVar: nextQuadruple))
        
        // Step 2 pjumps.push(cont-1)
        let pendingIndex = quadruples.count
        pendingQuadruples.append(pendingIndex - 1)
    }
    
    func generateGOTOquadruple(_ code:Int) {
        // Check if there is pending quadruples
        if let end = pendingQuadruples.popLast() {
            if code == 0 {
                quadruples[end].resultVar = quadruples.count + 1
            } else {
                quadruples[end].resultVar = quadruples.count + 1
            }
        }
        
        // Generate GOTO Quadruple
        let oper = Operator.GOTO
        let nextQuadruple = 99999
        quadruples.append(Quadruple(leftOperand: nil, rightOperand: nil, oper: oper, resultVar: nextQuadruple))
        
        // Add index to pending quadruples to fill later.
        if code != 3 {
            let pendingIndex = quadruples.count
            pendingQuadruples.append(pendingIndex - 1)
        }
  
    }
    
    func generateWriteQuadruple() {
        let variableAddress = idAddresses.popLast()
        _ = idTypes.popLast()
        
        // Create quadruple with temoral value
        quadruples.append(Quadruple(leftOperand: nil, rightOperand: nil, oper: Operator(rawValue: 18)!, resultVar: variableAddress))
        
    }
    
    func generateLoopConditionQuadruples() -> Bool {
        let maxAddress = idAddresses.popLast()!
        let minAddress = idAddresses.popLast()!
        let variableAddress = idAddresses.popLast()!
        let maxType = idTypes.popLast()
        let minType = idTypes.popLast()
        let varType = idTypes.popLast()
        
        guard varType == Type.Int && minType == Type.Int && maxType == Type.Int else {
            print("Error - Variable and Range must be Ints")
            return false
        }
        
        pendingQuadruples.append(quadruples.count - 1)
        
        // Conditional Quadruple
        let lessThanMaxAddress = virtualMemory.localMemory.setBool(value: nil)
        quadruples.append(Quadruple(leftOperand: variableAddress, rightOperand: maxAddress, oper: Operator(rawValue: 7)!, resultVar: lessThanMaxAddress))
        
        let greaterThanMinAddress = virtualMemory.localMemory.setBool(value: nil)
        quadruples.append(Quadruple(leftOperand: variableAddress, rightOperand: minAddress, oper: Operator(rawValue: 9)!, resultVar: greaterThanMinAddress))
        
        let conditionAddress = virtualMemory.localMemory.setBool(value: nil)
        quadruples.append(Quadruple(leftOperand: lessThanMaxAddress, rightOperand: greaterThanMinAddress, oper: Operator(rawValue: 12)!, resultVar: conditionAddress))
        
        // Push variable Address to keep using
        idAddresses.append(variableAddress)
        idTypes.append(varType!)
        
        // Push temporal with result to address stack
        idAddresses.append(conditionAddress)
        idTypes.append(Type.Bool)
        
        return true
    }
    
    func generateWhileConditionQuadruple() {
        let pendingIndex = quadruples.count
        pendingQuadruples.append(pendingIndex - 1)
    }
    
    /**
        Quadruple for for loops "by" increments
    */
    func generateByQuadruple() -> Bool {
        let byAddress = idAddresses.popLast()
        let byType = idTypes.popLast()
        let variableAddress = idAddresses.popLast()
        let variableType = idTypes.popLast()
        
        guard byType == Type.Int && variableType == Type.Int else {
            return false
        }
        
        quadruples.append(Quadruple(leftOperand: byAddress, rightOperand: variableAddress, oper: Operator(rawValue: 0)!, resultVar: variableAddress))
        return true
    }
    
    func generateERAQuadruple(_ name: String) {
        let functionStartQuadruple = getFunctionStartAddressWith(id: name)
        
        guard functionStartQuadruple > 0 else {print("Error No function declared" + name); return}
        
        quadruples.append(Quadruple(leftOperand: functionStartQuadruple, rightOperand: nil, oper: Operator(rawValue: 20)!, resultVar: nil))
        callingFunction.append(name)
    }
    
    func generateEndOfFunctionQuadruple() {
        if currentFunc != "corgiRun" {
           quadruples.append(Quadruple(leftOperand: nil, rightOperand: nil, oper: Operator(rawValue: 23)!, resultVar: nil))
        }
        
        funcTable[currentFunc]?.memory = virtualMemory.localMemory
        virtualMemory.localMemory = Memory(value: virtualMemory.localMemory.INT_START_ADDRESS)
        printQuadruples()
    }
    
    func generateEndOfProgramQuadruple() {
        quadruples.append(Quadruple(leftOperand: nil, rightOperand: nil, oper: Operator(rawValue: 24)!, resultVar: nil))
        let corgiRunQuadruple = funcTable["corgiRun"]?.startAddress
        quadruples[0].resultVar = corgiRunQuadruple!
        printQuadruples()
        virtualMemory.memoryStack.append((funcTable["corgiRun"]?.memory)!)
        virtualMemory.localMemory = virtualMemory.memoryStack.popLast()!
        run(quadruples: quadruples)
    }
    
    func generateGoSubQuadruple() {
        let functionName = callingFunction.popLast()
        let functionAddress: Int = getFunctionStartAddressWith(id: functionName!)
        
        quadruples.append(Quadruple(leftOperand: functionAddress, rightOperand: nil, oper: Operator(rawValue: 21)!, resultVar: nil))
        funcTable[functionName!]?.currentParameter = 0
        
        // Check if there is return value in stack
        if (funcTable[functionName!]?.returnType)! != Type.Void {
            let returnAddress = returnValues.popLast()
            idAddresses.append(returnAddress!)
            idTypes.append((funcTable[functionName!]?.returnType)!)
        }
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
        let parameterAddress = parameterTuple.1
        
        guard argumentType == parameterType else {
            print("Error Wrong parameter type")
            return false
        }
        
        quadruples.append(Quadruple(leftOperand: argumentAddress, rightOperand: nil, oper: Operator(rawValue: 22)!, resultVar: parameterAddress))
        
        funcTable[currentFunc]?.currentParameter += 1
        
        return true
    }
    
    func generateReturnQuadruple() -> Bool{
        guard funcTable[currentFunc]?.returnType != Type.Void else {
            print("ERROR - Wrong return type");
            return false
        }
        
        let valueType = idTypes.popLast()
        let valueAddress = idAddresses.popLast()
        
        // Check type of return type & value
        guard funcTable[currentFunc]?.returnType == valueType else {print("ERROR - Wrong return type"); return false}
    
        // Generate quadruple
        quadruples.append(Quadruple(leftOperand: nil, rightOperand: nil, oper: Operator(rawValue: 25)!, resultVar: valueAddress))
        returnValues.append(valueAddress!)
        return true
    }
    
    func generateVoidReturnQuadruple() -> Bool {
        if funcTable[currentFunc]?.returnType != Type.Void {
            print("ERROR - Wrong return type");
            return false
        }
        
        quadruples.append(Quadruple(leftOperand: nil, rightOperand: nil, oper: Operator(rawValue: 25)!, resultVar: nil))
        return true
    }
    
    func fillEndLoopQuadruple() {
        // Step 2 end = pjumps.pop()
        let end = pendingQuadruples.popLast()
        
        if let next = pendingQuadruples.popLast() {
            quadruples[end!].resultVar = next + 1
        }
        
        printQuadruples()
    }
    
    func fillEndConditionQuadruple() {
        // Step 2 end = pjumps.pop()
        let end = pendingQuadruples.popLast()
        
        let nextQuadruple = quadruples.count
        quadruples[end!].resultVar = nextQuadruple
        
        printQuadruples()
    }
    
    func checkIfArray() -> Bool {
        
        let arrAddress = idAddresses.popLast()
        let size = getArraySize(address: arrAddress!)
        
        if size > 0 {
            pendingArray.append(arrAddress!)
            return true
        }
        return false
    }
    
    func checkRangeforArrayExpresion() -> Void {
        
        let size = idAddresses[idAddresses.count-1]
        let arr = pendingArray[pendingArray.count-1]
        let arrSize = getArraySize(address: arr)
        
        quadruples.append(Quadruple(leftOperand: arrSize, rightOperand: 0, oper: .VER, resultVar: size))
        printQuadruples()
    }
    
    func addSizeGaptoBaseAddress() -> Bool {
        
        let arrBaseDir = pendingArray.popLast()
        let gap = idAddresses.popLast()
        let gapType = idTypes.popLast()
        
        guard gapType == Type.Int else {print("Error - wrong gap type"); return false;}
                
        let targetArrayAddress = virtualMemory.localMemory.setInt(value: 99999)
        
        idAddresses.append(-1 * targetArrayAddress)
        quadruples.append(Quadruple(leftOperand: gap, rightOperand: -1 * arrBaseDir!, oper: .Sum, resultVar: targetArrayAddress))
        
        return true
    }
    
}
