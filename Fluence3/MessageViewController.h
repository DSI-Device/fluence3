//
//  insuranceListViewController.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYJSON.h"
#import "utils.h"
#import "searchDao.h"
#import "SelectBoxProtocol.h"
#import "CustomMessageCell.h"
#import "viewMoreCell.h"
#import "Fluence3AppDelegate.h"
#import "FGalleryViewController.h"
#import "MainViewController.h"
#import "CurrentMessageViewController.h"
@interface MessageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MYSBJsonStreamParserAdapterDelegate> {
	MYSBJsonStreamParser *parser;
	MYSBJsonStreamParserAdapter *adapter;
	NSMutableArray *dataSource;
	NSMutableArray *selectedDataSource;
	NSString *defaultElemId;
	int totalCount;
	int action_status;
	int currentLimit;
	
	IBOutlet UITextField *searchBar;
	IBOutlet UITableView *listTableView;
	IBOutlet UIActivityIndicatorView *spinner;
	IBOutlet UIScrollView *spinnerBg;
	IBOutlet UILabel *countText;
    IBOutlet UITextField *commentTextField;
	
	searchDao *dao;
	BOOL *isSearchFromOnline;
	int maxSelectionLimit;
	UIViewController<SelectBoxProtocol> *filterView;
	NSString *followed_s;
    FGalleryViewController *fgc;
    Fluence3AppDelegate *appdt;
}

@property(nonatomic, retain) UITextField *searchBar;
@property(nonatomic, retain) UITableView *listTableView;
@property(nonatomic, retain) UIActivityIndicatorView *spinner;
@property(nonatomic, retain) UIScrollView *spinnerBg;
@property(nonatomic, retain) UILabel *countText;
@property(nonatomic, retain) NSMutableArray *dataSource;
@property(nonatomic, retain) NSMutableArray *selectedDataSource;
@property(nonatomic, retain) NSString *defaultElemId;
@property(nonatomic, retain) UIViewController<SelectBoxProtocol> *filterView;
@property(nonatomic, assign) BOOL *isSearchFromOnline;
@property(nonatomic, assign) int maxSelectionLimit;
@property(nonatomic, assign) int totalCount;
@property(nonatomic, assign) int currentLimit;
@property(nonatomic, assign) NSString *followed_s;
@property(nonatomic, assign) int action_status;
@property(nonatomic, assign) UITextField *commentTextField;
@property(nonatomic, strong) FGalleryViewController *fgc;
@property (nonatomic, retain) Fluence3AppDelegate *appdt;
- (IBAction) selectionDone:(id) sender;
- (IBAction) searchContentChanged: (id) sender;
- (IBAction) hideKeyboard: (id) sender;
- (IBAction) clearAllBtnClicked: (id) sender;
- (IBAction)commentTextButton:(id)sender;
-(IBAction)userDoneEnteringText:(id)sender;
- (NSString *) getSearchBarTitle;

@end
