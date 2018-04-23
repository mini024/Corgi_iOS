//
//  Execution.swift
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 4/17/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

import Foundation
//import "DataBridge.h"

extension Helper {
    
    func run(quadruples: [QuadrupleDir]) {
        var quadrupleNumber = 0
        
        while quadrupleNumber < quadruples.count{
            let quadruple = quadruples[quadrupleNumber]
            switch quadruple.oper {
            case .Sum:
                runAddition(leftAddress: quadruple.leftOperand!, rightAddress: quadruple.rightOperand!, resultAddress: quadruple.resultVar!)
                break
            case .Subtract:
                runDifference(leftAddress: quadruple.leftOperand!, rightAddress: quadruple.rightOperand!, resultAddress: quadruple.resultVar!)
                break
            case .Division:
                runDivision(leftAddress: quadruple.leftOperand!, rightAddress: quadruple.rightOperand!, resultAddress: quadruple.resultVar!)
                break
            case .Product:
                runMultiplication(leftAddress: quadruple.leftOperand!, rightAddress: quadruple.rightOperand!, resultAddress: quadruple.resultVar!)
                break
            case .Mod:
                runMod(leftAddress: quadruple.leftOperand!, rightAddress: quadruple.rightOperand!, resultAddress: quadruple.resultVar!)
                break
            case .Pow:
                runPow(leftAddress: quadruple.leftOperand!, rightAddress: quadruple.rightOperand!, resultAddress: quadruple.resultVar!)
                break
            case .Greater:
                runGreater(leftAddress: quadruple.leftOperand!, rightAddress: quadruple.rightOperand!, resultAddress: quadruple.resultVar!)
                break
            case .Lower:
                runLower(leftAddress: quadruple.leftOperand!, rightAddress: quadruple.rightOperand!, resultAddress: quadruple.resultVar!)
                break
            case .NotEqual:
                runNotEqual(leftAddress: quadruple.leftOperand!, rightAddress: quadruple.rightOperand!, resultAddress: quadruple.resultVar!)
                break
            case .GreaterEqual:
                runGreaterEqual(leftAddress: quadruple.leftOperand!, rightAddress: quadruple.rightOperand!, resultAddress: quadruple.resultVar!)
                break
            case .LowerEqual:
                runLowerEqual(leftAddress: quadruple.leftOperand!, rightAddress: quadruple.rightOperand!, resultAddress: quadruple.resultVar!)
                break
            case .Equal:
                runEqual(leftAddress: quadruple.leftOperand!, rightAddress: quadruple.rightOperand!, resultAddress: quadruple.resultVar!)
                break
            case .And:
                runAnd(leftAddress: quadruple.leftOperand!, rightAddress: quadruple.rightOperand!, resultAddress: quadruple.resultVar!)
                break
            case .Or:
                runOR(leftAddress: quadruple.leftOperand!, rightAddress: quadruple.rightOperand!, resultAddress: quadruple.resultVar!)
                break
            case .Par:
                break
            case .EqualSign:
                virtualMemory.setValueIn(address:quadruple.resultVar!, result: virtualMemory.getValueIn(address: quadruple.leftOperand!).0)
                break
            case .GOTOF:
                if (!(virtualMemory.getValueIn(address: quadruple.leftOperand!).0 as! Bool)) {
                    quadrupleNumber = quadruple.resultVar! - 1
                }
                break
            case .GOTO:
                quadrupleNumber = quadruple.resultVar! - 1
                break
            case .WRITE:
                runWrite(address: quadruple.resultVar!)
                break
            case .READ:
                break
            case .ERA:
                runERA(functionAddress: quadruple.leftOperand!)
                break
            case .GOSUB:
                runSub(quadrupleNumber: quadrupleNumber)
                quadrupleNumber = quadruple.leftOperand! - 1
                break
            case .PARAM:
                runParam(address: quadruple.resultVar!, valueAddress: quadruple.leftOperand!)
                break
            case .ENDFUNC:
                quadrupleNumber = virtualMemory.quadruplesStack.popLast()!
                break
            case .END:
                EndBlock();
                break
            case .RETURN:
                break
            case .VER:
                break
            }
            quadrupleNumber += 1;
        }
    }
    
    func runWrite(address: Int) {
        let valueTuple = virtualMemory.getValueIn(address: address)
        
        if valueTuple.1 == .Int {
            let value = String(valueTuple.0 as! Int) + "\n"
            ParseTestSuccessBlock(value)
        } else if valueTuple.1 == .Float {
            let value = String(valueTuple.0 as! Float) + "\n"
            ParseTestSuccessBlock(value)
        } else if valueTuple.1 == .Bool {
            let value = String(valueTuple.0 as! Bool) + "\n"
            ParseTestSuccessBlock(value)
        } else {
            let value = valueTuple.0 as! String + "\n"
            ParseTestSuccessBlock(value)
        }
    }
    
    // MARK: Function Operations
    
