//
//  utils.m
//  irefer2
//
//  Created by Mushraful Hoque on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "utils.h"


@implementation utils

+ (BOOL) validateEmail: (NSString *) email{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:email];
}

+ (NSString *) getServerURL {
	//return @"http://www.irefermd.com/admin-v1/index.php?r=";
	return @"http://103.4.147.139/fluence3/";
}

+ (UIColor *) getTableCellSelectionColor{
	return [UIColor colorWithRed:255.0 green:158.0 blue:57.0 alpha:1.0];
}

+ (void) showAlert:(NSString *)title message:(NSString *)msg delegate:(UIViewController *)controller{

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:controller cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
	return;
}

+ (void) dialANumber: (NSString *)number view:(UIViewController *)view{
	number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
	number = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
	number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];
	number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
	NSLog(@"custom number: %@",number);
	NSString *phoneStr = [NSString stringWithFormat:@"tel://%@", number];
	NSURL *phnURL = [[[NSURL alloc] initWithString:phoneStr] autorelease];
	
	UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame]; 
	[webview loadRequest:[NSURLRequest requestWithURL:phnURL]]; 
	webview.hidden = YES; 
	// Assume we are in a view controller and have access to self.view 
	[view addSubview:webview]; 
	[webview release]; 
	/*
	number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
	number = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
	number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];
	number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
	NSLog(@"custom number: %@",number);
	NSString *phoneStr = [NSString stringWithFormat:@"tel://%@", number];
	NSURL *phnURL = [[[NSURL alloc] initWithString:phoneStr] autorelease];
	[[UIApplication sharedApplication] openURL:phnURL];*/
}

+ (BOOL) isRowExistsOnList:(NSMutableArray *)list row:(NSDictionary *)dataSet{

	for(NSDictionary *dict in list){
	
		if([[dict objectForKey:@"id"] isEqual:[dataSet objectForKey:@"id"]] && [[dict objectForKey:@"name"] isEqual:[dataSet objectForKey:@"name"]])
			return YES;
	}
	return NO;
}

+ (BOOL) deleteRowFromList:(NSMutableArray *)list row:(NSDictionary *)dataSet{
	for(NSDictionary *dict in list){
		
		if([[dict objectForKey:@"id"] isEqual:[dataSet objectForKey:@"id"]] && [[dict objectForKey:@"name"] isEqual:[dataSet objectForKey:@"name"]]){
			[list removeObject:dict];
			return YES;
		}
	}
	return NO;	
}
+ (BOOL) deletePoseFromList:(NSMutableArray *)list row:(NSDictionary *)dataSet{
	for(NSDictionary *dict in list){
		
		if([[dict objectForKey:@"tasteID"] isEqual:[dataSet objectForKey:@"tasteID"]] && [[dict objectForKey:@"tasteName"] isEqual:[dataSet objectForKey:@"tasteName"]]){
			[list removeObject:dict];
			return YES;
		}
	}
	return NO;
}
+ (NSString *) getIdsFromList: (NSMutableArray *)list{
	NSString *ids = @"";
	for(NSDictionary *dict in list){
		ids = [ids stringByAppendingFormat:@"%@,",[dict objectForKey:@"id"]];
	}
	if( [ids length] > 0 ){
		ids = [ids substringToIndex:([ids length]-1)];
	}
	return ids;
}

+ (void)generateRatingBar:(UIView *)ratingView value:(NSString *)rankValue{
	
	int rank = 0;
	if( rankValue != [NSNull null] && ![rankValue isEqual:@"<null>"]){
		//NSLog(@"rank Value : %@",rankValue);
		rank = [rankValue intValue];
	}
	
	UIImage* star0 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Silver_star" ofType:@"png"]];
	UIImage* star1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"orange_star" ofType:@"png"]];
	
	for (int i = 0; i < 5; i++) {
		
		int xPos = (15 * i)+(i+1);
		int yPos = 0;
		
		if (i < rank) [self someDrawImageMethod:xPos :yPos :star1 :ratingView];
		else [self someDrawImageMethod:xPos :yPos :star0 :ratingView];
	}
}


+ (void)someDrawImageMethod:(int)xPos :(int)yPos :(UIImage *)image :(UIView *)ratingView {
	
	CGRect frame = CGRectMake(xPos, yPos, 12.0f, 12.0f);
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
	imageView.image = image;
	
	[ratingView addSubview:imageView];
}

