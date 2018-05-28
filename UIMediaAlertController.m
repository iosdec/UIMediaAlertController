//
//  UIMediaAlertController.m
//  UIMediaAlertController
//
//  Created by R3V0 on 25/05/2018.
//  Copyright © 2018 iosdec. All rights reserved.
//

#import "UIMediaAlertController.h"

@implementation UIMediaAlertController

__strong UIMediaAlertController *sharedController;
__strong UIMedia *sharedMedia;

+ (void)presentWithType:(MediaType)type picked:(void (^)(void))picked {
    if (!sharedController) {
        sharedController = [[UIMediaAlertController alloc] init];
    } if (!sharedMedia) {
        sharedMedia = [[UIMedia alloc] init];
    }
    [sharedController setController:[sharedController findTopViewController]];
    [sharedController setType:type];
    [sharedController setPicked:picked];
    [sharedController setRemoved:nil];
    [sharedController removeObjects];
    if (!sharedController.media) {
        sharedController.media = sharedMedia;
    }
}

+ (void)presentWithType:(MediaType)type picked:(void (^)(void))picked removed:(void (^)(void))removed {
    if (!sharedController) {
        sharedController = [[UIMediaAlertController alloc] init];
    } if (!sharedMedia) {
        sharedMedia = [[UIMedia alloc] init];
    }
    [sharedController setController:[sharedController findTopViewController]];
    [sharedController setType:type];
    [sharedController setPicked:picked];
    [sharedController setRemoved:removed];
    [sharedController removeObjects];
    if (!sharedController.media) {
        sharedController.media = sharedMedia;
    }
}

+ (void)resetMedia {
    sharedMedia.image       =   nil;
    sharedMedia.imageURL    =   nil;
    sharedMedia.videoURL    =   nil;
    sharedMedia.videoThumb  =   nil;
}

+ (UIMedia *)media {
    if (sharedMedia) { return sharedMedia; }
    else { sharedMedia = [[UIMedia alloc] init]; return sharedMedia; }
}

- (void)presentWithType:(MediaType)type picked:(void (^)(void))picked {
    [sharedController setController:[self findTopViewController]];
    [self setType:type];
    [self setPicked:picked];
    [self setRemoved:nil];
    [self removeObjects];
    if (!self.media) {
        self.media = [[UIMedia alloc] init];
    }
}

- (void)presentWithType:(MediaType)type picked:(void (^)(void))picked removed:(void (^)(void))removed {
    [sharedController setController:[self findTopViewController]];
    [self setType:type];
    [self setPicked:picked];
    [self setRemoved:removed];
    [self removeObjects];
    if (!self.media) {
        self.media = [[UIMedia alloc] init];
    }
}

- (void)resetMedia {
    self.media.image        =   nil;
    self.media.imageURL     =   nil;
    self.media.videoURL     =   nil;
    self.media.videoThumb   =   nil;
}

#pragma mark    -   Present Preperation:

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
        self.playerRef                      =   player;
        
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
        
        if (self.removed) {
            self.removed();
            [self presentWithType:self.type picked:self.picked removed:self.removed];
        } else {
            [self presentWithType:self.type picked:self.picked removed:nil];
        }
        
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
    
    UIAlertAction *cancel           =   [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (self.playerRef) {
            [self.playerRef seekToTime:CMTimeMake(0, 1)];
            [self.playerRef pause];
        }
    }];
    [ac addAction:cancel];
    
    //  add popover for iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [ac setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [ac popoverPresentationController];
        popPresenter.sourceView = self.controller.view;
        popPresenter.sourceRect = CGRectMake(self.controller.view.frame.size.width/2, 200, 2, 2);
    }
    
    //  present alert controller:
    [self.controller presentViewController:ac animated:YES completion:^{
        if (self.media.videoURL) {
            if (self.playerRef) {
                [self.playerRef play];
            }
        }
    }];
    
}

#pragma mark    -   Present:

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
        self.picked();
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
            self.media.videoThumb       =   thumb;
            self.media.videoURL         =   videoURL;
            self.picked();
        }
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark    -   Extras:

- (UIViewController *)findTopViewController {
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (rootController.presentedViewController) {
        rootController = rootController.presentedViewController;
    } return rootController;
}

- (NSString *)typeString {
    if (self.type == MediaTypeImage) { return @"Image"; }
    else if (self.type == MediaTypeVideo) { return @"Video"; }
    else { return @"Media"; }
}

- (void)removeObjects {
    if (self.imageView) {
        [self.imageView removeFromSuperview];
        self.imageView = nil;
    } if (self.videoView) {
        [self.videoView removeFromSuperview];
        self.videoView = nil;
    } if (self.playerRef) {
        self.playerRef = nil;
    }
}

@end
