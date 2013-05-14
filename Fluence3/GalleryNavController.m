//
//  GalleryNavController.m
//  Fluence3
//
//  Created by Joseph Armand Baroi on 3/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GalleryNavController.h"
#import "Fluence3AppDelegate.h"
#import "ImageViewController.h"
#import "CameraImageController.h"

@implementation GalleryNavController
@synthesize imgviewCntrllr;
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
	
    //localCaptions = [[NSArray alloc] initWithObjects:@"Lava", @"Hawaii", @"Audi", @"Happy New Year!",@"Frosty Web",nil];
    //localImages = [[NSArray alloc] initWithObjects: @"lava.jpeg", @"hawaii.jpeg", @"audi.jpg",nil];
    //localTags = [[NSArray alloc] initWithObjects:@"TestTag1", @"TestTag2", @"TestTag3", @"Happy New Year!",@"Frosty Web",nil];
    
    networkCaptions = [[NSArray alloc] initWithObjects:@"Happy New Year!",@"Frosty Web",nil];
    networkImages = [[NSArray alloc] initWithObjects:@"http://farm9.staticflickr.com/8111/8660669674_490f367358.jpg", 
                     @"http://farm6.static.flickr.com/5007/5311573633_3cae940638.jpg",nil];
    networkTags = [[NSArray alloc] initWithObjects:@"Lava", @"Hawaii", @"Audi", @"NetTestTag1",@"NetTestTag2",nil];    
    
    NSDictionary *tagCollection = [[NSDictionary alloc] initWithObjectsAndKeys: @"1", @"tagId", @"1", @"imageId", @"Test Tag 1", @"tagCaption", @"http://www.google.com", @"tagShopLink", @"100", @"tagX", @"150", @"tagY", nil];
    NSDictionary *tagCollection1 = [[NSDictionary alloc] initWithObjectsAndKeys: @"2", @"tagId", @"1", @"imageId", @"Test Tag 2", @"tagCaption", @"http://www.google.com", @"tagShopLink", @"100", @"tagX", @"200", @"tagY", nil];
    
    tagArray = [[NSMutableArray alloc] initWithObjects:tagCollection,tagCollection1,nil];    

    
    //tagCollection
    NSDictionary *tagCollection2 = [[NSDictionary alloc] initWithObjectsAndKeys: @"3", @"tagId", @"2", @"imageId", @"LLLLLLLTest Tag 1", @"tagCaption", @"http://www.google.com", @"tagShopLink", @"157", @"tagX", @"267", @"tagY", nil];
    NSDictionary *tagCollection3 = [[NSDictionary alloc] initWithObjectsAndKeys: @"4", @"tagId", @"2", @"imageId", @"KKKKKTest Tag 2", @"tagCaption", @"http://www.google.com", @"tagShopLink", @"115", @"tagX", @"188", @"tagY", nil];
    NSDictionary *tagCollection4 = [[NSDictionary alloc] initWithObjectsAndKeys: @"24", @"tagId", @"22", @"imageId", @"rE Tag 3", @"tagCaption", @"http://www.google.com", @"tagShopLink", @"191", @"tagX", @"191", @"tagY", nil];
    NSMutableDictionary *localCollection = [[NSMutableDictionary  alloc] initWithObjectsAndKeys: @"1", @"imageId", @"Lava", @"imageCaption", @"http://farm9.staticflickr.com/8111/8660669674_490f367358.jpg", @"imageUrl", tagArray, @"tags",@"12", @"imageLike", @"1", @"userId", @"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"userPic", @"Nazmul", @"userName", @"0", @"imageLiked",nil];
    NSMutableDictionary *localCollection1 = [[NSMutableDictionary  alloc] initWithObjectsAndKeys: @"2", @"imageId", @"Hawaii", @"imageCaption", @"http://farm6.static.flickr.com/5007/5311573633_3cae940638.jpg", @"imageUrl", tagArray, @"tags",@"11", @"imageLike", @"2", @"userId", @"http://farm6.static.flickr.com/5007/5311573633_3cae940638.jpg", @"userPic", @"Nahid", @"userName", @"0", @"imageLiked", nil];
    tagArray1 = [[NSMutableArray alloc] initWithObjects:tagCollection2,tagCollection3,tagCollection4,nil];
    
     NSMutableDictionary *localCollection2 = [[NSMutableDictionary  alloc] initWithObjectsAndKeys: @"3", @"imageId", @"Test", @"imageCaption", @"http://103.4.147.139/fluence3/uploads/ipodfile.jpg?121212", @"imageUrl", tagArray1, @"tags",@"11", @"imageLike", @"3", @"userId", @"http://farm6.static.flickr.com/5007/5311573633_3cae940638.jpg", @"userPic", @"Nahid", @"userName", @"0", @"imageLiked", nil];
    
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
    imageArray = [[NSMutableArray alloc] initWithObjects:localCollection,localCollection1,localCollection2,nil];
    
    [tagCollection release];
    [tagCollection1 release];
    [tagCollection2 release];
    [tagCollection3 release];
    [localCollection release];
    [localCollection1 release];
    [localCollection2 release];
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
        return 4;
    }
    else
    {
        return 3;
        
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
		cell.textLabel.text = @"Private Gallery";
	}
    else if( indexPath.row == 1 ) {
		cell.textLabel.text = @"Public Gallery";
	}
	else if( indexPath.row == 2 ) {
		cell.textLabel.text = @"Popular Gallery";//popular gallery
	}
    else if( indexPath.row == 3 ) {
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
		localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        //        [self.navigationController pushViewController:localGallery animated:YES];
        //        [localGallery release];
        
        // THIS IS THE MAGIC PART 2
        UIViewController *topVC = (UIViewController *)self.navigationController.delegate;
        [topVC.navigationController pushViewController:localGallery animated:YES];
//        [localGallery release];
	}
    else if( indexPath.row == 1 ) {
		networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        //        [self.navigationController pushViewController:networkGallery animated:YES];
        
        UIViewController *topVC = (UIViewController *)self.navigationController.delegate;
        [topVC.navigationController pushViewController:networkGallery animated:YES];        
    }
	else if( indexPath.row == 2 ) {
		UIImage *trashIcon = [UIImage imageNamed:@"photo-gallery-trashcan.png"];
		UIImage *captionIcon = [UIImage imageNamed:@"photo-gallery-edit-caption.png"];
		UIBarButtonItem *trashButton = [[[UIBarButtonItem alloc] initWithImage:trashIcon style:UIBarButtonItemStylePlain target:self action:@selector(handleTrashButtonTouch:)] autorelease];
		UIBarButtonItem *editCaptionButton = [[[UIBarButtonItem alloc] initWithImage:captionIcon style:UIBarButtonItemStylePlain target:self action:@selector(handleEditCaptionButtonTouch:)] autorelease];
		NSArray *barItems = [NSArray arrayWithObjects:editCaptionButton, trashButton, nil];
		
		localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self barItems:barItems];
        //        [self.navigationController pushViewController:localGallery animated:YES];
        UIViewController *topVC = (UIViewController *)self.navigationController.delegate;
        [topVC.navigationController pushViewController:localGallery animated:YES];        
    }
    else if( indexPath.row == 3 )
    {
        appdt.notification = @"0";
		imgviewCntrllr = [[[ImageViewController alloc] initWithNibName:nil bundle:nil]autorelease];
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


-(void)photoGallery:(FGalleryViewController *)gallery stylistButtonClicked:(NSInteger*)stylistId:(NSString*)userId:(NSString*)imageId{
    
    NSString * text = [[stylistArray objectAtIndex:stylistId] objectForKey:@"stylistName"];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: [[[@"Current Image ID : " stringByAppendingString:imageId] stringByAppendingString:@" User ID : "] stringByAppendingString: userId]
                          message: text
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)photoGallery:(FGalleryViewController *)gallery commentButtonClicked:(NSString*)imageId:(NSString*)comment{
    
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: [@"Image ID : " stringByAppendingString:imageId]
                          message: comment
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
