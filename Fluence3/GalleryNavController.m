//
//  GalleryNavController.m
//  Fluence3
//
//  Created by Joseph Armand Baroi on 3/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GalleryNavController.h"
#import "Fluence3AppDelegate.h"
#import "StylistViewController.h"
#import "CameraImageController.h"
#import "BrandGallery.h"
#import "RegionGallery.h"
#import "WeatherGallery.h"
#import "FollowerGallery.h"
#import "RegionGallery.h"
#import "CountryListViewController.h"
#import "BrandListViewController.h"
#import "WeatherListViewController.h"
#import "FollowListViewController.h"
@implementation GalleryNavController
@synthesize imgviewCntrllr,rg;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc {
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.<a href="http://www.flickr.com/photos/karimbokingz/8660669674/" title="Once upon a time by karimbokingz, on Flickr"><img src="http://farm9.staticflickr.com/8111/8660669674_490f367358.jpg" width="500" height="333" alt="Once upon a time"></a>
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView {
	[super loadView];
    appdt = [[UIApplication sharedApplication] delegate];
    
    
    
//   	NSDictionary *jsoning = [[NSDictionary alloc] initWithObjectsAndKeys: appdt.userGalleryId , @"UserId", @"1" , @"gallertType", nil];
//    
//    NSMutableDictionary *dictionnary = [NSMutableDictionary dictionary];
//    [dictionnary setObject:jsoning forKey:@"postData"];
//    
//    NSString *jsonStr = [dictionnary JSONRepresentation];
//
//    NSLog(@"Json send %@", jsonStr);
//    
//    NSString *serverUrl=[ [utils performSelector:@selector(getServerURL)] stringByAppendingFormat:@"index.php/welcome/getGallery/" ];
//    //[self performSelector:@selector(triggerAsyncronousRequest:) withObject: serverUrl];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverUrl]];
//    
//    [request setHTTPMethod:@"POST"];
//    
//    [request setHTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
//
//    NSError *theError = nil;
//    NSURLResponse *theResponse =[[NSURLResponse alloc]init];
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"Json back %@", string);
//    
//    NSMutableArray *imageArray2  = [string JSONValue];
	
    //localCaptions = [[NSArray alloc] initWithObjects:@"Lava", @"Hawaii", @"Audi", @"Happy New Year!",@"Frosty Web",nil];
    //localImages = [[NSArray alloc] initWithObjects: @"lava.jpeg", @"hawaii.jpeg", @"audi.jpg",nil];
    //localTags = [[NSArray alloc] initWithObjects:@"TestTag1", @"TestTag2", @"TestTag3", @"Happy New Year!",@"Frosty Web",nil];
    
    networkCaptions = [[NSArray alloc] initWithObjects:@"Happy New Year!",@"Frosty Web",nil];
    networkImages = [[NSArray alloc] initWithObjects:@"http://farm9.staticflickr.com/8111/8660669674_490f367358.jpg", 
                     @"http://farm6.static.flickr.com/5007/5311573633_3cae940638.jpg",nil];
    networkTags = [[NSArray alloc] initWithObjects:@"Lava", @"Hawaii", @"Audi", @"NetTestTag1",@"NetTestTag2",nil];    
    
    
    
    NSDictionary *stylist1 = [[NSDictionary alloc] initWithObjectsAndKeys: @"0", @"stylistId", @"Nahid", @"stylistName", nil];
    NSDictionary *stylist2 = [[NSDictionary alloc] initWithObjectsAndKeys: @"1", @"stylistId", @"Naim", @"stylistName", nil];
    NSDictionary *stylist3 = [[NSDictionary alloc] initWithObjectsAndKeys: @"2", @"stylistId", @"Shuvo", @"stylistName", nil];
    NSDictionary *stylist4 = [[NSDictionary alloc] initWithObjectsAndKeys: @"3", @"stylistId", @"Rijwan", @"stylistName", nil];
    NSDictionary *stylist5 = [[NSDictionary alloc] initWithObjectsAndKeys: @"4", @"stylistId", @"Mushraful", @"stylistName", nil];
    NSDictionary *stylist6 = [[NSDictionary alloc] initWithObjectsAndKeys: @"5", @"stylistId", @"Tanveer", @"stylistName", nil];
    NSDictionary *stylist7 = [[NSDictionary alloc] initWithObjectsAndKeys: @"6", @"stylistId", @"Rubel", @"stylistName", nil];
    stylistArray = [[NSMutableArray alloc] initWithObjects:stylist1,stylist2,stylist3,stylist4,stylist5,stylist6,stylist7,nil];
    NSMutableDictionary *stdic = [[NSMutableDictionary  alloc] initWithObjectsAndKeys: stylistArray, @"stylists", nil];
    stylists = [[NSMutableArray alloc] initWithObjects:stdic,nil];
//    imageArray = [[NSMutableArray alloc] initWithObjects:localCollection,localCollection1,localCollection2,nil];
    imageArray = [[NSMutableArray alloc] initWithObjects:nil];
//    for (NSDictionary *dict in imageArray2) {
//        [imageArray addObject:dict];
//    }


    [stylist1 release];
    [stylist2 release];
    [stylist3 release];
    [stylist4 release];
    [stylist5 release];
    [stylist6 release];
    [stylist7 release];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(appdt.isStylist)
    {
        return 7;
    }
    else
    {
        return 6;
        
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	if( indexPath.row == 0 ) {
		cell.textLabel.text = @"Featured Gallery";
	}
    else if( indexPath.row == 1 ) {
		cell.textLabel.text = @"Brand Gallery";
	}
	else if( indexPath.row == 2 ) {
		cell.textLabel.text = @"Popular Gallery";//popular gallery
	}
    else if( indexPath.row == 3 ) {
		cell.textLabel.text = @"Region wise Gallery";
	}
	else if( indexPath.row == 4 ) {
		cell.textLabel.text = @"Weather wise Gallery";//popular gallery
	}
    else if( indexPath.row == 5 ) {
		cell.textLabel.text = @"Follower wise Gallery";
	}

    else if( indexPath.row == 6 ) {
        appdt = [[UIApplication sharedApplication] delegate];
        int x = [appdt.notification intValue];
        if(x > 0)
        {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@          (%@)", @"Stylist Gallery", appdt.notification];
        }
        else
        {
            cell.textLabel.text = @"Stylist Gallery";
        }
	}
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if( indexPath.row == 0 ) {
        
        
        
        NSDictionary *jsoning = [[NSDictionary alloc] initWithObjectsAndKeys: appdt.userGalleryId , @"UserId",@"1" , @"gallertType", nil];
        
        NSMutableDictionary *dictionnary = [NSMutableDictionary dictionary];
        [dictionnary setObject:jsoning forKey:@"postData"];
        
        NSString *jsnString = [dictionnary JSONRepresentation];
        
        NSString *serverUrl=[ [utils performSelector:@selector(getServerURL)] stringByAppendingFormat:@"index.php/welcome/getGallery/" ];
        //[self performSelector:@selector(triggerAsyncronousRequest:) withObject: serverUrl];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverUrl]];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:[jsnString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSError *theError = nil;
        NSURLResponse *theResponse =[[NSURLResponse alloc]init];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"Json back %@", string);
        
        NSMutableArray *imageArray2  = [string JSONValue];
        imageArray = [[NSMutableArray alloc] initWithObjects:nil];
        for (NSDictionary *dict in imageArray2) {
            [imageArray addObject:dict];
        }

        
        
        
        
        
		localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        //        [self.navigationController pushViewController:localGallery animated:YES];
        //        [localGallery release];
        
        // THIS IS THE MAGIC PART 2
        UIViewController *topVC = (UIViewController *)self.navigationController.delegate;
        [topVC.navigationController pushViewController:localGallery animated:YES];
//        [localGallery release];
        
                
        
        
        
        
        
	}
    else if( indexPath.row == 1 ) {
//		networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
//        //        [self.navigationController pushViewController:networkGallery animated:YES];
//        
//        UIViewController *topVC = (UIViewController *)self.navigationController.delegate;
//        [topVC.navigationController pushViewController:networkGallery animated:YES];        
        
        
        
        BrandListViewController* nextView = [[BrandListViewController alloc]initWithNibName:@"BrandListViewController" bundle:[NSBundle mainBundle]];
        nextView.delegate = self;
        [self presentViewController:nextView animated:YES completion:nil];
        [nextView release];
        
        
        
        
        
    }
	else if( indexPath.row == 2 ) {
		UIImage *trashIcon = [UIImage imageNamed:@"photo-gallery-trashcan.png"];
		UIImage *captionIcon = [UIImage imageNamed:@"photo-gallery-edit-caption.png"];
		UIBarButtonItem *trashButton = [[[UIBarButtonItem alloc] initWithImage:trashIcon style:UIBarButtonItemStylePlain target:self action:@selector(handleTrashButtonTouch:)] autorelease];
		UIBarButtonItem *editCaptionButton = [[[UIBarButtonItem alloc] initWithImage:captionIcon style:UIBarButtonItemStylePlain target:self action:@selector(handleEditCaptionButtonTouch:)] autorelease];
		NSArray *barItems = [NSArray arrayWithObjects:editCaptionButton, trashButton, nil];
		
        
        
        NSDictionary *jsoning = [[NSDictionary alloc] initWithObjectsAndKeys: appdt.userGalleryId , @"UserId",@"3" , @"gallertType", nil];
        
        NSMutableDictionary *dictionnary = [NSMutableDictionary dictionary];
        [dictionnary setObject:jsoning forKey:@"postData"];
        
        NSString *jsnString = [dictionnary JSONRepresentation];
        
        NSString *serverUrl=[ [utils performSelector:@selector(getServerURL)] stringByAppendingFormat:@"index.php/welcome/getGallery/" ];
        //[self performSelector:@selector(triggerAsyncronousRequest:) withObject: serverUrl];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverUrl]];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:[jsnString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSError *theError = nil;
        NSURLResponse *theResponse =[[NSURLResponse alloc]init];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"Json back %@", string);
        
        NSMutableArray *imageArray2  = [string JSONValue];
        imageArray = [[NSMutableArray alloc] initWithObjects:nil];
        for (NSDictionary *dict in imageArray2) {
            [imageArray addObject:dict];
        }

        
        
        
        
        
		localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self barItems:barItems];
        //        [self.navigationController pushViewController:localGallery animated:YES];
        UIViewController *topVC = (UIViewController *)self.navigationController.delegate;
        [topVC.navigationController pushViewController:localGallery animated:YES];        
        
        

        
        
        
        
    }
    else if( indexPath.row == 3 )
    {
        CountryListViewController* nextView = [[CountryListViewController alloc]initWithNibName:@"CountryListViewController" bundle:[NSBundle mainBundle]];
        nextView.delegate = self;
        [self presentViewController:nextView animated:YES completion:nil];
        [nextView release];
        
        
        /*
        rg = [[[RegionGallery alloc] initWithFrame:self.view.bounds title:@"Region Gallery"] autorelease];
        
        int blocksDelegateOrNone = arc4random() % 3;
        if (0 == blocksDelegateOrNone) {
            rg.onClosePressed = ^(UAModalPanel* panel) {
                [panel hideWithOnComplete:^(BOOL finished) {
                    [panel removeFromSuperview];
                }];
                UADebugLog(@"onClosePressed block called from panel: %@", modalPanel);
            };
            rg.onActionPressed = ^(UAModalPanel* panel) {
                UADebugLog(@"onActionPressed block called from panel: %@", modalPanel);
            };
            
            UADebugLog(@"UAModalView will display using blocks: %@", modalPanel);
            
        } else if (1 == blocksDelegateOrNone) {
            ///////////////////////////////////
            // Add self as the delegate so we know how to close the panel
            rg.delegate = self;
            
            UADebugLog(@"UAModalView will display using delegate methods: %@", modalPanel);
            
        } else {
            // no-op. No delegate or blocks
            UADebugLog(@"UAModalView will display without blocks or delegate methods: %@", modalPanel);
        }
        
        
        ///////////////////////////////////
        // Add the panel to our view
        [self.view addSubview:rg];
        
        ///////////////////////////////////
        // Show the panel from the center of the button that was pressed
        [rg showFromPoint:CGPointMake(150.0, 150.0)];*/
    }
    else if( indexPath.row == 4 )
    {
        
        WeatherListViewController* nextView = [[WeatherListViewController alloc]initWithNibName:@"WeatherListViewController" bundle:[NSBundle mainBundle]];
        nextView.delegate = self;
        [self presentViewController:nextView animated:YES completion:nil];
        [nextView release];
    }
    else if( indexPath.row == 5 )
    {
        FollowListViewController* nextView = [[FollowListViewController alloc]initWithNibName:@"FollowListViewController" bundle:[NSBundle mainBundle]];
        nextView.delegate = self;
        [self presentViewController:nextView animated:YES completion:nil];
        [nextView release];
    }
    else if( indexPath.row == 6 )
    {
        appdt.notification = @"0";
		imgviewCntrllr = [[[StylistViewController alloc] initWithNibName:@"StylistViewController" bundle:nil]autorelease];
        [self.navigationController pushViewController:imgviewCntrllr animated:true];
    }
}

