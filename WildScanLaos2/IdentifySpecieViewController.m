//
//  IdentifySpecieViewController.m
//  WildScan
//
//  Created by Shabir Jan on 07/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "IdentifySpecieViewController.h"
#import "IdentifySpecieCollectionViewCell.h"
#import "SpeciesLibraryViewController.h"
@interface IdentifySpecieViewController ()
@property (nonatomic)BOOL isIntactAnimalPressed;
@property (nonatomic)BOOL isAnimalPartPressed;
@property (nonatomic)BOOL isPlantPressed;
@property (nonatomic)BOOL isSFFSOSelected;
@property (nonatomic)BOOL isColorSelected;
@property (nonatomic)BOOL isAnimalPartSubItemSelected;
@property (nonatomic)BOOL isAnimalProductSelected;
@property (nonatomic)BOOL isPlantFormSelected;
@property (nonatomic)BOOL isPlantPurposeSelected;


@property (nonatomic,strong)NSMutableArray *animalBodyPartArray;
@property (nonatomic,strong)NSMutableArray *intactAnimalsArray;
@property (nonatomic,strong)NSMutableArray *animalsPartArray;
@property (nonatomic,strong)NSMutableArray *plantFormArray;
@property (nonatomic,strong)NSMutableArray *plantPurposeArray;
@property (nonatomic,strong)NSMutableArray *colorsArray;
@property (nonatomic,strong)NSMutableArray *sizeArray;
@property (nonatomic,strong)NSMutableArray *animalProductArray;
@property (nonatomic,strong)NSMutableArray *queryBuilder;
@end

@implementation IdentifySpecieViewController
@synthesize isIntactAnimalPressed,isAnimalPartPressed,isSFFSOSelected,isColorSelected,isAnimalPartSubItemSelected,isAnimalProductSelected, isPlantPressed, isPlantFormSelected, isPlantPurposeSelected;
@synthesize isSubmitReportView;

