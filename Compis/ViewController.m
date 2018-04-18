//
//  ViewController.m
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 2/14/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import "ViewController.h"
#import "CorgiCode-Swift.h"
#import "Program.h"

#import "y.tab.h"
#import "DataBridge.h"

@interface ViewController ()
@property bool failed;
@property NSString* errors;
@end

@implementation ViewController
@synthesize textView;
@synthesize corgiWeb;
@synthesize selectedProgram;
@synthesize selectedCode;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (selectedProgram.code != nil) {
        textView.text = selectedCode;
    } else {
        textView.text = @"corgi test; var i: Int; var j: Int; func dos(b:Int) -> Int {b = b * i + j; return (b*2);} corgiRun() { var a: Int; i = 0; j = 10; a = dos(i+j); }";
    }
    
    [corgiWeb loadHTMLString:@"https://media.giphy.com/media/Wj7lNjMNDxSmc/giphy.gif" baseURL:[NSURL URLWithString:@"https://media.giphy.com/media/Wj7lNjMNDxSmc/giphy.gif"]];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://media.giphy.com/media/Wj7lNjMNDxSmc/giphy.gif"]];
    [corgiWeb loadData:data MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@"https://media.giphy.com/media/Wj7lNjMNDxSmc/giphy.gif"]];
    [corgiWeb scalesPageToFit];
}

