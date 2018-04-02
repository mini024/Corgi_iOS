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
        
        // Step 1 generate GOTOF quad
        let oper = Operator.GOTOF
        let nextQuadruple = 99999
    quadruplesAddress.append(QuadrupleDir(leftOperand: temporalVariableAddress, rightOperand: nil, oper: oper, resultVar: nextQuadruple))
        
        // Step 1 pjumps.push(cont-1)
        let pendingIndex = quadruplesAddress.count - 1
        
        pendingQuadruples.append(pendingIndex)
        print("Cuadruplo GOTOF \n")
        print(quadruplesAddress)

        return true
    }
    
    func generateGOTOquadruple() -> Bool {
        
        // Step 3 generate GOTO quad
        let oper = Operator.GOTO
        let nextQuadruple = 99999
    quadruplesAddress.append(QuadrupleDir(leftOperand: nil, rightOperand: nil, oper: oper, resultVar: nextQuadruple))
        
        // Step 3 false = pjumps.pop()
        let pendingQuadruple = pendingQuadruples.popLast()
    
        // Step 3 pjumps.push(cont-1)
        let pendingIndex = quadruplesAddress.count - 1
        pendingQuadruples.append(pendingIndex)
        
        // Step 3 fill (false, cont)
        fill(pendingQuadruple!, nextQuadruple: quadruplesAddress.count + 1)
        
        print("Cuadruplo GOTO \n")
        print(quadruplesAddress)
        
        return true
    }
    
    func fillEndquadruple() -> Bool {
        
        // Step 2 end = pjups.pop()
        let end = pendingQuadruples.popLast()
        
        // Step 2 Fill(end, count)
        fill(end!, nextQuadruple: quadruplesAddress.count + 1)
        
        return true
    }
    
    func fill(_ pendingIndex: Int, nextQuadruple: Int) -> Bool {
        
        quadruplesAddress[pendingIndex].resultVar = nextQuadruple
        
        return true
    }
    
}