@synthesize animalsPartArray,intactAnimalsArray,colorsArray,sizeArray,animalProductArray,animalBodyPartArray,queryBuilder, plantFormArray, plantPurposeArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    isSFFSOSelected = false;
    isIntactAnimalPressed = false;
    isAnimalPartPressed = false;
    isColorSelected = false;
    isAnimalPartSubItemSelected = false;
    isAnimalProductSelected = false;
    isPlantPressed = false;
    isPlantFormSelected = false;
    isPlantPurposeSelected = false;
    
    queryBuilder = [NSMutableArray new];
    intactAnimalsArray = [NSMutableArray new];
    animalsPartArray = [NSMutableArray new];
    colorsArray = [NSMutableArray new];
    sizeArray = [NSMutableArray new];
    animalProductArray = [NSMutableArray new];
    animalBodyPartArray = [NSMutableArray new];
    plantFormArray = [NSMutableArray new];
    plantPurposeArray = [NSMutableArray new];
    
    NSDictionary *scales = [NSDictionary dictionaryWithObjectsAndKeys:@"Scales",@"name",@"id_q_cover_scales",@"image",NSLocalizedString(@"id_wizard_covering_scales", @""),@"displayName", nil];
    NSDictionary *fur = [NSDictionary dictionaryWithObjectsAndKeys:@"Fur",@"name",@"id_q_cover_fur",@"image",NSLocalizedString(@"id_wizard_covering_fur", @""),@"displayName", nil];
    NSDictionary *feathers = [NSDictionary dictionaryWithObjectsAndKeys:@"Feathers",@"name",@"id_q_cover_feathers",@"image",NSLocalizedString(@"id_wizard_covering_feathers", @""),@"displayName", nil];
    NSDictionary *skin = [NSDictionary dictionaryWithObjectsAndKeys:@"Skin",@"name",@"id_q_cover_skin",@"image",NSLocalizedString(@"id_wizard_covering_skin", @""),@"displayName", nil];
    NSDictionary *other = [NSDictionary dictionaryWithObjectsAndKeys:@"Other/Not sure",@"name",@"id_unk",@"image",NSLocalizedString(@"id_wizard_covering_not_sure", @""),@"displayName", nil];
    [intactAnimalsArray addObject:scales];
    [intactAnimalsArray addObject:fur];
    [intactAnimalsArray addObject:feathers];
    [intactAnimalsArray addObject:skin];
    [intactAnimalsArray addObject:other];
    
    
    
    NSDictionary *food = [NSDictionary dictionaryWithObjectsAndKeys:@"Food",@"name",@"id_q_purpose_food",@"image",NSLocalizedString(@"id_wizard_purpose_food", @""),@"displayName", nil];
    NSDictionary *clothing = [NSDictionary dictionaryWithObjectsAndKeys:@"Clothing",@"name",@"id_q_purpose_clothing",@"image",NSLocalizedString(@"id_wizard_purpose_clothing", @""),@"displayName", nil];
    NSDictionary *jewelry = [NSDictionary dictionaryWithObjectsAndKeys:@"Jewelry",@"name",@"id_q_purpose_jewelery",@"image",NSLocalizedString(@"id_wizard_purpose_jewelry", @""),@"displayName", nil];
    NSDictionary *trophy = [NSDictionary dictionaryWithObjectsAndKeys:@"Trophy/ornament",@"name",@"id_q_purpose_ornament",@"image",NSLocalizedString(@"id_wizard_purpose_trophy", @""),@"displayName", nil];
    NSDictionary *medicine = [NSDictionary dictionaryWithObjectsAndKeys:@"Medicine",@"name",@"id_q_purpose_medicine",@"image",NSLocalizedString(@"id_wizard_purpose_medicine", @""),@"displayName", nil];
    [animalsPartArray addObject:food];
    [animalsPartArray addObject:clothing];
    [animalsPartArray addObject:jewelry];
    [animalsPartArray addObject:trophy];
    [animalsPartArray addObject:medicine];
    [animalsPartArray addObject:other];
    
    
    
    NSDictionary *red = [NSDictionary dictionaryWithObjectsAndKeys:@"Red",@"name",@"id_q_color_red",@"image",NSLocalizedString(@"id_wizard_color_red", @""),@"displayName", nil];
    NSDictionary *orange = [NSDictionary dictionaryWithObjectsAndKeys:@"Orange",@"name",@"id_q_color_orange",@"image",NSLocalizedString(@"id_wizard_color_orange", @""),@"displayName", nil];
    NSDictionary *yellow = [NSDictionary dictionaryWithObjectsAndKeys:@"Yellow",@"name",@"id_q_color_yellow",@"image",NSLocalizedString(@"id_wizard_color_yellow", @""),@"displayName", nil];
    NSDictionary *green = [NSDictionary dictionaryWithObjectsAndKeys:@"Green",@"name",@"id_q_color_green",@"image",NSLocalizedString(@"id_wizard_color_green", @""),@"displayName", nil];
    NSDictionary *blue= [NSDictionary dictionaryWithObjectsAndKeys:@"Blue",@"name",@"id_q_color_blue",@"image",NSLocalizedString(@"id_wizard_color_blue", @""),@"displayName", nil];
    NSDictionary *purple= [NSDictionary dictionaryWithObjectsAndKeys:@"Purple",@"name",@"id_q_color_purple",@"image",NSLocalizedString(@"id_wizard_color_purple", @""),@"displayName", nil];
    NSDictionary *gray= [NSDictionary dictionaryWithObjectsAndKeys:@"Gray",@"name",@"id_q_color_gray",@"image",NSLocalizedString(@"id_wizard_color_gray", @""),@"displayName", nil];
    NSDictionary *brown= [NSDictionary dictionaryWithObjectsAndKeys:@"Brown",@"name",@"id_q_color_brown",@"image",NSLocalizedString(@"id_wizard_color_brown", @""),@"displayName", nil];
    NSDictionary *white= [NSDictionary dictionaryWithObjectsAndKeys:@"White",@"name",@"id_q_color_white",@"image",NSLocalizedString(@"id_wizard_color_white", @""),@"displayName", nil];
    NSDictionary *black= [NSDictionary dictionaryWithObjectsAndKeys:@"Black",@"name",@"id_q_color_black",@"image",NSLocalizedString(@"id_wizard_color_not_sure", @""),@"displayName", nil];
    
    
    [colorsArray addObject:red];
    [colorsArray addObject:orange];
    [colorsArray addObject:yellow];
    [colorsArray addObject:green];
    [colorsArray addObject:blue];
    [colorsArray addObject:purple];
    [colorsArray addObject:gray];
    [colorsArray addObject:brown];
    [colorsArray addObject:white];
    [colorsArray addObject:black];
    [colorsArray addObject:other];
    
    NSDictionary *smallerThanHand = [NSDictionary dictionaryWithObjectsAndKeys:@"Smaller than your hand",@"name",@"id_q_size_tiny",@"image",NSLocalizedString(@"id_wizard_size_small_hand", @""),@"displayName", nil];
    NSDictionary *smallerThanDog = [NSDictionary dictionaryWithObjectsAndKeys:@"Smaller than average dog",@"name",@"id_q_size_small",@"image",NSLocalizedString(@"id_wizard_size_average_dog", @""),@"displayName", nil];
    NSDictionary *smallerThanYou = [NSDictionary dictionaryWithObjectsAndKeys:@"Smaller than you",@"name",@"id_q_size_medium",@"image",NSLocalizedString(@"id_wizard_size_smaller_than_you", @""),@"displayName", nil];
    NSDictionary *largerThanYou = [NSDictionary dictionaryWithObjectsAndKeys:@"Larger than you",@"name",@"id_q_size_large",@"image",NSLocalizedString(@"id_wizard_size_larger_than_you", @""),@"displayName", nil];
    NSDictionary *notSure= [NSDictionary dictionaryWithObjectsAndKeys:@"Not sure",@"name",@"id_q_size_unk",@"image",NSLocalizedString(@"id_wizard_size_not_sure", @""),@"displayName", nil];
    
    [sizeArray addObject:smallerThanHand];
    [sizeArray addObject:smallerThanDog];
    [sizeArray addObject:smallerThanYou];
    [sizeArray addObject:largerThanYou];
    [sizeArray addObject:notSure];
    
    NSDictionary *bone = [NSDictionary dictionaryWithObjectsAndKeys:@"Bone",@"name",@"id_q_material_bone",@"image",NSLocalizedString(@"id_wizard_material_bone", @""),@"displayName", nil];
    NSDictionary *pelt = [NSDictionary dictionaryWithObjectsAndKeys:@"Pelt/leather",@"name",@"id_q_material_leather",@"image",NSLocalizedString(@"id_wizard_material_pelt", @""),@"displayName", nil];
    NSDictionary *shell = [NSDictionary dictionaryWithObjectsAndKeys:@"Shell",@"name",@"id_q_material_shell",@"image",NSLocalizedString(@"id_wizard_material_shell", @""),@"displayName", nil];
    NSDictionary *powder = [NSDictionary dictionaryWithObjectsAndKeys:@"Powder",@"name",@"id_q_material_powder",@"image",NSLocalizedString(@"id_wizard_material_poweder", @""),@"displayName", nil];
    NSDictionary *meat = [NSDictionary dictionaryWithObjectsAndKeys:@"Meat",@"name",@"id_q_material_meat",@"image",NSLocalizedString(@"id_wizard_material_meat", @""),@"displayName", nil];
    
    [animalProductArray addObject:bone];
    [animalProductArray addObject:pelt];
    [animalProductArray addObject:shell];
    [animalProductArray addObject:powder];
    [animalProductArray addObject:meat];
    [animalProductArray addObject:other];
    
    
    NSDictionary *horn = [NSDictionary dictionaryWithObjectsAndKeys:@"Horn",@"name",@"id_q_part_horn",@"image",NSLocalizedString(@"id_wizard_part_horn", @""),@"displayName", nil];
    NSDictionary *tusk = [NSDictionary dictionaryWithObjectsAndKeys:@"Tusk",@"name",@"id_q_part_tusk",@"image",NSLocalizedString(@"id_wizard_part_tusk", @""),@"displayName", nil];
    NSDictionary *skins = [NSDictionary dictionaryWithObjectsAndKeys:@"Skin",@"name",@"id_q_part_skin",@"image", NSLocalizedString(@"id_wizard_part_skin", @""),@"displayName",nil];
    NSDictionary *paw = [NSDictionary dictionaryWithObjectsAndKeys:@"Paw",@"name",@"id_q_part_paw",@"image",NSLocalizedString(@"id_wizard_part_paw", @""),@"displayName", nil];
    NSDictionary *claw = [NSDictionary dictionaryWithObjectsAndKeys:@"Tooth/claw",@"name",@"id_q_part_tooth",@"image",NSLocalizedString(@"id_wizard_part_claw", @""),@"displayName", nil];
    
    [animalBodyPartArray addObject:horn];
    [animalBodyPartArray addObject:tusk];
    [animalBodyPartArray addObject:skins];
    [animalBodyPartArray addObject:paw];
    [animalBodyPartArray addObject:claw];
    [animalBodyPartArray addObject:other];
    
    NSDictionary *plant_intact = [NSDictionary dictionaryWithObjectsAndKeys:@"Plant Intact",@"name",@"id_q_p_form_intact",@"image",NSLocalizedString(@"id_wizard_plant_form_intact", @""),@"displayName", nil];
    NSDictionary *plant_timber = [NSDictionary dictionaryWithObjectsAndKeys:@"Plant Timber",@"name",@"id_q_p_form_timber",@"image",NSLocalizedString(@"id_wizard_plant_form_timber", @""),@"displayName", nil];
    NSDictionary *plant_article = [NSDictionary dictionaryWithObjectsAndKeys:@"Plant Article",@"name",@"id_q_p_form_article",@"image",NSLocalizedString(@"id_wizard_plant_form_article", @""),@"displayName", nil];
    NSDictionary *plant_other = [NSDictionary dictionaryWithObjectsAndKeys:@"Plant Other/Not sure",@"name",@"id_unk",@"image",NSLocalizedString(@"id_wizard_plant_form_other", @""),@"displayName", nil];
    [plantFormArray addObject:plant_intact];
    [plantFormArray addObject:plant_timber];
    [plantFormArray addObject:plant_article];
    [plantFormArray addObject:plant_other];
    
    
    NSDictionary *plant_purpose_food = [NSDictionary dictionaryWithObjectsAndKeys:@"Plant Purpose  Food",@"name",@"id_q_p_purpose_food",@"image",NSLocalizedString(@"id_wizard_plant_purpose_food", @""),@"displayName", nil];
    NSDictionary *plant_purpose_furniture = [NSDictionary dictionaryWithObjectsAndKeys:@"Plant Purpose Furniture",@"name",@"id_q_p_purpose_furniture",@"image",NSLocalizedString(@"id_wizard_plant_purpose_furniture", @""),@"displayName", nil];
    NSDictionary *plant_purpose_ornament = [NSDictionary dictionaryWithObjectsAndKeys:@"Plant Purpose Ornament",@"name",@"id_q_p_purpose_ornament",@"image",NSLocalizedString(@"id_wizard_plant_purpose_ornament", @""),@"displayName", nil];
    NSDictionary *plant_purpose_medicine = [NSDictionary dictionaryWithObjectsAndKeys:@"Plant Purpose Medicine",@"name",@"id_q_p_purpose_medicine",@"image",NSLocalizedString(@"id_wizard_plant_purpose_medicine", @""),@"displayName", nil];
    NSDictionary *plant_purpose_article = [NSDictionary dictionaryWithObjectsAndKeys:@"Plant Purpose Article",@"name",@"id_q_p_purpose_article",@"image",NSLocalizedString(@"id_wizard_plant_purpose_article", @""),@"displayName", nil];
    NSDictionary *plant_purpose_other = [NSDictionary dictionaryWithObjectsAndKeys:@"Plant Purpose Other/Not sure",@"name",@"id_unk",@"image",NSLocalizedString(@"id_wizard_plant_purpose_other", @""),@"displayName", nil];
    [plantPurposeArray addObject:plant_purpose_food];
    [plantPurposeArray addObject:plant_purpose_furniture];
    [plantPurposeArray addObject:plant_purpose_ornament];
    [plantPurposeArray addObject:plant_purpose_medicine];
    [plantPurposeArray addObject:plant_purpose_article];
    [plantPurposeArray addObject:plant_purpose_other];


    self.lblDescription.text = self.descriptionText;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)btnIntactAnimalPressed:(id)sender {
    self.lblDescription.text =NSLocalizedString(@"id_wizard_questions_primary_covering", @"");
    [queryBuilder addObject:@"animal"];
    isIntactAnimalPressed = true;
    isAnimalPartPressed = false;
    isPlantPressed = false;
    [self.backImage setHidden:NO];
    [self.identifyCV setHidden:NO];
    [self.identifyCV reloadData];
    
}

