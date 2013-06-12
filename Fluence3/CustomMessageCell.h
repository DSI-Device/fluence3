//
//  customSelectCell.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomMessageCell : UITableViewCell {
	
	IBOutlet NSString *senderID;
    IBOutlet UILabel *senderName;
    IBOutlet UILabel *messageDate;
    IBOutlet UILabel *messageBody;
	IBOutlet UIImageView *messageImage;
    IBOutlet UIImageView *notiImage;
	BOOL isFollowed;
}

@property(nonatomic, retain) NSString *senderID;
@property(nonatomic, retain) UILabel *senderName;
@property(nonatomic, retain) UILabel *messageDate;
@property(nonatomic, retain) UILabel *messageBody;
@property(nonatomic, retain) UIImageView *messageImage;
@property(nonatomic, retain) UIImageView *notiImage;
@property(nonatomic, assign) BOOL isFollowed;
-(IBAction)cellButtonClick:(id)sender;
@end
