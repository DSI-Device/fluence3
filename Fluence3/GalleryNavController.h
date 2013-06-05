//
//  GalleryNavController.h
//  Fluence3
//
//  Created by Joseph Armand Baroi on 3/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGalleryViewController.h"
#import "Fluence3AppDelegate.h"
#import "StylistViewController.h"

@class Fluence3AppDelegate;

@interface GalleryNavController : UITableViewController<FGalleryViewControllerDelegate>{
    Fluence3AppDelegate *appdt;
    NSArray *localCaptions;
    NSArray *localImages;
    NSArray *localTags;
    NSArray *networkCaptions;
    NSArray *networkImages;
    NSArray *networkTags;
    
    NSMutableArray *tagArray;
    NSMutableArray *tagArray1;
    NSMutableArray *stylistArray;
    NSMutableArray *stylists;
    NSMutableArray *imageArray;
//    ImageViewController *imgviewCntrllr;
     StylistViewController *imgviewCntrllr;
    
    FGalleryViewController *localGallery;
    FGalleryViewController *networkGallery;
    
}
@property (strong, nonatomic) StylistViewController *imgviewCntrllr;


-(void)RegionGallerySelected:(NSString*)jsnString;
@end
