//
//  IdentifySpecieViewController.h
//  WildScan
//
//  Created by Shabir Jan on 07/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdentifySpecieViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSManagedObjectContext *moc;
@property (nonatomic)BOOL isSubmitReportView;
@property (nonatomic,strong)NSString *descriptionText;
- (IBAction)btnBackPressed:(id)sender;
- (IBAction)btnIntactAnimalPressed:(id)sender;
- (IBAction)btnAnimalProductPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UICollectionView *identifyCV;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIView *specialFeatureView;
@property (weak, nonatomic) IBOutlet UIButton *btnTail;
@property (weak, nonatomic) IBOutlet UIButton *btnWings;
@property (weak, nonatomic) IBOutlet UIButton *btnBeak;
@property (weak, nonatomic) IBOutlet UIButton *btnShell;
@property (weak, nonatomic) IBOutlet UIButton *btnFins;
- (IBAction)btnTailPressed:(id)sender;
- (IBAction)btnWingsPressed:(id)sender;
- (IBAction)btnBeakPressed:(id)sender;
- (IBAction)btnShellPressed:(id)sender;
- (IBAction)btnFinPressed:(id)sender;
- (IBAction)btnCancelPressed:(id)sender;
- (IBAction)btnIdentifyPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *firstCollectionView;

@end
