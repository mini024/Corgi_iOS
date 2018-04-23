//
//  VariableTable.m
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 3/9/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBridge.h"

// End Program
void (^EndBlock)(void);

// Line Counter
void (^addLineCounterBlock)(void);
int (^getLineNumber)(void);

// Variables
void (^addVariableBlock)(NSString *id, NSString *type, int parameter);
bool (^findVariableBlock)(NSString *value);

// Arrays
void (^addArrayVariableBlock)(NSString *id, NSString *type, int size);

// Parameters
void (^addParameterBlock)(NSString *id, NSString *type);
bool (^findParameterBlock)(NSString *value);

// Functions
bool (^addCorgiFunctionBlock)(NSString *id, NSString *type);
void (^addFunctionWithIdBlock)(NSString *id);
void (^addFunctionReturnTypeBlock)(NSString *id, NSString *type);
bool (^findFunctionBlock)(NSString *value);

// Results
void (^ParseTestSuccessBlock)(NSString *value);
void (^ParseTestFailBlock)(NSString *msg);

// Operations
void (^addIdToStackBlock)(NSString *id, NSString *type);
void (^addOperatorToStackBlock)(NSString *name);
bool (^checkNextOperatorBlock)(NSString *typeOp);
void (^deleteParentesisFromStackBlock)(void);

// COND, WHILE, FOR Quadruples
void (^generateGOTOFquadrupleBlock)(int id);
void (^generateGOTOquadrupleBlock)(int id);
void (^fillEndConditionQuadrupleBlock)(void);
void (^fillEndLoopQuadrupleBlock)(void);
bool (^generateLoopConditionQuadruplesBlock)(void);
bool (^generateByQuadrupleBlock)(void);
void (^generateWhileConditionQuadrupleBlock)(void);

// Write and Read Quadruples
void (^generateWritequadrupleBlock)(NSString *id);
void (^generateReadquadrupleBlock)(NSString *id);

// Function Quadruples
void (^generateERAQuadrupleBlock)(NSString *id);
void (^generateEndOfFunctionQuadrupleBlock)(void);
void (^generateEndOfProgramQuadrupleBlock)(void);
void (^generateGoSubQuadrupleBlock)(NSString * id);
bool (^generateParameterQuadrupleBlock)(NSString * id);
bool (^generateReturnBlock)(void);
bool (^generateVoidReturnBlock)(void);

// Arrays
bool (^checkIfArrayBlock)(void);
void (^checkRangeforArrayExpresionBlock)(void);
bool (^addSizeGaptoBaseAddressBlock)(void);
