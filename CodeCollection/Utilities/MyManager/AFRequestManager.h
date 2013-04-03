//
//  AFRequestManager.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 9/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "Constants.h"
#import "AFRequestManagerDelegate.h"


@interface AFRequestManager : AFHTTPClient {
    id<AFRequestManagerDelegate> delegate;
    // To identify this requestManager
    QueryType queryType;
    // Get or Post
    RequestType requestType;
    
    // Parameter encoding (JSON/XML)
    AFHTTPClientParameterEncoding parameterEncoding;
    NSString * rootPathString; // for cancellation
    
    
}
@property (nonatomic,retain) NSString * rootPathString;
@property (nonatomic,assign) id<AFRequestManagerDelegate> delegate;
@property (nonatomic,assign) QueryType queryType;
@property (nonatomic,assign) RequestType requestType;
@property (nonatomic,assign) AFHTTPClientParameterEncoding parameterEncoding;


//+ (AFRequestManager *)sharedClient;
- (id) initWithDelegate:(id)delegateIn withQueryType:(QueryType)queryTypeIn;
- (void) requestWithSuffixPath:(NSString *)suffixPath paramKeys:(NSArray*)keysIn values:(NSArray*)valuesIn;


- (void) sendRequestWithURL:(NSURL *)url withKeys:(NSArray *)keys andValues:(NSArray *)values;
- (void) requestFinishedWithJSONResponse:(id)responseJSON
                          fromRequestURL:(NSURL *)url
                   withRequestParameters:(NSDictionary *)dictReq
                           localResponse:(BOOL)isLocalResponse;
- (BOOL) hasInternetConnection;
- (void) cancel;
@end
