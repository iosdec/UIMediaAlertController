//
//  UIImageAlertController.h
//  Kho
//
//  Created by R3V0 on 09/11/2017.
//  Copyright © 2017 iosdec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIViewController (UIImageAlertController) <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void)presentImageAlertController;

@end
