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
    // Stores quadruple address to return when calling goto function
    var quadruplesStack: [Int] = []
    
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
    
    func setValueForParameter(address: Int, result: Any) {
        if address < LOCAL_START_ADDRESS {
            globalMemory.setValueIn(address: address, result:result)
        } else if address < TEMPORAL_START_ADDRESS {
            memoryStack[memoryStack.count - 1].setValueIn(address: address, result:result)
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

}

