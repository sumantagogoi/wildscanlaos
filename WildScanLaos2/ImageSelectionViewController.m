//
//  ImageSelectionViewController.m
//  WildScan
//
//  Created by Shabir Jan on 21/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "ImageSelectionViewController.h"
#import "ReportDetailsViewController.h"
@interface ImageSelectionViewController ()
@end

@implementation ImageSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL isWarningShow = [[NSUserDefaults standardUserDefaults]boolForKey:SHOWREPORTWARNING];
    if (isWarningShow) {
        self.backBlurrView.hidden = NO;
        self.warningView.hidden =NO;
    }
    if (self.btnCheckmark.isSelected) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:SHOWREPORTWARNING];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)takePhotoFromCamera{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
-(void)takePhotoFromLibrary{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (IBAction)btnTakePhotoPressed:(id)sender {
    [self takePhotoFromCamera];
}

- (IBAction)btnChooseExisitingPressed:(id)sender {
    [self takePhotoFromLibrary];
}

- (IBAction)btnNextPressed:(id)sender {
    AppDelegate *dlg = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIImage *img = self.reportImgae.image;
    img = [self compressImage:img];
    NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
    NSString *encodedString = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //encodedString = [encodedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:encodedString,@"imageString", nil];
    [dlg.submitReportData addObject:dic];
    
    ReportDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"report2VC"];
    vc.moc = self.moc;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark - UICollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IdentifyCollectionViewCell *cell = (IdentifyCollectionViewCell*)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"identifyCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.lblTitle.text = NSLocalizedString(@"capture", @"");
        cell.img.image = [UIImage imageNamed:@"report_capture"];
    }else if(indexPath.row == 1){
        cell.lblTitle.text = NSLocalizedString(@"browse", @"");
        cell.img.image = [UIImage imageNamed:@"report_browse"];
    }
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        float cellWidth = (screenWidth-6); //Replace the divisor with the column count requirement. Make sure to have it in float.
        float cellHeight = (screenHeight-146)/2.0;
        CGSize size = CGSizeMake(cellWidth, cellHeight);
        
        return size;
    }else{
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight1 = screenRect.size.height;
        float cellWidth = (screenWidth-6); //Replace the divisor with the column count requirement. Make sure to have it in float.
        float cellHeight = (screenHeight1-146)/2.0;
        CGSize size = CGSizeMake(cellWidth, cellHeight);
        
        return size;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self takePhotoFromCamera];
        
    }else if (indexPath.row == 1){
        [self takePhotoFromLibrary];
        
    }
}
#pragma mark -
#pragma mark - UIImagePickerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    
    self.imageView.hidden = NO;
    self.reportImgae.image = img;
    self.buttonView.hidden = NO;
}

- (IBAction)btnCheckmark:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (btn.isSelected) {
        [btn setSelected:NO];
    }
    else{
        [btn setSelected:YES];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:SHOWREPORTWARNING];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

- (IBAction)btnCancelPressed:(id)sender {
    self.backBlurrView.hidden = YES;
    self.warningView.hidden =YES;
}

- (IBAction)btnOkPressed:(id)sender {
    self.backBlurrView.hidden = YES;
    self.warningView.hidden =YES;
}
#pragma mark -
#pragma mark - Helper
- (UIImage *)compressImage:(UIImage *)image{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.1;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth) {
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}
@end
