# UIMediaAlertController

UIAlertController extension for selecting images / videos.<br>
Written in *Objective-C*.

*Created By: [Declan Land](https://twitter.com/declanland)*

**Features**<br>
*	Completion handlers<br>
*	Ease of use<br>
*	Media Preview<br>
*	Customisable<br>

![Screenshot](uimac.png)

---

### Installation

Download the contents of this repo and add these files to your project:<br>
```
UIMediaAlertController.h
UIMediaAlertController.m
UIMedia.h
UIMedia.m
```
Include these frameworks in your project:
```objc
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
```
---

### Usage (.h)

Import the *UIMediaAlertController.h* file into your project.<br>
You must store the UIMediaAlertController as a property in your header class like so:
```objc
//		MyViewController.h

#import "UIMediaAlertController.h"

@implementation MyViewController : UIViewController

@property (strong, nonatomic) UIMediaAlertController *mediaPicker;

@end
```

### Usage (.m)

UIMediaAlertController can be used from any class. If the *root* object is not a UIViewController, UIMediaAlertController will loop through responders and find the controller.<br>

Use **MediaTypeImage** to pick an image<br>
Use **MediaTypeVideo** to pick a video<br>

```objc
@implementation MyViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self showMediaController];
}

#pragma mark	-	Show Controller:

- (void)showMediaController {
	
    self.mediaPicker = [[UIMediaAlertController alloc] initWithRoot:self];
    [self.mediaPicker presentMediaAlertWithType:MediaTypeImage picked:^(UIMedia *media) {
		//	do something with media.image
    } removed:^(UIMedia *media) {
		//	user removed image
    }];
	
}
```
