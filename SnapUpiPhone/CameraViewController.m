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
NSData *capturedImageData;
NSString *fileName;
UIImage *capturedImage;
CTAssetsPickerController * pickerController;
PHAsset *selectedAsset;

float tabBarOriginY;
bool isCameraFullView = false;

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initializeCameraSwipeGestures];
    [[self.captureButton layer] setBorderColor:[UIColor colorWithWhite:1.0f alpha:1.0f].CGColor];
    [[self.captureButton layer] setBorderWidth:5.0f];
    [[self.captureButton layer] setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.5f].CGColor];;
    [self initializeCameraSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    if (isCameraFullView) {
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
            capturedImageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            fileName = [self generateTimeStampFileName];
            capturedImage = [UIImage imageWithData:capturedImageData];
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
        UIImage *resizeDownImage = [UIImage imageNamed:@"resize_down.png"];
        [self.resizeButton setImage:resizeDownImage forState:UIControlStateNormal];
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
        UIImage *resizeUpImage = [UIImage imageNamed:@"resize_up.png"];
        [self.resizeButton setImage:resizeUpImage forState:UIControlStateNormal];
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

-(BOOL) prefersStatusBarHidden { // override
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

- (IBAction)resizeButtonPressed:(id)sender {
    if (isCameraFullView) {
        [self cameraSwipedDown];
    } else {
        [self cameraSwipedUp];
    }
}

- (IBAction)switchCameraButtonPressed:(id)sender {
    //Change camera source
    if(session)
    {
        //Indicate that some changes will be made to the session
        [session beginConfiguration];
        
        //Remove existing input
        AVCaptureInput* currentCameraInput = [session.inputs objectAtIndex:0];
        [session removeInput:currentCameraInput];
        
        //Get new input
        AVCaptureDevice *newCamera = nil;
        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        else
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
        
        //Add input to session
        NSError *err = nil;
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:&err];
        if(!newVideoInput || err)
        {
            NSLog(@"Error creating capture device input: %@", err.localizedDescription);
        }
        else
        {
            [session addInput:newVideoInput];
        }
        
        //Commit all the configuration changes at once
        [session commitConfiguration];
    }
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            return device;
        }
    }
    return nil;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"CameraToSelectBus"]) {
        SelectBusViewController *selectBusVC = [segue destinationViewController];
        [selectBusVC setAssetDataToUpload:capturedImageData];
        [selectBusVC setFileName:fileName];
    }
}

- (IBAction)unwindFromModalViewController:(UIStoryboardSegue *)segue {
    if ([[segue identifier] isEqualToString:@"SelectBusToCamera"]) {
        SelectBusViewController *selectBusVC = segue.sourceViewController;
        if (selectBusVC.didUpload) {
            NSLog(@"OMG, iz uplodid");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self capturedImageCloseButtonPressed:self];
                [self cameraSwipedDown];
            });
        }
    }
}

- (NSString *) generateTimeStampFileName {
    NSCalendar *sysCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.calendar = sysCalendar;
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"mmddyyyyHHmmss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}

// Captured Image Methods
- (IBAction)capturedImageCloseButtonPressed:(id)sender {
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    // assume 1 item selected
    //[self dismissViewControllerAnimated:YES completion:nil];
    selectedAsset = [picker.selectedAssets lastObject];
    [[PHImageManager defaultManager] requestImageDataForAsset:selectedAsset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        capturedImageData = imageData;
        fileName = [selectedAsset valueForKey:@"filename"];
        NSLog(@"picked asset");
        [self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"CameraToSelectBus" sender:self];
    }];
}

@end