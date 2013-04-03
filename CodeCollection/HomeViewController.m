//
//  HomeViewController.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 1/3/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "HomeViewController.h"
#import "ItemViewController1.h"
#import "ItemViewController2.h"
#import "ItemViewController3.h"
#import "ItemViewController4.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "MoveScaleImageViewController.h"
#import "DITableViewController.h"
#import "LBViewController.h"
#import "MyViewController.h"
#import "NotifierViewController.h"
#import "MapViewController.h"
#import "SectionTableViewController.h"
#import "CategorizeTableViewController.h"
#import "CarouselViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        //Item View Styles
        ListItem *item1 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"5_64x64.png"] text:@"Table"];
        ListItem *item2 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"6_64x64.png"] text:@"Collection"];
        ListItem *item3 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"7_64x64.png"] text:@"PageControl"];
        ListItem *item4 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"8_64x64.png"] text:@"PageSheet"];
        ListItem *item5 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"9_64x64.png"] text:@"Section"];
        ListItem *item6= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"6_64x64.png"] text:@"Category"];
        ListItem *item7= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"6_64x64.png"] text:@"Collapse"];
        ListItem *item8= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"6_64x64.png"] text:@"MultiColumn"];
        ListItem *item9= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"6_64x64.png"] text:@"iCarousel"];
        ListItem *item10= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"6_64x64.png"] text:@"Pending"];
        
        //Map and Location
        ListItem *item11 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"10_64x64.png"] text:@"Locate Me"];
        ListItem *item12 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"11_64x64.png"] text:@"NearBy"];
        ListItem *item13 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"12_64x64.png"] text:@"CheckIn"];
        ListItem *item14 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"10_64x64.png"] text:@"Direction"];
        
        //Connect and Share
        ListItem *item15= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"11_64x64.png"] text:@"Sharer"];
        ListItem *item16= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"9_64x64.png"] text:@"FB Feeds"];
        ListItem *item17= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"8_64x64.png"] text:@"TW Feeds"];
        ListItem *item18= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"7_64x64.png"] text:@"FB Checkin"];
        ListItem *item19= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"6_64x64.png"] text:@"Call"];
        ListItem *item20= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"5_64x64.png"] text:@"WebView"];
        ListItem *item21= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"11_64x64.png"] text:@"Browser"];
        
        //Camera and Image
        ListItem *item22= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"10_64x64.png"] text:@"Camera"];
        ListItem *item23= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"9_64x64.png"] text:@"Album"];
        ListItem *item24= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"8_64x64.png"] text:@"MoveScale"];
        ListItem *item25= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"6_64x64.png"] text:@"Recolor"];
        ListItem *item26= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"5_64x64.png"] text:@"Crop"];
        ListItem *item27= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"7_64x64.png"] text:@"Meme"];
        
        //Camera and Video
        ListItem *item28= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"5_64x64.png"] text:@"Camera"];
        ListItem *item29= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"12_64x64.png"] text:@"Album"];
        ListItem *item30= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"6_64x64.png"] text:@"Slice"];
        ListItem *item31= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"11_64x64.png"] text:@"Crop"];
        ListItem *item32= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"9_64x64.png"] text:@"Graph"];

        //File and Viewers
        ListItem *item33= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"11_64x64.png"] text:@"PDFs"];
        ListItem *item34= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"9_64x64.png"] text:@"Videos"];
        ListItem *item35= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"8_64x64.png"] text:@"Audios"];
        ListItem *item36= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"7_64x64.png"] text:@"Images"];
        ListItem *item37= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"6_64x64.png"] text:@"Directory"];
        ListItem *item38= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"5_64x64.png"] text:@"BackUp"];
        ListItem *item39= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"11_64x64.png"] text:@"Print"];

        //Notification
        ListItem *item40= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"11_64x64.png"] text:@"Notify"];
        
        freeList = [[NSMutableArray alloc] initWithObjects: item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, nil];
        paidList = [[NSMutableArray alloc] initWithObjects: item11, item12, item13, item14, nil];
        grossingList = [[NSMutableArray alloc] initWithObjects: item15, item16, item18, item19, item20, item21, nil];
        imgcamList = [[NSMutableArray alloc] initWithObjects:item22, item23, item24, item25, item26, item27, nil];
        videoAudioList = [[NSMutableArray alloc]initWithObjects:item28,item29, item30, item31,item32, nil];
        fileList = [[NSMutableArray alloc] initWithObjects:item33, item34, item35, item36, item38, item39, nil];
        notifyList=[[NSMutableArray alloc]initWithObjects:item40, nil];
    }
    self.title = @"HOME";
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    //[self.navigationController.navigationBar setHidden:YES];
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            tableHeight=368;
        }
        if(result.height == 568)
        {
            // iPhone 5
            tableHeight=455;
        }
    }
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320,470) style:UITableViewStylePlain];
    tableView.dataSource=self;
    tableView.delegate = self;
    tableView.frame = CGRectMake(0, 0, 320, tableHeight);
    [self.view addSubview:tableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *title = @"";
    POHorizontalList *list;
    
    if ([indexPath row] == 0) {
        title = @"Item View Style";
        
        list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 155.0) title:title items:freeList];
    }
    else if ([indexPath row] == 1) {
        title = @"Map and Location";
        
        list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 155.0) title:title items:paidList];
    }
    else if ([indexPath row] == 2) {
        title = @"Connect and Share";
        
        list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 155.0) title:title items:grossingList];
    }
    else if ([indexPath row] == 3) {
        title = @"Camera and Images";
        
        list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 155.0) title:title items:imgcamList];
    }
    else if ([indexPath row] == 4) {
        title = @"Camera, Audio and Video";
        
        list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 155.0) title:title items:videoAudioList];
    }
    else if ([indexPath row] == 5) {
        title = @"Files and Viewer";
        
        list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 155.0) title:title items:fileList];
    }
    else if ([indexPath row] == 6) {
        title = @"Files and Viewer";
        
        list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 155.0) title:title items:notifyList];
    }
    
    [list setDelegate:self];
    [cell.contentView addSubview:list];
    
    return cell;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark  POHorizontalListDelegate

