//
//  customSelectCell.m
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomWeatherListCell.h"

@implementation CustomWeatherListCell

@synthesize weatherID, weatherName;

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
    [weatherID release];
	[weatherName release];
	
    [super dealloc];
}


@end