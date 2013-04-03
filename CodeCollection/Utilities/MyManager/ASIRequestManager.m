//
//  ASIRequestManager.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 9/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "ASIRequestManager.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "Atlas.h"

@implementation ASIRequestManager
@synthesize request=_request;
@synthesize arrayAllItems;
@synthesize delegate;

-(id)initWithDelegate:(id)del {
    self = [super init];
    if (self) {
        self.delegate = del;
    }
    return self;
}

- (void)requestAllItems {
    [self.delegate dASIRequestManager:self willRequestItem:YES];
    NSURL *URL = nil;
    URL = [Atlas URLItemList];
    self.request = [ASIHTTPRequest requestWithURL:URL];
    [self.request setDelegate:self];
    [self.request startAsynchronous];
}

//For ASIHTTPRequest
#pragma mark - ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)aRequest
{
    NSLog(@"request: %@", aRequest);
}
- (void)request:(ASIHTTPRequest *)aRequest didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"Headers: %@", responseHeaders);
}
- (void)requestFinished:(ASIHTTPRequest *)aRequest
{
    NSString *jsonString = [aRequest responseString];
    
    NSError *error = nil;
	SBJsonParser *jsonParser = [[SBJsonParser new] autorelease];
	NSDictionary *json = [jsonParser objectWithString:jsonString error:&error];
    
    NSAssert1(error == nil, @"error on parse json: %@", [error description]);
    
    NSInteger count = [[[json objectForKey:@"Info"]objectForKey:@"RecordCount"] intValue];
    NSArray *data = [json objectForKey:@"Data"];
    NSLog(@"data : %@",data);
    if ([data count] != count) {
        NSLog(@"count mismatch [%d : %d]", [data count], count);
        return;
    }
    
    if ([data count] == 0) {
        NSLog(@"No data!!!");
    }
    
    if (arrayAllItems!= nil) {
        [arrayAllItems release];
        arrayAllItems = nil;
    }
    arrayAllItems = [[NSArray alloc] initWithArray:data copyItems:YES];
    
    NSLog(@"Data Content: %@", arrayAllItems);
    [self.delegate dASIRequestManager:self shouldShowAllItems:arrayAllItems];
}
- (void)requestFailed:(ASIHTTPRequest *)aRequest
{
    NSLog(@"requestFailed: %@", [aRequest error]);
    
}

-(void)dealloc{
    [_request release];
    [super dealloc];
}
@end
