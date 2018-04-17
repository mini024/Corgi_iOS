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
    var memoryStack: [Memory] = []
    
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
                quadrupleNumber = quadruple.resultVar! - 1
                break
            case .WRITE:
                break
            case .READ:
                break
            case .ERA:
                runERA(functionAddress: quadruple.leftOperand!)
                break
            case .GOSUB:
                localMemory = memoryStack.popLast()!
                break
            case .PARAM:
                runParam(address: quadruple.resultVar!, valueAddress: quadruple.leftOperand!)
                break
            case .ENDFUNC:
                break
            case .END:
                break
            case .RETURN:
                break
            }
            quadrupleNumber += 1;
        }
    }
    
    func runParam(address:Int, valueAddress:Int) {
        let valueTuple = getValueIn(address: valueAddress)
        
        if valueTuple.1 == .Int {
            let value = valueTuple.0 as! Int
            setValueIn(address: address, result: value)
        } else if valueTuple.1 == .Float {
            let value = valueTuple.0 as! Float
            setValueIn(address: address, result: value)
        } else if valueTuple.1 == .String {
            let value = valueTuple.0 as! String
            setValueIn(address: address, result: value)
        } else if valueTuple.1 == .Bool {
            let value = valueTuple.0 as! Bool
            setValueIn(address: address, result: value)
        } else {
            print("ERROR - Wrong data type")
        }
        
    }
    
    func runERA(functionAddress: Int) {
        // Get function name from address
        let functionName = Helper.singleton.getFunctionNameWith(address: functionAddress)
        
        guard functionName != "Error" else {print("Error no function with start address"); return}
        
        let functionMemory = Helper.singleton.funcTable[functionName]?.memory
        
        // Generate instance of memory & add to stack
        memoryStack.append(functionMemory!)
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

// MARK: Memory
class Memory {
    var intMemory: [Int?]! = []
    var INT_START_ADDRESS = 0
    var floatMemory: [Float?]! = []
    var FLOAT_START_ADDRESS = 1000
    var stringMemory: [String?]! = []
    var STRING_START_ADDRESS = 2000
    var boolMemory: [Bool?]! = []
    var BOOL_START_ADDRESS = 3000
    
    init() {}
    
    init(value: Int) {
        INT_START_ADDRESS = value
        FLOAT_START_ADDRESS += value
        STRING_START_ADDRESS += value
        BOOL_START_ADDRESS += value
    }
    
    func setValueIn(address: Int, result: Any) {
        if address < FLOAT_START_ADDRESS {
            intMemory[address - INT_START_ADDRESS] = result as? Int
        } else if address < STRING_START_ADDRESS {
            floatMemory[address - FLOAT_START_ADDRESS] = result as? Float
        } else if address < BOOL_START_ADDRESS {
            stringMemory[address - STRING_START_ADDRESS] = result as? String
        } else {
            boolMemory[address - BOOL_START_ADDRESS] = result as? Bool
        }
    }
    
    func getValueIn(address: Int) -> (Any, Type) {
        if address < FLOAT_START_ADDRESS {
            // int
            return (intMemory[address - INT_START_ADDRESS] as Any, Type.Int)
        } else if address < STRING_START_ADDRESS {
            // Float
            return (floatMemory[address - FLOAT_START_ADDRESS] as Any, Type.Float)
        } else if address < BOOL_START_ADDRESS {
            // String
            return (stringMemory[address - STRING_START_ADDRESS] as Any, Type.String)
        } else {
            // Bool
            return (boolMemory[address - BOOL_START_ADDRESS] as Any, Type.Bool)
        }
    }
    
    func setInt(value: Int?) -> Int {
        intMemory.append(value)
        return INT_START_ADDRESS + intMemory.count - 1
    }
    
    func setFloat(value: Float?) -> Int {
        floatMemory.append(value)
        return FLOAT_START_ADDRESS + floatMemory.count - 1
    }
    
    func setString(value: String?) -> Int {
        stringMemory.append(value)
        return STRING_START_ADDRESS + stringMemory.count - 1
    }
    
    func setBool(value: Bool?) -> Int {
        boolMemory.append(value)
        return BOOL_START_ADDRESS + boolMemory.count - 1
    }
    
    func getMaxAddress() -> Int {
        return BOOL_START_ADDRESS + boolMemory.count
    }
    
    func getIntWith(address: Int) -> Int? {
        if address < FLOAT_START_ADDRESS {
            return intMemory[address - INT_START_ADDRESS]
        }
    
        return nil
    }
    
    func getFloatWith(address: Int) -> Float? {
        if address < STRING_START_ADDRESS {
            return floatMemory[address - FLOAT_START_ADDRESS]
        }
    
        return nil
    }
    
    func getStringWith(address: Int) -> String? {
        if address < BOOL_START_ADDRESS {
            return stringMemory[address - STRING_START_ADDRESS]
        }
        return nil
    }
    
    func getBoolWith(address: Int) -> Bool? {
        if address >= BOOL_START_ADDRESS {
            return boolMemory[address - BOOL_START_ADDRESS]
        }
        return nil
    }
    
}