- (IBAction)btnAnimalProductPressed:(id)sender {
    self.lblDescription.text =NSLocalizedString(@"id_wizard_questions_part_product", @"");
    [queryBuilder addObject:@"product"];
    isIntactAnimalPressed = false;
    isAnimalPartPressed = true;
    isPlantPressed = false;
    [self.backImage setHidden:NO];
    [self.identifyCV setHidden:NO];
    [self.identifyCV reloadData];
}

- (IBAction)btnPlantFormPressed:(id)sender {
    self.lblDescription.text =NSLocalizedString(@"id_wizard_questions_plant_form", @"");
    [queryBuilder addObject:@"plant"];
    isIntactAnimalPressed = false;
    isAnimalPartPressed = false;
    isPlantPressed = false;
    isPlantFormSelected = true;
    [self.backImage setHidden:NO];
    [self.identifyCV setHidden:NO];
    [self.identifyCV reloadData];
}

#pragma mark -
#pragma mark - UICollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.firstCollectionView) {
        return  3;
    }
    else {
        if (isIntactAnimalPressed){
            return intactAnimalsArray.count;
        }
        else if (isAnimalPartPressed) {
            return animalsPartArray.count;
        }
        else if (isAnimalProductSelected){
            return  animalBodyPartArray.count;
        }
        else if (isPlantPressed){
            return plantFormArray.count;
        }
        else if (isSFFSOSelected){
            return colorsArray.count;
        }
        else if (isColorSelected){
            return sizeArray.count;
        }
        else if (isAnimalPartSubItemSelected){
            return  animalProductArray.count;
        }
        else if (isAnimalProductSelected){
            return  animalBodyPartArray.count;
        }
        else if (isPlantFormSelected){
            return  plantPurposeArray.count;
        }
    }
    return 0;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.firstCollectionView) {
        IdentifySpecieCollectionViewCell *cell = [self.firstCollectionView dequeueReusableCellWithReuseIdentifier:@"identifyCell1" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.identifyImage.image = [UIImage imageNamed:@"id_q_prod_ani_animal"];
            cell.lblIdentify.text = NSLocalizedString(@"id_wizard_prod_ani_intact_animal", @"");
        }
        else if (indexPath.row == 1) {
            cell.identifyImage.image = [UIImage imageNamed:@"id_q_prod_ani_product"];
            cell.lblIdentify.text = NSLocalizedString(@"id_wizard_prod_ani_animal_part_product", @"");
        }
        else {
            cell.identifyImage.image = [UIImage imageNamed:@"id_q_plant"];
            cell.lblIdentify.text = NSLocalizedString(@"id_wizard_prod_ani_plant", @"");
        }
        return cell;
        
    }else{
        IdentifySpecieCollectionViewCell *cell = [self.identifyCV dequeueReusableCellWithReuseIdentifier:@"identifyCell" forIndexPath:indexPath];
        
        NSDictionary *currentObj ;
        if (isIntactAnimalPressed) {
            currentObj = [intactAnimalsArray objectAtIndex:indexPath.row];
        }
        else if (isAnimalPartPressed) {
            currentObj = [animalsPartArray objectAtIndex:indexPath.row];
        }
        else if (isPlantPressed){
            currentObj = [plantFormArray objectAtIndex:indexPath.row];
        }
        else if (isSFFSOSelected){
            currentObj = [colorsArray objectAtIndex:indexPath.row];
        }
        else if (isColorSelected){
            currentObj = [sizeArray objectAtIndex:indexPath.row];
        }
        else if (isAnimalPartSubItemSelected){
            currentObj = [animalProductArray objectAtIndex:indexPath.row];
        }
        else if (isAnimalProductSelected){
            currentObj = [animalBodyPartArray objectAtIndex:indexPath.row];
        }
        else if (isPlantFormSelected){
            currentObj = [plantPurposeArray objectAtIndex:indexPath.row];
        }
        cell.identifyImage.image = [UIImage imageNamed:[currentObj valueForKey:@"image"]];
        cell.lblIdentify.text = [currentObj valueForKey:@"displayName"];
        return cell;
    }
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
        CGSize size = CGSizeMake(cellWidth, 150);
        
        return size;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.firstCollectionView) {
        self.firstCollectionView.hidden = YES;
        if (indexPath.row == 0) {
            
            self.lblDescription.text =NSLocalizedString(@"id_wizard_questions_primary_covering", @"");
            [queryBuilder addObject:@"animal"];
            isIntactAnimalPressed = true;
            isAnimalPartPressed = false;
            isPlantPressed = false;
            [self.backImage setHidden:NO];
            [self.identifyCV setHidden:NO];
            [self.identifyCV reloadData];
        }
        else if (indexPath.row == 1) {
            self.lblDescription.text =NSLocalizedString(@"id_wizard_questions_part_product", @"");
            [queryBuilder addObject:@"product"];
            isIntactAnimalPressed = false;
            isAnimalPartPressed = true;
            isPlantPressed = false;
            [self.backImage setHidden:NO];
            [self.identifyCV setHidden:NO];
            [self.identifyCV reloadData];
        }
        else{
            self.lblDescription.text =NSLocalizedString(@"id_wizard_questions_plant_form", @"");
            [queryBuilder addObject:@"plant"];
            isIntactAnimalPressed = false;
            isAnimalPartPressed = false;
            isPlantPressed = true;
            [self.backImage setHidden:NO];
            [self.identifyCV setHidden:NO];
            [self.identifyCV reloadData];
        }
    }else{
        NSDictionary *currentObj ;
        if (isIntactAnimalPressed) {
            currentObj = [intactAnimalsArray objectAtIndex:indexPath.row];
            if ([[currentObj valueForKey:@"name"] isEqualToString:@"Scales"] ||[[currentObj valueForKey:@"name"] isEqualToString:@"Fur"] || [[currentObj valueForKey:@"name"] isEqualToString:@"Feathers"]  || [[currentObj valueForKey:@"name"] isEqualToString:@"Skin"] || [[currentObj valueForKey:@"name"] isEqualToString:@"Other/Not sure"]) {
                if ([[currentObj valueForKey:@"name"] isEqualToString:@"Other/Not sure"]) {
                    
                }else{
                    [queryBuilder addObject:[[currentObj valueForKey:@"name"] lowercaseString]];
                }
                self.lblDescription.text = NSLocalizedString(@"id_wizard_questions_color", @"");
                isSFFSOSelected = true;
                self.isAnimalPartPressed = false;
                self.isIntactAnimalPressed = false;
                [self.identifyCV reloadData];
                
            }
        }
        else if (isAnimalPartPressed){
            currentObj = [animalsPartArray objectAtIndex:indexPath.row];
            if ([[currentObj valueForKey:@"name"]isEqualToString:@"Other/Not sure"]) {
                
            }else{
                [queryBuilder addObject:[[currentObj valueForKey:@"name"] lowercaseString]];
            }
            self.lblDescription.text = NSLocalizedString(@"id_wizard_questions_material", @"");
            isSFFSOSelected = false;
            self.isAnimalPartPressed = false;
            self.isIntactAnimalPressed = false;
            self.isColorSelected = false;
            self.isAnimalPartSubItemSelected = true;
            [self.identifyCV reloadData];
        }
        else if (isPlantPressed) {
            currentObj = [plantFormArray objectAtIndex:indexPath.row];
            if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_form_intact", @"")]) {
                [queryBuilder addObject:@"intact"];
            }
            else if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_form_timber", @"")]){
                [queryBuilder addObject:@"timber"];
            }
            else if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_form_article", @"")]){
                [queryBuilder addObject:@"articles"];
            }
            if ([[currentObj valueForKey:@"name"]isEqualToString:@"Other/Not sure"]) {
                [queryBuilder addObject:@"other"];
            }
            self.lblDescription.text = NSLocalizedString(@"id_wizard_questions_plant_purpose", @"");
            isAnimalPartPressed = false;
            isIntactAnimalPressed = false;
            isPlantFormSelected = true;
            isPlantPurposeSelected = false;
            isPlantPressed = false;
            [self.identifyCV reloadData];
        }
        else if (isAnimalPartSubItemSelected){
            currentObj = [animalProductArray objectAtIndex:indexPath.row];
            if ([[currentObj valueForKey:@"name"]isEqualToString:@"Other/Not sure"]) {
                
            }else{
                [queryBuilder addObject:[[currentObj valueForKey:@"name"] lowercaseString]];
            }
            self.lblDescription.text = NSLocalizedString(@"id_wizard_questions_body_part", @"");
            isSFFSOSelected = false;
            self.isAnimalPartPressed = false;
            self.isIntactAnimalPressed = false;
            self.isColorSelected = false;
            self.isAnimalPartSubItemSelected = false;
            self.isAnimalProductSelected = true;
            [self.identifyCV reloadData];
        }
        else if (self.isAnimalProductSelected) {
            self.isAnimalProductSelected = false;
            currentObj = [animalBodyPartArray objectAtIndex:indexPath.row];
            [queryBuilder addObject:[[currentObj valueForKey:@"name"] lowercaseString]];
            [self btnIdentifyPressed:self];
        }
        else if (isSFFSOSelected){
            currentObj = [colorsArray objectAtIndex:indexPath.row];
            if ([[currentObj valueForKey:@"name"] isEqualToString:@"Other/Not sure"]) {
                
            }else{
                [queryBuilder addObject:[[currentObj valueForKey:@"name"] lowercaseString]];
            }
            self.lblDescription.text = NSLocalizedString(@"id_wizard_questions_size", @"");
            isSFFSOSelected = false;
            self.isAnimalPartPressed = false;
            self.isIntactAnimalPressed = false;
            self.isColorSelected = true;
            [self.identifyCV reloadData];
            
        }
        else if (isColorSelected){
            currentObj = [sizeArray objectAtIndex:indexPath.row];
            if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_size_small_hand", @"")]) {
                [queryBuilder addObject:@"tiny"];
            }else if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_size_average_dog", @"")]){
                [queryBuilder addObject:@"small"];
            }else if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_size_smaller_than_you", @"")]){
                [queryBuilder addObject:@"medium"];
            }else if ([[currentObj valueForKey:@"displayName"]isEqualToString:NSLocalizedString(@"id_wizard_size_larger_than_you", @"")]){
                [queryBuilder addObject:@"large"];
            }
            
            self.lblDescription.text = NSLocalizedString(@"id_wizard_questions_special_features", @"");
            isSFFSOSelected = false;
            self.isAnimalPartPressed = false;
            self.isIntactAnimalPressed = false;
            self.identifyCV.hidden = true;
            self.specialFeatureView.hidden= false;
        }
        else if (isPlantFormSelected) {
            currentObj = [plantPurposeArray objectAtIndex:indexPath.row];
            if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_purpose_food", @"")]) {
                [queryBuilder addObject:@"food"];
            }
            else if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_purpose_furniture", @"")]){
                [queryBuilder addObject:@"furniture"];
            }
            else if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_purpose_ornament", @"")]){
                [queryBuilder addObject:@"ornament"];
            }
            else if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_purpose_medicine", @"")]){
                [queryBuilder addObject:@"medicine"];
            }
            else if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_purpose_article", @"")]){
                [queryBuilder addObject:@"articles"];
            }
            else if ([[currentObj valueForKey:@"displayName"]isEqualToString:NSLocalizedString(@"id_wizard_purpose_other", @"")]){
                [queryBuilder addObject:@"other"];
            }
            [self btnIdentifyPressed:self];
        }
