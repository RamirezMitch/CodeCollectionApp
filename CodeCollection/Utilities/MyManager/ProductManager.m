//
//  ProductManager.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 5/4/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "ProductManager.h"
#import "Product.h"
#import "MyUtil.h"
@implementation ProductManager
@synthesize delegate;
@synthesize listContent, listSection;
-(id)initWithDelegate:(id)del :(BOOL)grouped {
    self = [super init];
    if (self) {
        self.delegate = del;
        groupAll=grouped;
    }
    return self;
}
-(void)dealloc{
    [listSection release];
    [listContent release];
    [super dealloc];
}
-(void)loadXLS
{   //[self showActivityIndicator];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    NSString *f = [[NSBundle mainBundle] pathForResource:@"BundleProducts" ofType:@"xls"];
    NSURL *url=[NSURL fileURLWithPath:f];
    
    NSURLRequest *requestObj=[NSURLRequest requestWithURL:url];
    [web loadRequest:requestObj];
    
    web.delegate = self;
}

-(NSString*)getXLSField:(int)row:(int)col
{
    if (row + 1 == [arrRowBundle count])
    {
        return @"";
    }
    
    NSArray *arrCol = [[arrRowBundle objectAtIndex:row + 1] componentsSeparatedByString:@"<td"];
    
    NSString *result = [[[arrCol objectAtIndex:col + 1] componentsSeparatedByString:@">"] objectAtIndex:1];
    
    result = [[result componentsSeparatedByString:@"<"] objectAtIndex:0];
    result = [result stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return result;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    listBundlePrd = [[NSMutableArray alloc] init];
    
    xlsContent = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    arrRowBundle = [xlsContent componentsSeparatedByString:@"<tr"];
    
    //[NSThread detachNewThreadSelector:@selector(prepareBundleXLS) toTarget:self withObject:nil];
    
    int row = 1;
    NSString *prdCode = [self getXLSField:row :0];
    
    NSMutableArray *listPrdTmp;
    NSMutableArray *theProducts = [[NSMutableArray alloc] init];
    while (![prdCode isEqualToString:@""])
    {
        NSString *brand = [self getXLSField:row :1];
        NSString *desc = [self getXLSField:row :2];
        NSInteger prdCatCode = [self getXLSField:row :2];
        NSString *prdCat = [self getXLSField:row :4];
        NSString *thumbURL = [self getXLSField:row :5];
        
        
        listPrdTmp = [[NSMutableArray alloc] init];
        
        [listPrdTmp addObject:prdCode];
        [listPrdTmp addObject:brand];
        [listPrdTmp addObject:desc];
        [listPrdTmp addObject:thumbURL];
        [listPrdTmp addObject:prdCat];
        
        [listBundlePrd addObject:listPrdTmp];
        
        row = row + 1;
        prdCode = [self getXLSField:row :0];
        
        //Product *p = [Product alloc] initWithDictionary:arrRowBundle obje
        Product *p = [[Product alloc] init];
        p.product_code = prdCode;
        p.product_title = brand;
        p.desc = desc;
        p.segmentDesc = prdCat;
        p.segmentCode = [MyUtil safeNumber:prdCatCode];
        p.imageUrlSmall = thumbURL;
        NSLog(@"title: %@", p.product_title);
        NSString *c = [p.segmentDesc substringToIndex:1];
        p.characterGroup=[c uppercaseString];
        [theProducts addObject:p];
        [p release];
        
    }
    NSArray *sortedArray;
    NSSortDescriptor *lastDescriptor =[[NSSortDescriptor alloc] initWithKey:@"characterGroup"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor, nil];
    sortedArray = [theProducts sortedArrayUsingDescriptors:descriptors];
    self.listContent = [NSArray arrayWithArray:sortedArray];
    [theProducts release];
    
   /* log only
    for (Product *prd in self.listContent)
    {
        NSLog(@"sorted: %@", prd.segmentDesc);
    }
    */
    self.listSection = [[NSMutableDictionary alloc] init];
    
    BOOL found;
    
    // Loop through the books and create our keys
    for (Product *prd in self.listContent)
    {
        NSString *c = [prd.product_title substringToIndex:1];
        
        found = NO;
        
        for (NSString *str in [self.listSection allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.listSection setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    
    // Loop again and sort the books into their respective keys
    for (Product *prd in self.listContent)
    {
        [[self.listSection objectForKey:[prd.product_title substringToIndex:1]] addObject:prd];
    }
    
    // Sort each section array
    for (NSString *key in [self.listSection allKeys])
    {
        [[self.listSection objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"product_title" ascending:YES]]];
    }

    if(groupAll){
        [self.delegate dProductManager:self shouldShowAllSections:self.listSection];
    }else{
        [self.delegate dProductManager:self shouldShowAllItems:self.listContent];
    }
}

@end
