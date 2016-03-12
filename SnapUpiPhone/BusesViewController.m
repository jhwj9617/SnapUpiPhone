//
//  ViewController.m
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-09.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import "BusesViewController.h"


@interface BusesViewController () {
    CTAssetsPickerController * pickerController;
    PHAsset *selectedAsset;
    __weak IBOutlet UILabel *centerLabel;
}

@end

@implementation BusesViewController

- (IBAction)pickImage:(id)sender {
    [self initializePicker];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// CTAssetsPickerController

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

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    // assume 1 item selected
    [self dismissViewControllerAnimated:YES completion:nil];
    self->selectedAsset = [picker.selectedAssets lastObject];
    centerLabel.text = [selectedAsset valueForKey:@"filename"];
}


@end
