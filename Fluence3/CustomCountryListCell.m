//
//  customSelectCell.m
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomCountryListCell.h"

@implementation CustomCountryListCell

@synthesize countryID, countryName;

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
    [countryID release];
	[countryName release];
	
    [super dealloc];
}


@end
