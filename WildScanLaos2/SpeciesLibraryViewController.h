//
//  SpeciesLibraryViewController.h
//  WildScan
//
//  Created by Shabir Jan on 19/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeciesLibraryViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (nonatomic)BOOL isSpecieForSubmitReport;
@property (nonatomic,strong)NSManagedObjectContext *moc;
@property (nonatomic,strong)NSArray *identifiedResults;
@property (nonatomic)BOOL loadSpeciesFromIdentifieds;
- (IBAction)btnBackPressed:(id)sender;
- (IBAction)btnListModePressed:(id)sender;
- (IBAction)btnFavoritePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnList;
@property (weak, nonatomic) IBOutlet UIButton *btnIsFavorite;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnFavoriteShowPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *txtSpeciesName;
@property (nonatomic,strong)NSMutableArray *searchSpecieArray;

- (IBAction)btnAnimalTypesPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *specieSearchTableView;
@property (weak, nonatomic) IBOutlet UIView *specieTypeView;
- (IBAction)btnFilterSpeciePressed:(id)sender;
- (IBAction)btnSearchPressed:(id)sender;
- (IBAction)btnSpeciesReportPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectedCategory;

-(NSString *)translateCites:(NSString *)appendix;

@end
