//
//  VirtualMemory.swift
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 3/25/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

import Foundation

let GLOBAL_START_ADDRESS = 10000
let LOCAL_START_ADDRESS = 11000
let TEMPORAL_START_ADDRESS = 11500
let CONSTANTS_START_ADDRESS = 12500

class VirtualMemory {
    var globalMemory = Memory(value: GLOBAL_START_ADDRESS)
    var localMemory = Memory(value: LOCAL_START_ADDRESS)
    var temporalMemory = Memory(value: TEMPORAL_START_ADDRESS)
    var constantsMemory = Memory(value: CONSTANTS_START_ADDRESS)
    
}

class Memory {
    var intMemory: [Int?]! = []
    var intStartAddress = -1
    var floatMemory: [Float?]! = []
    var floatStartAddress = 0
    var stringMemory: [String?]! = []
    var stringStartAddress = 1
    var boolMemory: [Bool?]! = []
    var boolStartAddress = 2
    
    init(value: Int) {
        intStartAddress = value
        floatStartAddress += value
        stringStartAddress += value
        boolStartAddress += value
    }
    
    func increaseStartAddress(by: Int) {
        intStartAddress += 1
        floatStartAddress += 1
        stringStartAddress += 1
        boolStartAddress += 1
    }
    
    func setInt(value: Int?) {
        floatStartAddress += 1
        stringStartAddress += 1
        boolStartAddress += 1
        
        intMemory.append(value)
    }
    
    func setFloat(value: Float?) {
        stringStartAddress += 1
        boolStartAddress += 1
        
        floatMemory.append(value)
    }
    
    func setString(value: String?) {
        boolStartAddress += 1
        
        stringMemory.append(value)
    }
    
    func setBool(value: Bool?) {
        boolMemory.append(value)
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
