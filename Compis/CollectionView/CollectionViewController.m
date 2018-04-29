//
//  CollectionViewController.m
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 4/17/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import "CollectionViewController.h"
#import "ViewController.h"
#import "TitleCollectionReusableView.h"
#import "ProgramCollectionViewCell.h"
#import "Program.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"myCell";
NSMutableDictionary *defaultProgramsDict;
NSMutableDictionary *myProgramsDict;
NSArray *myProgramKeys;
NSArray *defaultProgramKeys;
Program *selectedProgram;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get Saved Programs
    [self getPrograms];
}

- (void)viewDidAppear:(BOOL)animated {
    // Get Saved Programs
    [self getPrograms];
    
    [self.collectionView reloadData];
}

- (void)getPrograms {
    // Get my saved programs
    myProgramsDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"SavedPrograms"];
    
    // Get test programs
    defaultProgramsDict = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TestPrograms" ofType:@"plist"]];
    
    //Join
    myProgramKeys = myProgramsDict.allKeys;
    defaultProgramKeys = defaultProgramsDict.allKeys;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    ViewController *next = (ViewController*) [segue destinationViewController];
//    // Pass the selected object to the new view controller.
//    next.selectedProgram = selectedProgram;
//
//}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return [myProgramsDict count];
    }
    
    return [defaultProgramsDict count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProgramCollectionViewCell *cell = (ProgramCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    if (indexPath.section == 0) {
        NSString* name = myProgramKeys[indexPath.row];
        cell.programName = name;
        
        return cell;
    }
    
    NSString* name = defaultProgramKeys[indexPath.row];
    cell.programName = name;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Get TabBar size
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat spacingHeight = 50;
    CGFloat height = (collectionView.frame.size.height - tabBarHeight - statusBarHeight - navBarHeight - spacingHeight)/4 ;
    CGFloat width = height * 0.71;
    return CGSizeMake(width, height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    TitleCollectionReusableView *view = (TitleCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
   
    if (indexPath.section == 0) {
        view.title = @"My programs";
    } else {
        view.title = @"Default programs";
    }
    
    return view;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5.0, 0.0, 5.0, 0.0);
}

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString* name = @"";
    NSString* code = @"";
    
    if (indexPath.section == 0) {
        name = myProgramKeys[indexPath.row];
        code = [NSString stringWithFormat:@"%@ \n", myProgramsDict[name]];
    } else {
        name = defaultProgramKeys[indexPath.row];
        code = [NSString stringWithFormat:@"%@ \n", defaultProgramsDict[name]];
    }
    
    selectedProgram = [[Program alloc] initWithTitle:name andCode:code];
    
    // Send program to inputTab
    UINavigationController *next = (UINavigationController*) self.tabBarController.viewControllers[1];
    ViewController *desitination = (ViewController*) next.topViewController;
    
    // Pass the selected object to the new view controller.
    desitination.selectedProgram = selectedProgram;
    desitination.selectedCode = code;
    [self.tabBarController setSelectedIndex:1];
}

#pragma mark Files Managment

- (void) deleteProgramFromDefaults {
    // Delete from Defaults
    NSMutableDictionary *savedPrograms = [[NSUserDefaults standardUserDefaults] objectForKey:@"SavedPrograms"];
    
    [savedPrograms removeObjectForKey:selectedProgram.title];
    [[NSUserDefaults standardUserDefaults] setObject:savedPrograms forKey:@"SavedPrograms"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Delete from currentFiles
    [myProgramsDict removeObjectForKey:selectedProgram.title];
    myProgramKeys = myProgramsDict.allKeys;
}

@end
