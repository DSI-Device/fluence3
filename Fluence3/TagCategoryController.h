//
//  TagCategoryController.h
//  Fluence3
//
//  Created by Joseph Armand Baroi on 4/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagBrandController.h"

@protocol TagCategoryControllerDelegate ;

@interface TagCategoryController : UITableViewController <TagBrandControllerDelegate>
{
    NSString *category, *brand;
}


@property (nonatomic, retain) id <TagCategoryControllerDelegate> delegate;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *brand;

@end


@protocol TagCategoryControllerDelegate <NSObject>

@optional
- (void)addItemViewController:(TagCategoryController *)controller didFinishEnteringItem:(NSString *)item:(NSString *)item2;

@end
