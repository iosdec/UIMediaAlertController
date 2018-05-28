//
//  UIMediaAlertController.h
//  UIMediaAlertController
//
//  Created by R3V0 on 25/05/2018.
//  Copyright © 2018 iosdec. All rights reserved.
//

#import "UIMedia.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>

#define kUIM_MediaWidth     250
#define kUIM_MediaHeight    230
#define kUIM_LineSpacing    16.5

typedef enum {
    MediaTypeImage  =   0,
    MediaTypeVideo  =   1,
}MediaType;

@interface UIMediaAlertController : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

typedef void (^mediaPicked)(void);
typedef void (^mediaRemoved)(void);

@property (strong, nonatomic)   UIViewController *controller;
@property (nonatomic, assign)   MediaType type;
@property (strong, nonatomic)   UIMedia *media;
@property (nonatomic, copy)     mediaPicked picked;
@property (nonatomic, copy)     mediaRemoved removed;
@property (nonatomic, assign)   BOOL autoplayDisabled;
@property (nonatomic, assign)   BOOL soundDisabled;
@property (strong, nonatomic)   NSString *title;
@property (strong, nonatomic)   NSString *message;
@property (strong, nonatomic)   UIImageView *imageView;
@property (strong, nonatomic)   UIView *videoView;
@property (strong, nonatomic)   AVPlayer *playerRef;

//  Presentation Options:

+ (void)presentWithType:(MediaType)type picked:(void(^)(void))picked;
+ (void)presentWithType:(MediaType)type picked:(void (^)(void))picked removed:(void(^)(void))removed;
+ (void)resetMedia;
+ (UIMedia *)media;
- (void)presentWithType:(MediaType)type picked:(void(^)(void))picked;
- (void)presentWithType:(MediaType)type picked:(void(^)(void))picked removed:(void(^)(void))removed;
- (void)resetMedia;

@end
