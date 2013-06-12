//
//  customSelectCell.m
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomMessageCell.h"

@implementation CustomMessageCell

@synthesize senderID, senderName, messageBody,messageDate,messageImage,isFollowed,notiImage;

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
    [senderID release];
	[senderName release];
	[messageBody release];
	[messageImage release];
    [notiImage release];
    [super dealloc];
}

-(IBAction)cellButtonClick:(id)sender{
    NSLog(@"Cell Button Clicked...");
}

@end
