//
//  DownloadViewController.m
//  Amazon Part 1
//
//  Created by Nina Yang on 10/16/15.
//  Copyright (c) 2015 Nina Yang. All rights reserved.
//

#import "DownloadViewController.h"

@interface DownloadViewController ()

@end

@implementation DownloadViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    NSLog(@"DOWNLOAD VC VIEW WILL APPEAR: %@", self.key);
    self.dao = [[DAO alloc]init];
    self.dao.callbackDelegate = self;
    [self.dao downloadFromAmazonS3:self.key];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Download

-(void)imageDownloaded {
    NSLog(@"%@", self.dao.imageData);
    self.image = [UIImage imageWithData:self.dao.imageData];
    
    self.imageToDownload.image = self.image;
    NSLog(@"Image download %@", self.imageToDownload.image);

}

-(void) downloadComplete:(NSData*)data {
    self.image = [UIImage imageWithData:data];
    
    self.imageToDownload.image = self.image;
    NSLog(@"Image download %@", self.imageToDownload.image);
}

@end
