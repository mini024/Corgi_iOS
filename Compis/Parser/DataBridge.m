//
//  VariableTable.m
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 3/9/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBridge.h"

// Variables
void (^addVariableBlock)(NSString *id, NSString *type);
bool (^findVariableBlock)(NSString *value);

// Parameters
void (^addParameterBlock)(NSString *id, NSString *type);
bool (^findParameterBlock)(NSString *value);

// Functions
void (^addFunctionBlock)(NSString *id, NSString *type);
bool (^findFunctionBlock)(NSString *value);

// Results
void (^ParseTestSuccessBlock)(NSString *value);
void (^ParseTestFailBlock)(NSString *msg);

// Operations
void (^addIdToStackBlock)(NSString *id, NSString *type);
void (^addOperatorToStackBlock)(NSString *name);
bool (^checkNextOperatorBlock)(NSString *typeOp);
void (^deleteParentesisFromStackBlock)(void);
