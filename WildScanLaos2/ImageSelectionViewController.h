//
//  ImageSelectionViewController.h
//  WildScan
//
//  Created by Shabir Jan on 21/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IdentifyCollectionViewCell.h"
@interface ImageSelectionViewController : UIViewController<UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate>
- (IBAction)btnBackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSManagedObjectContext *moc;
@property (weak, nonatomic) IBOutlet UIView *imageView;
- (IBAction)btnTakePhotoPressed:(id)sender;
- (IBAction)btnChooseExisitingPressed:(id)sender;
- (IBAction)btnNextPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIImageView *reportImgae;
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UIView *backBlurrView;
- (IBAction)btnCheckmark:(id)sender;
- (IBAction)btnCancelPressed:(id)sender;
- (IBAction)btnOkPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckmark;
@end