    /**
     Adds values to the parameters of the called function (top in memory Stack), takes values from local memory
     */
    func runParam(address:Int, valueAddress:Int) {
        // Get Value from local memory
        let valueTuple = virtualMemory.getValueIn(address: valueAddress)
        
        // Set Value in top memory of stack
        if valueTuple.1 == .Int {
            let value = valueTuple.0 as! Int
            virtualMemory.setValueForParameter(address: address, result: value)
        } else if valueTuple.1 == .Float {
            let value = valueTuple.0 as! Float
            virtualMemory.setValueForParameter(address: address, result: value)
        } else if valueTuple.1 == .String {
            let value = valueTuple.0 as! String
            virtualMemory.setValueForParameter(address: address, result: value)
        } else if valueTuple.1 == .Bool {
            let value = valueTuple.0 as! Bool
            virtualMemory.setValueForParameter(address: address, result: value)
        } else {
            print("ERROR - Wrong data type")
        }
        
    }
    
    /**
     Creates instance of called memory and add to stack.
     */
    func runERA(functionAddress: Int) {
        // Get function name from address
        let functionName = getFunctionNameWith(address: functionAddress)
        
        guard functionName != "Error" else {print("Error no function with start address"); return}
        
        // Generate instance of memory
        let functionMemory = funcTable[functionName]?.memory.copy()
        
        // Add memory to stack
        virtualMemory.memoryStack.append(functionMemory!)
    }
    
    /**
     Make top memory from memory stack local memory and sleep local memory
    */
    func runSub(quadrupleNumber: Int) {
        let local = virtualMemory.localMemory
        
        // Make top memory -> local memory
        virtualMemory.localMemory = virtualMemory.memoryStack.popLast()!
        
        // Sleep local memory
        virtualMemory.memoryStack.append(local)
        
        // Save quadruple to return
        virtualMemory.quadruplesStack.append(quadrupleNumber)
    }
    
    
    // MARK: Logic Operations
    /**
     Evaluates greater conditional and sets result in result Address.
     */
    func runGreater(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = virtualMemory.getValueIn(address: leftAddress)
        let rightTuple = virtualMemory.getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Int
            let rightValue = rightTuple.0 as! Int
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue > rightValue)
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue > rightValue)
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue > rightValue)
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        virtualMemory.setValueIn(address: resultAddress, result: leftValue > rightValue)
    }
    
    /**
     Evaluates greater equal conditional and sets result in result Address.
     */
    func runGreaterEqual(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = virtualMemory.getValueIn(address: leftAddress)
        let rightTuple = virtualMemory.getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Int
            let rightValue = rightTuple.0 as! Int
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue >= rightValue)
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue >= rightValue)
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue >= rightValue)
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        virtualMemory.setValueIn(address: resultAddress, result: leftValue >= rightValue)
    }
    
    /**
     Evaluates lower conditional and sets result in result Address.
     */
    func runLower(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = virtualMemory.getValueIn(address: leftAddress)
        let rightTuple = virtualMemory.getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Int
            let rightValue = rightTuple.0 as! Int
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue < rightValue)
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue < rightValue)
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue < rightValue)
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        virtualMemory.setValueIn(address: resultAddress, result: leftValue < rightValue)
    }
    
    /**
     Evaluates lower equal conditional and sets result in result Address.
     */
    func runLowerEqual(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = virtualMemory.getValueIn(address: leftAddress)
        let rightTuple = virtualMemory.getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Int
            let rightValue = rightTuple.0 as! Int
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue <= rightValue)
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue <= rightValue)
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue <= rightValue)
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        virtualMemory.setValueIn(address: resultAddress, result: leftValue <= rightValue)
    }
    
    /**
     Evaluates not equal conditional and sets result in result Address.
     */
    func runNotEqual(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = virtualMemory.getValueIn(address: leftAddress)
        let rightTuple = virtualMemory.getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Int
            let rightValue = rightTuple.0 as! Int
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue != rightValue)
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Float {
            let leftValue = leftTuple.0 as! Float
            let rightValue = rightTuple.0 as! Float
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue != rightValue)
            return
        } else if leftTuple.1 == .String && rightTuple.1 == .String {
            let leftValue = leftTuple.0 as! String
            let rightValue = rightTuple.0 as! String
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue != rightValue)
            return
        } else if leftTuple.1 == .Bool && rightTuple.1 == .Bool {
            let leftValue = leftTuple.0 as! Bool
            let rightValue = rightTuple.0 as! Bool
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue != rightValue)
            return
        }
        
