//
//  NativeAPIManager.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 17/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "NativeAPIManager.h"
#import "SBJson.h"
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"

@implementation NativeAPIManager
static NativeAPIManager *defaultManager = nil;

+ (NativeAPIManager *)defaultManager
{
	@synchronized(self)
	{
		if (defaultManager==nil)
		{
			[[self alloc] init];
		}
	}
	return defaultManager;
}
- (id)retain {
    return self;
}
-
(unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}
- (id)autorelease
{
    return self;
}
- (void)dealloc {
	[super dealloc];
}

- (id)init
{
	if (self = [super init])
	{
    }
	return self;
}


- (NSMutableArray*)arrayAllItems
{
	
	WebRequestObject *webRequestObject = [[WebRequestObject alloc] init];
	[webRequestObject setUrlString: @"http://www.melbournecentral.com.au/api/servicecms.svc/GetOffersByCategories?catIds=ce48e178-88fb-4f7f-a0ab-b0d59d3502ea,de391a14-3536-4a71-8fc8-52cf6877a5e9,41e197ff-e362-40fa-b688-bbe18de6c1ae,82a023b7-f0a8-4836-8077-95fdddaea94b,d4f067b6-d22f-4749-91d2-7505a3aa3740,10bae0b9-7058-486c-8e6a-cdd88e5c8a56,08d3be5d-bc5e-4ca6-9241-e024109e2074,57359977-73c4-4c83-910a-dc165beb079d,179f2f7c-9547-4501-a3ba-e9d4cd8b6b16,fd461612-520a-455b-b512-ca8ea3338231&itemspercat=20&page=1"];
	[webRequestObject setHttpMethod:@"GET"];
    
    NSArray *paramKeys=[NSArray arrayWithObjects:@"catIds", @"page",@"itemspercat", nil];
    NSArray *values = [NSArray arrayWithObjects:@"ce48e178-88fb-4f7f-a0ab-b0d59d3502ea,de391a14-3536-4a71-8fc8-52cf6877a5e9,41e197ff-e362-40fa-b688-bbe18de6c1ae,82a023b7-f0a8-4836-8077-95fdddaea94b,d4f067b6-d22f-4749-91d2-7505a3aa3740,10bae0b9-7058-486c-8e6a-cdd88e5c8a56,08d3be5d-bc5e-4ca6-9241-e024109e2074,57359977-73c4-4c83-910a-dc165beb079d,179f2f7c-9547-4501-a3ba-e9d4cd8b6b16,fd461612-520a-455b-b512-ca8ea3338231",@"1",@"20",nil];
    // Construct a NSDictionary
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    if ([paramKeys count] == [values count]) { // ensure
        for (int i=0; i<[paramKeys count]; i++) {
            NSString * k = (NSString *)[paramKeys objectAtIndex:i];
            NSString * v = (NSString *)[values objectAtIndex:i];
            [dict setValue:v forKey:k];
        }
    }

    [webRequestObject setParameters:dict];
	
	id resultsDict = [self webRequest:webRequestObject];
	[webRequestObject release];
	
	//NSLog(@"%@", resultsDict);
		
	if (resultsDict!=nil)
	{
        NSLog(@"%@", resultsDict);
		NSMutableArray *resultsArray = [resultsDict objectForKey:@"Data"];
		
		/*NSMutableArray *sectionArray = [NSMutableArray array];
		NSMutableDictionary *sectionOne = [NSMutableDictionary dictionary];
		[sectionOne setObject:[resultsDict objectForKey:@"n"] forKey:@"n"];
		[sectionOne setObject:resultsArray forKey:@"rows"];
		[sectionArray addObject:sectionOne];
		
		for (NSMutableDictionary *item in resultsArray)
		{
			[item setObject:[NSNumber numberWithInt:kCELLTYPE_FORUM_LISTING] forKey:@"cellType"];
			
			NSString *description = [item objectForKey:@"content"];
			CGSize maxSize = CGSizeMake(275,1000);
			CGSize optimumSize = [description sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:maxSize];
			[item setObject:[NSNumber numberWithFloat:optimumSize.height] forKey:@"contentHeight"];
			
		}*/
		
		return resultsArray;
	}
	else return nil;
    
}
- (NSString*)md5Key
{
	NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];
	NSDate *cal = [NSDate date];
	NSString *description_ = [cal description];
	NSArray *break_ = [[[description_ componentsSeparatedByString:@" "] objectAtIndex:1] componentsSeparatedByString:@":"];
	NSString *newDate = [NSString stringWithFormat:@"com.buuuk.tnp.foodballkaki_%@%@%@%@",[[description_ componentsSeparatedByString:@" "] objectAtIndex:0] ,[break_ objectAtIndex:0], [break_ objectAtIndex:1],[break_ objectAtIndex:2]];
	
	NSString *seed = [NSString stringWithFormat:@"%@%@", udid, newDate];
	const char *cStr = [seed UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, strlen(cStr), result);
	
	NSString *md5Key = [NSString
						stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
						result[0], result[1],
						result[2], result[3],
						result[4], result[5],
						result[6], result[7],
						result[8], result[9],
						result[10], result[11],
						result[12], result[13],
						result[14], result[15]
						];
	
	return md5Key;
}

