//
//  customSelectCell.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomCategoryListCell : UITableViewCell {
	
	IBOutlet NSString *CategoryID;
    IBOutlet UILabel *CategoryName;
    
}

@property(nonatomic, retain) NSString *CategoryID;
@property(nonatomic, retain) UILabel *CategoryName;

@end
