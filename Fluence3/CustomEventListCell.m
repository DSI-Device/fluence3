//
//  customSelectCell.m
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomEventListCell.h"

@implementation CustomEventListCell

@synthesize eventID, eventName, joined,eventImage,isJoined;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    //[super setSelected:selected animated:animated];
	// Configure the view for the selected state
}

- (void)dealloc {
    [eventID release];
	[eventName release];
	[joined release];
	[eventImage release];
    [super dealloc];
}

-(IBAction)cellButtonClick:(id)sender{
    NSLog(@"Cell Button Clicked...");
	if (!self.isJoined) {
        
        self.isJoined = YES;
        [self.joined setTitle:@"Unfollow" forState:UIControlStateNormal];
        
		
    }else {
        
        self.isJoined = NO;
        [self.joined setTitle:@"Follow" forState:UIControlStateNormal];
        
    }
}

@end
