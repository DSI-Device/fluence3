//
//  galleryDateSelect.h
//  Fluence3
//
//  Created by Joseph Armand Baroi on 5/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol galleryDateSelectDelegate <NSObject>

-(void)selectedRow:(int)row withString:(NSString *)text;

@end

@interface galleryDateSelect : UIView<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UISearchBarDelegate>{
    
    UIDatePicker *pickerView;
    
    UIToolbar *picketToolbar;
    UISearchBar *txtSearch;
    NSArray *arrRecords;
    UIActionSheet *aac;
    
    NSMutableArray *copyListOfItems;
    BOOL searching;
	BOOL letUserSelectRow;
    
    id <galleryDateSelectDelegate> delegate;
    
}


@property (nonatomic, retain) NSArray *arrRecords;
@property (nonatomic, retain) id <galleryDateSelectDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withNSArray:(NSArray *)arrValues;
-(void)showPicker;
- (void)searchTableView;
-(void)btnDoneClick;
@end
