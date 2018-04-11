//
//  Conditional-ControlExpresions.swift
//  Compis
//
//  Created by Luis Alfonso Arriaga Quezada on 3/25/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.

//  TODO: Finish implementation of generateGOTOFquadruple()

import UIKit

extension Helper {
    
    func generateGOTOFquadruple() -> Bool {
        
        // Step 1 result = pilaO.pop()
        let temporalVariableAddress = idAddresses.popLast()
        
        // Step 2 generate GOTOF quad
        let oper = Operator.GOTOF
        let nextQuadruple = 99999
        quadruplesAddress.append(QuadrupleDir(leftOperand: temporalVariableAddress, rightOperand: nil, oper: oper, resultVar: nextQuadruple))
        
        // Step 2 pjumps.push(cont-1)
        let pendingIndex = quadruplesAddress.count - 1
        
        pendingQuadruples.append(pendingIndex)

        return true
    }
    
    func generateGOTOquadruple() -> Bool {
        
        // Step 3 generate GOTO quad
        let oper = Operator.GOTO
        let nextQuadruple = 99999
    quadruplesAddress.append(QuadrupleDir(leftOperand: nil, rightOperand: nil, oper: oper, resultVar: nextQuadruple))
        
        // Step 3 false = pjumps.pop()
        //let pendingQuadruple = pendingQuadruples.popLast()
        
        fillEndquadruple()
    
        // Step 3 pjumps.push(cont-1)
        let pendingIndex = quadruplesAddress.count - 1
        pendingQuadruples.append(pendingIndex)
        
        // Step 3 fill (false, cont)
        //fill(pendingQuadruple!, nextQuadruple: quadruplesAddress.count + 1)
        
        printQuadruples()
        
        return true
    }
    
    func printQuadruples() {
        var index = 0;
        for quadruple in quadruplesAddress {
            print(String(index), terminator:" ")
            print(quadruple)
            index += 1
        }
    }
    
    func fillEndquadruple() {
        
        // Step 2 end = pjumps.pop()
        let end = pendingQuadruples.popLast()
        
        // Step 2 Fill(end, count)
        fill(end!, nextQuadruple: quadruplesAddress.count + 1)
    }
    
    func fill(_ pendingIndex: Int, nextQuadruple: Int) -> Bool {
        
        quadruplesAddress[pendingIndex].resultVar = nextQuadruple
        
        return true
    }
    
    func generateWriteQuadruple(_ id:String) {
        let variableAddress = getVariableAddress(id: id)
        
        if variableAddress != 0 {
            quadruplesAddress.append(QuadrupleDir(leftOperand: nil, rightOperand: nil, oper: Operator(rawValue: 18)!, resultVar: variableAddress))
            return
        }
        
        // Add string to temporal variable
        virtualMemory.temporalMemory.setString(value: id)
        let temporalAddress = virtualMemory.temporalMemory.boolStartAddress - 1
        
        // Create quadruple with temoral value
        quadruplesAddress.append(QuadrupleDir(leftOperand: nil, rightOperand: nil, oper: Operator(rawValue: 18)!, resultVar: temporalAddress))
        
    }
    
    func generateLoopConditionQuadruples(_ id:String, min:Int, max:Int, by:Int) {
        let variableAddress = getVariableAddress(id: id)
        guard variableAddress != 0 else { print("ERROR - Varaible no existe"); return}
        
        // Generate temporals with values
        virtualMemory.temporalMemory.setInt(value: max)
        let maxAddress = virtualMemory.temporalMemory.boolStartAddress - 1
        
        virtualMemory.temporalMemory.setInt(value: min)
        let minAddress = virtualMemory.temporalMemory.boolStartAddress - 1

        virtualMemory.temporalMemory.setInt(value: by)
        let byAddress = virtualMemory.temporalMemory.boolStartAddress - 1
        
        // Conditional Quadruple
        virtualMemory.temporalMemory.setBool(value: nil)
        let lessThanMaxAddress = virtualMemory.temporalMemory.boolStartAddress - 1
        quadruplesAddress.append(QuadrupleDir(leftOperand: variableAddress, rightOperand: maxAddress, oper: Operator(rawValue: 10)!, resultVar: lessThanMaxAddress))
        
        virtualMemory.temporalMemory.setBool(value: nil)
        let greaterThanMinAddress = virtualMemory.temporalMemory.boolStartAddress - 1
        quadruplesAddress.append(QuadrupleDir(leftOperand: variableAddress, rightOperand: minAddress, oper: Operator(rawValue: 10)!, resultVar: greaterThanMinAddress))
        
        virtualMemory.temporalMemory.setBool(value: nil)
        let conditionAddress = virtualMemory.temporalMemory.boolStartAddress - 1
        quadruplesAddress.append(QuadrupleDir(leftOperand: lessThanMaxAddress, rightOperand: greaterThanMinAddress, oper: Operator(rawValue: 12)!, resultVar: conditionAddress))
    }
    
}
