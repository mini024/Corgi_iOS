//
//  Structures.swift
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 4/11/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

import Foundation

enum  Scope {
    case global
    case local
}

enum Type: Int {
    case Corgi = 0
    case Float = 1
    case String = 2
    case Bool = 3
    case Int = 4
    case Void = 5
    case ERROR = 999
}

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
    case GOTOF = 16
    case GOTO = 17
    case WRITE = 18
    case READ = 19
    case ERA = 20
    case GOSUB = 21
    case PARAM = 22
    case ENDFUNC = 23
    case END = 24
    case RETURN = 25
    case VER = 26
    
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
        case .GOTOF:
            return "GOTOF"
        case .GOTO:
            return "GOTO"
        case .WRITE:
            return "WRITE"
        case .READ:
            return "Read"
        case .ERA:
            return "ERA"
        case .GOSUB:
            return "GOSUB"
        case .END:
            return "END"
        case .ENDFUNC:
            return "ENDFUNC"
        case .PARAM:
            return "PARAM"
        case .RETURN:
            return "RETURN"
        case .VER:
            return "VER"
        }
    }
}

struct Variable {
    var type: Type!
    var scope: Scope!
    var address: Int!
    var index: Int!
    var arrSize: Int!
}

struct Function {
    var returnType: Type!
    var variables = [String: Variable]()
    var parameters = [String: Variable]()
    var startAddress: Int // Quadruple index
    var currentParameter = 0
    var memory: Memory!
    
    init(type: Type, address: Int) {
        returnType = type
        startAddress = address
        variables = [:]
        parameters = [:]
    }
    
    init(address:Int) {
        startAddress = address
        variables = [:]
        parameters = [:]
    }
}

struct Quadruple {
    var leftOperand : Int?
    var rightOperand : Int?
    var oper: Operator
    var resultVar: Int?
}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}


