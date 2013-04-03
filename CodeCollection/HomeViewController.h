//
//  HomeViewController.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 1/3/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POHorizontalList.h"

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, POHorizontalListDelegate> {
    NSMutableArray *itemArray;
    
    NSMutableArray *freeList;
    NSMutableArray *paidList;
    NSMutableArray *grossingList;
    
    //Camera and Images
    NSMutableArray *imgcamList;
    
    //Camera and Video and Audio
    NSMutableArray *videoAudioList;
    
    //PDF, YouTube, Audio and Images Files
    NSMutableArray *fileList;
    
    //Notification
    NSMutableArray *notifyList;
    
    int tableHeight;
    UITableView *tableView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
