//
//  SpeciesLibraryViewController.m
//  WildScan
//
//  Created by Shabir Jan on 19/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "SpeciesLibraryViewController.h"
#import "ReportDetailsViewController.h"
#import "ImageSelectionViewController.h"
#import "AppDelegate.h"
#import "SpeciesTranslation.h"
@interface SpeciesLibraryViewController ()
@property (nonatomic,strong)NSMutableArray *allSpecies;
@property (nonatomic,strong)NSMutableArray *allSpeciesForSearch;
@property (nonatomic)BOOL isUserSearching;
@end

@implementation SpeciesLibraryViewController
@synthesize allSpecies;
@synthesize loadSpeciesFromIdentifieds;
@synthesize identifiedResults;
@synthesize searchSpecieArray;
@synthesize isSpecieForSubmitReport;
@synthesize allSpeciesForSearch;
@synthesize isUserSearching;

- (void)viewDidLoad {
    [super viewDidLoad];
    searchSpecieArray = [NSMutableArray new];
    isUserSearching = NO;
    if (loadSpeciesFromIdentifieds) {
        allSpecies = [NSMutableArray arrayWithArray:identifiedResults];
        if (allSpecies.count==0) {
            
            [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"report_wizard_warning_dialog_title", @"") message:NSLocalizedString(@"msg_species_lib_wizard_empty", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil]show];
        }
    }else{
        
        allSpecies = [NSMutableArray arrayWithArray:[Species getAllSpecies:self.moc]];
        /*
        for (NSInteger i = 0; i < [allSpecies count]; i++) {
            NSLog(@"Species %@", [[allSpecies objectAtIndex:i] valueForKey:@"specieCommonName"]);
        }
         */
        //[allSpecies sortUsingSelector:@selector(localizedCompare:)];
        //NSLog(@"Sorted Species %@", allSpecies);
    }
    allSpeciesForSearch = [NSMutableArray arrayWithArray:[Species getAllSpecies:self.moc]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOccured)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    BOOL isListSelected = [[NSUserDefaults standardUserDefaults]boolForKey:SHOWLIST];
    if (isListSelected) {
        [self btnListModePressed:nil];
    }
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)tapOccured{
    self.searchView.hidden = YES;
    self.txtSpeciesName.text = NSLocalizedString(@"species_lib_search_by_name_hint", @"");
    [self.txtSpeciesName resignFirstResponder];
    self.specieTypeView.hidden= YES;
    self.specieSearchTableView.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnFavoriteShowPressed:(id)sender {
    if (self.btnIsFavorite.isSelected) {
        self.btnIsFavorite.selected = NO;
        [allSpecies removeAllObjects];
        allSpecies = [NSMutableArray arrayWithArray:[Species getAllSpecies:self.moc]];
        [self.collectionView reloadData];
        [self.tableView reloadData];
    }else{
        self.btnIsFavorite.selected = YES;
        [allSpecies removeAllObjects];
        allSpecies =[NSMutableArray arrayWithArray:[Species getAllFavoriteSpecies:self.moc]];
        if (allSpecies.count>0) {
            [self.collectionView reloadData];
            [self.tableView reloadData];
        }else{
            [allSpecies removeAllObjects];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"msg_species_lib_fav_empty", @"")];
            [self.btnIsFavorite setSelected:NO];
            allSpecies = [NSMutableArray arrayWithArray:[Species getAllSpecies:self.moc]];
            [self.collectionView reloadData];
            [self.tableView reloadData];
            
        }
        
    }
    
}
- (IBAction)btnListModePressed:(id)sender {
    if ([self.btnList isSelected]) {
        [self.btnList setSelected:NO];
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
    }else{
        [self.btnList setSelected:YES];
        self.collectionView.hidden =YES;
        self.tableView.hidden = NO;
    }
}

