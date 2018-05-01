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
let CONSTANTS_START_ADDRESS = 120000

class VirtualMemory {
    var globalMemory = Memory(value: GLOBAL_START_ADDRESS)
    var localMemory = Memory(value: LOCAL_START_ADDRESS)
    var constantsMemory = Memory(value: CONSTANTS_START_ADDRESS)
    var memoryStack: [Memory] = []
    // Stores quadruple address to return when calling goto function
    var quadruplesStack: [Int] = []
    
    func setValueIn(address: Int, result: Any) {
        var realAddress = address
        if address < Helper.singleton.quadruples.count && address > 0 {
            let funcName = Helper.singleton.getFunctionNameWith(address: address)
            realAddress = (Helper.singleton.funcTable[funcName]?.returnAddress)!
        }
        
        if realAddress < LOCAL_START_ADDRESS {
            globalMemory.setValueIn(address: realAddress, result:result)
        } else if realAddress < CONSTANTS_START_ADDRESS {
            localMemory.setValueIn(address: realAddress, result:result)
        } else {
            constantsMemory.setValueIn(address: realAddress, result:result)
        }
    }
    
    func setValueForParameter(address: Int, result: Any) {
        var realAddress = address
        if address < 0 {
            realAddress = Helper.singleton.virtualMemory.getValueIn(address: -1 * address).0 as! Int
        }
        
        if realAddress < LOCAL_START_ADDRESS {
            globalMemory.setValueIn(address: realAddress, result:result)
        } else if realAddress < CONSTANTS_START_ADDRESS {
            memoryStack[memoryStack.count - 1].setValueIn(address: realAddress, result:result)
        } else {
            constantsMemory.setValueIn(address: realAddress, result:result)
        }
    }
    
    func getValueIn(address: Int) -> (Any, Type) {
        var realAddress = address
        if address < 0 {
            realAddress = Helper.singleton.virtualMemory.getValueIn(address: -1 * address).0 as! Int
        } else if address < Helper.singleton.quadruples.count {
            let funcName = Helper.singleton.getFunctionNameWith(address: address)
            realAddress = (Helper.singleton.funcTable[funcName]?.returnAddress)!
        }
        
        if realAddress < LOCAL_START_ADDRESS {
            return globalMemory.getValueIn(address:realAddress)
        } else if realAddress < CONSTANTS_START_ADDRESS {
            // local de function -> se busca en functon Memory
            return localMemory.getValueIn(address:realAddress)
        } else {
            return constantsMemory.getValueIn(address:realAddress)
        }
    }

}

