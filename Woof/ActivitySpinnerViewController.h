//
//  ActivitySpinnerViewController.h
//  Woof
//
//  Created by Patrick Whitehead on 2016-03-20.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitySpinnerViewController : UIView

@property (nonatomic, strong) NSString *message;

- (id)initWithMessage:(NSString *)message;

@end
