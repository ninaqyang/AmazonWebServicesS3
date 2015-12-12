//
//  ViewController.h
//  Amazon Part 1
//
//  Created by Nina Yang on 10/14/15.
//  Copyright (c) 2015 Nina Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSS3/AWSS3.h>
#import <AWSCore/AWSCore.h>
#import "DAO.h"
#import "UploadViewController.h"
#import "DownloadViewController.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UINavigationBarDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *selectedImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DAO *dao;
@property (strong, nonatomic) NSString *key;

- (IBAction)getPicture:(UIBarButtonItem *)sender;
- (void)reloadTableView;

@end

