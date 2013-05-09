//
//  customSelectCell.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomGalleryCommentCell : UITableViewCell {
	
	IBOutlet NSString *userID;
    IBOutlet UILabel *userName;
    IBOutlet UIButton *followed;
	IBOutlet UIImageView *userImage;
	BOOL isFollowed;
}

@property(nonatomic, retain) NSString *userID;
@property(nonatomic, retain) UILabel *userName;
@property(nonatomic, retain) UIButton *followed;
@property(nonatomic, retain) UIImageView *userImage;
@property(nonatomic, assign) BOOL isFollowed;
-(IBAction)cellButtonClick:(id)sender;
@end
