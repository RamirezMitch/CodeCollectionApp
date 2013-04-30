//
//  GridViewController.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 29/4/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIGridView.h"
#import "UIGridViewDelegate.h"

@interface GridViewController : UIViewController <UIGridViewDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UIGridView *table;


@end
