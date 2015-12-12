//
//  UploadViewController.m
//  Amazon Part 1
//
//  Created by Nina Yang on 10/16/15.
//  Copyright (c) 2015 Nina Yang. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController ()

@end

@implementation UploadViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageToUpload.image = self.image;
    self.progressLabel.hidden = YES;
    self.progressView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Upload

- (IBAction)uploadImageToAmazon:(id)sender {
    self.dao = [[DAO alloc]init];
    self.dao.delegate = self;
    [self.dao uploadToAmazonS3:self.imageToUpload.image];
}

- (void)updateProgress {
    self.progressLabel.hidden = NO;
    self.progressLabel.text = [NSString stringWithFormat:@"Uploading: %.0f%%", ((float)self.dao.amountUploaded/ (float)self.dao.filesize) * 100];
}

- (void)startProgressBar {
    self.progressView.hidden = NO;
    self.progressView.progress = ((float)self.dao.amountUploaded/ (float)self.dao.filesize);
}

@end
