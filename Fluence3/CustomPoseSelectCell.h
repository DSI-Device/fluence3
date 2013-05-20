//
//  customSelectCell.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomPoseSelectCell : UITableViewCell {
	IBOutlet NSString *tasteID;
	IBOutlet UILabel *tasteName;
	IBOutlet UIImageView *checked;
    NSString *description;
	BOOL isSelected;
}
@property(nonatomic, retain) NSString *tasteID;
@property(nonatomic, retain) UILabel *tasteName;
@property(nonatomic, retain) UIImageView *checked;
@property(nonatomic, assign) NSString *description;
@property(nonatomic, assign) BOOL isSelected;
@end
