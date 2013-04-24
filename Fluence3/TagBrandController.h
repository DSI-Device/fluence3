//
//  TagBrandController.h
//  Fluence3
//
//  Created by Joseph Armand Baroi on 4/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagBrandControllerDelegate ;

@interface TagBrandController : UITableViewController
@property (nonatomic, retain) id <TagBrandControllerDelegate> delegate;
@end

@protocol TagBrandControllerDelegate <NSObject>

@optional
- (void)addBrandViewController:(TagBrandController *)controller didFinishEnteringBrand:(NSString *)item;

@end