/*
            currentObj = [plantFormArray objectAtIndex:indexPath.row];
            if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_form_intact", @"")]) {
                [queryBuilder addObject:@"intact"];
            }
            else if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_form_timber", @"")]){
                [queryBuilder addObject:@"timber"];
            }
            else if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_form_article", @"")]){
                [queryBuilder addObject:@"articles"];
            }
            else if ([[currentObj valueForKey:@"displayName"]isEqualToString:NSLocalizedString(@"id_wizard_plant_other", @"")]){
                [queryBuilder addObject:@"other"];
            }
            self.lblDescription.text = NSLocalizedString(@"id_wizard_questions_plant_purpose", @"");
            self.isPlantFormSelected = false;
            self.isPlantPurposeSelected = true;
            [self.identifyCV reloadData];
        }
        else if (isPlantPurposeSelected) {
            currentObj = [plantPurposeArray objectAtIndex:indexPath.row];
            if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_purpose_food", @"")]) {
                [queryBuilder addObject:@"intact"];
            }
            else if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_purpose_furniture", @"")]){
                [queryBuilder addObject:@"timber"];
            }
            else if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_purpose_ornament", @"")]){
                [queryBuilder addObject:@"ornament"];
            }
            else if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_purpose_medicine", @"")]){
                [queryBuilder addObject:@"medicine"];
            }
            else if ([[currentObj valueForKey:@"displayName"] isEqualToString:NSLocalizedString(@"id_wizard_plant_purpose_article", @"")]){
                [queryBuilder addObject:@"articles"];
            }
            else if ([[currentObj valueForKey:@"displayName"]isEqualToString:NSLocalizedString(@"id_wizard_purpose_other", @"")]){
                [queryBuilder addObject:@"other"];
            }
            [self btnIdentifyPressed:self];
        }
  */
    }
}

