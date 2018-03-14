//
//  UIMedia.h
//  iOSDec
//
//  Created by iOSDec on 09/11/2017.
//  Copyright © 2017 iosdec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIMedia : NSObject
@property (strong, nonatomic) NSURL *imageLocalURL;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSDictionary *imageMeta;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) UIImage *thumbImage;
@property (strong, nonatomic) UIImage *thumbVideo;
@end
