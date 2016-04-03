//
//  ActivitySpinnerViewController.m
//  Woof
//
//  Created by Patrick Whitehead on 2016-03-20.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import "ActivitySpinnerViewController.h"

@interface ActivitySpinnerViewController ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation ActivitySpinnerViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//}


- (id)initWithMessage:(NSString *)message {
    self = [super init];
    self.message = message;
//    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 100, 200, 200, 150)];
    self.backgroundView = [[UIView alloc]init];
    self.backgroundView.frame = CGRectMake(87.5, 200, 200, 150);
    
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0.5;
    self.backgroundView.layer.cornerRadius = 5;
    self.backgroundView.layer.masksToBounds = YES;
    [self addSubview:self.backgroundView];
    
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 40)];
    self.textLabel.text = message;
    self.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.center = CGPointMake(100, 115);
    self.textLabel.textColor = [UIColor whiteColor];
    [self.backgroundView addSubview:self.textLabel];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(100, 60)];
#warning dont hardcode the frame
    
    [self.backgroundView addSubview:spinner];
    [spinner startAnimating];
    return self;
}

- (void)setMessage:(NSString *)message {
    
    self.textLabel.text = message;
    
}


@end