- (IBAction)btnSpeciesReportPressed:(id)sender {
    UIButton *pressedBtn = (UIButton*)sender;
    NSInteger indexPath = pressedBtn.tag;
    Species *currentObj =[allSpecies objectAtIndex:indexPath];
    [[NSUserDefaults standardUserDefaults]setValue:currentObj.specieID forKey:@"reportSpecie"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    ImageSelectionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"imageVC"];
    vc.moc = self.moc;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)btnFavoritePressed:(id)sender {
    UIButton *pressedBtn = (UIButton*)sender;
    NSInteger indexPath = pressedBtn.tag;
    Species *currentObj;
    if ([allSpecies count]>0) {
        currentObj = [allSpecies objectAtIndex:indexPath];
    }else{
        [self btnFavoriteShowPressed:nil];
    }
    
    if ([currentObj.specieIsFavorite boolValue]) {
        currentObj.specieIsFavorite = [NSNumber numberWithBool:NO];
        [self.moc save:nil];
        pressedBtn.selected = NO;
        [allSpecies removeObject:currentObj];
        [self.collectionView reloadData];
        [self.tableView reloadData];
        if (allSpecies.count == 0) {
            [self btnFavoritePressed:nil];
        }
    }else{
        pressedBtn.selected = YES;
        currentObj.specieIsFavorite = [NSNumber numberWithInt:YES];
        [self.moc save:nil];
        [self.collectionView reloadData];
        [self.tableView reloadData];
    }
}