//        let leftValue = leftTuple.0 as! Float
//        let rightValue = rightTuple.0 as! Float
//
//        virtualMemory.setValueIn(address: resultAddress, result: leftValue <= rightValue)
    }
    
    /**
     Evaluates equal conditional and sets result in result Address.
     */
    func runEqual(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = virtualMemory.getValueIn(address: leftAddress)
        let rightTuple = virtualMemory.getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Int
            let rightValue = rightTuple.0 as! Int
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue == rightValue)
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Float {
            let leftValue = leftTuple.0 as! Float
            let rightValue = rightTuple.0 as! Float
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue == rightValue)
            return
        } else if leftTuple.1 == .String && rightTuple.1 == .String {
            let leftValue = leftTuple.0 as! String
            let rightValue = rightTuple.0 as! String
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue == rightValue)
            return
        } else if leftTuple.1 == .Bool && rightTuple.1 == .Bool {
            let leftValue = leftTuple.0 as! Bool
            let rightValue = rightTuple.0 as! Bool
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue == rightValue)
            return
        }
        
        //        let leftValue = leftTuple.0 as! Float
        //        let rightValue = rightTuple.0 as! Float
        //
        //        virtualMemory.setValueIn(address: resultAddress, result: leftValue <= rightValue)
    }
    
    /**
     Evaluates And and sets value in result address
    */
    func runAnd(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = virtualMemory.getValueIn(address: leftAddress)
        let rightTuple = virtualMemory.getValueIn(address: rightAddress)
        
        let leftValue = leftTuple.0 as! Bool
        let rightValue = rightTuple.0 as! Bool
        
        virtualMemory.setValueIn(address: resultAddress, result: leftValue && rightValue)
    }
    
    /**
     Evaluates Or and sets value in result address
     */
    func runOR(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = virtualMemory.getValueIn(address: leftAddress)
        let rightTuple = virtualMemory.getValueIn(address: rightAddress)
        
        let leftValue = leftTuple.0 as! Bool
        let rightValue = rightTuple.0 as! Bool
        
        virtualMemory.setValueIn(address: resultAddress, result: leftValue || rightValue)
    }
    
    // MARK: Aritmetic Operations
    /**
     Runs addition and sets value in result Address
     */
    func runAddition(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        var realLeftAddress = leftAddress
        if rightAddress < 0 {
            
            // Check if leftAddress (the overlap) is an negative address also * Indexing array with another array*
            if leftAddress < 0{
                let leftTuple = virtualMemory.getValueIn(address: -1 * leftAddress)
                let overlap = leftTuple.0 as! Int
                virtualMemory.setValueIn(address: resultAddress, result: -1 * rightAddress + (virtualMemory.getValueIn(address: overlap).0 as! Int))
                return
            }
            
            let leftTuple = virtualMemory.getValueIn(address: leftAddress)
            let overlap = leftTuple.0 as! Int
            virtualMemory.setValueIn(address: resultAddress, result: -1 * rightAddress + overlap)
            return
        }
        
        if leftAddress < 0 {
            realLeftAddress = -1 * leftAddress
        }
        
        var leftTuple = virtualMemory.getValueIn(address: realLeftAddress)
        let rightTuple = virtualMemory.getValueIn(address: rightAddress)
        
        if leftAddress < 0 {
            leftTuple = virtualMemory.getValueIn(address: leftTuple.0 as! Int)
        }

        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Int
            let rightValue = rightTuple.0 as! Int
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue + rightValue)
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue + rightValue)
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue + rightValue)
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        virtualMemory.setValueIn(address: resultAddress, result: leftValue + rightValue)
    }
    
    /**
     Runs difference and sets value in result Address
     */
    func runDifference(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = virtualMemory.getValueIn(address: leftAddress)
        let rightTuple = virtualMemory.getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Int
            let rightValue = rightTuple.0 as! Int
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue - rightValue)
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue - rightValue)
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue - rightValue)
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        virtualMemory.setValueIn(address: resultAddress, result: leftValue - rightValue)
    }
    
    /**
     Runs division and sets value in result Address
     */
    func runDivision(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = virtualMemory.getValueIn(address: leftAddress)
        let rightTuple = virtualMemory.getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = Float(rightTuple.0 as! Int)
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue / rightValue)
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue / rightValue)
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue / rightValue)
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        virtualMemory.setValueIn(address: resultAddress, result: leftValue / rightValue)
    }
    
    /**
     Runs multiplication and sets value in result Address
     */
    func runMultiplication(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = virtualMemory.getValueIn(address: leftAddress)
        let rightTuple = virtualMemory.getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Int
            let rightValue = rightTuple.0 as! Int
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue * rightValue)
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue * rightValue)
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue * rightValue)
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        virtualMemory.setValueIn(address: resultAddress, result: leftValue * rightValue)
    }
    
    /**
     Runs reminder and sets value in result Address
     */
    func runMod(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = virtualMemory.getValueIn(address: leftAddress)
        let rightTuple = virtualMemory.getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = Float(rightTuple.0 as! Int)
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue.truncatingRemainder(dividingBy: rightValue))
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue.truncatingRemainder(dividingBy:rightValue))
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue.truncatingRemainder(dividingBy: rightValue))
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        virtualMemory.setValueIn(address: resultAddress, result: leftValue.truncatingRemainder(dividingBy: rightValue))
    }
    
    /**
     Runs power and sets value in result Address
     */
    func runPow(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = virtualMemory.getValueIn(address: leftAddress)
        let rightTuple = virtualMemory.getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Int
            let rightValue = rightTuple.0 as! Int
            
            virtualMemory.setValueIn(address: resultAddress, result: leftValue ^ rightValue)
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            virtualMemory.setValueIn(address: resultAddress, result: powf(leftValue, rightValue))
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            virtualMemory.setValueIn(address: resultAddress, result: powf(leftValue, rightValue))
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        virtualMemory.setValueIn(address: resultAddress, result:powf(leftValue, rightValue))
    }
}