#pragma mark - FGalleryViewControllerDelegate Methods

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    /*if( gallery == localGallery ) {
     num = [localImages count];
     }
     else if( gallery == networkGallery ) {
     num = [networkImages count];
     }*/
    num = [imageArray count];
	return num;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
	if( gallery == localGallery ) {
		return FGalleryPhotoSourceTypeLocal;
	}
	else return FGalleryPhotoSourceTypeNetwork;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption = @"";
    if( gallery == localGallery ) {
        //        caption = [localCaptions objectAtIndex:index];
        caption = [[imageArray objectAtIndex:index]objectForKey:@"imageCaption"];
    }
    else if( gallery == networkGallery ) {
        caption = [networkCaptions objectAtIndex:index];
    }
	return caption;
}
// for tags
- (NSMutableArray*)photoGallery:(FGalleryViewController *)gallery tagsForPhotoAtIndex:(NSUInteger)index
{
    //tagCollection
    NSMutableArray *tag;
    tag = [[imageArray objectAtIndex:index] objectForKey:@"tags"];
    /*if( gallery == localGallery ) {
     tag = [localTags objectAtIndex:index];
     }
     else if( gallery == networkGallery ) {
     tag = [networkTags objectAtIndex:index];
     }*/
    return tag;
}

- (NSMutableArray*)stylistInfos
{
    //tagCollection
    NSMutableArray *stlst;
    stlst = [[stylists objectAtIndex:0] objectForKey:@"stylists"];
    return stlst;
}

