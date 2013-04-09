//
//  customSelectCell.m
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomPeopleListCell.h"

@implementation CustomPeopleListCell

@synthesize userID, userName, followed,userImage,isFollowed;

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
    [userID release];
	[userName release];
	[followed release];
	[userImage release];
    [super dealloc];
}

-(IBAction)cellButtonClick:(id)sender{
    NSLog(@"Cell Button Clicked...");
	if (!self.isFollowed) {
        
        self.isFollowed = YES;
        [self.followed setTitle:@"Unfollow" forState:UIControlStateNormal];
        
		
    }else {
        
        self.isFollowed = NO;
        [self.followed setTitle:@"Follow" forState:UIControlStateNormal];
        
    }
}

@end
