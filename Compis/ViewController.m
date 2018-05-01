//
//  ViewController.m
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 2/14/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import "ViewController.h"
#import "ConsoleViewController.h"
#import "CorgiCode-Swift.h"
#import "ColorPalette.h"
#import "Program.h"

#import "y.tab.h"
#import "DataBridge.h"

NSString * const KEY_PROGRAM = @"SavedProgram";

@interface ViewController () <UITextViewDelegate>

@property bool failed;
@property NSString *errors;
@property NSString *result;
@property NSString *unSavedCode;
@property int line;

@end

@implementation ViewController
@synthesize codeTextView;
@synthesize selectedProgram;
@synthesize selectedCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Code Text View
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height + statusBarFrame.size.height, self.view.frame.size.width, self.tabBarController.tabBar.frame.origin.y);
    QEDTextView *codeTextView = [[QEDTextView alloc] initWithFrame:frame];
    codeTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    codeTextView.delegate = self;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NightMode"] isEqual: @"true"] ) {
        codeTextView.backgroundColor = ColorPalette.codeBackgroundNightModeColor;
        codeTextView.textColor = ColorPalette.codeTextNightModeColor;
    } else {
        codeTextView.backgroundColor = ColorPalette.codeBackgroundColor;
        codeTextView.textColor = ColorPalette.codeTextColor;
    }
    
    self.codeTextView = codeTextView;
    
    [self setCode];
    [self.view addSubview:codeTextView];
    
    // Keyboard
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipeDown];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.navigationController.navigationBar addGestureRecognizer:tap];

}

- (void)viewDidAppear:(BOOL)animated {
    [self setCode];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NightMode"] isEqual: @"true"] ) {
        codeTextView.textColor = ColorPalette.codeTextNightModeColor;
        codeTextView.backgroundColor = ColorPalette.codeBackgroundNightModeColor;
    } else {
        codeTextView.textColor = ColorPalette.codeTextColor;
        codeTextView.backgroundColor = ColorPalette.codeBackgroundColor;
    }
    [codeTextView changedMode];
}