+ (void)generateLargeRatingBar:(UIView *)ratingView value:(NSString *)rankValue{
	
	int rank = 0;
	if( rankValue != [NSNull null] && ![rankValue isEqual:@"<null>"]){
		//NSLog(@"rank Value : %@",rankValue);
		rank = [rankValue intValue];
	}
	
	UIImage* star0 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Silver_star" ofType:@"png"]];
	UIImage* star1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"orange_star" ofType:@"png"]];
	
	for (int i = 0; i < 5; i++) {
		
		int xPos = (18 * i)+(i+1);
		int yPos = 0;
		
		if (i < rank) [self someDrawLargeImageMethod:xPos :yPos :star1 :ratingView];
		else [self someDrawLargeImageMethod:xPos :yPos :star0 :ratingView];
	}
}


+ (void)someDrawLargeImageMethod:(int)xPos :(int)yPos :(UIImage *)image :(UIView *)ratingView {
	
	CGRect frame = CGRectMake(xPos, yPos, 16.0f, 16.0f);
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
	imageView.image = image;
	
	[ratingView addSubview:imageView];
}


+ (void)generateCostBar:(UIView *)ratingView value:(NSString *)rankValue{
	
	int rank = 0;
	if( rankValue != [NSNull null] && ![rankValue isEqual:@"<null>"]){
		//NSLog(@"rank Value : %@",rankValue);
		rank = [rankValue intValue];
	}
	
//	UIImage* star0 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dollar_silver" ofType:@"png"]];
//	UIImage* star1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dollar_orange" ofType:@"png"]];
	
	for (int i = 0; i < 5; i++) {
		
		int xPos = (15 * i)+(i+1);
		int yPos = 0;
		
		if (i < rank) [self drawDollarImageMethod:xPos :yPos :[UIColor orangeColor] :ratingView];
		else [self drawDollarImageMethod:xPos :yPos :[UIColor whiteColor] :ratingView];
	}
}


+ (void)drawDollarImageMethod:(int)xPos :(int)yPos :(UIColor *)color :(UIView *)ratingView {
	UILabel *lagLabel = [[[UILabel alloc] init] autorelease];
	lagLabel.text = @"$";
	lagLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
	lagLabel.textColor = color;
	lagLabel.backgroundColor = [UIColor clearColor];
	lagLabel.textAlignment = UITextAlignmentCenter;
	lagLabel.frame = CGRectMake(xPos, yPos, 12.0f, 13.0f);
	
	[ratingView addSubview:lagLabel];
}

+ (void)generateQualityBar:(UIView *)ratingView value:(NSString *)rankValue{
	
	int rank = 0;
	if( rankValue != [NSNull null] && ![rankValue isEqual:@"<null>"]){
		//NSLog(@"rank Value : %@",rankValue);
		rank = [rankValue intValue];
	}
	
	for (int i = 0; i < 5; i++) {
		
		int xPos = (15 * i)+(i+1);
		int yPos = 0;
		
		if (i < rank) [self drawQualityImageMethod:xPos :yPos :[UIColor orangeColor] :ratingView];
		else [self drawQualityImageMethod:xPos :yPos :[UIColor whiteColor] :ratingView];
	}
}


+ (void)drawQualityImageMethod:(int)xPos :(int)yPos :(UIColor *)color :(UIView *)ratingView {
	UILabel *lagLabel = [[[UILabel alloc] init] autorelease];
	lagLabel.text = @"*";
	lagLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:27];
	lagLabel.textColor = color;
	lagLabel.backgroundColor = [UIColor clearColor];
	lagLabel.textAlignment = UITextAlignmentCenter;
	lagLabel.frame = CGRectMake(xPos, yPos, 12.0f, 23.0f);
	
	[ratingView addSubview:lagLabel];
}

+ (void)generatePatientExpBar:(UIView *)ratingView value:(NSString *)rankValue{
	
	int rank = 0;
	if( rankValue != [NSNull null] && ![rankValue isEqual:@"<null>"]){
		//NSLog(@"rank Value : %@",rankValue);
		rank = [rankValue intValue];
	}
	
	for (int i = 0; i < 5; i++) {
		
		int xPos = (15 * i)+(i+1);
		int yPos = 0;
		
		if (i < rank) [self drawPexpImageMethod:xPos :yPos :[UIColor orangeColor] :ratingView];
		else [self drawPexpImageMethod:xPos :yPos :[UIColor whiteColor] :ratingView];
	}
}