#pragma mark
#pragma mark - UICollectionView Delegates
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return allSpecies.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SpecieCollectionViewCell *cell =(SpecieCollectionViewCell*) [self.collectionView dequeueReusableCellWithReuseIdentifier:@"specieCollectionCell" forIndexPath:indexPath];
    AppDelegate *dlg = [UIApplication sharedApplication].delegate;
    if ([dlg.languageISO isEqualToString:@"en"]) {
        Species *currentObj = [allSpecies objectAtIndex:indexPath.row];
        cell.specieName.text = currentObj.specieCommonName;
        cell.specieImage.image = [UIImage imageNamed:currentObj.specieImageUrl];
        if (cell.specieImage.image == nil) {
            cell.specieImage.image=  [UIImage imageWithContentsOfFile:currentObj.specieImageUrl];
			if (cell.specieImage.image == nil) {
				NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
				cell.specieImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory,currentObj.specieImageUrl]];
			}
			NSLog(@"%@",currentObj.specieImageUrl);
        }
        cell.specieCites.text = currentObj.specieCities;
        cell.specieFavoriteBtn.tag = indexPath.row;
        cell.specieReportBtn.tag = indexPath.row;
        BOOL isFavorite = [currentObj.specieIsFavorite boolValue];
        if (isFavorite) {
            cell.specieFavoriteBtn.selected=YES;
        }else{
            cell.specieFavoriteBtn.selected=NO;
        }
        
    }else{
        NSString *appendix;
        if (isUserSearching) {
            SpeciesTranslation *obj2 = [allSpecies objectAtIndex:indexPath.row];
            Species *currentObj = [Species getSpecieByID:obj2.specieID.specieID moc:self.moc];
            cell.specieImage.image = [UIImage imageNamed:currentObj.specieImageUrl];
            if (cell.specieImage.image == nil) {
                cell.specieImage.image=  [UIImage imageWithContentsOfFile:currentObj.specieImageUrl];
                if (cell.specieImage.image == nil) {
                    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    cell.specieImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory,currentObj.specieImageUrl]];
                }
                NSLog(@"%@",currentObj.specieImageUrl);
            }
            NSString *specieName = @"";
            if (obj2!=nil) {
                if ([obj2.specieCommonName isEqualToString:@""]) {
                    specieName = currentObj.specieCommonName;
                }else{
                    specieName = obj2.specieCommonName;
                }
            }else{
                specieName = currentObj.specieCommonName;
            }
            cell.specieName.text = specieName;
            cell.specieImage.image = [UIImage imageNamed:currentObj.specieImageUrl];
            if (cell.specieImage.image == nil) {
                cell.specieImage.image=  [UIImage imageWithContentsOfFile:currentObj.specieImageUrl];
            }
            cell.specieFavoriteBtn.tag = indexPath.row;
            cell.specieReportBtn.tag = indexPath.row;
            BOOL isFavorite = [currentObj.specieIsFavorite boolValue];
            if (isFavorite) {
                cell.specieFavoriteBtn.selected=YES;
            }else{
                cell.specieFavoriteBtn.selected=NO;
            }
            appendix = currentObj.specieCities;
        }else{
            Species *currentObj = [allSpecies objectAtIndex:indexPath.row];
            SpeciesTranslation *obj2 = [SpeciesTranslation getSpecieTranslation:currentObj language:dlg.languageISO moc:self.moc];
            cell.specieImage.image = [UIImage imageNamed:currentObj.specieImageUrl];
            if (cell.specieImage.image == nil) {
                cell.specieImage.image=  [UIImage imageWithContentsOfFile:currentObj.specieImageUrl];
                if (cell.specieImage.image == nil) {
                    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    cell.specieImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory,currentObj.specieImageUrl]];
                }
                NSLog(@"%@",currentObj.specieImageUrl);
            }
            NSString *specieName = @"";
            NSString *specieCites = @"";
            if (obj2!=nil) {
                if ([obj2.specieCommonName isEqualToString:@""]) {
                    specieName = currentObj.specieCommonName;
                    specieCites = currentObj.specieCities;
                }else{
                    specieName = obj2.specieCommonName;
                }
            }else{
                specieName = currentObj.specieCommonName;
            }
            
            appendix = currentObj.specieCities;
            cell.specieName.text = specieName;
            
            cell.specieImage.image = [UIImage imageNamed:currentObj.specieImageUrl];
            if (cell.specieImage.image == nil) {
                cell.specieImage.image=  [UIImage imageWithContentsOfFile:currentObj.specieImageUrl];
            }
            cell.specieFavoriteBtn.tag = indexPath.row;
            cell.specieReportBtn.tag = indexPath.row;
            BOOL isFavorite = [currentObj.specieIsFavorite boolValue];
            if (isFavorite) {
                cell.specieFavoriteBtn.selected=YES;
            }else{
                cell.specieFavoriteBtn.selected=NO;
            }
        }
        NSArray *cites = @[@"Appendix I", @"Appendix II", @"Appendix III", @"None"];
        NSString *c = @"";
        NSUInteger item = [cites indexOfObject:appendix];
        switch (item) {
            case 0:
                c = NSLocalizedString(@"species_details_label_cites_appendix_1", @"");
               break;
            case 1:
               c = NSLocalizedString(@"species_details_label_cites_appendix_2", @"");
               break;
            case 2:
                c = NSLocalizedString(@"species_details_label_cites_appendix_3", @"");
               break;
            case 3:
                c = NSLocalizedString(@"species_details_label_cites_none", @"");
               break;
            default:
               c = appendix;
               break;
        }
        cell.specieCites.text = c;
    }
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        float cellWidth = (screenWidth-30) / 2.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
        CGSize size = CGSizeMake(cellWidth, 340);
        
        return size;
    }else{
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        float cellWidth = (screenWidth-30) / 2.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
        CGSize size = CGSizeMake(cellWidth, 220);
        
        return size;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *dlg = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (isSpecieForSubmitReport) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:NSLocalizedString(@"species_lib_select_dlg_text", @"")
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"species_lib_select_dlg_btn_details", @"")
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 if (isUserSearching) {
                                     
                                     if ([dlg.languageISO isEqualToString:@"en"]) {
                                         NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[allSpecies objectAtIndex:indexPath.row],@"userSelectedSpecie", nil];
                                         [dlg.submitReportData addObject:dic];
                                         [self proceedToDetails:[allSpecies objectAtIndex:indexPath.row]];
                                     }
                                     else{
                                         SpeciesTranslation *obj = [allSpecies objectAtIndex:indexPath.row];
                                         Species *obj2 = [Species getSpecieByID:obj.specieID.specieID moc:self.moc];
                                         [self proceedToDetails:obj2];
                                     }
                                 }else{
                                     [self proceedToDetails:[allSpecies objectAtIndex:indexPath.row]];
                                 }
                                 
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"species_lib_select_dlg_btn_select", @"")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                     
                                     if (isUserSearching) {
                                         if ([dlg.languageISO isEqualToString:@"en"]) {
                                             NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[allSpecies objectAtIndex:indexPath.row],@"userSelectedSpecie", nil];
                                             [dlg.submitReportData addObject:dic];
                                             [self proceedToDetails:[allSpecies objectAtIndex:indexPath.row]];
                                         }else{
                                             SpeciesTranslation *obj = [allSpecies objectAtIndex:indexPath.row];
                                             Species *obj2 = [Species getSpecieByID:obj.specieID.specieID moc:self.moc];
                                             
                                             NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:obj2,@"userSelectedSpecie", nil];
                                             [dlg.submitReportData addObject:dic];
                                         }
                                         
                                     }else{
                                         NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[allSpecies objectAtIndex:indexPath.row],@"userSelectedSpecie", nil];
                                         [dlg.submitReportData addObject:dic];
                                         
                                     }
                                     
                                     
                                     
                                     
                                     NSMutableArray *allControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                                     for (id object in allControllers) {
                                         if ([object isKindOfClass:[ReportDetailsViewController class]]) {
                                             [self.navigationController popToViewController:object animated:YES];
                                         }
                                     }
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        if (isUserSearching) {
            if ([dlg.languageISO isEqualToString:@"en"]) {
               
                [self proceedToDetails:[allSpecies objectAtIndex:indexPath.row]];
            }else{
                SpeciesTranslation *obj = [allSpecies objectAtIndex:indexPath.row];
                Species *obj2 = [Species getSpecieByID:obj.specieID.specieID moc:self.moc];
                [self proceedToDetails:obj2];
            }
        }else{
            [self proceedToDetails:[allSpecies objectAtIndex:indexPath.row]];
        }
        
    }
}

