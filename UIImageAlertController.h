//
//  UIImageAlertController.h
//  Kho
//
//  Created by R3V0 on 09/11/2017.
//  Copyright © 2017 iosdec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define kUIIACImagePicked               @"kUIIACImagePicked"
#define kUIIACImageReset                @"kUIIACImageReset"

@interface UIViewController (UIImageAlertController) <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void)presentImageAlertController;
- (void)addUIImageAlertImagePicked:(SEL)selector;
- (void)addUIImageAlertImageReset:(SEL)selector;

@end
