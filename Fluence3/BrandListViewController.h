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
#import "CustomBrandListCell.h"
#import "viewMoreCell.h"
#import "Fluence3AppDelegate.h"
@protocol BrandControllerDelegate ;
@interface BrandListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MYSBJsonStreamParserAdapterDelegate> {
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
	
	searchDao *dao;
	BOOL *isSearchFromOnline;
	int maxSelectionLimit;
	UIViewController<SelectBoxProtocol> *filterView;
	NSString *followed_s;
    
    Fluence3AppDelegate *appdt;
}
@property (nonatomic, retain) id <BrandControllerDelegate> delegate;
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
@property(nonatomic, assign) Fluence3AppDelegate *appdt;
- (IBAction) selectionDone:(id) sender;
- (IBAction) searchContentChanged: (id) sender;
- (IBAction) hideKeyboard: (id) sender;
- (IBAction) clearAllBtnClicked: (id) sender;

- (NSString *) getSearchBarTitle;

@end
@protocol BrandControllerDelegate <NSObject>

@optional
- (void)BrandItemViewController:(BrandListViewController *)controller didFinishEnteringItem:(NSString *)item;

@end
