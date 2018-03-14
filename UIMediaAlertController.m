//
//  UIMediaAlertController.m
//  iOSDec
//
//  Created by iOSDec on 09/11/2017.
//  Copyright © 2017 iosdec. All rights reserved.
//

#import "UIMediaAlertController.h"

//
//      **  UIMediaAlertController:
//

@implementation UIMediaAlertController : NSObject

- (id)initWithRoot:(id)root {
    self = [super init];
    self.root = root;
    return self;
}

- (void)presentMediaAlertWithType:(MediaType)type picked:(void(^)(UIMedia *media))picked removed:(void(^)(UIMedia *media))removed {
    
    [self setType:type];
    [self setPickerFinished:picked];
    [self setPickerRemoved:removed];
    [self setController:nil];
    
    //  find root controller:
    UIViewController *controller    =   [self controllerWithRoot:self.root];
    if (!controller) { return; }
    self.controller                 =   controller;
    
    //  init media if not already:
    if (!self.media) { self.media   =   [[UIMedia alloc] init]; }
    
    //  show alert controller:
    [self showAlertController];
    
}

#pragma mark    -   Show Alert Controller:

- (void)showAlertController {
    
    //  check if type is image:
    if (self.type == MediaTypeImage) {
        
        self.title                  =   @"Add Image";
        self.message                =   @"\n\nNo Image\n\n";
        
        if (self.media.image) {
            self.title              =   @"Image Options";
            self.message            =   @"";
            NSUInteger lines        =   round(kUIM_MediaHeight/kUIM_LineSpacing);
            for (int i = 0; i < lines; i++) {
                self.message        =   [self.message stringByAppendingString:@"\n"];
            }
        }
        
        self.imageView                      =   [[UIImageView alloc] init];
        self.imageView.frame                =   CGRectMake(0, 62, kUIM_MediaWidth, kUIM_MediaHeight);
        self.imageView.contentMode          =   UIViewContentModeScaleAspectFill;
        self.imageView.center               =   CGPointMake(self.controller.view.center.x-10, self.imageView.center.y);
        self.imageView.image                =   self.media.image;
        self.imageView.layer.cornerRadius   =   5;
        self.imageView.clipsToBounds        =   YES;
        
    }
    
    //  check if type is video:
    if (self.type == MediaTypeVideo) {
        
        self.title                  =   @"Add Video";
        self.message                =   @"\n\nNo Video\n\n";
        
        if (self.media.videoURL) {
            self.title              =   @"Video Options";
            self.message            =   @"";
            NSUInteger lines        =   round(kUIM_MediaHeight/kUIM_LineSpacing);
            for (int i = 0; i < lines; i++) {
                self.message        =   [self.message stringByAppendingString:@"\n"];
            }
        }
        
        self.videoView                      =   [[UIView alloc] init];
        self.videoView.frame                =   CGRectMake(0, 62, kUIM_MediaWidth, kUIM_MediaHeight);
        self.videoView.center               =   CGPointMake(self.controller.view.center.x-10, self.videoView.center.y);
        self.videoView.layer.cornerRadius   =   5;
        self.videoView.clipsToBounds        =   YES;
        
        AVPlayer *player                    =   [[AVPlayer alloc] init];
        if (self.media.videoURL) { player   =   [[AVPlayer alloc] initWithURL:self.media.videoURL]; }
        
        AVPlayerLayer *layer                =   [AVPlayerLayer playerLayerWithPlayer:player];
        layer.frame                         =   CGRectMake(0, 0, self.videoView.frame.size.width, self.videoView.frame.size.height);
        [self.videoView.layer insertSublayer:layer atIndex:0];
        
    }
    
    //
    //      **  present UIAlertController:
    //
    
    UIAlertController *ac           =   [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:UIAlertControllerStyleActionSheet];
    
    //  check if the image isn't nil.. if so add it:
    if (self.media.image) {
        [ac.view addSubview:self.imageView];
    }
    
    //  check if the media url isn't nil.. if so add view:
    if (self.media.videoURL) {
        [ac.view addSubview:self.videoView];
    }
    
    //  create actions:
    UIAlertAction *add              =   [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Add %@",[self typeString]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentPickerWithType:self.type];
    }];
    
    if (self.type == MediaTypeImage) {
        if (!self.media.image) {
            [ac addAction:add];
        }
    }
    if (self.type == MediaTypeVideo) {
        if (!self.media.videoURL) {
            [ac addAction:add];
        }
    }
    
    UIAlertAction *replace          =   [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Replace %@",[self typeString]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.type == MediaTypeImage) { self.media.image = nil; }
        if (self.type == MediaTypeVideo) { self.media.videoURL = nil; }
        [self presentPickerWithType:self.type];
    }];
    
    if (self.type == MediaTypeImage) {
        if (self.media.image) {
            [ac addAction:replace];
        }
    }
    if (self.type == MediaTypeVideo) {
        if (self.media.videoURL) {
            [ac addAction:replace];
        }
    }
    
    UIAlertAction *removeImage      =   [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Remove %@",[self typeString]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (self.type == MediaTypeImage) { self.media.image = nil; }
        if (self.type == MediaTypeVideo) { self.media.videoURL = nil; }
        
        self.pickerRemoved(self.media);
        [self presentMediaAlertWithType:self.type picked:self.pickerFinished removed:self.pickerRemoved];
        
    }];
    
    if (self.type == MediaTypeImage) {
        if (self.media.image) {
            [ac addAction:removeImage];
        }
    }
    
    if (self.type == MediaTypeVideo) {
        if (self.media.videoURL) {
            [ac addAction:removeImage];
        }
    }
    
    UIAlertAction *cancel           =   [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancel];
    
    //  add popover for iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [ac setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [ac popoverPresentationController];
        popPresenter.sourceView = self.controller.view;
        popPresenter.sourceRect = CGRectMake(self.controller.view.frame.size.width/2, 200, 2, 2);
    }
    
    //  present alert controller:
    [self.controller presentViewController:ac animated:YES completion:nil];
    
}

