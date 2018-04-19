//
//  CollectionViewController.m
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 4/17/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import "CollectionViewController.h"
#import "ViewController.h"
#import "ProgramCollectionViewCell.h"
#import "Program.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"myCell";
NSMutableDictionary *programDict;
NSArray *programKeys;
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
    NSDictionary *savedPrograms = [[NSUserDefaults standardUserDefaults] objectForKey:@"SavedPrograms"];
    
    // Get test programs
    programDict = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TestPrograms" ofType:@"plist"]];
    
    //Join
    [programDict addEntriesFromDictionary:savedPrograms];
    programKeys = programDict.allKeys;
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
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [programDict count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProgramCollectionViewCell *cell = (ProgramCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSString* name = programKeys[indexPath.row];
    cell.programName = name;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Get TabBar size
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    CGFloat statusBarHeight = 15;
    CGFloat spacingHeight = 50;
    CGFloat height = (collectionView.frame.size.height - tabBarHeight - statusBarHeight)/3 - spacingHeight;
    CGFloat width = (collectionView.frame.size.width - 20) / 3 - 10;
    return CGSizeMake(width, height);
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
    NSString* name = programKeys[indexPath.row];
    NSString* code = [NSString stringWithFormat:@"%@ \n", programDict[name]];
    code = [code stringByReplacingOccurrencesOfString:@"\n" withString:@"\n"];
    code = [code stringByReplacingOccurrencesOfString:@"\t" withString:@"\t"];
    selectedProgram = [[Program alloc] initWithTitle:name andCode:code];
    
    // Send program to console
    UINavigationController *next = (UINavigationController*) self.tabBarController.viewControllers[1];
    ViewController *desitination = (ViewController*) next.topViewController;
    // Pass the selected object to the new view controller.
    desitination.selectedProgram = selectedProgram;
    desitination.selectedCode = code;
    [self.tabBarController setSelectedIndex:1];
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
