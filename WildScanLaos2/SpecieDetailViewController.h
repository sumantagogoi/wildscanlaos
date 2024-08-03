//
//  SpecieDetailViewController.h
//  WildScan
//
//  Created by Shabir Jan on 04/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecieDetailViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSManagedObjectContext *moc;
@property (nonatomic,strong)Species *currentSpecie;
@property (weak, nonatomic) IBOutlet UIView *imageCopyRView;
@property (weak, nonatomic) IBOutlet UILabel *lblDefault;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *galleryView;
@property (weak, nonatomic) IBOutlet UILabel *lblImageCopyRight;
@property (weak, nonatomic) IBOutlet UILabel *lblComonScientificName;
@property (weak, nonatomic) IBOutlet UILabel *lblCites;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblWarnings;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;
@property (weak, nonatomic) IBOutlet UIButton *btnReport;
@property (weak, nonatomic) IBOutlet UILabel *lblClues;
@property (weak, nonatomic) IBOutlet UILabel *lblSimilarAnimals;
@property (weak, nonatomic) IBOutlet UILabel *lblLawAdvice;
@property (weak, nonatomic) IBOutlet UILabel *lblConsumerAdvice;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstResponderAdvice;
@property (weak, nonatomic) IBOutlet UILabel *lblTradedAs;
@property (weak, nonatomic) IBOutlet UILabel *lblCommonTraffickingMethods;
@property (weak, nonatomic) IBOutlet UILabel *lblKnownAs;
@property (weak, nonatomic) IBOutlet UILabel *lblDistribution;
@property (weak, nonatomic) IBOutlet UILabel *lblAverageSizeWeight;
@property (weak, nonatomic) IBOutlet UILabel *lblHabitat;
@property (weak, nonatomic) IBOutlet UILabel *lblZoontaciDiease;
@property (weak, nonatomic) IBOutlet UILabel *lblNotes;
- (IBAction)btnFavoritePressed:(id)sender;

- (IBAction)btnReportSpeciePressed:(id)sender;


- (IBAction)btnBackPressed:(id)sender;

@end
