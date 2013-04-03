//
//  NativeRequestManager.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 15/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "NativeRequestManager.h"
#import "SBJson.h"
#import "NSObject+SBJSON.h"

@implementation NativeRequestManager
@synthesize delegate;

-(id)initWithDelegate:(id)del
{
	if(self == [super init])
	{
		urlObject = nil;
		urlString = nil;
		dataLoaded = NO;
		isLoadingData = NO;
		self.delegate = del;
	}
	return self;
}

-initWithReadingURL:(NSString *)url
{
	if(self ==[super init])
	{
		urlString = [[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                     stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		[urlString retain];
		
		urlObject = [[NSURL alloc]initWithString:urlString];
		dataLoaded = NO;
		isLoadingData = NO;
		//delegate = self;
	}
	return self;
}

-(void)loadData:(id<NativeRequestManagerDelegate>)delegateObject
{
	if(self.delegate)
		self.delegate = nil;
	
	self.delegate = delegateObject;
	if(downloadedData !=nil)
		[downloadedData release];
	downloadedData = nil;
	downloadedData = [[NSMutableData alloc] init];
	
    NSLog(@"load URL: %@", urlObject.absoluteString);
	NSURLRequest *request = [NSURLRequest requestWithURL:urlObject];
    
	if(currentConnection!=nil)
		[currentConnection release];
	currentConnection = nil;
	
	currentConnection = [[NSURLConnection alloc] initWithRequest:request
														delegate:self
												startImmediately:YES];
	isLoadingData = YES;
}

-(void)cancelDataLoading
{
	if(currentConnection!=nil)
	{
		[currentConnection cancel];
		[currentConnection release];
	}
	isLoadingData = NO;
}

-(NSDictionary *)getData
{
	return loadedData;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if(connection==currentConnection)
		[downloadedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if(connection==currentConnection)
	{
		[currentConnection release];
		currentConnection = nil;
		isLoadingData = NO;
		dataLoaded = YES; //consider loaded even if empty
		if(delegate)
        {
            if(urlString==nil)
                [delegate dataLoaded:self];
            else if([urlString isEqualToString:@""])
                [delegate dataLoaded:self];
            else
                NSLog(@"data error:%@", error);
            [delegate dataLoadedWithError:self];
        }
	}
}

/*- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	return nil;
}*/

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	isLoadingData = NO;
	if(connection==currentConnection)
	{
		[currentConnection release];
		currentConnection = nil;
	}
    
	// Create new SBJSON parser object
	SBJsonParser *parser = [[SBJsonParser new] autorelease];
    
	// Get JSON as a NSString from NSData response
	NSString *json_string = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
    
	// parse the JSON response into an object
	NSDictionary *dataDictionaries = [parser objectWithString:json_string error:nil];
	
	NSLog(@"URL:%@", urlString);
    
	[json_string release];
	[parser release];
	if(loadedData!=nil)
		[loadedData release];
	loadedData = nil;
	loadedData = [dataDictionaries copy];
	dataLoaded = YES;
	if(self.delegate)
		[self.delegate dataLoaded:self];
}

-(BOOL)isDataLoaded
{
	return dataLoaded;
}

-(void)dealloc
{
	if(urlString)
		[urlString release];
	urlString = nil;
	if(urlObject!=nil)
		[urlObject release];
	urlObject = nil;
	
	if(downloadedData!=nil)
		[downloadedData release];
	downloadedData = nil;
	
	if(loadedData!=nil)
		[loadedData release];
	loadedData = nil;
	
	if(currentConnection!=nil)
		[currentConnection release];
	currentConnection = nil;
	
	delegate = nil;
    
	[super dealloc];
}
@end
