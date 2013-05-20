//
//  galleryDateSelect.m
//  Fluence3
//
//  Created by Joseph Armand Baroi on 5/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "galleryDateSelect.h"

@implementation galleryDateSelect
@synthesize arrRecords,delegate;


-(id)initWithFrame:(CGRect)frame withNSArray:(NSArray *)arrValues{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.arrRecords = arrValues;
    }
    return self;
    
}
-(void)showPicker{
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShowNotification:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHideNotification:)
     name:UIKeyboardWillHideNotification object:nil];
    
    
    self.userInteractionEnabled = TRUE;
    self.backgroundColor = [UIColor clearColor];
    
    copyListOfItems = [[NSMutableArray alloc] init];
    pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 200, 320.0, 0.0)];
    pickerView.datePickerMode = UIDatePickerModeDate;
    //[picketView addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    picketToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 156, 320, 44)];
    
    picketToolbar.barStyle = UIBarStyleBlackOpaque;
    [picketToolbar sizeToFit];
    
    txtSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 7, 240, 31)];
    txtSearch.tag = 1;
    txtSearch.barStyle = UIBarStyleBlackTranslucent;
    txtSearch.backgroundColor = [UIColor clearColor];
    txtSearch.delegate = self;
    txtSearch.userInteractionEnabled = TRUE;
    
    for (UIView *subview in txtSearch.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    } 
    
    
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:@selector(btnCancelClick)];
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDoneClick)];
    
    NSArray *arrBarButtoniTems = [[NSArray alloc] initWithObjects:flexible,btnDone, nil];
    [picketToolbar setItems:arrBarButtoniTems];
    [self addSubview:pickerView];
    [self addSubview:picketToolbar];
    
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    searching = NO;
	letUserSelectRow = NO;
    ////    if (pickerView) {
    ////        [pickerView removeFromSuperview];
    ////    }
    //    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    //    pickerView.showsSelectionIndicator = YES;
    //    pickerView.delegate = self;
    //    pickerView.dataSource = self;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
	//Remove all objects first.
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
        
		searching = YES;
		letUserSelectRow = YES;
        
		[self searchTableView];
	}
	else {
		
		searching = NO;
		letUserSelectRow = NO;
        
	}
	
	[pickerView reloadAllComponents];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self btnDoneClick];
}

- (void) searchTableView {
	
	NSString *searchText = txtSearch.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
	
	for (NSString *sTemp in self.arrRecords)
	{
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0){
			[copyListOfItems addObject:sTemp];
        }
	}
    [pickerView reloadAllComponents];
	
	[searchArray release];
	searchArray = nil;
}

-(void)keyboardWillShowNotification:(id)sender{
    
    pickerView.frame = CGRectMake(0, 44, 320, 216);
    picketToolbar.frame = CGRectMake(0, 0, 320, 44);
}

-(void)keyboardWillHideNotification:(id)sender{
    
    pickerView.frame = CGRectMake(0.0, 200, 320, 216);
    picketToolbar.frame = CGRectMake(0, 156, 320, 44);
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


-(void)btnCancelClick{
    
    [self removeFromSuperview];
}

-(void)btnDoneClick{
    NSDate *selectedDate = [pickerView date];
    [self.delegate dateChanged:selectedDate];
    
   
    
    [self removeFromSuperview];
    
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (searching) {
        return copyListOfItems.count;
    }else{
        return self.arrRecords.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (searching) {
        return [copyListOfItems objectAtIndex:row];
    }else{
        return [self.arrRecords objectAtIndex:row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

@end
