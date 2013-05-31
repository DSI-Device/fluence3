//
//  customSelectCell.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomBrandListCell : UITableViewCell {
	
	IBOutlet NSString *brandID;
    IBOutlet UILabel *brandName;
    
}

@property(nonatomic, retain) NSString *brandID;
@property(nonatomic, retain) UILabel *brandName;

@end
