//  ImageViewController.m
//
//  Copyright (c) 2012 modocache
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import "ImageViewController.h"
#import "MDCParallaxView.h"


@interface ImageViewController () <UIScrollViewDelegate>

@end


@implementation ImageViewController


#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    UIImage *backgroundImage = [UIImage imageNamed:@"background.png"];
    CGRect backgroundRect = CGRectMake(0, 0, self.view.frame.size.width, backgroundImage.size.height);
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:backgroundRect];
    backgroundImageView.image = backgroundImage;
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [backgroundImageView addGestureRecognizer:tapGesture];

    
    
    
    
    
    
    
    
    
    UIViewController *commentViewController = [UIViewController alloc];
    commentViewController.view.frame = CGRectMake(0,0,300, 400);   UITextField* _commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, 300, 30)];
    _commentTextField.borderStyle = UITextBorderStyleRoundedRect;
    _commentTextField.font = [UIFont systemFontOfSize:15];
    _commentTextField.placeholder = @"enter text";
    _commentTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _commentTextField.keyboardType = UIKeyboardTypeDefault;
    _commentTextField.returnKeyType = UIReturnKeyDone;
    _commentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _commentTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _commentTextField.delegate = self;
    [commentViewController.view addSubview:_commentTextField];
    [_commentTextField release];
    
    
    
    
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [topButton addTarget:self action:@selector(commentDone:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    topButton.frame = CGRectMake(10, 80, 100, 30);
    [topButton setTitle:@"Comment" forState:UIControlStateNormal];
    
    [commentViewController.view addSubview:topButton];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    MDCParallaxView *parallaxView = [[MDCParallaxView alloc] initWithBackgroundView:backgroundImageView
                                                                     foregroundView:commentViewController.view];
    parallaxView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    parallaxView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    parallaxView.backgroundHeight = 400.0f;
    parallaxView.scrollView.scrollsToTop = YES;
    parallaxView.backgroundInteractionEnabled = NO;
    parallaxView.scrollViewDelegate = self;
    [self.view addSubview:parallaxView];
}


- (void)commentDone:(id)sender forEvent:(UIEvent*)event {
    
}

#pragma mark - UIScrollViewDelegate Protocol Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}


#pragma mark - Internal Methods

- (void)handleTap:(UIGestureRecognizer *)gesture {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

@end