- (IBAction)btnTailPressed:(id)sender {
    [self.btnTail setSelected:!self.btnTail.isSelected];
    [queryBuilder addObject:@"tail"];
}

- (IBAction)btnWingsPressed:(id)sender {
    [self.btnWings setSelected:!self.btnWings.isSelected];
    [queryBuilder addObject:@"wings"];
}

- (IBAction)btnBeakPressed:(id)sender {
    [self.btnBeak setSelected:!self.btnBeak.isSelected];
    [queryBuilder addObject:@"beak"];
}

- (IBAction)btnShellPressed:(id)sender {
    [self.btnShell setSelected:!self.btnShell.isSelected];
    [queryBuilder addObject:@"shell"];
}

- (IBAction)btnFinPressed:(id)sender {
    [self.btnFins setSelected:!self.btnFins.isSelected];
    [queryBuilder addObject:@"fins"];
}

- (IBAction)btnCancelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnIdentifyPressed:(id)sender {
    NSMutableString *queryString =[[NSMutableString alloc]init];
    NSString *QueryString1 = [queryBuilder firstObject];
    [queryString appendString:[NSString stringWithFormat:@"(specieKeywordTags CONTAINS[cd] \"%@\")",QueryString1]];
    for (NSString *query in queryBuilder) {
        if ([QueryString1 isEqualToString:query]) {
            
        }else{
            if (![query isEqualToString:@"other/not sure"]) {
                [queryString appendString:[NSString stringWithFormat:@"AND (specieKeywordTags CONTAINS[cd] \"%@\")",query]];
            }
        }
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Species" inManagedObjectContext:self.moc];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"specieScientificName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByName, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:queryString];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objects = [self.moc executeFetchRequest:fetchRequest error:&error];
    SpeciesLibraryViewController *libraryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"speciesLibraryVC"];
    libraryVC.moc = self.moc;
    libraryVC.isSpecieForSubmitReport = isSubmitReportView;
    libraryVC.loadSpeciesFromIdentifieds = true;
    libraryVC.identifiedResults = objects;
    [self.navigationController pushViewController:libraryVC animated:YES];
}
@end
