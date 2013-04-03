//
//  ASIRequestManager.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 9/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"

@protocol ASIRequestManagerDelegate;
@interface ASIRequestManager : NSObject <ASIHTTPRequestDelegate> {
    //for ASIHTTPRequest
    ASIHTTPRequest *request;
    NSArray * arrayAllItems;
    id<ASIRequestManagerDelegate> delegate;
   
}
 @property(nonatomic,assign) id<ASIRequestManagerDelegate> delegate;
@property (nonatomic, retain) ASIHTTPRequest *request;
@property(nonatomic,retain) NSArray * arrayAllItems;
-(id)initWithDelegate:(id)del;
- (void)requestAllItems;
@end

@protocol ASIRequestManagerDelegate <NSObject>
@optional
- (void)dASIRequestManager:(ASIRequestManager *)om willRequestItem:(BOOL)will;
- (void)dASIRequestManager:(ASIRequestManager *)om shouldShowAllItems:(NSArray *)allItems;
@end