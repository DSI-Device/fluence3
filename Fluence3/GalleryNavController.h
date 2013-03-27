//
//  GalleryNavController.h
//  Fluence3
//
//  Created by Joseph Armand Baroi on 3/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGalleryViewController.h"

@interface GalleryNavController : UITableViewController<FGalleryViewControllerDelegate>{
    NSArray *localCaptions;
    NSArray *localImages;
    NSArray *networkCaptions;
    NSArray *networkImages;
	FGalleryViewController *localGallery;
    FGalleryViewController *networkGallery;

}


@end