#pragma mark    -   Present Picker:

- (void)presentPickerWithType:(MediaType)type {
    
    UIImagePickerController *picker     =   [[UIImagePickerController alloc] init];
    
    if (type == MediaTypeImage) { picker.mediaTypes = @[(NSString *)kUTTypeImage]; }
    if (type == MediaTypeVideo) { picker.mediaTypes = @[(NSString *)kUTTypeMovie]; }
    
    picker.delegate                     =   self;
    picker.sourceType                   =   UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing                =   YES;
    [self.controller presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark    -   UIImagePickerController Delegate:

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    if (self.type == MediaTypeImage) {
        UIImage *image          =   info[UIImagePickerControllerEditedImage];
        self.media.image        =   image;
        self.media.thumbImage   =   image;
        self.pickerFinished(self.media);
    }
    
    if (self.type == MediaTypeVideo) {

        NSString *mediaType             =   [info objectForKey: UIImagePickerControllerMediaType];
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            NSURL *videoURL             =   (NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
            AVURLAsset *asset           =   [[AVURLAsset alloc] initWithURL:videoURL options:nil];
            AVAssetImageGenerator *gen  =   [[AVAssetImageGenerator alloc] initWithAsset:asset];
            gen.appliesPreferredTrackTransform = YES;
            CMTime time = CMTimeMakeWithSeconds(0.0, 600);
            NSError *error              =   nil;
            CMTime actualTime;
            CGImageRef image            =   [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
            UIImage *thumb              =   [[UIImage alloc] initWithCGImage:image];
            CGImageRelease(image);
            self.media.thumbVideo       =   thumb;
            self.media.videoURL         =   videoURL;
            self.pickerFinished(self.media);
        }
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark    -   Extras:

- (NSString *)typeString {
    if (self.type == MediaTypeImage) { return @"Image"; }
    else if (self.type == MediaTypeVideo) { return @"Video"; }
    else { return @"Media"; }
}

- (UIViewController *)controllerWithRoot:(id)root {
    if ([root isKindOfClass:[UIViewController class]]) { return (UIViewController *)root; }
    UIResponder *responder = root;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) { break; }
    } return (UIViewController *)responder;
}

@end