- (void)viewWillDisappear:(BOOL)animated {
    _unSavedCode = codeTextView.text;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setTextView {
    
}

- (void) setCode {
    if (selectedProgram.code != nil) {
        codeTextView.text = selectedProgram.code;
    } else if (_unSavedCode != nil ) {
        codeTextView.text = _unSavedCode;
    } else {
        _saveButton.enabled = NO;
        codeTextView.text = @"corgi //[PROGRAM NAME]; \ncorgiRun() { \n }";
    }
}

- (IBAction)parseTextView:(id)sender {
    YY_BUFFER_STATE buf;
    _failed = false;
    _errors = @"";
    _result = @"";
    _line = 1;
    
    [Helper.singleton clear];
    
    self.codeTextView.text = [self.codeTextView.text stringByReplacingOccurrencesOfString:@"”" withString:@"\""];
    self.codeTextView.text = [self.codeTextView.text stringByReplacingOccurrencesOfString:@"“" withString:@"\""];
    
    buf = yy_scan_string([self.codeTextView.text cStringUsingEncoding:NSUTF8StringEncoding]);
    
    EndBlock = ^() {
        UINavigationController *next = (UINavigationController*) self.tabBarController.viewControllers[[self.tabBarController selectedIndex] + 1];
        ConsoleViewController *destination = (ConsoleViewController*) next.topViewController;
        if (!self.failed) {
            destination.consoleText = self->_result;
        } else {
            destination.consoleText = self->_errors;
        }
        
        self->selectedProgram.code = self->codeTextView.text;
        
        [self.tabBarController setSelectedIndex:[self.tabBarController selectedIndex] + 1];
    };
    
    ParseTestSuccessBlock = ^(NSString *value) {
        if (!self.failed) {
            self->_result = [self->_result stringByAppendingString:value];
        }
    };
    
    ParseTestFailBlock = ^(NSString *msg) {
        self.failed = true;
        self->_errors = [self->_errors stringByAppendingString:msg];
    };
    
    addLineCounterBlock = ^() {
        self->_line +=1;
    };
    
    getLineNumber = ^() {
        return self->_line;
    };
    
    addVariableBlock = ^(NSString *name, NSString *type, int parameter) {
        [Helper.singleton addVariableToTable:name type: type parameter: parameter];
    };
    
    addArrayVariableBlock = ^(NSString *name, NSString *type, int size) {
        [Helper.singleton addArrayVariable:name type:type size:size];
    };
    
    addCorgiFunctionBlock = ^(NSString *name, NSString *type) {
        return [Helper.singleton addCorgiFunctionBlock:name type:type];
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
        if (self->_failed) {
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
    
    generateGOTOFquadrupleBlock = ^(int code) {
        [Helper.singleton generateGOTOFquadruple:code];
    };
    
    generateGOTOquadrupleBlock = ^(int code) {
        [Helper.singleton generateGOTOquadruple:code];
    };
    
    generateLoopConditionQuadruplesBlock = ^() {
        return [Helper.singleton generateLoopConditionQuadruples];
    };
    
    generateWhileConditionQuadrupleBlock = ^() {
        [Helper.singleton generateWhileConditionQuadruple];
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
    
    generateWritequadrupleBlock = ^() {
        [Helper.singleton generateWriteQuadruple];
    };
    
    generateERAQuadrupleBlock = ^(NSString *name) {
        [Helper.singleton generateERAQuadruple:name];
    };
    
    generateEndOfFunctionQuadrupleBlock = ^() {
        [Helper.singleton generateEndOfFunctionQuadruple];
    };
    
    generateEndOfProgramQuadrupleBlock = ^() {
        if (!self->_failed) {
            [Helper.singleton generateEndOfProgramQuadruple];
        } else {
            EndBlock();
        }
    };
    
    generateGoSubQuadrupleBlock = ^(NSString *name) {
        if (!self->_failed) {
            return [Helper.singleton generateGoSubQuadruple];
        }
        return YES;
    };
    
    generateParameterQuadrupleBlock = ^(NSString *name) {
        return [Helper.singleton generateParameterQuadruple];
    };
    
    checkIfArrayBlock = ^(){
        return [Helper.singleton checkIfArray];
    };
    
    checkRangeforArrayExpresionBlock = ^(){
        return [Helper.singleton checkRangeforArrayExpresion];
    };
    
    addSizeGaptoBaseAddressBlock = ^(){
        return [Helper.singleton addSizeGaptoBaseAddress];
    };
    
    generateReturnBlock = ^() {
        return [Helper.singleton generateReturnQuadruple];
    };
    
    generateVoidReturnBlock = ^() {
        return [Helper.singleton generateVoidReturnQuadruple];
    };
    
    yyparse();
    
    yy_delete_buffer(buf);
    _saveButton.enabled = YES;
}

- (IBAction)saveCode:(id)sender {
    // Get my saved programs
    NSDictionary *savedPrograms = [[NSUserDefaults standardUserDefaults] objectForKey:@"SavedPrograms"];
    
    if (savedPrograms == nil) {
        savedPrograms = [[NSMutableDictionary alloc] init];
    }
    
    // Check if program already exists
    if (savedPrograms[Helper.singleton.programName] != nil) {
        // Show Alert
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:[NSString stringWithFormat: @"Replace existing?"]
                                    message:[NSString stringWithFormat:@"Program with name %@ already exists, do you want to replace exisiting code?", Helper.singleton.programName]
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           // Disable save button
                                           self->_saveButton.enabled = false;
                                       }];
        UIAlertAction *replaceAction = [UIAlertAction
                                      actionWithTitle:@"Replace"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action) {
                                          NSMutableDictionary *newProgram = [[NSMutableDictionary alloc] init];
                                          [newProgram addEntriesFromDictionary:savedPrograms];
                                          [newProgram setObject:self->codeTextView.text forKey:Helper.singleton.programName];
                                          
                                          [[NSUserDefaults standardUserDefaults] setObject:newProgram forKey:@"SavedPrograms"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                      }];
        [alert addAction:replaceAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSMutableDictionary *newProgram = [[NSMutableDictionary alloc] init];
    [newProgram setObject:codeTextView.text forKey:Helper.singleton.programName];
    [newProgram addEntriesFromDictionary:savedPrograms];

    [[NSUserDefaults standardUserDefaults] setObject:newProgram forKey:@"SavedPrograms"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// MARK: Keyboard

- (void)dismissKeyboard {
    [codeTextView resignFirstResponder];
}

@end
