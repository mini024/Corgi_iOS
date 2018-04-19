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

@interface ViewController () <UITextViewDelegate>

@property bool failed;
@property NSString *errors;
@property NSString *result;
@property int line;
//@property (nonatomic, strong) QEDTextView *codeTextView;

@end

@implementation ViewController
@synthesize codeTextView;
@synthesize consoleTextView;
@synthesize selectedProgram;
@synthesize selectedCode;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Code Text View
    CGRect frame = CGRectMake(10, self.navigationController.navigationBar.bounds.size.height + 40, self.view.frame.size.width - 20, self.consoleTextView.frame.origin.y - self.navigationController.navigationBar.frame.size.height - 10);
    QEDTextView *codeTextView = [[QEDTextView alloc] initWithFrame:frame];
    codeTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    codeTextView.delegate = self;
    
    self.codeTextView = codeTextView;
    
    if (selectedProgram.code != nil) {
        codeTextView.text = selectedCode;
    } else {
        codeTextView.text = @"corgi test; var i: Int; var j: Int; func dos(b:Int) -> Int {b = b * i + j; return (b*2);} corgiRun() { var a: Int; i = 0; j = 10; a = dos(i+j); }";
    }
    
    [self.view addSubview:codeTextView];

}

- (void)viewDidAppear:(BOOL)animated {
    consoleTextView.text = @"Console";
    
    if (selectedProgram.code != nil) {
        codeTextView.text = selectedCode;
    } else {
        codeTextView.text = @"corgi test; var i: Int; var j: Int; func dos(b:Int) -> Int {b = b * i + j; return (b*2);} corgiRun() { var a: Int; i = 0; j = 10; a = dos(i+j); }";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)parseTextView:(id)sender {
    YY_BUFFER_STATE buf;
    _failed = false;
    _errors = @"";
    _result = @"";
    _line = 1;
    
    [Helper.singleton clear];
    
    buf = yy_scan_string([self.codeTextView.text cStringUsingEncoding:NSUTF8StringEncoding]);
    
    ParseTestSuccessBlock = ^(NSString *value) {
        if (!self.failed) {
            _result = [_result stringByAppendingString:value];
            consoleTextView.text = _result;
        }
    };
    
    ParseTestFailBlock = ^(NSString *msg) {
        self.failed = true;
        _errors = [_errors stringByAppendingString:msg];
        consoleTextView.text = _errors;
        
    };
    
    addLineCounterBlock = ^() {
        _line +=1;
    };
    
    getLineNumber = ^() {
        return _line;
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
    
    generateLoopConditionQuadruplesBlock = ^() {
        return [Helper.singleton generateLoopConditionQuadruples];
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

// MARK: Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.dissmisButton.enabled = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.dissmisButton.enabled = NO;
}

- (IBAction)dismissKeyboard:(id)sender {
    [codeTextView resignFirstResponder];
}

@end
