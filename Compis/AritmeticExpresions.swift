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
        case .Par:
            return "("
        }
    }
}

struct Quadruple {
    var leftOperand : Any
    var rightOperand : Any
    var oper: Operator
    var resultVar: Int // Indice de variable temporal
}

// Aritmetic Expresions - Semantic Cube, Quadruples.
extension Helper {
    
    // Punto 1
    func pushId(_ name: String, type: String) {
        idValues.append(name)
        idTypes.append(stringToType(type: type))
    }
    
    // Punto 2, 3 y 6
    func pushOperator(_ op: String) {
        operators.append(stringToOperator(oper: op))
    }
    
    // Punto 4 y 5
    func generateQuadruple(){
        let rightType = idTypes.popLast()
        let leftType = idTypes.popLast()
        let rightOperand = idValues.popLast()
        let leftOperand = idValues.popLast()
        let oper = operators.popLast()
        
        let operArray = operationTable!.value(forKey: (oper?.description)!) as! [[Int]]
        let resultType = Type(rawValue: operArray[(leftType?.rawValue)!][(rightType?.rawValue)!])
        guard resultType != .ERROR else {
            print("Error No possible ")
            return
        }
        
        quadruples.append(Quadruple(leftOperand: leftOperand!, rightOperand: rightOperand!, oper: oper!, resultVar: indexTempVars))
        indexTempVars += 1;
        print(quadruples)
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
        default:
            return Operator.Par
        }
    }
    
}