#pragma mark -
#pragma mark - UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.specieSearchTableView) {
        return searchSpecieArray.count;
    }else{
        return allSpecies.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.specieSearchTableView) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.backgroundColor = [UIColor darkGrayColor];
        AppDelegate *dlg = [UIApplication sharedApplication].delegate;
        if ([dlg.languageISO isEqualToString:@"en"]) {
            
            
            Species *currentObj = [searchSpecieArray objectAtIndex:indexPath.row];
            
            cell.textLabel.text = currentObj.specieCommonName;
        }
        else{
            Species *currentObj = [searchSpecieArray objectAtIndex:indexPath.row];
            SpeciesTranslation *obj2 = [SpeciesTranslation getSpecieTranslation:currentObj language:dlg.languageISO moc:self.moc];
            NSString *specieName = @"";
            if (obj2!=nil) {
                if ([obj2.specieCommonName isEqualToString:@""]) {
                    specieName = currentObj.specieCommonName;
                }else{
                    specieName = obj2.specieCommonName;
                }
            }else{
                specieName = currentObj.specieCommonName;
            }
            cell.textLabel.text = specieName;
            
        }
        
        return cell;
        
    }else{
        SpecieTableViewCell *cell =(SpecieTableViewCell*) [self.tableView dequeueReusableCellWithIdentifier:@"specieCell"];
        
        
        AppDelegate *dlg = [UIApplication sharedApplication].delegate;
        if ([dlg.languageISO isEqualToString:@"en"]) {
            Species *currentObj = [allSpecies objectAtIndex:indexPath.row];
            
            cell.specieName.text = currentObj.specieCommonName;
            cell.specieCites.text = currentObj.specieCities;
			cell.specieImage.image = [UIImage imageNamed:currentObj.specieImageUrl];
			if (cell.specieImage.image == nil) {
				cell.specieImage.image=  [UIImage imageWithContentsOfFile:currentObj.specieImageUrl];
				if (cell.specieImage.image == nil) {
					NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
					NSString *documentsDirectory = [paths objectAtIndex:0];
					cell.specieImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory,currentObj.specieImageUrl]];
                    NSLog(@"%@/%@",documentsDirectory, currentObj.specieImageUrl);
                }
			}
			
            cell.specieFavoriteBtn.tag = indexPath.row;
            cell.specieReportBtn.tag = indexPath.row;
            BOOL isFavorite = [currentObj.specieIsFavorite boolValue];
            if (isFavorite) {
                cell.specieFavoriteBtn.selected=YES;
            }else{
                cell.specieFavoriteBtn.selected=NO;
            }
            
        }else{
            if (isUserSearching) {
                SpeciesTranslation *obj2 = [allSpecies objectAtIndex:indexPath.row];
                NSString *sid, *sname = @"";
                sid = obj2.specieID.specieID;
                sname = obj2.specieID.specieCommonName;
                
                Species *currentObj = [Species getSpecieByID:obj2.specieID.specieID moc:self.moc];
                NSString *specieName = @"";
                if (obj2!=nil) {
                    if ([obj2.specieCommonName isEqualToString:@""]) {
                        specieName = currentObj.specieCommonName;
                    }else{
                        specieName = obj2.specieCommonName;
                    }
                }else{
                    specieName = currentObj.specieCommonName;
                }
                
                
                cell.specieName.text = specieName;
                cell.specieCites.text = currentObj.specieCities;
                
				cell.specieImage.image = [UIImage imageNamed:currentObj.specieImageUrl];
				if (cell.specieImage.image == nil) {
					cell.specieImage.image=  [UIImage imageWithContentsOfFile:currentObj.specieImageUrl];
				}
                cell.specieFavoriteBtn.tag = indexPath.row;
                cell.specieReportBtn.tag = indexPath.row;
                BOOL isFavorite = [currentObj.specieIsFavorite boolValue];
                if (isFavorite) {
                    cell.specieFavoriteBtn.selected=YES;
                }else{
                    cell.specieFavoriteBtn.selected=NO;
                }
            }else{
                Species *currentObj = [allSpecies objectAtIndex:indexPath.row];
                SpeciesTranslation *obj2 = [SpeciesTranslation getSpecieTranslation:currentObj language:dlg.languageISO moc:self.moc];
                NSString *specieName = @"";
                if (obj2!=nil) {
                    if ([obj2.specieCommonName isEqualToString:@""]) {
                        specieName = currentObj.specieCommonName;
                    }else{
                        specieName = obj2.specieCommonName;
                    }
                }else{
                    specieName = currentObj.specieCommonName;
                }
                
                
                cell.specieName.text = specieName;
                cell.specieCites.text = currentObj.specieCities;
                
				cell.specieImage.image = [UIImage imageNamed:currentObj.specieImageUrl];
				if (cell.specieImage.image == nil) {
					cell.specieImage.image=  [UIImage imageWithContentsOfFile:currentObj.specieImageUrl];
				}
                cell.specieFavoriteBtn.tag = indexPath.row;
                cell.specieReportBtn.tag = indexPath.row;
                BOOL isFavorite = [currentObj.specieIsFavorite boolValue];
                if (isFavorite) {
                    cell.specieFavoriteBtn.selected=YES;
                }else{
                    cell.specieFavoriteBtn.selected=NO;
                }
            }
            
        }
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *dlg = [[UIApplication sharedApplication] delegate];
    if (tableView == self.specieSearchTableView) {
        self.specieSearchTableView.hidden = YES;
        self.searchView.hidden = YES;
        
        
    }else{
        if (isSpecieForSubmitReport) {
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:NSLocalizedString(@"species_lib_select_dlg_text", @"")
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"species_lib_select_dlg_btn_details", @"")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     if (isUserSearching) {
                                         if ([dlg.languageISO isEqualToString:@"en"]) {
                                             
                                             
                                             SpeciesTranslation *obj = [allSpecies objectAtIndex:indexPath.row];
                                             Species *obj2 = [Species getSpecieByID:obj.specieID.specieID moc:self.moc];
                                             [self proceedToDetails:obj2];
                                         }else{
                                             SpeciesTranslation *obj = [allSpecies objectAtIndex:indexPath.row];
                                             Species *obj2 = [Species getSpecieByID:obj.specieID.specieID moc:self.moc];
                                             [self proceedToDetails:obj2];
                                         }
                                     }else{
                                         [self proceedToDetails:[allSpecies objectAtIndex:indexPath.row]];
                                     }
                                     
                                 }];
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:NSLocalizedString(@"species_lib_select_dlg_btn_select", @"")
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         AppDelegate *dlg = (AppDelegate*)[UIApplication sharedApplication].delegate;
                                         if (isUserSearching) {
                                             if (isUserSearching) {
                                                 
                                                 SpeciesTranslation *obj = [allSpecies objectAtIndex:indexPath.row];
                                                 Species *obj2 = [Species getSpecieByID:obj.specieID.specieID moc:self.moc];
                                                 [self proceedToDetails:obj2];
                                             }else{
                                                 SpeciesTranslation *obj = [allSpecies objectAtIndex:indexPath.row];
                                                 Species *obj2 = [Species getSpecieByID:obj.specieID.specieID moc:self.moc];
                                                 
                                                 NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:obj2,@"userSelectedSpecie", nil];
                                                 [dlg.submitReportData addObject:dic];
                                             }
                                             
                                         }else{
                                             NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[allSpecies objectAtIndex:indexPath.row],@"userSelectedSpecie", nil];
                                             [dlg.submitReportData addObject:dic];
                                             
                                         }
                                         NSMutableArray *allControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                                         for (id object in allControllers) {
                                             if ([object isKindOfClass:[ReportDetailsViewController class]]) {
                                                 [self.navigationController popToViewController:object animated:YES];
                                             }
                                         }
                                         
                                     }];
            
            [alert addAction:ok];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            if (isUserSearching) {
                if ([dlg.languageISO isEqualToString:@"en"]) {
                    [self proceedToDetails:[allSpecies objectAtIndex:indexPath.row]];
                }else{
                    SpeciesTranslation *obj = [allSpecies objectAtIndex:indexPath.row];
                    Species *obj2 = [Species getSpecieByID:obj.specieID.specieID moc:self.moc];
                    [self proceedToDetails:obj2];
                }
            }else{
                [self proceedToDetails:[allSpecies objectAtIndex:indexPath.row]];
            }
            
        }
        
    }
}
-(void)proceedToDetails:(Species*)obj{
    
    SpecieDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"specieDetailVC"];
    vc.moc = self.moc;
    vc.currentSpecie = obj;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnAnimalTypesPressed:(id)sender {
    self.specieTypeView.hidden = NO;
}
- (IBAction)btnFilterSpeciePressed:(id)sender {
    UIButton *pressedBtn = (UIButton*)sender;
    NSInteger buttonIndex = pressedBtn.tag;
    [allSpecies removeAllObjects];
    switch (buttonIndex) {
        case 0:
            
            allSpecies = [NSMutableArray arrayWithArray:[Species getAllSpecies:self.moc]];
            [self.btnSelectedCategory setTitle:NSLocalizedString(@"species_filters_all", @"") forState:UIControlStateNormal];
            break;
        case 1:
            
            allSpecies = [NSMutableArray arrayWithArray:[Species getAllSpecieWithType:@"Mammal" moc:self.moc]];
            [self.btnSelectedCategory setTitle:NSLocalizedString(@"species_filters_mammal", @"") forState:UIControlStateNormal];
            break;
        case 2:
            allSpecies = [NSMutableArray arrayWithArray:[Species getAllSpecieWithType:@"Bird" moc:self.moc]];
            [self.btnSelectedCategory setTitle:NSLocalizedString(@"species_filters_bird", @"") forState:UIControlStateNormal];
            break;
        case 3:
            allSpecies = [NSMutableArray arrayWithArray:[Species getAllSpecieWithType:@"Fish" moc:self.moc]];
            [self.btnSelectedCategory setTitle:NSLocalizedString(@"species_filters_fish", @"")forState:UIControlStateNormal];
            break;
        case 4:
            allSpecies = [NSMutableArray arrayWithArray:[Species getAllSpecieWithType:@"Reptile" moc:self.moc]];
            [self.btnSelectedCategory setTitle:NSLocalizedString(@"species_filters_reptile", @"") forState:UIControlStateNormal];
            break;
        case 5:
            allSpecies = [NSMutableArray arrayWithArray:[Species getAllSpecieWithType:@"Amphibian" moc:self.moc]];
            [self.btnSelectedCategory setTitle:NSLocalizedString(@"species_filters_amphibian", @"") forState:UIControlStateNormal];
            break;
        case 6:
            allSpecies = [NSMutableArray arrayWithArray:[Species getAllSpecieWithType:@"Invertebrate" moc:self.moc]];
            [self.btnSelectedCategory setTitle:NSLocalizedString(@"species_filters_invetebrate", @"") forState:UIControlStateNormal];
            break;
        case 8:
            allSpecies = [NSMutableArray arrayWithArray:[Species getAllSpecieWithType:@"Derivative product" moc:self.moc]];
            [self.btnSelectedCategory setTitle:NSLocalizedString(@"species_filters_product", @"") forState:UIControlStateNormal];
            break;
        case 9:
            allSpecies = [NSMutableArray arrayWithArray:[Species getAllSpecieWithType:@"Close Specie" moc:self.moc]];
            [self.btnSelectedCategory setTitle:NSLocalizedString(@"species_filters_close_species", @"") forState:UIControlStateNormal];
            break;
        case 7:
            allSpecies = [NSMutableArray arrayWithArray:[Species getAllSpecieWithType:@"Plant" moc:self.moc]];
            [self.btnSelectedCategory setTitle:NSLocalizedString(@"species_filters_plants", @"") forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    self.searchView.hidden = YES;
    self.specieTypeView.hidden = YES;
    [self.collectionView reloadData];
    [self.tableView reloadData];
}

- (IBAction)btnSearchPressed:(id)sender {
    self.searchView.hidden = NO;
}


#pragma mark -
#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (void)textFieldValueChanged:(NSNotification*)notification
{
    UITextField  *txtField = notification.object;
    if (txtField == self.txtSpeciesName && txtField.text.length>1) {
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"caseNumber CONTAINS[cd] %@", txtField.text];
        //self.filteredCases = [self.allCases filteredArrayUsingPredicate:predicate];
        
        [self specieTextValueChanged];
        
        
    }if(txtField.text.length==0){
        isUserSearching = NO;
        allSpecies = [NSMutableArray arrayWithArray:[Species getAllSpecies:self.moc]];
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }
}
-(void)specieTextValueChanged{
    [searchSpecieArray removeAllObjects];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Species" inManagedObjectContext:self.moc];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"specieCommonName CONTAINS[cd] %@", self.txtSpeciesName.text];
    [fetchRequest setPredicate:predicate];
    AppDelegate *dlg = [UIApplication sharedApplication].delegate;
    NSArray *filterArray = [[NSArray alloc]init];
    if ([dlg.languageISO isEqualToString:@"en"]) {
        filterArray = [allSpeciesForSearch filteredArrayUsingPredicate:predicate];
    }else{
        allSpeciesForSearch = [NSMutableArray arrayWithArray:[SpeciesTranslation getAllSpeciesTranslations:dlg.languageISO moc:self.moc]];
        filterArray = [allSpeciesForSearch filteredArrayUsingPredicate:predicate];
    }
    
    if (filterArray.count == 0) {
        predicate = [NSPredicate predicateWithFormat:@"specieKnownAs CONTAINS[cd] %@",self.txtSpeciesName.text];
        filterArray = [allSpeciesForSearch filteredArrayUsingPredicate:predicate];
    }
    
    searchSpecieArray = [NSMutableArray arrayWithArray:filterArray];
    if ([searchSpecieArray count]>0) {
        isUserSearching = YES;
        [allSpecies removeAllObjects];
        allSpecies = [NSMutableArray arrayWithArray:filterArray];
        [self.tableView reloadData];
        [self.collectionView reloadData];
        
    }else{
        
    }
}
#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([self.searchView isHidden]) {
        if ([touch.view isDescendantOfView:self.tableView] || [touch.view isDescendantOfView:self.specieSearchTableView] || [touch.view isDescendantOfView:self.collectionView]) {
            
            // Don't let selections of auto-complete entries fire the
            // gesture recognizer
            return NO;
        }
    }
    
    return YES;
}

@end
