//
//  customSelectCell.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface stylistGalleryCommentCell : UITableViewCell {
	
	IBOutlet NSString *commentID;
    IBOutlet UILabel *commentName;
    IBOutlet UILabel *commentDate;
    IBOutlet UILabel *commentBody;
	IBOutlet UIImageView *commentImage;
	BOOL isFollowed;
}

@property(nonatomic, retain) NSString *commentID;
@property(nonatomic, retain) UILabel *commentName;
@property(nonatomic, retain) UILabel *commentDate;
@property(nonatomic, retain) UILabel *commentBody;
@property(nonatomic, retain) UIImageView *commentImage;
@property(nonatomic, assign) BOOL isFollowed;
-(IBAction)cellButtonClick:(id)sender;
@end
