//
//  UploadViewController.h
//  Amazon Part 1
//
//  Created by Nina Yang on 10/16/15.
//  Copyright (c) 2015 Nina Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"
#import "ViewController.h"

@interface UploadViewController : UIViewController

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) IBOutlet UIImageView *imageToUpload;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) DAO *dao;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic) float progressValue;
@property (strong, nonatomic) ViewController *viewController;

- (IBAction)uploadImageToAmazon:(id)sender;
- (void)updateProgress;
- (void)startProgressBar;

@end
