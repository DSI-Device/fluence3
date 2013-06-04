//
//  TagBrandController.h
//  Fluence3
//
//  Created by Joseph Armand Baroi on 4/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYJSON.h"
#import "utils.h"
#import "Fluence3AppDelegate.h"
@protocol TagBrandControllerDelegate ;

@interface TagBrandController : UITableViewController<UITableViewDelegate, UITableViewDataSource, MYSBJsonStreamParserAdapterDelegate,TagBrandControllerDelegate>
{
    MYSBJsonStreamParser *parser;
	MYSBJsonStreamParserAdapter *adapter;
	NSMutableArray *dataSource;
    int action_status;
    int totalCount;
	int currentLimit;
    Fluence3AppDelegate *appdt;

}
@property (nonatomic, retain) id <TagBrandControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, assign) int action_status;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, assign) int currentLimit;
@property(nonatomic, assign) Fluence3AppDelegate *appdt;
@end

@protocol TagBrandControllerDelegate <NSObject>

@optional
- (void)addBrandViewController:(TagBrandController *)controller didFinishEnteringBrand:(NSString *)item;

@end
