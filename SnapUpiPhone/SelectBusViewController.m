//
//  SelectBusViewController.m
//  SnapUpiPhone
//
//  Created by WEI JOON JOSEPH HO on 2016-03-11.
//  Copyright © 2016 Cryptic Android. All rights reserved.
//

#import "SelectBusViewController.h"

@implementation SelectBusViewController

BusOrigin *selectedBusOriginToUploadAsset;

- (void) viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsZero;
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.tabBarController.tabBar setHidden:YES];
    [self.uploadButton setEnabled:false];
    [self loadBusOriginList];
    [self renderTableView];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)renderTableView {
    [self.tableView setDelegate:self];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setRowHeight:70];
    [self.tableView setDataSource:busOriginList];
    [self.tableView reloadData];
}

- (void) loadBusOriginList {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent: @"BusOriginList.txt"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath] && [NSKeyedUnarchiver unarchiveObjectWithFile:filePath] != nil) {
        busOriginList = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        busOriginList = [[BusOriginList alloc] init];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedBusOriginToUploadAsset = [busOriginList.busOrigins objectAtIndex:indexPath.row];
    [self.uploadButton setEnabled:true];
}

- (IBAction)uploadButtonPressed:(id)sender {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        [self uploadAssetData];
    }
    else {
        UIAlertController *noInternetAlert = [InterfaceUtilities createAlertDialogWithTitle:@"Deleting Bus Unavailable" Message:@"You need to be connected to your network or Wi-Fi to delete your bus."];
        [self presentViewController:noInternetAlert animated:YES completion:nil];
    }
}

- (void) uploadAssetData {
    UIViewController * contributeViewController = [[UIViewController alloc] init];
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *beView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    beView.frame = self.view.bounds;
    contributeViewController.view.frame = self.view.bounds;
    contributeViewController.view.backgroundColor = [UIColor clearColor];
    [contributeViewController.view insertSubview:beView atIndex:0];
    contributeViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:contributeViewController animated:YES completion:nil];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // filetype jpg assumed
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@",
                           @"http://snapup.apphb.com/Buses/CreateAsset?mobileId=1&fileName=", self.fileName,
                           @".jpg&code=", selectedBusOriginToUploadAsset.code];
    
    __block NSDictionary *json;
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@", strData);
                if(data != nil) {
                    json = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
                    
                    if ([json objectForKey:@"statusCode"] && [[json objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                        NSString *putUrl = [[json objectForKey:@"putUrl"] stringByReplacingOccurrencesOfString:@"\\u0026" withString:@"&"]; // \u0026 must be decoded to &
                        NSLog(@"%@", putUrl);
                        
                        NSMutableURLRequest *uploadRequest = [[NSMutableURLRequest alloc] init];
                        [uploadRequest setURL:[NSURL URLWithString:putUrl]];
                        uploadRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
                        [uploadRequest setHTTPMethod:@"PUT"];
                        [uploadRequest setHTTPBody:self.assetDataToUpload];
                        [uploadRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[self.assetDataToUpload length]] forHTTPHeaderField:@"Content-Length"];
                        [uploadRequest setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
                        NSURLSession *session = [NSURLSession sharedSession];
                        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:uploadRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                            NSLog(@"YAY COMPLETED");
                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                            if ([httpResponse statusCode] == 200) {
                                [self confirmAssetUpload];
                            } else {
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            }
                        }];
                        [dataTask resume];
                    }
                }
            }] resume];
}

- (void) confirmAssetUpload {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",
                           @"http://snapup.apphb.com/Assets/ConfirmAssetUpload?mobileId=1&code=", selectedBusOriginToUploadAsset.code];
    __block NSDictionary *json;
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@", strData);
                if(data != nil) {
                    json = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
                    
                    if ([json objectForKey:@"statusCode"] && [[json objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                        self.didUpload = true;
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        [self performSegueWithIdentifier:@"SelectBusToCamera" sender:self];
                    }
                }
            }] resume];
}

@end