+ (void)drawPexpImageMethod:(int)xPos :(int)yPos :(UIColor *)color :(UIView *)ratingView {
	UILabel *lagLabel = [[[UILabel alloc] init] autorelease];
	lagLabel.text = @"*";
	lagLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
	lagLabel.textColor = color;
	lagLabel.backgroundColor = [UIColor clearColor];
	lagLabel.textAlignment = UITextAlignmentCenter;
	lagLabel.frame = CGRectMake(xPos, yPos, 12.0f, 23.0f);
	
	[ratingView addSubview:lagLabel];
}


+ (NSMutableArray *) getLanguageList: (NSString *)searchCode{

	NSMutableArray *languages = [self getLanguages];
	
	if (searchCode == nil || [searchCode isEqual:@""]) {
		return languages;
	}else {
		NSPredicate *predicate = [NSPredicate predicateWithFormat: @"name contains[c] %@",searchCode ];
		[languages filterUsingPredicate:predicate];
		return languages;
	}

}

+ (NSMutableArray *) getLanguages {
	
	NSMutableArray *langs =  [[[NSMutableArray alloc] initWithCapacity:20] autorelease];
	
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"1", @"id",@"English", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"2", @"id",@"French", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"3", @"id",@"Spanish", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"4", @"id",@"German", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"5", @"id",@"Italian", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"6", @"id",@"Chinese", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"7", @"id",@"Russian", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"8", @"id",@"Hindi", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"9", @"id",@"Hebrew", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"10", @"id",@"Dutch", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"11", @"id",@"Arabic", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"12", @"id",@"Thai", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"13", @"id",@"Urdu", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"14", @"id",@"Tamil", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"15", @"id",@"Bengali", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"16", @"id",@"Polish", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"17", @"id",@"Korean", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"18", @"id",@"Romanian", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"19", @"id",@"Farsi", @"name", nil]];
	[langs addObject:[[NSDictionary alloc] initWithObjectsAndKeys: @"20", @"id",@"Turkish", @"name", nil]];
	
	return langs;
	
}

+ (NSMutableArray *) getDataFromSyncronousURLCall: (NSString *)url{
	
	MYSBJsonParser *parser = [[MYSBJsonParser alloc] init];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *newData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSString *responseString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
	
	NSMutableArray *dataList = [parser objectWithString:responseString error:NULL];
	[parser release];
	[responseString release];
	
	return dataList;
}

+ (NSString *) getStringFromSyncronousURLCall: (NSString *)url{
	
	url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];	

	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *newData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSString *responseString = [[[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding] autorelease];
	
	return responseString;
}

+ (void)roundUpView:(UIView *)view{
	view.layer.cornerRadius = 10;
}

+ (NSString *)getFormatedStringFromDate:(NSDate *)origDate{
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy HH:mm"];
	
	NSString *dateString = [formatter stringFromDate:origDate];
	[formatter release];
	return dateString;
}

+ (NSDate *)getDateFromFormatedString:(NSString *)origDateString{

	if (origDateString == nil || origDateString == [NSNull null] || [origDateString isEqual:@"<null>"] || [origDateString isEqual:@""] ) {
		return nil;
	}
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm"];
	NSDate *dateFromString = [[[NSDate alloc] init] autorelease];
	dateFromString = [dateFormatter dateFromString:origDateString];
	[dateFormatter release];
	
	return dateFromString;
}

+ (NSDate *)getDateFromFormatedString:(NSString *)origDateString format:(NSString *)format{

	if (origDateString == nil || origDateString == [NSNull null] || [origDateString isEqual:@"<null>"] || [origDateString isEqual:@""] ) {
		return nil;
	}
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:format];
	NSDate *dateFromString = [[[NSDate alloc] init] autorelease];
	dateFromString = [dateFormatter dateFromString:origDateString];
	[dateFormatter release];
	
	return dateFromString;
	
}


+(BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
			
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
			
			
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
				
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
			
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
	
    return NO;
}

+ (NSArray *)getReportOptionIndexes{
	return [[[NSArray alloc] initWithObjects:@"2",@"6",@"10",@"14",nil] autorelease];
}

+ (NSString *)getReportOptionContent:(int)index{
	if (index == 2) {
		return @"Provider not in plan.";
	}else if (index == 6) {
		return @"Address or phone number incorrect.";
	}else if (index == 10) {
		return @"Incorrect speciality.";
	}else if (index == 14) {
		return @"Hospital list incorrect.";
	}else {
		return @"";
	}
	
}

+ (int) getRandomNumber:(int)lowerBound :(int)upperBound{

	return rand() % (upperBound - lowerBound +1) + lowerBound;
}

@end
