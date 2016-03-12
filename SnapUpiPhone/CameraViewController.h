//
//  CameraViewController.h
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-10.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <CTAssetsPickerController.h>
@import Photos;

@interface CameraViewController : UIViewController <UIGestureRecognizerDelegate, CTAssetsPickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *captureFrame;
@property (strong, nonatomic) IBOutlet UIImageView *capturedImageView;
@property (strong, nonatomic) IBOutlet UIView *selectAssetFrame;
@property (strong, nonatomic) IBOutlet UIButton *selectAssetButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *selectAssetFrameHeightConstraint;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationBarTopConstraint;
@property (strong, nonatomic) IBOutlet UIView *cameraBottomFrame;
@property (strong, nonatomic) IBOutlet UIButton *captureButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cameraBottomFrameBottomConstraint;
@property (strong, nonatomic) IBOutlet UIView *capturedImageFrame;

@end
