//
//  customSelectCell.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomFollowListCell : UITableViewCell {
	
	IBOutlet NSString *FollowID;
    IBOutlet UILabel *FollowName;
    IBOutlet UIImageView *FollowImage;
}

@property(nonatomic, retain) NSString *FollowID;
@property(nonatomic, retain) UILabel *FollowName;
@property(nonatomic, retain) UIImageView *FollowImage;
@end
