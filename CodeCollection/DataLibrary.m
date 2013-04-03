//
//  DataLibrary.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 15/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "DataLibrary.h"

@implementation DataLibrary
static DataLibrary *dataLibrary;

@synthesize delegate;

+(DataLibrary *)instance
{
	if(dataLibrary==nil)
	{
		dataLibrary = [[DataLibrary alloc] init];
	}
	return dataLibrary;
}

+(void)destroyInstance
{
    if(dataLibrary)
    {
        [dataLibrary release];
    }
    dataLibrary = nil;
}
-(id)initWithDelegate:(id)del {
    self = [super init];
    if (self) {
        self.delegate = del;
    }
    return self;
}

-(void)loadAllItems
{
	if(nativeRequestManager!=nil)
	{
		[nativeRequestManager release];
		nativeRequestManager = nil;
	}
	
	NSString *urlString = @"http://www.melbournecentral.com.au/api/servicecms.svc/GetOffersByCategories?catIds=ce48e178-88fb-4f7f-a0ab-b0d59d3502ea,de391a14-3536-4a71-8fc8-52cf6877a5e9,41e197ff-e362-40fa-b688-bbe18de6c1ae,82a023b7-f0a8-4836-8077-95fdddaea94b,d4f067b6-d22f-4749-91d2-7505a3aa3740,10bae0b9-7058-486c-8e6a-cdd88e5c8a56,08d3be5d-bc5e-4ca6-9241-e024109e2074,57359977-73c4-4c83-910a-dc165beb079d,179f2f7c-9547-4501-a3ba-e9d4cd8b6b16,fd461612-520a-455b-b512-ca8ea3338231&itemspercat=20&page=1";
		
		nativeRequestManager = [[NativeRequestManager alloc] initWithReadingURL:urlString];
		[nativeRequestManager loadData:self];
}

-(void)loadAllItemswithDelegate:(NSObject<DataLibraryDelegate> *)delegate
{
	NSString *urlString = @"http://www.melbournecentral.com.au/api/servicecms.svc/GetOffersByCategories?catIds=ce48e178-88fb-4f7f-a0ab-b0d59d3502ea,de391a14-3536-4a71-8fc8-52cf6877a5e9,41e197ff-e362-40fa-b688-bbe18de6c1ae,82a023b7-f0a8-4836-8077-95fdddaea94b,d4f067b6-d22f-4749-91d2-7505a3aa3740,10bae0b9-7058-486c-8e6a-cdd88e5c8a56,08d3be5d-bc5e-4ca6-9241-e024109e2074,57359977-73c4-4c83-910a-dc165beb079d,179f2f7c-9547-4501-a3ba-e9d4cd8b6b16,fd461612-520a-455b-b512-ca8ea3338231&itemspercat=20&page=1";

		
		nativeRequestManager = [[[NativeRequestManager alloc] initWithReadingURL:urlString]autorelease];
		[nativeRequestManager loadData:self];
}


-(NSArray *)getItemsArray
{
	return itemsArray;
}
-(void)dataLoadedWithError:(NativeRequestManager *)dataReader
{
	
	/*UIAlertView * locationAlert = [[UIAlertView alloc] initWithTitle:Localization(APP_TITLE)
															 message:Localization(MESSAGE_CONNECTION_ERROR)
															delegate:nil
												   cancelButtonTitle:Localization(BUTTON_OK)
												   otherButtonTitles:nil];
	[locationAlert show];
	[locationAlert release];*/
}
-(void)dataLoaded:(NativeRequestManager *)dataReader
{
      
	if(dataReader == nativeRequestManager)
	{
        NSDictionary *data = [dataReader getData];
        
        NSLog(@"Data Result: %@",data);
        itemsArray = [NSArray arrayWithArray:[data objectForKey:@"Data"]];
        
		if(self)
		{
			[self.delegate retrieveData];
			//self.delegate = nil;
		}
	}
}
@end
