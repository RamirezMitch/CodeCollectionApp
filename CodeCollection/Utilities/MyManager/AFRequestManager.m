//
//  AFRequestManager.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 9/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "AFRequestManager.h"
#import "AFJSONRequestOperation.h"
#import "Constants.h"
#import "MyUtil.h"
#import "Reachability.h"

@implementation AFRequestManager
@synthesize delegate;
@synthesize requestType,queryType,parameterEncoding;
@synthesize rootPathString;

//static NSString * const baseURL = @"http://gpt.cellcityservice.com";

/*+ (AFRequestManager *)sharedClient {
    static AFRequestManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFRequestManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    
    return _sharedClient;
}*/
- (id) initWithDelegate:(id)delegateIn withQueryType:(QueryType)queryTypeIn {
    self = [super init];
    if (self) {
        self.delegate = delegateIn;
        self.queryType = queryTypeIn;
        self.requestType = RequestTypeGET; // Unless assigned explicitly
    }
    return self;
}
- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}


#pragma mark - generic request

// set suffixPath to nil if there is no suffix path
-(void) requestWithSuffixPath:(NSString *)suffixPath paramKeys:(NSArray*)keysIn values:(NSArray*)valuesIn
{
    // rootPath and apiServer
    NSString * rootPath = @"";
    
    switch (self.queryType) {
        case QueryTypeCategories:
            rootPath = URL_CATEGORIES;
            break;
        case QueryTypeOffers:
            rootPath = URL_OFFERS;
            break;
        case QueryTypeOffersAllCategories:
            rootPath = URL_OFFERS_ALL_CATEGORIES;
            break;
        default:
            break;
    }
    
   
    if (suffixPath != nil && ![suffixPath isEqualToString:@""]) {
        rootPath = [rootPath stringByAppendingFormat:@"/%@",suffixPath];
    }
    NSString * urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, rootPath];
    
    self.rootPathString = rootPath; // for cancelation
    
    NSLog(@"urlString=%@", urlString);
    
    // Send
    NSURL * url = [[NSURL alloc] initWithString:urlString];
    [self sendRequestWithURL:url withKeys:keysIn andValues:valuesIn];
    [url release];
}

- (void) sendRequestWithURL:(NSURL *)url withKeys:(NSArray *)keys andValues:(NSArray *)values {
    
    NSLog(@"** sendRequestWithURL: url=%@", [url absoluteString]);
    
    // Construct a NSDictionary
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    if ([keys count] == [values count]) { // ensure
        for (int i=0; i<[keys count]; i++) {
            NSString * k = (NSString *)[keys objectAtIndex:i];
            NSString * v = (NSString *)[values objectAtIndex:i];
            [dict setValue:v forKey:k];
        }
    }
    
    NSLog(@"sendRequestWithURL: dict=%@", dict);
    
    // Activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Send
                      
            if (![self hasInternetConnection]) { // No network connection
                
                NSLog(@"local dict=%@",dict);
                   [MyUtil showAlertViewWithOkButtonWithMessage:MSG_NO_INTERNET_CONNECTION withTitle:APP_TITLE];

            }
            else { // Has network connection
                [self initWithBaseURL:[NSURL URLWithString:BASE_URL]];
                if (requestType == RequestTypeGET) {
                    
                    NSLog(@"RequestType GET");
                    
                    [self getPath:[url path]
                            parameters:[NSDictionary dictionaryWithDictionary:dict]
                               success:^(AFHTTPRequestOperation *operation, id responseJSON) {
                                   
                                   NSLog(@"GET response remote dict=%@",dict);
                                   
                                   // Code on success
                                   [self requestFinishedWithJSONResponse:responseJSON
                                                          fromRequestURL:url
                                                   withRequestParameters:[NSDictionary dictionaryWithDictionary:dict]
                                                           localResponse:NO];
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   // Code on failure
                                   [self requestFailedWithError:error];
                               }];
                }
                else if (requestType == RequestTypePOST) {
                    
                    NSLog(@"RequestType POST");
                    
                    [self setParameterEncoding:self.parameterEncoding];
                    [self postPath:[url path]
                             parameters:[NSDictionary dictionaryWithDictionary:dict]
                                success:^(AFHTTPRequestOperation *operation, id responseJSON) {
                                    
                                    NSLog(@"POST response remote dict=%@", dict);
                                    
                                    // Code on success
                                    [self requestFinishedWithJSONResponse:responseJSON
                                                           fromRequestURL:url
                                                    withRequestParameters:[NSDictionary dictionaryWithDictionary:dict]
                                                            localResponse:NO];
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    // Code on failure
                                    [self requestFailedWithError:error];
                                }];
                }
            }// End Has network connection
          [dict release];
}


#pragma mark - Check Internet Connection

- (BOOL) hasInternetConnection
{
    Reachability * reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

#pragma mark - JSON Responses

- (void)requestFinishedWithJSONResponse:(id)responseJSON
                         fromRequestURL:(NSURL *)url
                  withRequestParameters:(NSDictionary *)dictReq
                          localResponse:(BOOL)isLocalResponse
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //
    // Handling individual response
    //
    
    //DebugLog("requestFinishedWithJSONResponse %@",responseJSON);
            if (responseJSON != nil && (id)responseJSON!=[NSNull null] && [responseJSON isKindOfClass:[NSDictionary class]]) { // Has response
                NSDictionary * dict = [[NSDictionary alloc] initWithDictionary:responseJSON];
                
                NSLog(@"queryType=%d, RequestManager: response dict=%@", self.queryType, dict);
                
                // Send the delegate
                 [self.delegate afrequestManager:self didGetResults:dict withError:nil ofQuery:self.queryType];
                 [dict release];
                
                NSLog(@"*** Just got JSON response from Local Device ***"); // Test only
            }
            else { // No response
                [self.delegate afrequestManager:self didGetResults:nil withError:MSG_NO_RESULTS_DEFAULT ofQuery:self.queryType];
            }

}// End requestFinishedWithJSONResponse



#pragma mark - Error Responses

- (void)requestFailedWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSLog(@"%@\n",[NSString stringWithFormat:@"** Request failed with error: %@", [error description]]);

        [self.delegate afrequestManager:self didGetResults:nil withError:[error localizedDescription] ofQuery:self.queryType];
       
}// End requestFailed


#pragma mark - Cancel Request

- (void) cancel {
    NSString * method = @"GET";
    if (self.requestType == RequestTypePOST) {
        method = @"POST";
    }
   [ self cancelAllHTTPOperationsWithMethod:method path:self.rootPathString];
}

- (void) dealloc {
    [rootPathString release];
    [super dealloc];
}

@end
