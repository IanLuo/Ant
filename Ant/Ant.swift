//
//  Ant.swift
//  Ant
//
//  Created by ian luo on 2017/5/24.
//  Copyright © 2017年 wod. All rights reserved.
//

import Foundation

typealias JSONDict = [String : Any]

/// Returns a parser, which is able to take a dictionary and return specific value
/// - Parameter type: The type of the return value
/// - Parameter key: Dictioanry key。
/// - Parameter or: Default value when there's no value found
/// - Returns : The parser。
func Parser<Type>(_ type: Type.Type, key: String, or: Type) -> (JSONDict) -> Type {
    return { map in
        if let value = map[key] as? Type {
            return value
        } else {
            print("Faild to get value with key: \(key) from dic: \(map)")
            return or
        }
    }
}

func JSONParserTestValue<Type: Comparable>(_ type: Type.Type, key: String, compareTo: Type) -> (JSONDict) -> Bool {
    return { map in
        if let value = map[key] as? Type {
            return value == compareTo
        } else {
            return false
        }
    }
}

/// Bind two parsers together, with which you can parse deeper from the dictionary
///
///     let data: JSONDict = ["type" : 1,
///                             "inner" : [
///                                 "name" : "John",
///                                 "age" : 18,
///                                 "address" : [
///                                     "street" : "Some street",
///                                     "number" : "No.1"
///                                 ]
///                              ]
///                            ]
///
///     let innerParser = JSONParser(JSONDict.self, key: "inner", or: [:])
///     let addressParser = JSONParser(JSONDict.self, key: "address", or: [:])
///     let streetParser =  JSONParser(String.self, key: "street", or: "")
///     print((innerParser >>> addressParser >>> streetParser)(data))
func >>><Type>(lhs: @escaping (JSONDict) -> JSONDict, rhs: @escaping (JSONDict) -> Type) -> (JSONDict) -> Type {
    return { data in
        return rhs(lhs(data))
    }
}

infix operator |||: LogicalDisjunctionPrecedence
precedencegroup LogicalDisjunctionPrecedence {
    associativity : left
}

infix operator >>>: MultiplePrecedence
precedencegroup MultiplePrecedence {
    associativity : left
    higherThan : LogicalDisjunctionPrecedence
}
