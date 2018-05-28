//
//  UIMedia.h
//  UIMediaAlertController
//
//  Created by R3V0 on 25/05/2018.
//  Copyright © 2018 iosdec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIMedia : NSObject

@property (strong, nonatomic) UIImage   *image;
@property (strong, nonatomic) NSURL     *imageURL;
@property (strong, nonatomic) NSURL     *videoURL;
@property (strong, nonatomic) UIImage   *videoThumb;

@end
