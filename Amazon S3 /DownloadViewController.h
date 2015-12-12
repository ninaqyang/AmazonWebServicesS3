//
//  DownloadViewController.h
//  Amazon Part 1
//
//  Created by Nina Yang on 10/16/15.
//  Copyright (c) 2015 Nina Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"
#import "ViewController.h"

@interface DownloadViewController : UIViewController <DAODelegate>

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) IBOutlet UIImageView *imageToDownload;
@property (strong, nonatomic) DAO *dao;
@property (strong, nonatomic) NSString *key;

-(void)imageDownloaded;

@end
