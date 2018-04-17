//
//  VariableTable.h
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 3/9/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef DataBridge_h
#define DataBridge_h

/**
    This file is used to join the parser (flex & bision) with the fuctions and objects in the application. Functions will be used in neural points and objects will be used to store data.
 */

// Variables
extern void (^addVariableBlock)(NSString *id, NSString *type, int parameter);
extern bool (^findVariableBlock)(NSString *value);

// Arrays
extern void (^addArrayVariableBlock)(NSString *id, NSString *type, int size);

// Parameters
extern bool (^findParameterBlock)(NSString *value);

// Functions
extern void (^addCorgiFunctionBlock)(NSString *id, NSString *type);
extern void (^addFunctionWithIdBlock)(NSString *id);
extern void (^addFunctionReturnTypeBlock)(NSString *id, NSString *type);
extern bool (^findFunctionBlock)(NSString *value);

// Results
extern void (^ParseTestSuccessBlock)(NSString *value);
extern void (^ParseTestFailBlock)(NSString *msg);

// Operations
extern void (^addIdToStackBlock)(NSString *id, NSString *type);
extern void (^addOperatorToStackBlock)(NSString *name);
extern bool (^checkNextOperatorBlock)(NSString *typeOp);
extern void (^deleteParentesisFromStackBlock)(void);

// COND, WHILE, FOR Queadruples
extern void (^generateGOTOFquadrupleBlock)(void);
extern void (^generateGOTOquadrupleBlock)(void);
extern void (^fillEndConditionQuadrupleBlock)(void);
extern void (^fillEndLoopQuadrupleBlock)(void);
extern void (^generateLoopConditionQuadruplesBlock)(NSString *id, int min, int max, int by);
extern void (^generateByQuadrupleBlock)(void);

// Write and Read Quadruples
extern void (^generateWritequadrupleBlock)(NSString *id);
extern void (^generateReadquadrupleBlock)(NSString *id);

// Function Quadruples
extern void (^generateERAQuadrupleBlock)(NSString *id);
extern void (^generateEndOfFunctionQuadrupleBlock)(void);
extern void (^generateEndOfProgramQuadrupleBlock)(void);
extern void (^generateGoSubQuadrupleBlock)(NSString * id);
extern bool (^generateParameterQuadrupleBlock)(NSString * id);

// Added some extras to suppress warnings...
#ifndef FLEXINT_H

typedef struct yy_buffer_state *YY_BUFFER_STATE;
YY_BUFFER_STATE  yy_scan_string(const char *s);

int yyparse(void);
void yy_delete_buffer(YY_BUFFER_STATE buf);

#endif

#endif /* DataBridge_h */
