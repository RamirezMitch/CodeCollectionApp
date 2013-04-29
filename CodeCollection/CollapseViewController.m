//
//  CollapseViewController.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 24/4/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "CollapseViewController.h"
#import "Product.h"
@interface CollapseViewController (){
   }
@end

@implementation CollapseViewController
@synthesize productManager;
@synthesize myTable;
@synthesize sectionTitleArray,sectionContentDict,arrayForBool;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    [productManager release];
    [myTable release];
    [sectionContentDict release];
    [sectionTitleArray release];
    [arrayForBool release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
          self.productManager = [[[ProductManager alloc] initWithDelegate:self :YES] autorelease];
      [self.productManager loadXLS];
    
}
- (void)dProductManager:(ProductManager *)om shouldShowAllSections:(NSArray *)allSections withContent:(NSMutableDictionary *)allContent {
    self.sectionTitleArray =[NSArray arrayWithArray:allSections];
    self.sectionContentDict =[NSMutableDictionary dictionaryWithDictionary:  allContent];
    if (!arrayForBool) {
        self.arrayForBool    = [NSMutableArray arrayWithCapacity:[sectionTitleArray count]];
        for(int cnt=0; cnt < [sectionTitleArray count]; cnt++){
            [arrayForBool addObject:[NSNumber numberWithBool:NO]];
        }
    }
    [self.myTable reloadData];
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [sectionTitleArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        return [[sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:section]] count];
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headerView.tag                  = section;
    headerView.backgroundColor      = [UIColor whiteColor];
    UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20-50, 50)];
    BOOL manyCells                  = [[arrayForBool objectAtIndex:section] boolValue];
    if (!manyCells) {
        headerString.text = [sectionTitleArray objectAtIndex:section]; //@"click to enlarge";
    }else{
        headerString.text = [sectionTitleArray objectAtIndex:section]; //@"click again to reduce";
    }
    headerString.textAlignment      = NSTextAlignmentLeft;
    headerString.textColor          = [UIColor blackColor];
    [headerView addSubview:headerString];
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [headerView addGestureRecognizer:headerTapped];
    
    //up or down arrow depending on the bool
    UIImageView *upDownArrow        = [[UIImageView alloc] initWithImage:manyCells ? [UIImage imageNamed:@"upArrowBlack"] : [UIImage imageNamed:@"downArrowBlack"]];
    upDownArrow.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin;
    upDownArrow.frame               = CGRectMake(self.view.frame.size.width-40, 10, 30, 30);
    [headerView addSubview:upDownArrow];
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer  = [[UIView alloc] initWithFrame:CGRectZero];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 50;
    }
    return 1;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    if (!manyCells) {
        cell.textLabel.text = [sectionTitleArray objectAtIndex:indexPath.section]; // @"click to enlarge";
    }
    else{
        NSArray *content = [sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
        Product *dproduct = [content objectAtIndex:indexPath.row];
        cell.textLabel.text = dproduct.product_title;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.myTable deselectRowAtIndexPath:indexPath animated:YES];
  /*  DetailViewController *dvc;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        dvc = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone"  bundle:[NSBundle mainBundle]];
    }else{
        dvc = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPad"  bundle:[NSBundle mainBundle]];
    }
    dvc.title        = [sectionTitleArray objectAtIndex:indexPath.section];
    dvc.detailItem   = [[sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
    */
}


#pragma mark - gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        collapsed       = !collapsed;
        [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
        
        //reload specific section animated
        NSRange range   = NSMakeRange(indexPath.section, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.myTable reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
