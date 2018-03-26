//
//  AritmeticExpresions.swift
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 3/16/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

import UIKit

enum Operator: Int, CustomStringConvertible{
    case Sum = 0
    case Subtract = 1
    case Division = 2
    case Product = 3
    case Mod = 4
    case Pow = 5
    case Greater = 6
    case Lower = 7
    case NotEqual = 8
    case GreaterEqual = 9
    case LowerEqual = 10
    case Equal = 11
    case And = 12
    case Or = 13
    case Par = 14
    case EqualSign = 15
    
    var description: String {
        switch self {
        case .Sum:
            return "+"
        case .Subtract:
            return "-"
        case .Division:
            return "/"
        case .Product:
            return "*"
        case .Mod:
            return "%"
        case .Pow:
            return "^"
        case .Greater:
            return ">"
        case .Lower:
            return "<"
        case .NotEqual:
            return "!="
        case .GreaterEqual:
            return ">="
        case .LowerEqual:
            return "<="
        case .Equal:
            return "=="
        case .And:
            return "&&"
        case .Or:
            return "||"
        case .EqualSign:
            return "="
        case .Par:
            return "("
        }
    }
}

struct Quadruple {
    var leftOperand : Any?
    var rightOperand : Any?
    var oper: Operator
    var resultVar: Int // Indice de variable temporal
}

struct QuadrupleDir {
    var leftOperand : Int?
    var rightOperand : Int?
    var oper: Operator
    var resultVar: Int
}

// Aritmetic Expresions - Semantic Cube, Quadruples.
extension Helper {
    
    // Punto 1
    func pushIdAddress(_ name: String, type: String) {
        if variableExists(name) {
            idAddresses.append(getVariableAddress(id: name))
            idTypes.append(getVariableType(name))
        } else {
            switch type {
            case "Int":
                virtualMemory.constantsMemory.setInt(value: Int(name)!)
                let address = virtualMemory.constantsMemory.floatStartAddress - 1
                idAddresses.append(address)
                idTypes.append(Type.Int)
            case "Float":
                virtualMemory.constantsMemory.setFloat(value: Float(name)!)
                let address = virtualMemory.constantsMemory.stringStartAddress - 1
                idAddresses.append(address)
                idTypes.append(Type.Float)
            case "String":
                virtualMemory.constantsMemory.setString(value: name)
                let address = virtualMemory.constantsMemory.boolStartAddress - 1
                idAddresses.append(address)
                idTypes.append(Type.String)
            case "Bool":
                virtualMemory.constantsMemory.setBool(value: Bool(name)!)
                let address = virtualMemory.constantsMemory.boolMemory.count + virtualMemory.constantsMemory.boolStartAddress - 1
                idAddresses.append(address)
                idTypes.append(Type.Bool)
            default:
                // ERROR or Corgi
                break
            }
        }
    }
    
    // Punto 2, 3 y 6
    func pushOperator(_ op: String) {
        operators.append(stringToOperator(oper: op))
    }
    
    // Punto 4 y 5
    func generateQuadruple() -> Bool {
        let rightType = idTypes.popLast()
        let leftType = idTypes.popLast()
        let rightOperand = idAddresses.popLast()
        let leftOperand = idAddresses.popLast()
        let oper = operators.popLast()
        
        let operArray = operationTable!.value(forKey: (oper?.description)!) as! [[Int]]
        let resultType = Type(rawValue: operArray[(leftType?.rawValue)!][(rightType?.rawValue)!])
        guard resultType != .ERROR else {
            print("Error No possible ")
            return false
        }
        
        var resultAddress = 0
        
        switch resultType! {
        case .Int:
            virtualMemory.temporalMemory.setInt(value: nil)
            resultAddress = virtualMemory.temporalMemory.floatStartAddress - 1
            quadruplesAddress.append(QuadrupleDir(leftOperand: leftOperand!, rightOperand: rightOperand, oper: oper!, resultVar: resultAddress))
        case .Float:
            virtualMemory.temporalMemory.setFloat(value: nil)
            resultAddress = virtualMemory.temporalMemory.stringStartAddress - 1
            quadruplesAddress.append(QuadrupleDir(leftOperand: leftOperand!, rightOperand: rightOperand, oper: oper!, resultVar: resultAddress))
        case .String:
            virtualMemory.temporalMemory.setString(value: nil)
            resultAddress = virtualMemory.temporalMemory.boolStartAddress - 1
            quadruplesAddress.append(QuadrupleDir(leftOperand: leftOperand!, rightOperand: rightOperand, oper: oper!, resultVar: resultAddress))
        case .Bool:
            virtualMemory.temporalMemory.setBool(value: nil)
            resultAddress = virtualMemory.temporalMemory.boolMemory.count + virtualMemory.temporalMemory.boolStartAddress - 1
            quadruplesAddress.append(QuadrupleDir(leftOperand: leftOperand!, rightOperand: rightOperand, oper: oper!, resultVar: resultAddress))
        default:
            return false
        }
        
        idAddresses.append(resultAddress)
        idTypes.append(resultType!)
        print(quadruplesAddress)
        return true
    }
    
    func generateAssignationQuadruple() -> Bool {
        let oper = operators.popLast()
        let temporalType = idTypes.popLast()
        let temporalVariable = idAddresses.popLast()
        let resultVariable = idAddresses.popLast()
        let resultType = idTypes.popLast()

        
        guard temporalType == resultType else { return false}
        
        quadruplesAddress.append(QuadrupleDir(leftOperand: temporalVariable, rightOperand: nil, oper: oper!, resultVar: resultVariable!))
        
        return true
    }
    
    // Punto 7
    func popPar() {
        guard operators[operators.count-1] != Operator.Par else {return}
        operators.removeLast()
    }

    func getNextOp() -> String {
        guard operators.count > 0 else {return "EMPTY"}
        guard operators[operators.count-1] != Operator.Par else {return "EMPTY"}
        return operators[operators.count-1].description
    }
    
    
    func stringToOperator(oper: String) -> Operator {
        switch oper {
        case "+":
            return Operator.Sum
        case "-":
            return Operator.Subtract
        case "/":
            return Operator.Division
        case "*":
            return Operator.Product
        case "%":
            return Operator.Mod
        case "^":
            return Operator.Pow
        case ">":
            return Operator.Greater
        case "<":
            return Operator.Lower
        case "!=":
            return Operator.NotEqual
        case ">=":
            return Operator.GreaterEqual
        case "<=":
            return Operator.LowerEqual
        case "==":
            return Operator.Equal
        case "&&":
            return Operator.And
        case "&&":
            return Operator.Or
        case "=":
            return Operator.EqualSign
        default:
            return Operator.Par
        }
    }
    
}
