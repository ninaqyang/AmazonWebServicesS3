//
//  DAO.m
//  Amazon Part 1
//
//  Created by Nina Yang on 10/19/15.
//  Copyright © 2015 Nina Yang. All rights reserved.
//

#import "DAO.h"
#import "ViewController.h"
#import "DownloadViewController.h"

@implementation DAO

#pragma mark - Update UI

- (void)displayToastWithMessage:(NSString *)toastMessage {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
        UILabel *toastView = [[UILabel alloc]init];
        toastView.text = toastMessage;
        toastView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.6];
        toastView.textAlignment = NSTextAlignmentCenter;
        toastView.frame = CGRectMake(0, 0, keyWindow.frame.size.width / 2, 100);
        toastView.layer.cornerRadius = 10;
        toastView.layer.masksToBounds = YES;
        toastView.center = keyWindow.center;
        [keyWindow addSubview:toastView];
        
        [UIView animateWithDuration:3.0f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            toastView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [toastView removeFromSuperview];
        }];
    }];
}

#pragma mark - Timestamp

- (NSString *)setTimeStamp {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [format stringFromDate:now];
    
    return dateString;
}

#pragma mark - Amazon S3 Requests

- (void)uploadToAmazonS3:(UIImage *)image {
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"image.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:path atomically:YES];
    
    NSURL *url = [[NSURL alloc]initFileURLWithPath:path];
    
    self.uploadRequest = [[AWSS3TransferManagerUploadRequest alloc]init];
    self.uploadRequest.bucket = @"ninaawsbucket";
    self.uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
    self.uploadRequest.key = [NSString stringWithFormat:@"photo: %@", [self setTimeStamp]];
    // Fix with name of image instead
    self.uploadRequest.contentType = @"photo/png";
    self.uploadRequest.body = url;
    
    __weak DAO *weakSelf = self;
    
    self.uploadRequest.uploadProgress =^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            weakSelf.amountUploaded = totalBytesSent;
            weakSelf.filesize = totalBytesExpectedToSend;
            NSLog(@"Uploading: %.0f%%", ((float)self.amountUploaded/ (float)self.filesize) * 100);
            [weakSelf.delegate updateProgress];
            [weakSelf.delegate startProgressBar];
        });
    };
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    [[transferManager upload:self.uploadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
        if (task.error) {
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                        break;
                        
                    default:
                        NSLog(@"error: %@", task.error);
                        break;
                }
            }
            else {
                NSLog(@"unknown error: %@", task.error);
            }
        }
        
        if (task.result) {
            NSLog(@"upload successful");
            [self displayToastWithMessage:@"Upload is successful!"];
        }
        return nil;
    }];
}

- (void)makeListRequest {
    AWSS3 *s3 = [AWSS3 defaultS3];
    AWSS3ListObjectsRequest *listObjectsRequest = [[AWSS3ListObjectsRequest alloc]init];
    listObjectsRequest.bucket = @"ninaawsbucket";
    
    [[s3 listObjects:listObjectsRequest]continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"error: %@", task.error);
        }
        if (task.result) {
            AWSS3ListObjectsOutput *listObjectsOutput = task.result;
            self.tableViewImages = [[NSMutableArray alloc]init];
            for (AWSS3Object *s3Object in listObjectsOutput.contents) {
                NSString *downloadingFilePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"download"]stringByAppendingPathComponent:s3Object.key];
                NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:downloadingFilePath]) {
                    [self.tableViewImages addObject:downloadingFileURL];
                }
                else {
                    AWSS3TransferManagerDownloadRequest *downloadRequest = [[AWSS3TransferManagerDownloadRequest alloc]init];
                    downloadRequest.bucket = @"ninaawsbucket";
                    downloadRequest.key = s3Object.key;
                    downloadRequest.downloadingFileURL = downloadingFileURL;
                    //if only want to create one image file for table view, then initialize array here to add one by one to view controller
                    [self.tableViewImages addObject:downloadRequest];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@", self.tableViewImages);
                NSLog(@"%@", self.delegate);
                [self.delegate reloadTableView];
            });
            
        }
        return nil;
    }];
}

- (void)downloadFromAmazonS3:(NSString *)imageKey {
    NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"image.png"];
    NSURL *downloadingFileURL = [[NSURL alloc]initFileURLWithPath:downloadingFilePath];
    
    self.downloadRequest = [[AWSS3TransferManagerDownloadRequest alloc]init];
    self.downloadRequest.bucket = @"ninaawsbucket";
    self.downloadRequest.key = imageKey;
    self.downloadRequest.downloadingFileURL = downloadingFileURL;
    
    __weak DAO *weakSelf = self;
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    [[transferManager download:self.downloadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
        if (task.error) {
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                        break;
                        
                    default:
                        NSLog(@"error: %@", task.error);
                        break;
                }
            }
            else {
                NSLog(@"unknown error: %@", task.error);
            }
        }
        if (task.result) {
            NSLog(@"download successful");
            [self displayToastWithMessage:@"Download is successful!"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *imagePath = [task.result valueForKey:@"body"];
            NSData *data = [NSData dataWithContentsOfFile:imagePath];
            [weakSelf.callbackDelegate downloadComplete:data];
        });

        return nil;
    }];
}

@end
