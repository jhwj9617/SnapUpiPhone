//
//  CameraViewController.m
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-10.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import "CameraViewController.h"

// CoreMotion to detect orientation changes

@implementation CameraViewController
AVCaptureSession *session;
AVCaptureStillImageOutput *stillImageOutput;
AVCaptureVideoPreviewLayer *previewLayer;
UIImage *capturedImage;
CTAssetsPickerController * pickerController;
PHAsset *selectedAsset;

float tabBarOriginY;
bool isCameraFullView = false;

- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Upload";
    [self initializeCameraSwipeGestures];
    
    [[self.captureButton layer] setBorderColor:[UIColor colorWithWhite:1.0f alpha:1.0f].CGColor];
    [[self.captureButton layer] setBorderWidth:5.0f];
    [[self.captureButton layer] setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.5f].CGColor];;
    [self initializeCameraSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.capturedImageFrame.hidden == false) {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    } else {
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
    
    [session startRunning];
}

-(void) initializeCameraSetup {
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    }
    
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CGRect bounds=[[UIScreen mainScreen] bounds];
    previewLayer.frame = bounds;
    [self.captureFrame.layer addSublayer:previewLayer];
    UIView *view = self.captureFrame;
    CALayer *rootLayer = [view layer];
    [rootLayer setMasksToBounds:YES];
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    // set up capture
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];
}

- (IBAction)takePhoto:(id)sender {
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            capturedImage = [UIImage imageWithData:imageData];
            float imageSize = imageData.length;
            NSLog(@"SIZE OF IMAGE: %f ", imageSize);
            [self.capturedImageView setContentMode:UIViewContentModeScaleAspectFill];
            self.capturedImageView.image = capturedImage;
            self.capturedImageFrame.hidden = false;
            [self cameraSwipedUp];
        }
    }];
    previewLayer.connection.enabled = NO;
}

-(void)cameraSwipedUp {
    if (!isCameraFullView) {
        isCameraFullView = true;
        [self.view layoutIfNeeded];
        self.selectAssetFrameHeightConstraint.constant = 0;
        [self.navigationController setNavigationBarHidden:YES animated:true];
        self.selectAssetButton.hidden = true;
        self.cameraBottomFrameBottomConstraint.constant -= self.tabBarController.tabBar.frame.size.height;
        //new tab bar height
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
            [self setNeedsStatusBarAppearanceUpdate];
            // Hide tab bar
            CGRect tabFrame = self.tabBarController.tabBar.frame;
            tabBarOriginY = tabFrame.origin.y;
            tabFrame.origin.y = self.view.frame.size.height;
            self.tabBarController.tabBar.frame = tabFrame;
        }];
    }
}

-(void)cameraSwipedDown {
    if (isCameraFullView) {
        isCameraFullView = false;
        [self.view layoutIfNeeded];
        self.selectAssetFrameHeightConstraint.constant = 100;
        [self.navigationController setNavigationBarHidden:NO animated:true];
        self.selectAssetButton.hidden = false;
        self.cameraBottomFrameBottomConstraint.constant += self.tabBarController.tabBar.frame.size.height;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
            [self setNeedsStatusBarAppearanceUpdate];
            CGRect tabFrame = self.tabBarController.tabBar.frame;
            // Show tab bar
            tabFrame.origin.y = tabBarOriginY;
            self.tabBarController.tabBar.frame = tabFrame;
        }];
    }
}

-(UIStatusBarAnimation) preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

-(BOOL) prefersStatusBarHidden {
    return isCameraFullView;
}

-(void)initializeCameraSwipeGestures {
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cameraSwipedUp)];
    swipeUp.numberOfTouchesRequired = 1;
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.captureFrame addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cameraSwipedDown)];
    swipeDown.numberOfTouchesRequired = 1;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.captureFrame addGestureRecognizer:swipeDown];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:NULL];
}

// Captured Image Methods
- (IBAction)capturedImageClose:(id)sender {
    self.capturedImageFrame.hidden = true;
    previewLayer.connection.enabled = YES;
    NSLog([@(self.tabBarController.tabBar.frame.origin.y) stringValue]);
}



// Picker Controller Methods
- (IBAction)cameraRollButtonClicked:(id)sender {
    [self initializePicker];
}

- (void)initializePicker {
    pickerController = [[CTAssetsPickerController alloc] init];
    pickerController.delegate = self;
    pickerController.defaultAssetCollection = PHAssetCollectionSubtypeSmartAlbumUserLibrary;
    pickerController.showsEmptyAlbums = false;
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    // only pictures for now
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    pickerController.assetsFetchOptions = fetchOptions;
    [self presentViewController:pickerController animated:YES completion:NULL];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset
{
    // Allow only 1 asset for now
    if (picker.selectedAssets.count == 1) {
        [picker deselectAsset:[picker.selectedAssets lastObject]];
    }
    return true;
}

-(void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker
{
    NSLog(@"cancelled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    // assume 1 item selected
    [self dismissViewControllerAnimated:YES completion:nil];
    selectedAsset = [picker.selectedAssets lastObject];
    NSString *string = [selectedAsset valueForKey:@"filename"];
    NSLog(string);
}

@end