- (void) didSelectItem:(ListItem *)item {
    NSLog(@"Horizontal List Item %@ selected", item.imageTitle);
    //Category1
    if([item.imageTitle isEqualToString:@"Table"]){
        ItemViewController1 *view1 =[[ItemViewController1 alloc]initWithNibName:@"ItemViewController1" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNav pushViewController:view1 animated:YES];
        [view1 release];
    }else if([item.imageTitle isEqualToString:@"Collection"]){
        ItemViewController2 *view2 =[[ItemViewController2 alloc]init];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNav pushViewController:view2 animated:YES];
        [view2 release];
    }else if([item.imageTitle isEqualToString:@"PageControl"]){
        ItemViewController3 *view3 =[[ItemViewController3 alloc]init];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNav pushViewController:view3 animated:YES];
        [view3 release];
    }else if([item.imageTitle isEqualToString:@"PageSheet"]){
        ItemViewController4 *view4 =[[ItemViewController4 alloc]init];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNav pushViewController:view4 animated:YES];
        [view4 release];
    }else if([item.imageTitle isEqualToString:@"MoveScale"]){
    
    MoveScaleImageViewController *movescaleView =[[MoveScaleImageViewController alloc]initWithNibName:@"MoveScaleImageViewController" bundle:nil];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainNav pushViewController:movescaleView animated:YES];
    [movescaleView release];
    }else if([item.imageTitle isEqualToString:@"PDFs"]){
        
        DITableViewController *movescaleView =[[DITableViewController alloc]initWithNibName:@"DITableViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNav pushViewController:movescaleView animated:YES];
        [movescaleView release];
    }
    else if([item.imageTitle isEqualToString:@"Videos"]){
        
        LBViewController *movescaleView =[[LBViewController alloc]initWithNibName:@"LBViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNav pushViewController:movescaleView animated:YES];
        [movescaleView release];
    }
    else if([item.imageTitle isEqualToString:@"Camera"]){
        
        MyViewController *movescaleView =[[MyViewController alloc]initWithNibName:@"MyViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNav pushViewController:movescaleView animated:YES];
        [movescaleView release];
    }
    else if([item.imageTitle isEqualToString:@"Notify"]){
        
        NotifierViewController *movescaleView =[[NotifierViewController alloc]initWithNibName:@"NotifierViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNav pushViewController:movescaleView animated:YES];
        [movescaleView release];
    }
    else if([item.imageTitle isEqualToString:@"Locate Me"]){
        
        MapViewController *movescaleView =[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNav pushViewController:movescaleView animated:YES];
        [movescaleView release];
    }
    else if([item.imageTitle isEqualToString:@"Section"]){
        
        SectionTableViewController *movescaleView =[[SectionTableViewController alloc]initWithNibName:@"SectionTableViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNav pushViewController:movescaleView animated:YES];
        [movescaleView release];
    }
    else if([item.imageTitle isEqualToString:@"Category"]){
        
        CategorizeTableViewController *movescaleView =[[CategorizeTableViewController alloc]initWithNibName:@"CategorizeTableViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNav pushViewController:movescaleView animated:YES];
        [movescaleView release];
    }
    else if([item.imageTitle isEqualToString:@"iCarousel"]){
        
        CarouselViewController *movescaleView =[[CarouselViewController alloc]init];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNav pushViewController:movescaleView animated:YES];
        [movescaleView release];
    }

    //Category2
    //Category3
    //Category4
    //Category5
}
@end
