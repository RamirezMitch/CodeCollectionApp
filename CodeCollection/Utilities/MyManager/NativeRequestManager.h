//
//  NativeRequestManager.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 15/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NativeRequestManagerDelegate;
@interface NativeRequestManager : NSObject
{
	NSURL *urlObject;
	NSString *urlString;
	bool dataLoaded;
	bool isLoadingData;
	NSDictionary *loadedData;
	NSMutableData *downloadedData;
	NSURLConnection *currentConnection;
	id<NativeRequestManagerDelegate> delegate;
}
@property(nonatomic,assign) id<NativeRequestManagerDelegate> delegate;
-(id)initWithDelegate:(id)del;
-initWithReadingURL:(NSString *)url;
-(void)loadData:(id<NativeRequestManagerDelegate>) delegate;
-(BOOL)isDataLoaded;
-(void)cancelDataLoading;
-(NSDictionary *)getData;

@end


@protocol NativeRequestManagerDelegate
-(void)dataLoaded:(NativeRequestManager *)dataReader;
-(void)dataLoadedWithError:(NativeRequestManager *)dataReader;
@end