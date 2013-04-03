//
//  DataLibrary.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 15/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NativeRequestManager.h"

@protocol DataLibraryDelegate;
@class NativeRequestManager;
@interface DataLibrary : NSObject <NativeRequestManagerDelegate> {
    NativeRequestManager *nativeRequestManager;
    NSString *itemListURL;
	NSArray *itemsArray;
	
    id<DataLibraryDelegate> delegate;
}
@property(nonatomic,assign) id<DataLibraryDelegate> delegate;
+instance;
+(void)destroyInstance;
-(void)loadAllItemswithDelegate:(NSObject<DataLibraryDelegate> *)delegate;
-(NSArray *)getItemsArray;

-(id)initWithDelegate:(id)del;
- (void) cancelRequest;
@end

@protocol DataLibraryDelegate
-(void)retrieveData;
@end

