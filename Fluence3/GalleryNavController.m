//
//  GalleryNavController.m
//  Fluence3
//
//  Created by Joseph Armand Baroi on 3/27/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GalleryNavController.h"
#import "Fluence3AppDelegate.h"

@implementation GalleryNavController

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
    // Releases the view if it doesn't have a superview.
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
    networkImages = [[NSArray alloc] initWithObjects:@"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", 
                     @"http://farm6.static.flickr.com/5007/5311573633_3cae940638.jpg",nil];
    networkTags = [[NSArray alloc] initWithObjects:@"Lava", @"Hawaii", @"Audi", @"NetTestTag1",@"NetTestTag2",nil];    
    
    NSDictionary *tagCollection = [[NSDictionary alloc] initWithObjectsAndKeys: @"1", @"tagId", @"1", @"imageId", @"Test Tag 1", @"tagCaption", @"http://www.google.com", @"tagShopLink", @"50", @"tagX", @"150", @"tagY", nil];
    NSDictionary *tagCollection1 = [[NSDictionary alloc] initWithObjectsAndKeys: @"2", @"tagId", @"1", @"imageId", @"Test Tag 2", @"tagCaption", @"http://www.google.com", @"tagShopLink", @"100", @"tagX", @"200", @"tagY", nil];
    
    tagArray = [[NSMutableArray alloc] initWithObjects:tagCollection,tagCollection1,nil];    
    
    NSMutableDictionary *localCollection = [[NSMutableDictionary  alloc] initWithObjectsAndKeys: @"1", @"imageId", @"Lava", @"imageCaption", @"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"imageUrl", tagArray, @"tags",@"12", @"imageLike", @"1", @"userId", @"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"userPic", @"Nazmul", @"userName", @"0", @"imageLiked",nil];
    NSMutableDictionary *localCollection1 = [[NSMutableDictionary  alloc] initWithObjectsAndKeys: @"2", @"imageId", @"Hawaii", @"imageCaption", @"http://farm6.static.flickr.com/5007/5311573633_3cae940638.jpg", @"imageUrl", tagArray, @"tags",@"11", @"imageLike", @"1", @"userId", @"http://farm6.static.flickr.com/5007/5311573633_3cae940638.jpg", @"userPic", @"Nahid", @"userName", @"0", @"imageLiked", nil];

    
    imageArray = [[NSMutableArray alloc] initWithObjects:localCollection,localCollection1,nil];
    
    [tagCollection release];
    [tagCollection1 release];
    [localCollection release];
    [localCollection1 release];
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
    return 3;
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
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Next Date"
                          message: @"test"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    [localGallery reloadGallery];
}

-(void)photoGallery:(FGalleryViewController *)gallery likeButtonClicked:(NSString*)imageId:(NSInteger)imgIndex{
    
    
    NSString * str = [[imageArray objectAtIndex:imgIndex] objectForKey:@"imageLike"];
    NSInteger value = [str intValue];
    value = value + 1;
    NSString *imglk = [NSString stringWithFormat:@"%d", value];
    [[imageArray objectAtIndex:imgIndex] setValue:imglk forKey:@"imageLike"];

    NSString *string = [NSString stringWithFormat:@"%d", imgIndex];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: string
                          message: str
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    [localGallery reloadGallery];
}

@end
