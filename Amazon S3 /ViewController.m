//
//  ViewController.m
//  Amazon Part 1
//
//  Created by Nina Yang on 10/14/15.
//  Copyright (c) 2015 Nina Yang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.dao = [[DAO alloc]init];
    self.dao.delegate = self;
    [self.dao makeListRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIImagePicker

- (IBAction)getPicture:(UIBarButtonItem *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        self.imagePicker.allowsEditing = true;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.selectedImage = info[UIImagePickerControllerEditedImage];
    NSLog(@"%@", self.selectedImage);
    [self performSegueWithIdentifier:@"upload" sender:info];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //place to pass image source data to new view controller
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    DAO *images = [self.dao.tableViewImages objectAtIndex:indexPath.row];
    self.key = [images valueForKey:@"key"];

    if ([segue.identifier isEqualToString:@"upload"]) {
        NSLog(@"pushing to upload view controller");
        
        UploadViewController *uploadVC = [segue destinationViewController];
        uploadVC.image = self.selectedImage;
    }
    if ([segue.identifier isEqualToString:@"download"]) {
        NSLog(@"pushing to download view controller");
        
        DownloadViewController *downloadVC = [segue destinationViewController];
        downloadVC.key = self.key;
        NSLog(@"%@", downloadVC.key);
    }
}

#pragma mark - Table View Data Source

- (void)reloadTableView {
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"table data count: %lu", (unsigned long)self.dao.tableViewImages.count);

    return self.dao.tableViewImages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    DAO *images = [self.dao.tableViewImages objectAtIndex:[indexPath row]];
    cell.textLabel.text = [images valueForKey:@"key"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:editing animated:YES];
    }
    else {
        [self.tableView setEditing:editing animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dao.tableViewImages removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"pushing to download view controller");
}

@end
