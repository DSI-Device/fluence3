//
//  viewMoreCell.m
//  irefer2
//
//  Created by Mushraful Hoque on 2/16/12.
//  Copyright 2012 Dynamic Solution Innovators Limited. All rights reserved.
//

#import "viewMoreCell.h"


@implementation viewMoreCell

@synthesize showMessage, moreCountMessage;

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
	[moreCountMessage release];
	[showMessage release];
    [super dealloc];
}

@end
