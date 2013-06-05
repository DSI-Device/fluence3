//
//  customSelectCell.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomCountryListCell : UITableViewCell {
	
	IBOutlet NSString *countryID;
    IBOutlet UILabel *countryName;
    
}

@property(nonatomic, retain) NSString *countryID;
@property(nonatomic, retain) UILabel *countryName;

@end
