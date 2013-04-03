//
//  FirstViewController.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 9/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DItemManager.h"
#import "ASIRequestManager.h"
#import "DataLibrary.h"
@interface ConnectionsViewController : UIViewController <DItemManagerDelegate,ASIRequestManagerDelegate,DataLibraryDelegate>{
    NSArray * arrayAllItems;

}
@property(nonatomic,retain) DItemManager *dItemManager;
@property(nonatomic,retain) ASIRequestManager *asiRequestManager;
@property(nonatomic,retain) NativeRequestManager *nativeRequestManager;
@property(nonatomic,retain) NSArray * arrayAllItems;
-(IBAction)afNetworking:(id)sender;
-(IBAction)asiNetworking:(id)sender;
-(IBAction)nativeNetworking:(id)sender;
@end
