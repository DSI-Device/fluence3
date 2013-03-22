//
//  utils.h
//  irefer2
//
//  Created by Mushraful Hoque on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYJSON.h"
#import <QuartzCore/QuartzCore.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <stdlib.h>

@interface utils : NSObject {

}

+ (BOOL) validateEmail: (NSString *) email;

+ (NSString *) getServerURL ;

+ (UIColor *) getTableCellSelectionColor;

+ (void) showAlert:(NSString *)title message:(NSString *)msg delegate:(UIViewController *)controller;

+ (void) dialANumber: (NSString *)number view:(UIViewController *)view;

+ (BOOL) isRowExistsOnList:(NSMutableArray *)list row:(NSDictionary *)dataSet;

+ (BOOL) deleteRowFromList:(NSMutableArray *)list row:(NSDictionary *)dataSet;

+ (NSString *) getIdsFromList: (NSMutableArray *)list;

+ (void)generateRatingBar:(UIView *)ratingView value:(NSString *)rankValue;

+ (void)generateLargeRatingBar:(UIView *)ratingView value:(NSString *)rankValue;

+ (void)generateCostBar:(UIView *)ratingView value:(NSString *)rankValue;

+ (void)generateQualityBar:(UIView *)ratingView value:(NSString *)rankValue;

+ (void)generatePatientExpBar:(UIView *)ratingView value:(NSString *)rankValue;

+ (NSMutableArray *) getLanguageList: (NSString *)searchCode;

+ (NSMutableArray *) getDataFromSyncronousURLCall: (NSString *)url;

+ (NSString *) getStringFromSyncronousURLCall: (NSString *)url;

+ (void)roundUpView:(UIView *)view;

+ (NSString *)getFormatedStringFromDate:(NSDate *)origDate;

+ (NSDate *)getDateFromFormatedString:(NSString *)origDateString;

+ (NSDate *)getDateFromFormatedString:(NSString *)origDateString format:(NSString *)format;

+(BOOL)hasConnectivity;

+ (NSArray *)getReportOptionIndexes;

+ (NSString *)getReportOptionContent:(int)index;

+ (int) getRandomNumber:(int)lowerBound :(int)upperBound;

@end
