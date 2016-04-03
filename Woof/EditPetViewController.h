//
//  EditPetViewController.h
//  Woof
//
//  Created by Patrick Whitehead on 2016-02-22.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WoofPet.h"

@interface EditPetViewController : UIViewController <UIBarPositioningDelegate>

@property (nonatomic, strong) WoofPet *pet;

@property BOOL isNewPet;

@end
