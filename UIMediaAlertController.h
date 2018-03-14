//
//  UIMediaAlertController.h
//  iOSDec
//
//  Created by iOSDec on 09/11/2017.
//  Copyright © 2017 iosdec. All rights reserved.
//

#import "UIMedia.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>

//
//      **  UIMediaAlertController:
//

#define kUIM_MediaWidth     250
#define kUIM_MediaHeight    230
#define kUIM_LineSpacing    16.5

typedef enum {
    MediaTypeImage  =   0,
    MediaTypeVideo  =   1,
}MediaType;

@interface UIMediaAlertController : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

typedef void (^pickerFinished)(UIMedia *media);
typedef void (^pickerRemoved)(UIMedia *media);

@property (nonatomic, copy)     pickerFinished      pickerFinished;
@property (nonatomic, copy)     pickerRemoved       pickerRemoved;
@property (strong, nonatomic)   UIMedia             *media;
@property (nonatomic, assign)   MediaType           type;
@property (strong, nonatomic)   id                  root;
@property (strong, nonatomic)   UIViewController    *controller;
@property (strong, nonatomic)   NSString            *title;
@property (strong, nonatomic)   NSString            *message;
@property (strong, nonatomic)   UIImageView         *imageView;
@property (strong, nonatomic)   UIView              *videoView;

- (id)initWithRoot:(id)root;
- (void)presentMediaAlertWithType:(MediaType)type picked:(void(^)(UIMedia *media))picked removed:(void(^)(UIMedia *media))removed;

@end






