- (void)viewDidAppear:(BOOL)animated {
    if (selectedProgram.code != nil) {
        textView.text = selectedCode;
    } else {
        textView.text = @"corgi test; var i: Int; var j: Int; func dos(b:Int) -> Int {b = b * i + j; return (b*2);} corgiRun() { var a: Int; i = 0; j = 10; a = dos(i+j); }";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)parseTextView:(id)sender
{
    YY_BUFFER_STATE buf;
    _failed = false;
    _errors = @"";
    [Helper.singleton clear];
    
    buf = yy_scan_string([self.textView.text cStringUsingEncoding:NSUTF8StringEncoding]);
    
    ParseTestSuccessBlock = ^(NSString *value) {
        if (!self.failed) {
            textView.text = value;
        }
    };
    
    ParseTestFailBlock = ^(NSString *msg) {
        self.failed = true;
        _errors = [_errors stringByAppendingString:msg];
        textView.text = _errors;
        
    };
    
    addVariableBlock = ^(NSString *name, NSString *type, int parameter) {
        [Helper.singleton addVariable:name type: type parameter: parameter];
    };
    
    addArrayVariableBlock = ^(NSString *name, NSString *type, int size) {
        [Helper.singleton addArrayVariable:name type:type size:size];
    };
    
    addCorgiFunctionBlock = ^(NSString *name, NSString *type) {
        [Helper.singleton addCorgiFunctionBlock:name type:type];
    };
    
    addFunctionWithIdBlock = ^(NSString *name) {
        [Helper.singleton addFunctionWith:name];
    };
    
    addFunctionReturnTypeBlock = ^(NSString *name, NSString *type) {
        [Helper.singleton addFunctionReturnType:name type: type];
    };
    
    findFunctionBlock = ^(NSString *value) {
        return [Helper.singleton functionExists:value];
    };
    
    findVariableBlock = ^(NSString *value) {
        return [Helper.singleton variableExists:value];
    };
    
    findParameterBlock = ^(NSString *value) {
        return [Helper.singleton parameterExists:value];
    };
    
    addIdToStackBlock = ^(NSString *name, NSString *type) {
        [Helper.singleton pushIdAddress:name type:type];
    };
    
    addOperatorToStackBlock = ^(NSString *val) {
        [Helper.singleton pushOperator:val];
    };
    
    checkNextOperatorBlock = ^(NSString *type) {
        if (_failed) {
            return YES;
        }
        
        NSString *nextOperator = [Helper.singleton getNextOp];
        bool isNextExp = [nextOperator isEqual: @"+"] || [nextOperator  isEqual: @"-"];
        bool isNextTerm = [nextOperator isEqual: @"/"] || [nextOperator  isEqual: @"*"] || [nextOperator  isEqual: @"^"] || [nextOperator  isEqual: @"%"];
        bool isNextRelation = [nextOperator isEqual: @"<"] || [nextOperator  isEqual: @">"] || [nextOperator  isEqual: @"<="] || [nextOperator  isEqual: @">="] || [nextOperator  isEqual: @"!="] || [nextOperator  isEqual: @"=="];
        bool isNextAssignation = [nextOperator isEqual: @"="];
        bool isNextLogical = [nextOperator isEqual: @"&&"] || [nextOperator isEqual: @"||"];
        
        if ([type isEqual: @"exp"] && isNextExp) {
            return [Helper.singleton generateQuadruple];
        } else if ([type isEqual: @"term"] && isNextTerm) {
            return [Helper.singleton generateQuadruple];
        } else if ([type isEqual: @"relational"] && isNextRelation) {
            return [Helper.singleton generateQuadruple];
        } else if ([type isEqual: @"assignation"] && isNextAssignation) {
            return [Helper.singleton generateAssignationQuadruple];
        } else if ([type isEqual: @"logical"] && isNextLogical) {
            return [Helper.singleton generateQuadruple];
        }
        
        return YES;
    };
    
    deleteParentesisFromStackBlock = ^() {
        [Helper.singleton popPar];
    };
    
    generateGOTOFquadrupleBlock = ^() {
        [Helper.singleton generateGOTOFquadruple];
    };
    
    generateGOTOquadrupleBlock = ^() {
        [Helper.singleton generateGOTOquadruple];
    };
    
    generateLoopConditionQuadruplesBlock = ^(NSString *id, int min, int max, int by) {
        return [Helper.singleton generateLoopConditionQuadruples:id min:min max:max by:by];
    };
    
    generateByQuadrupleBlock = ^() {
        return [Helper.singleton generateByQuadruple];
    };
    
    fillEndConditionQuadrupleBlock = ^() {
        [Helper.singleton fillEndConditionQuadruple];
    };
    
    fillEndLoopQuadrupleBlock = ^() {
        [Helper.singleton fillEndLoopQuadruple];
    };
    
    generateWritequadrupleBlock = ^(NSString *name) {
        [Helper.singleton generateWriteQuadruple:name];
    };
    
    generateERAQuadrupleBlock = ^(NSString *name) {
        [Helper.singleton generateERAQuadruple:name];
    };
    
    generateEndOfFunctionQuadrupleBlock = ^() {
        [Helper.singleton generateEndOfFunctionQuadruple];
    };
    
    generateEndOfProgramQuadrupleBlock = ^() {
        if (!_failed) {
            [Helper.singleton generateEndOfProgramQuadruple];
        }
    };
    
    generateGoSubQuadrupleBlock = ^(NSString *name) {
        [Helper.singleton generateGoSubQuadruple];
    };
    
    generateParameterQuadrupleBlock = ^(NSString *name) {
        return [Helper.singleton generateParameterQuadruple];
    };
    
    generateReturnBlock = ^() {
        return [Helper.singleton generateReturnQuadruple];
    };
    
    yyparse();
    
    yy_delete_buffer(buf);
}

- (IBAction)Test1:(id)sender {
    textView.text = @"corgi test;\nvar a : Int;\nvar x : Float;\n\nfunc dos(b:Int) -> Int {\n\tb = b * i * j;\n\treturn (b*2);\n}\n\ncorgiRun() {\n\ta=0;\n\tdos(a);\n\tx= a + 3.0;\n}";
}

- (IBAction)Test2:(id)sender {
    textView.text = @"corgi test;\nvar a : Int;\n\ncorgiRun() {\n\ta = 0;\n\tfor a in 0...10 by 1 {\n\twrite(\"Hello\");\n\t}\n}";
}

- (IBAction)Test3:(id)sender {
    textView.text = selectedProgram.code;
}
    
- (IBAction)Test4:(id)sender {
    textView.text = @"corgi test;\nvar i: Int;\nvar j: Int;\n\nfunc uno(a:Int) -> void { \n\tvar n : Int; \n\tn = a * 2; \n\tcase {\n\t\tn < a+4 : uno(a+1); \n\t}\n\twrite(i);\n\treturn;\n}\n\nfunc dos(b:Int) -> Int {\n\tb = b * i + j; \n\treturn (b*2);\n}\n\ncorgiRun() { \n\ti = 2;\n\tj = i * 2 - 1;\n\tuno(j);\n\ti = dos(i+j);\n}\n";
}



@end
