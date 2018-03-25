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
extern void (^addVariableBlock)(NSString *id, NSString *type);
extern bool (^findVariableBlock)(NSString *value);

// Functions
extern void (^addFunctionBlock)(NSString *id, NSString *type);
extern bool (^findFunctionBlock)(NSString *value);

// Results
extern void (^ParseTestSuccessBlock)(NSString *value);
extern void (^ParseTestFailBlock)(NSString *msg);

// Operations
extern void (^addIdToStackBlock)(NSString *id, NSString *type);
extern void (^addOperatorToStackBlock)(NSString *name);
extern bool (^checkNextOperatorBlock)(NSString *typeOp);
extern void (^deleteParentesisFromStackBlock)(void);


// Added some extras to suppress warnings...
#ifndef FLEXINT_H

typedef struct yy_buffer_state *YY_BUFFER_STATE;
YY_BUFFER_STATE  yy_scan_string(const char *s);

int yyparse(void);
void yy_delete_buffer(YY_BUFFER_STATE buf);

#endif

#endif /* DataBridge_h */
