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
}

class Memory {
    var intMemory: [Int?]! = []
    var intStartAddress = 0
    var floatMemory: [Float?]! = []
    var floatStartAddress = 1000
    var stringMemory: [String?]! = []
    var stringStartAddress = 2000
    var boolMemory: [Bool?]! = []
    var boolStartAddress = 3000
    
    init(value: Int) {
        intStartAddress = value
        floatStartAddress += value
        stringStartAddress += value
        boolStartAddress += value
    }
    
    func setInt(value: Int?) -> Int {
        intMemory.append(value)
        return intStartAddress + intMemory.count - 1
    }
    
    func setFloat(value: Float?) -> Int {
        floatMemory.append(value)
        return floatStartAddress + floatMemory.count - 1
    }
    
    func setString(value: String?) -> Int {
        stringMemory.append(value)
        return stringStartAddress + stringMemory.count - 1
    }
    
    func setBool(value: Bool?) -> Int {
        boolMemory.append(value)
        return boolStartAddress + boolMemory.count - 1
    }
    
    func getMaxAddress() -> Int {
        return boolStartAddress + boolMemory.count
    }
    
    func getIntWith(address: Int) -> Int? {
        if address < floatStartAddress {
            return intMemory[address - intStartAddress]
        }
        
        return nil
    }
    
    func getFloatWith(address: Int) -> Float? {
        if address < stringStartAddress {
            return floatMemory[address - floatStartAddress]
        }
        
        return nil
    }
    
    func getStringWith(address: Int) -> String? {
        if address < boolStartAddress {
            return stringMemory[address - stringStartAddress]
        }
        
        return nil
    }
    
    func getBoolWith(address: Int) -> Bool? {
        if address >= boolStartAddress {
            return boolMemory[address - boolStartAddress]
        }
        
        return nil
    }
    
}
