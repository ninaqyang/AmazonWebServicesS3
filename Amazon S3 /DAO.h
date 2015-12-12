//
//  DAO.h
//  Amazon Part 1
//
//  Created by Nina Yang on 10/19/15.
//  Copyright © 2015 Nina Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSS3/AWSS3.h>
#import <AWSCore/AWSCore.h>

@class ViewController;

@protocol DAODelegate <NSObject>

@optional
-(void) downloadComplete:(NSData*)data;

@end


@interface DAO : NSObject

@property (nonatomic, strong) AWSS3TransferManagerUploadRequest *uploadRequest;
@property (nonatomic) uint64_t filesize;
@property (nonatomic) uint64_t amountUploaded;
@property (strong, nonatomic) NSString *progress;
@property (nonatomic) NSString *timeStamp;
@property(nonatomic, strong) id delegate;

@property(nonatomic, strong) id<DAODelegate> callbackDelegate;


@property (strong, nonatomic) NSMutableArray *tableViewImages;
@property (nonatomic, strong) AWSS3TransferManagerDownloadRequest *downloadRequest;
@property (strong, nonatomic) NSData *imageData;

- (void)displayToastWithMessage:(NSString *)toastMessage;
- (void)uploadToAmazonS3:(UIImage *)image;
- (void)makeListRequest;
- (void)downloadFromAmazonS3:(NSString *)imageKey;

@end
