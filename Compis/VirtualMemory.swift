//
//  VirtualMemory.swift
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 3/25/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

import Foundation

let GLOBAL_START_ADDRESS = 100000
let LOCAL_START_ADDRESS = 110000
let TEMPORAL_START_ADDRESS = 120000
let CONSTANTS_START_ADDRESS = 130000

class VirtualMemory {
    var globalMemory = Memory(value: GLOBAL_START_ADDRESS)
    var localMemory = Memory(value: LOCAL_START_ADDRESS)
    var temporalMemory = Memory(value: TEMPORAL_START_ADDRESS)
    var constantsMemory = Memory(value: CONSTANTS_START_ADDRESS)
    var functionMemory: [Memory] = []
    
    func setValueIn(address: Int, result: Any) {
        if address < LOCAL_START_ADDRESS {
            globalMemory.setValueIn(address: address, result:result)
        } else if address < TEMPORAL_START_ADDRESS {
            localMemory.setValueIn(address: address, result:result)
        } else if address < CONSTANTS_START_ADDRESS {
            temporalMemory.setValueIn(address: address, result:result)
        } else {
            constantsMemory.setValueIn(address: address, result:result)
        }
    }
    
    func getValueIn(address: Int) -> (Any, Type) {
        if address < LOCAL_START_ADDRESS {
            return globalMemory.getValueIn(address:address)
        } else if address < TEMPORAL_START_ADDRESS {
            // local de function -> se busca en functon Memory
            return localMemory.getValueIn(address:address)
        } else if address < CONSTANTS_START_ADDRESS {
            return temporalMemory.getValueIn(address:address)
        } else {
            return constantsMemory.getValueIn(address:address)
        }
    }
    
    func run(quadruples: [QuadrupleDir]) {
        for quadruple in quadruples {
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
                break
            case .Lower:
                break
            case .NotEqual:
                break
            case .GreaterEqual:
                break
            case .LowerEqual:
                break
            case .Equal:
                break
            case .And:
                break
            case .Or:
                break
            case .Par:
                break
            case .EqualSign:
                setValueIn(address:quadruple.resultVar!, result: getValueIn(address: quadruple.leftOperand!).0)
                break
            case .GOTOF:
                break
            case .GOTO:
                break
            case .WRITE:
                break
            case .READ:
                break
            case .ERA:
                break
            case .GOSUB:
                break
            case .PARAM:
                break
            case .ENDFUNC:
                break
            case .END:
                break
            case .RETURN:
                break
            }
        }
    }
    
    func runAddition(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = getValueIn(address: leftAddress)
        let rightTuple = getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Int
            let rightValue = rightTuple.0 as! Int
            
            setValueIn(address: resultAddress, result: leftValue + rightValue)
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            setValueIn(address: resultAddress, result: leftValue + rightValue)
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            setValueIn(address: resultAddress, result: leftValue + rightValue)
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        setValueIn(address: resultAddress, result: leftValue + rightValue)
    }
    
    func runDifference(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = getValueIn(address: leftAddress)
        let rightTuple = getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Int
            let rightValue = rightTuple.0 as! Int
            
            setValueIn(address: resultAddress, result: leftValue - rightValue)
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            setValueIn(address: resultAddress, result: leftValue - rightValue)
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            setValueIn(address: resultAddress, result: leftValue - rightValue)
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        setValueIn(address: resultAddress, result: leftValue - rightValue)
    }
    
    func runDivision(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = getValueIn(address: leftAddress)
        let rightTuple = getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = Float(rightTuple.0 as! Int)
            
            setValueIn(address: resultAddress, result: leftValue / rightValue)
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            setValueIn(address: resultAddress, result: leftValue / rightValue)
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            setValueIn(address: resultAddress, result: leftValue / rightValue)
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        setValueIn(address: resultAddress, result: leftValue / rightValue)
    }
    
    func runMultiplication(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = getValueIn(address: leftAddress)
        let rightTuple = getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Int
            let rightValue = rightTuple.0 as! Int
            
            setValueIn(address: resultAddress, result: leftValue * rightValue)
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            setValueIn(address: resultAddress, result: leftValue * rightValue)
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            setValueIn(address: resultAddress, result: leftValue * rightValue)
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        setValueIn(address: resultAddress, result: leftValue * rightValue)
    }
    
    func runMod(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = getValueIn(address: leftAddress)
        let rightTuple = getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = Float(rightTuple.0 as! Int)
            
            setValueIn(address: resultAddress, result: leftValue.truncatingRemainder(dividingBy: rightValue))
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            setValueIn(address: resultAddress, result: leftValue.truncatingRemainder(dividingBy:rightValue))
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            setValueIn(address: resultAddress, result: leftValue.truncatingRemainder(dividingBy: rightValue))
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        setValueIn(address: resultAddress, result: leftValue.truncatingRemainder(dividingBy: rightValue))
    }
    
    func runPow(leftAddress:Int, rightAddress:Int, resultAddress:Int) {
        let leftTuple = getValueIn(address: leftAddress)
        let rightTuple = getValueIn(address: rightAddress)
        
        if leftTuple.1 == .Int && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Int
            let rightValue = rightTuple.0 as! Int
            
            setValueIn(address: resultAddress, result: leftValue ^ rightValue)
            return
        } else if leftTuple.1 == .Int && rightTuple.1 == .Float {
            let leftValue = Float(leftTuple.0 as! Int)
            let rightValue = rightTuple.0 as! Float
            
            setValueIn(address: resultAddress, result: powf(leftValue, rightValue))
            return
        } else if leftTuple.1 == .Float && rightTuple.1 == .Int {
            let leftValue = leftTuple.0 as! Float
            let rightValue = Float(rightTuple.0 as! Int)
            
            setValueIn(address: resultAddress, result: powf(leftValue, rightValue))
            return
        }
        
        let leftValue = leftTuple.0 as! Float
        let rightValue = rightTuple.0 as! Float
        
        setValueIn(address: resultAddress, result:powf(leftValue, rightValue))
    }
}