- (id)webRequest:(WebRequestObject*)webRequestObject
{
	
	if ([webRequestObject parameters]==nil)
	{
		NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
		[webRequestObject setParameters:parameters];
	}
	
	
	id jsonResponse = [self requestWithHttpMethod:webRequestObject.httpMethod baseURLString:webRequestObject.urlString parameters:webRequestObject.parameters isMultipart:webRequestObject.isMultipart];
			
	return jsonResponse;
}

- (void)webRequestInThread:(WebRequestObject *)webRequestObject
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	id jsonResponse = [self requestWithHttpMethod:webRequestObject.httpMethod baseURLString:webRequestObject.urlString parameters:webRequestObject.parameters  isMultipart:webRequestObject.isMultipart];
    [[NSNotificationCenter defaultCenter] postNotificationName:webRequestObject.notificationName object:jsonResponse];
	
	[pool release];
}

- (id)requestWithHttpMethod:(NSString*)httpMethod baseURLString:(NSString*)urlString parameters:(NSDictionary *)parameters isMultipart:(BOOL)isMultipart
{
	NSMutableString *postURLString = [NSMutableString stringWithString:urlString];
	NSMutableString *parameterString = nil;
	if ([parameters count]>0)
	{
		parameterString = [NSMutableString stringWithString:@""];
		int i;
		for (i=0; i<[[parameters allKeys] count]; i++)
		{
			NSString *key = [[parameters allKeys] objectAtIndex:i];
			id value = [parameters objectForKey:key];
			if (i!=0) [parameterString appendString:@"&"];
			[parameterString appendFormat:@"%@=%@", key, value];
		}
	}
	
	if ([httpMethod isEqualToString:@"GET"])
	{
		if (parameterString!=nil)
		{
			[postURLString appendFormat:@"?%@", parameterString];
		}
	}
	else if ([httpMethod isEqualToString:@"POST"])
	{
	}
	

	 NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postURLString]
																 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
															 timeoutInterval:60] autorelease];
	
	if ([httpMethod isEqualToString:@"GET"])
	{
		[request setHTTPMethod:@"GET"];
	}
	else if ([httpMethod isEqualToString:@"POST"])
	{
		[request setHTTPMethod:@"POST"];
		
		NSString *boundary = @"0xAbCdEfGbOuNdArY";
		if (isMultipart)
		{
			NSMutableData *postData = [NSMutableData data];
			[postData appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
			
			int i;
			for (i=0; i<[[parameters allKeys] count]; i++)
			{
				NSString *key = [[parameters allKeys] objectAtIndex:i];
				
				id value = [parameters objectForKey:key];
				if ([key rangeOfString:@"file"].location==0)
				{
					//NSLog(@"has photo %@", value);
					NSData *imageData = UIImageJPEGRepresentation(value,0.8);
					NSString *filename = [NSString stringWithFormat:@"%0.f.jpg", [[NSDate date] timeIntervalSince1970] ];
					
					[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, filename] dataUsingEncoding:NSUTF8StringEncoding]];
					[postData appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\nContent-Transfer-Encoding: binary\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
					//[postData appendData:[[NSString stringWithString:@"Content-Type: image/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
					[postData appendData:imageData];
					[postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
					
				}
				else
				{
					if ([value isKindOfClass:[NSString class]])
					{
						// escape text
						value = [value stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
						value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
						value = [value stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
						value = [value stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
						value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
						value = [value stringByReplacingOccurrencesOfString:@";" withString:@"%3B"];
						value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
					}
					//NSLog(@"%@ %@", key, value);
					[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
					[postData appendData:[[NSString stringWithFormat:@"%@",value] dataUsingEncoding:NSUTF8StringEncoding]];
					[postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
					//[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n--\r\n", key, value, boundary] dataUsingEncoding:NSUTF8StringEncoding]];
					
				}
				
				//NSLog(@"length %d", [postData length]);
			}
			
			// close boundary
			[postData appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"data\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
			[postData appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
			[postData appendData:[NSData dataWithData:nil]];
			
			
			[postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
			NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
			[request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
			[request setValue:@"st.buuuk.in" forHTTPHeaderField:@"Host"];
			[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
			[request setHTTPBody:postData];
			
		}
		else
		{
			NSData *postData = [parameterString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
			NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
			[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
			[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
			[request setHTTPBody:postData];
		}
	}
    NSLog(@"REQUEST: %@", request);
  
	NSURLResponse *response;
	NSError *error;
	NSData *myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
	NSString *responseString = [[[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding] autorelease];
	
	
	SBJsonParser *jsonParser = [SBJsonParser new];
	id jsonResponse = [jsonParser objectWithString:responseString error:NULL];
	[jsonParser release];
	
	if (jsonResponse!=nil)
	{
		return jsonResponse;
	}
	else
	{
		BOOL show = YES;
		if ([[UIApplication sharedApplication] respondsToSelector:@selector(applicationState)])
		{
			UIApplicationState state = [[UIApplication sharedApplication] applicationState];
			if (state==UIApplicationStateBackground || state==UIApplicationStateInactive)
			{
				show = NO;
			}
		}
        
		if ([[responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]!=0)
		{
			if (show)
			{
				UIAlertView *alertView = [[UIAlertView alloc] init];
				[alertView setTitle:@"Please check back again later.\nThank you"];
				[alertView addButtonWithTitle:@"OK"];
				[alertView show];
				[alertView release];
			}
		}
		
		
		
		
		//NSLog(@"%@", responseString);
		return nil; //responseString;
	}
}

@end
