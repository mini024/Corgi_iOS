//
//  Memory.swift
//  Compis
//
//  Created by Luis Alfonso Arriaga Quezada on 4/17/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

import Foundation

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

    /**
     Generates memory copy
     */
    func copy () -> Memory {
        let copy = Memory(value: INT_START_ADDRESS)
        copy.intMemory = intMemory
        copy.floatMemory = floatMemory
        copy.stringMemory = stringMemory
        copy.boolMemory = boolMemory
        return copy
    }
    
    /**
     Sets value in right memory depending on address index
     */
    func setValueIn(address: Int, result: Any) {
        var realAddress = address
        if address < 0 {
            realAddress = Helper.singleton.virtualMemory.getValueIn(address: -1 * address).0 as! Int
        }
        
        if realAddress < FLOAT_START_ADDRESS {
            intMemory[realAddress - INT_START_ADDRESS] = result as? Int
        } else if realAddress < STRING_START_ADDRESS {
            floatMemory[realAddress - FLOAT_START_ADDRESS] = result as? Float
        } else if realAddress < BOOL_START_ADDRESS {
            stringMemory[realAddress - STRING_START_ADDRESS] = result as? String
        } else {
            boolMemory[realAddress - BOOL_START_ADDRESS] = result as? Bool
        }
    }
    
    /**
     Gets value from right memory depending on address index
     */
    func getValueIn(address: Int) -> (Any, Type) {
        if address < FLOAT_START_ADDRESS {
            // int
            return (intMemory[address - INT_START_ADDRESS]! as Int, Type.Int)
        } else if address < STRING_START_ADDRESS {
            // Float
            return (floatMemory[address - FLOAT_START_ADDRESS]! as Float, Type.Float)
        } else if address < BOOL_START_ADDRESS {
            // String
            return (stringMemory[address - STRING_START_ADDRESS]! as String, Type.String)
        } else {
            // Bool
            return (boolMemory[address - BOOL_START_ADDRESS]! as Bool, Type.Bool)
        }
    }
    
    /**
     Generates space in Ints memory
        @param value - value to store
        @return type - New address
     */
    func setInt(value: Int?) -> Int {
        intMemory.append(value)
        return INT_START_ADDRESS + intMemory.count - 1
    }
    
    /**
     Generates space in Float memory
     @param value - value to store
     @return type - New address
     */
    func setFloat(value: Float?) -> Int {
        floatMemory.append(value)
        return FLOAT_START_ADDRESS + floatMemory.count - 1
    }
    
    /**
     Generates space in String memory
     @param value - value to store
     @return type - New address
     */
    func setString(value: String?) -> Int {
        stringMemory.append(value)
        return STRING_START_ADDRESS + stringMemory.count - 1
    }
    
    /**
     Generates space in Bool memory
     @param value - value to store
     @return type - New address
     */
    func setBool(value: Bool?) -> Int {
        boolMemory.append(value)
        return BOOL_START_ADDRESS + boolMemory.count - 1
    }
    
}
