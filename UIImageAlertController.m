//
//  UIImageAlertController.m
//  Kho
//
//  Created by R3V0 on 09/11/2017.
//  Copyright © 2017 iosdec. All rights reserved.
//

#import "UIImageAlertController.h"

#define kUIIACImageWidth                250
#define kUIIACImageHeight               230
#define kLineSpaceHeight                16.5

@implementation UIViewController (UIImageAlertController)

UIImage *pickedImage;

- (void)presentImageAlertController {
    
    /*  create variables for title and message:                     */
    
    NSString *title                 =   @"Add Image";
    NSString *message               =   @"\n\nNo Image\n\n";
    
    /*  first, we check this property contains an image:            */
    
    if (pickedImage) {
        title                       =   @"Image Options";
        message                     =   @"";
        NSUInteger lines            =   round(kUIIACImageHeight/kLineSpaceHeight);
        for (int i = 0; i < lines; i++) {
            message                 =   [message stringByAppendingString:@"\n"];
        }
    }
    
    /*  create image view:                                          */
    
    UIImageView *imageView          =   [[UIImageView alloc] init];
    imageView.frame                 =   CGRectMake(0, 62, kUIIACImageWidth, kUIIACImageHeight);
    imageView.contentMode           =   UIViewContentModeScaleAspectFill;
    imageView.center                =   CGPointMake(self.view.center.x-10, imageView.center.y);
    imageView.image                 =   pickedImage;
    imageView.layer.cornerRadius    =   5;
    imageView.clipsToBounds         =   YES;
    
    /*  create uialertcontroller:                                   */
    
    UIAlertController *ac           =   [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    /*  check if picked image exists:                               */
    
    if (pickedImage) {
        [ac.view addSubview:imageView];
    }
    
    /*  create uialert actions:                                     */
    
    UIAlertAction *addImage         =   [UIAlertAction actionWithTitle:@"Add Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentImagePicker];
    }];
    
    if (!pickedImage) {
        [ac addAction:addImage];
    }
    
    UIAlertAction *replaceImage     =   [UIAlertAction actionWithTitle:@"Replace Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pickedImage                 =   nil;
        [self presentImagePicker];
    }];
    
    if (pickedImage) {
        [ac addAction:replaceImage];
    }
    
    UIAlertAction *removeImage      =   [UIAlertAction actionWithTitle:@"Remove Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pickedImage                 =   nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUIIACImageReset object:nil];
        [self presentImageAlertController];
    }];
    
    if (pickedImage) {
        [ac addAction:removeImage];
    }
    
    UIAlertAction *cancel           =   [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
    [ac addAction:cancel];
    
    /*  present alert controller:                                   */
    
    [self presentViewController:ac animated:YES completion:nil];
    
}

#pragma mark    -   Present Picker:

- (void)presentImagePicker {
    
    UIImagePickerController *picker     =   [[UIImagePickerController alloc] init];
    picker.delegate                     =   self;
    picker.sourceType                   =   UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing                =   YES;
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark    -   Add Delegate:

- (void)addUIImageAlertImagePicked:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:kUIIACImagePicked object:nil];
}

- (void)addUIImageAlertImageReset:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:kUIIACImageReset object:nil];
}

#pragma mark    -   UIImagePickerController Delegate:

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage        =   info[UIImagePickerControllerEditedImage];
    pickedImage                 =   chosenImage;
    [[NSNotificationCenter defaultCenter] postNotificationName:kUIIACImagePicked object:pickedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self presentImageAlertController];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}








@end
