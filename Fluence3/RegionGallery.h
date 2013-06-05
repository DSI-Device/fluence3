//
//  UAModalExampleView.h
//  UAModalPanel
//
//  Created by Matt Coneybeare on 1/8/12.
//  Copyright (c) 2012 Urban Apps. All rights reserved.
//
#import "FGalleryViewController.h"
#import "UATitledModalPanel.h"

@interface RegionGallery : UATitledModalPanel <UITableViewDataSource> {
	UIView			*v;
	IBOutlet UIView	*viewLoadedFromXib;
    IBOutlet UITextField *commentTextField;
    FGalleryViewController *fg;
}

@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic, retain) IBOutlet UITextField *commentTextField;
@property (nonatomic, retain) FGalleryViewController *fg;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (IBAction)buttonPressed:(id)sender;


@end