- (NSDictionary*)photoGallery:(FGalleryViewController *)gallery tagsForPhotoAtId:(NSUInteger)tagId:(NSUInteger)photoIndex
{
    //tagCollection
    NSString * tId = [NSString stringWithFormat:@"%d",tagId];
    NSMutableArray* tag = [[imageArray objectAtIndex:photoIndex] objectForKey:@"tags"];//[dict objectForKey:aKey] 
    int tagCount = [tag count];
    
    for (int i = 0; i < tagCount; i++) {
        id row = [tag objectAtIndex:i];
        NSString * str = [NSString stringWithFormat:[row objectForKey:@"tagId"]];
        if([str isEqualToString:tId]){
           	return row;
        }
    }
    return nil; 
}

- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    //return [localImages objectAtIndex:index];
    return [[imageArray objectAtIndex:index] objectForKey:@"imageUrl"];
}

- (NSDictionary*)photoGallery:(FGalleryViewController*)gallery infoForPhotoAtIndex:(NSUInteger)index {
    //return [localImages objectAtIndex:index];
    return [imageArray objectAtIndex:index];
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    //return [networkImages objectAtIndex:index];
    return [[imageArray objectAtIndex:index] objectForKey:@"imageUrl"];
}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
}

- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}

-(void)photoGallery:(FGalleryViewController *)gallery handleChangeDate:(NSString*)date{
    NSDictionary *tagCollection = [[NSDictionary alloc] initWithObjectsAndKeys: @"1", @"tagId", @"1", @"imageId", @"Date Tag 1", @"tagCaption", @"http://www.google.com", @"tagShopLink", @"170", @"tagX", @"110", @"tagY", nil];
    NSDictionary *tagCollection1 = [[NSDictionary alloc] initWithObjectsAndKeys: @"2", @"tagId", @"1", @"imageId", @"Date Tag 2", @"tagCaption", @"http://www.google.com", @"tagShopLink", @"170", @"tagX", @"240", @"tagY", nil];
    
    tagArray = [[NSMutableArray alloc] initWithObjects:tagCollection1,nil];
    tagArray1 = [[NSMutableArray alloc] initWithObjects:tagCollection,nil];    
        
    NSDictionary *localCollection = [[NSDictionary  alloc] initWithObjectsAndKeys: @"1", @"imageId", @"Lava", @"imageCaption", @"http://farm6.static.flickr.com/5007/5311573633_3cae940638.jpg", @"imageUrl", tagArray, @"tags",@"1", @"imageLike", @"2", @"userId", @"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"userPic", @"Nazmul", @"userName", @"0", @"imageLiked",nil];
    NSDictionary *localCollection1 = [[NSDictionary  alloc] initWithObjectsAndKeys: @"2", @"imageId", @"Hawaii", @"imageCaption", @"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"imageUrl", tagArray1, @"tags",@"2", @"imageLike", @"1", @"userId", @"http://farm6.static.flickr.com/5007/5311573633_3cae940638.jpg", @"userPic", @"Nahid", @"userName", @"0", @"imageLiked", nil];
    
    [imageArray release];
    imageArray = [[NSMutableArray alloc] initWithObjects:localCollection,localCollection1,nil];
    
    [tagCollection release];
    [tagCollection1 release];
    [tagArray release];
    [tagArray1 release];
    [localCollection release];
    [localCollection1 release];
    [localGallery reloadGallery];
}

-(int)photoGallery:(FGalleryViewController *)gallery likeButtonClicked:(NSString*)imageId:(NSInteger)imgIndex{
    
    NSString * isLiked = [[imageArray objectAtIndex:imgIndex] objectForKey:@"imageLiked"];
    if([isLiked isEqualToString:@"0"]){
        NSString * str = [[imageArray objectAtIndex:imgIndex] objectForKey:@"imageLike"];
        NSInteger value = [str intValue];
        value = value + 1;
        NSString *imglk = [NSString stringWithFormat:@"%d", value];
        [[imageArray objectAtIndex:imgIndex] setValue:imglk forKey:@"imageLike"];
        imglk = @"1";
        [[imageArray objectAtIndex:imgIndex] setValue:imglk forKey:@"imageLiked"];
        
        
        
        NSDictionary *jsoning = [[NSDictionary alloc] initWithObjectsAndKeys: appdt.userGalleryId , @"userId",imageId , @"imageId", nil];
        
        NSMutableDictionary *dictionnary = [NSMutableDictionary dictionary];
        [dictionnary setObject:jsoning forKey:@"postData"];
        
        NSString *jsonStr = [dictionnary JSONRepresentation];
        
        //NSError *error = nil;
        //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionnary                                                       options:kNilOptions                                                         error:&error];
        
        NSLog(@"jsonRequest is %@", jsonStr);
        
        NSURL *nsurl = [ NSURL URLWithString: [[utils performSelector:@selector(getServerURL)] stringByAppendingFormat:@"index.php/welcome/follow/" ]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl
                                        
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        
                                                           timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        return 1;

        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Hello"
                              message: @"You have already liked it once"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return 0;
    }
    
}


-(void)photoGallery:(FGalleryViewController *)gallery stylistButtonClicked:(NSInteger*)stylistId:(NSString*)userId:(NSString*)imageId:(NSString*)query{
    
    NSString * text = [[stylistArray objectAtIndex:stylistId] objectForKey:@"stylistName"];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: [[[@"Current Image ID : " stringByAppendingString:imageId] stringByAppendingString:@" User ID : "] stringByAppendingString: userId]
                          message: [[text stringByAppendingString:@" was asked - "] stringByAppendingString: query]
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)commentButtonClicked:(NSString*)imageId:(NSString*)comment{
    
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: [@"Image ID : " stringByAppendingString:imageId]
                          message: comment
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


//-(void)RegionGallerySelected:(NSString*)jsnString{
//    //OBShapedButton* deleteBtn = (OBShapedButton *)sender;UAModalPanel* panel
//    
//   /* [rg.closeButton sendActionsForControlEvents: UIControlEventTouchUpInside];
//
//      UAModalPanel *rgPanel = (UAModalPanel *)rg;
//     [rgPanel removeFromSuperview];*/
//    
//    NSLog([NSString stringWithFormat:@"%@          (%@)", @"IT IS THE JSON FUNCTION", jsnString]);
//    NSString *serverUrl=[ [utils performSelector:@selector(getServerURL)] stringByAppendingFormat:@"index.php/welcome/getGallery/" ];
//    //[self performSelector:@selector(triggerAsyncronousRequest:) withObject: serverUrl];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverUrl]];
//    
//    [request setHTTPMethod:@"POST"];
//    
//    [request setHTTPBody:[jsnString dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSError *theError = nil;
//    NSURLResponse *theResponse =[[NSURLResponse alloc]init];
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"Json back %@", string);
//    
//    NSMutableArray *imageArray2  = [string JSONValue];
//    imageArray = [[NSMutableArray alloc] initWithObjects:nil];
//    for (NSDictionary *dict in imageArray2) {
//        [imageArray addObject:dict];
//    }
//    localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
//    //        [self.navigationController pushViewController:localGallery animated:YES];
//    //        [localGallery release];
//    
//    // THIS IS THE MAGIC PART 2
//    UIViewController *topVC = (UIViewController *)self.navigationController.delegate;
//    [topVC.navigationController pushViewController:localGallery animated:YES];
//}

- (void)addItemViewController:(CountryListViewController *)controller didFinishEnteringItem:(NSString *)jsnString
{
    NSLog([NSString stringWithFormat:@"%@          (%@)", @"IT IS THE JSON FUNCTION", jsnString]);
    NSString *serverUrl=[ [utils performSelector:@selector(getServerURL)] stringByAppendingFormat:@"index.php/welcome/getGallery/" ];
    //[self performSelector:@selector(triggerAsyncronousRequest:) withObject: serverUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverUrl]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[jsnString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *theError = nil;
    NSURLResponse *theResponse =[[NSURLResponse alloc]init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Json back %@", string);
    
    NSMutableArray *imageArray2  = [string JSONValue];
    imageArray = [[NSMutableArray alloc] initWithObjects:nil];
    for (NSDictionary *dict in imageArray2) {
        [imageArray addObject:dict];
    }
    localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    //        [self.navigationController pushViewController:localGallery animated:YES];
    //        [localGallery release];
    
    // THIS IS THE MAGIC PART 2
    UIViewController *topVC = (UIViewController *)self.navigationController.delegate;
    [topVC.navigationController pushViewController:localGallery animated:YES];}


- (void)BrandItemViewController:(BrandListViewController *)controller didFinishEnteringItem:(NSString *)jsnString
{
    NSLog([NSString stringWithFormat:@"%@          (%@)", @"IT IS THE JSON FUNCTION", jsnString]);
    NSString *serverUrl=[ [utils performSelector:@selector(getServerURL)] stringByAppendingFormat:@"index.php/welcome/getGallery/" ];
    //[self performSelector:@selector(triggerAsyncronousRequest:) withObject: serverUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverUrl]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[jsnString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *theError = nil;
    NSURLResponse *theResponse =[[NSURLResponse alloc]init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Json back %@", string);
    
    NSMutableArray *imageArray2  = [string JSONValue];
    imageArray = [[NSMutableArray alloc] initWithObjects:nil];
    for (NSDictionary *dict in imageArray2) {
        [imageArray addObject:dict];
    }
    localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    //        [self.navigationController pushViewController:localGallery animated:YES];
    //        [localGallery release];
    
    // THIS IS THE MAGIC PART 2
    UIViewController *topVC = (UIViewController *)self.navigationController.delegate;
    [topVC.navigationController pushViewController:localGallery animated:YES];}

- (void)WeatherItemViewController:(WeatherListViewController *)controller didFinishEnteringItem:(NSString *)jsnString
{
    NSLog([NSString stringWithFormat:@"%@          (%@)", @"IT IS THE JSON FUNCTION", jsnString]);
    NSString *serverUrl=[ [utils performSelector:@selector(getServerURL)] stringByAppendingFormat:@"index.php/welcome/getGallery/" ];
    //[self performSelector:@selector(triggerAsyncronousRequest:) withObject: serverUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverUrl]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[jsnString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *theError = nil;
    NSURLResponse *theResponse =[[NSURLResponse alloc]init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Json back %@", string);
    
    NSMutableArray *imageArray2  = [string JSONValue];
    imageArray = [[NSMutableArray alloc] initWithObjects:nil];
    for (NSDictionary *dict in imageArray2) {
        [imageArray addObject:dict];
    }
    localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    //        [self.navigationController pushViewController:localGallery animated:YES];
    //        [localGallery release];
    
    // THIS IS THE MAGIC PART 2
    UIViewController *topVC = (UIViewController *)self.navigationController.delegate;
    [topVC.navigationController pushViewController:localGallery animated:YES];}

- (void)FollowItemViewController:(FollowListViewController *)controller didFinishEnteringItem:(NSString *)jsnString
{
    NSLog([NSString stringWithFormat:@"%@          (%@)", @"IT IS THE JSON FUNCTION", jsnString]);
    NSString *serverUrl=[ [utils performSelector:@selector(getServerURL)] stringByAppendingFormat:@"index.php/welcome/getGallery/" ];
    //[self performSelector:@selector(triggerAsyncronousRequest:) withObject: serverUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverUrl]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[jsnString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *theError = nil;
    NSURLResponse *theResponse =[[NSURLResponse alloc]init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Json back %@", string);
    
    NSMutableArray *imageArray2  = [string JSONValue];
    imageArray = [[NSMutableArray alloc] initWithObjects:nil];
    for (NSDictionary *dict in imageArray2) {
        [imageArray addObject:dict];
    }
    localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    //        [self.navigationController pushViewController:localGallery animated:YES];
    //        [localGallery release];
    
    // THIS IS THE MAGIC PART 2
    UIViewController *topVC = (UIViewController *)self.navigationController.delegate;
    [topVC.navigationController pushViewController:localGallery animated:YES];}

@end



