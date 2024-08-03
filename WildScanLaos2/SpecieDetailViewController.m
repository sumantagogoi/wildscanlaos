//
//  SpecieDetailViewController.m
//  WildScan
//
//  Created by Shabir Jan on 04/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "SpecieDetailViewController.h"
#import "ImageGalleryCollectionViewCell.h"
#import "ImageSelectionViewController.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "AppDelegate.h"
#import "SpeciesTranslation.h"
@interface SpecieDetailViewController (){
    int i;
}
@property (nonatomic,strong)NSMutableArray *imagesArray;
@end

@implementation SpecieDetailViewController
@synthesize imagesArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    i =0;
    imagesArray = [NSMutableArray new];
    imagesArray = [NSMutableArray arrayWithArray:[SpeciesImages getAllSpecieImages:self.currentSpecie.specieID moc:self.moc]];
    AppDelegate *dlg = [UIApplication sharedApplication].delegate;
	

    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"specieImageOrder"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
   imagesArray = [NSMutableArray arrayWithArray:[imagesArray sortedArrayUsingDescriptors:sortDescriptors]];
	
	if (imagesArray.count == 0) {
		self.lblImageCopyRight.hidden = true;
		[self.lblDefault setText:NSLocalizedString(@"species_details_no_images", @"")];
		self.lblDefault.hidden = false;
		self.imageCopyRView.hidden = true;
		self.galleryView.hidden = true;
	} else {
		self.lblDefault.hidden = true;
		self.galleryView.hidden = false;
		self.lblImageCopyRight.hidden = false;
		self.imageCopyRView.hidden = false;
	}
	
    SpeciesImages *currentObj = [imagesArray firstObject];
    self.mainImageView.image = [UIImage imageNamed:currentObj.specieImagePath];
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	UIImage * img = [UIImage imageNamed:currentObj.specieImagePath];
	if (img == nil) {
		self.mainImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory,currentObj.specieImagePath]];
		;
	} else {
		self.mainImageView.image = img;
	}
	
	
    self.lblImageCopyRight.text = [NSString stringWithFormat:@"@%@",currentObj.specieImageCredit];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    //[tapGesture setDelegate: self];
    [self.mainImageView addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    
    
    [self.btnFavorite setSelected:[self.currentSpecie.specieIsFavorite boolValue]];
    
    
    UIFont *boldFont = [UIFont systemFontOfSize:15 weight:1];
    UIFont *italicFont = [UIFont italicSystemFontOfSize:15];
    SpeciesTranslation *speciesTranslation = nil;
     if ([dlg.languageISO isEqualToString:@"en"]) {
     }else{
         speciesTranslation = [SpeciesTranslation getSpecieTranslation:self.currentSpecie language:dlg.languageISO moc:self.moc];
     }
    
    
    NSString *commonScientificName = @"";
    NSString *commonName = @"";
    if ([dlg.languageISO isEqualToString:@"en"]) {
         commonScientificName = [NSString stringWithFormat:@"%@ (%@)",self.currentSpecie.specieCommonName,self.currentSpecie.specieScientificName];
    }else{
        if (speciesTranslation!=nil) {
            
            if ([speciesTranslation.specieCommonName isEqualToString:@""] || speciesTranslation.specieCommonName ==nil){
               commonScientificName = [NSString stringWithFormat:@"%@ (%@)",self.currentSpecie.specieCommonName,self.currentSpecie.specieScientificName];
                commonName = self.currentSpecie.specieCommonName;
            }
            else{
                commonScientificName = [NSString stringWithFormat:@"%@ (%@)",speciesTranslation.specieCommonName,self.currentSpecie.specieScientificName];
                commonName = speciesTranslation.specieCommonName;
            }
            
            
            
        }else{
            commonScientificName = [NSString stringWithFormat:@"%@ (%@)",self.currentSpecie.specieCommonName,self.currentSpecie.specieScientificName];
            commonName = _currentSpecie.specieCommonName;
        }
    }
    NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc]initWithString:commonScientificName];
    
    NSRange boldRange = [commonScientificName rangeOfString:commonName];
    NSRange italicRange = [commonScientificName rangeOfString:self.currentSpecie.specieScientificName];
    [attributedName setAttributes:@{ NSFontAttributeName: boldFont } range:boldRange];
    [attributedName setAttributes:@{NSFontAttributeName: italicFont} range:italicRange];
    self.lblComonScientificName.attributedText = attributedName;
    
    NSString *citesApendexs=@"";
    
    if ([dlg.languageISO isEqualToString:@"en"]) {
        citesApendexs = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"species_details_label_cites", @""),self.currentSpecie.specieCities];
    }else{
        if ([self.currentSpecie.specieCities isEqualToString:@"Appendix I"]) {
            citesApendexs = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"species_details_label_cites", @""),NSLocalizedString(@"species_details_label_cites_appendix_1", @"")];
        }else if ([self.currentSpecie.specieCities isEqualToString:@"Appendix II"]){
            citesApendexs = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"species_details_label_cites", @""),NSLocalizedString(@"species_details_label_cites_appendix_2", @"")];
        }else if ([self.currentSpecie.specieCities isEqualToString:@"Appendix III"]){
                citesApendexs = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"species_details_label_cites", @""),NSLocalizedString(@"species_details_label_cites_appendix_3", @"")];
        }else if ([self.currentSpecie.specieCities isEqualToString:@"None"]){
                citesApendexs = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"species_details_label_cites", @""),NSLocalizedString(@"species_details_label_cites_none", @"")];
        }else{
            citesApendexs = self.currentSpecie.specieCities;
        }
    }
    
    attributedName = [[NSMutableAttributedString alloc]initWithString:citesApendexs];
    boldRange = [citesApendexs rangeOfString:[NSString stringWithFormat:@"%@",NSLocalizedString(@"species_details_label_cites", @"")]];
    //NSRange normalRange = [citesApendexs rangeOfString:self.currentSpecie.specieCities];
    [attributedName setAttributes:@{NSFontAttributeName: boldFont} range:boldRange];
    self.lblCites.attributedText = attributedName;
    
    NSString *redListStatus = @"";
    if ([self.currentSpecie.specieStatus isEqualToString:@"NT"]) {
        redListStatus = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"species_details_label_status", @""),NSLocalizedString(@"species_details_label_status_nt", @"")];
    }
    else if ([self.currentSpecie.specieStatus isEqualToString:@"VU"]) {
        redListStatus = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"species_details_label_status", @""),NSLocalizedString(@"species_details_label_status_vu", @"")];
    }
    else if ([self.currentSpecie.specieStatus isEqualToString:@"EN"]) {
        redListStatus = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"species_details_label_status", @""),NSLocalizedString(@"species_details_label_status_en", @"")];
    }
    else if ([self.currentSpecie.specieStatus isEqualToString:@"CR"]) {
        redListStatus = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"species_details_label_status", @""),NSLocalizedString(@"species_details_label_status_cr", @"")];
    }
    else if ([self.currentSpecie.specieStatus isEqualToString:@"EW"]) {
        redListStatus = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"species_details_label_status", @""),NSLocalizedString(@"species_details_label_status_ew", @"")];
    }
    else if ([self.currentSpecie.specieStatus isEqualToString:@"EX"]) {
        redListStatus = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"species_details_label_status", @""),NSLocalizedString(@"species_details_label_status_ex", @"")];
    }
    else if ([self.currentSpecie.specieStatus isEqualToString:@"NA"]) {
        redListStatus = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"species_details_label_status", @""),NSLocalizedString(@"species_details_label_status_na", @"")];
    }else if ([self.currentSpecie.specieStatus isEqualToString:@"LC"]){
         redListStatus = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"species_details_label_status", @""),NSLocalizedString(@"species_details_label_status_lc", @"")];
    }
    else {
        redListStatus = @"";
    }
    
    attributedName = [[NSMutableAttributedString alloc]initWithString:redListStatus];
    boldRange = [redListStatus rangeOfString:@"IUCN Red-list Status:"];
    [attributedName setAttributes:@{NSFontAttributeName: boldFont} range:boldRange];
    self.lblStatus.attributedText = attributedName;
    self.lblStatus.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblStatus.numberOfLines = 0;
    
    NSString *warningDieaseRisk=@"";
    if ([dlg.languageISO isEqualToString:@"en"]) {
          warningDieaseRisk = [NSString stringWithFormat:@"%@: %@, %@ %@",NSLocalizedString(@"species_details_label_warning", @""),self.currentSpecie.specieWarnings,self.currentSpecie.specieDieaseRiskLevel,NSLocalizedString(@"species_details_label_warning_disease_risk", @"")];
    }else{
        NSString *riskLevel;
        NSString *warnings;
        if ([self.currentSpecie.specieDieaseRiskLevel isEqualToString:@"Low"]) {
            riskLevel = NSLocalizedString(@"species_details_label_warning_disease_risk_low", @"");
        }else if ([self.currentSpecie.specieDieaseRiskLevel isEqualToString:@"Medium"]){
            riskLevel = NSLocalizedString(@"species_details_label_warning_disease_risk_medium", @"");
        }else if ([self.currentSpecie.specieDieaseRiskLevel isEqualToString:@"High"]){
             riskLevel = NSLocalizedString(@"species_details_label_warning_disease_risk_high", @"");
        }
        else {
            riskLevel = @"";
        }
        
        if ([self.currentSpecie.specieWarnings isEqualToString:@"Dangerous"]) {
            warnings = NSLocalizedString(@"species_details_label_warning_dangerous", @"");
        }else if ([self.currentSpecie.specieWarnings isEqualToString:@"Poisonous"]){
            warnings = NSLocalizedString(@"species_details_label_warning_poisonous", @"");
        }else if ([self.currentSpecie.specieWarnings isEqualToString:@"Nocturnal"]){
            warnings = NSLocalizedString(@"species_details_label_warning_nocturnal", @"");
        }
        else {
            warnings = @"";
        }
        if ([warnings isEqualToString:@""] )  {
            if ([riskLevel isEqualToString:@""]) {
                warningDieaseRisk = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"species_details_label_warning", @""),NSLocalizedString(@"species_details_label_warning_disease_risk", @"")];
            }
            else {
                warningDieaseRisk = [NSString stringWithFormat:@"%@: %@ %@",NSLocalizedString(@"species_details_label_warning", @""),riskLevel,NSLocalizedString(@"species_details_label_warning_disease_risk", @"")];
            }
        }
        else {
            if ([riskLevel isEqualToString:@""]) {
                warningDieaseRisk = [NSString stringWithFormat:@"%@: %@ %@",NSLocalizedString(@"species_details_label_warning", @""),warnings,NSLocalizedString(@"species_details_label_warning_disease_risk", @"")];
            }
            else {
                warningDieaseRisk = [NSString stringWithFormat:@"%@: %@, %@ %@",NSLocalizedString(@"species_details_label_warning", @""),warnings, riskLevel,NSLocalizedString(@"species_details_label_warning_disease_risk", @"")];
            }
        }
    }
    
    attributedName = [[NSMutableAttributedString alloc]initWithString:warningDieaseRisk];
    boldRange = [warningDieaseRisk rangeOfString:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"species_details_label_warning", @"")]];
    
    [attributedName setAttributes:@{NSFontAttributeName: boldFont} range:boldRange];
    self.lblWarnings.attributedText = attributedName;
    self.lblWarnings.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblWarnings.numberOfLines = 0;

    
    
    NSString *idenfitifcationClues= @"";
    if ([dlg.languageISO isEqualToString:@"en"]) {
         idenfitifcationClues = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_id_clues", @""),self.currentSpecie.specieBasicIDCues];
    }else{
        if (speciesTranslation !=nil) {
            if ([speciesTranslation.specieBasicIDCues isEqualToString:@""]|| speciesTranslation.specieBasicIDCues == nil) {
                 idenfitifcationClues = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_id_clues", @""),self.currentSpecie.specieBasicIDCues];
            }
            else{
                 idenfitifcationClues = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_id_clues", @""),speciesTranslation.specieBasicIDCues];
            }
        }else{
             idenfitifcationClues = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_id_clues", @""),self.currentSpecie.specieBasicIDCues];
        }
    }
    boldRange = [idenfitifcationClues rangeOfString:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"species_details_label_id_clues", @"")]];
    attributedName = [[NSMutableAttributedString alloc]initWithString:idenfitifcationClues];
    [attributedName setAttributes:@{NSFontAttributeName:boldFont, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:boldRange];
    self.lblClues.attributedText = attributedName;
    
    
    NSString *similarAnimals=@"";
    if ([dlg.languageISO isEqualToString:@"en"]) {
        similarAnimals = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_similar", @""),self.currentSpecie.specieSimilarAnimals];
    }else{
        if (speciesTranslation !=nil) {
            if ([speciesTranslation.specieSimilarAnimals isEqualToString:@""] || speciesTranslation.specieSimilarAnimals == nil) {
                similarAnimals = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_similar", @""),self.currentSpecie.specieSimilarAnimals];
            }else{
                similarAnimals = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_similar", @""),speciesTranslation.specieSimilarAnimals];
            }
        }
        else{
            similarAnimals = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_similar", @""),self.currentSpecie.specieSimilarAnimals];
        }
    }
    boldRange = [similarAnimals rangeOfString:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"species_details_label_similar", @"")]];
    attributedName = [[NSMutableAttributedString alloc]initWithString:similarAnimals];
    [attributedName setAttributes:@{NSFontAttributeName:boldFont, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:boldRange];
    self.lblSimilarAnimals.attributedText = attributedName;
    
    
    
    NSString *lawEnforcementAdvice=@"";
    if ([dlg.languageISO isEqualToString:@"en"]) {
        lawEnforcementAdvice = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_enforcement", @""),self.currentSpecie.specieEnforcementAdvice];
    }else
    {
        if (speciesTranslation !=nil) {
            if ([speciesTranslation.specieEnforcementAdvice isEqualToString:@""] || speciesTranslation.specieEnforcementAdvice == nil) {
                lawEnforcementAdvice = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_enforcement", @""),self.currentSpecie.specieEnforcementAdvice];
            }else{
                lawEnforcementAdvice = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_enforcement", @""),speciesTranslation.specieEnforcementAdvice];
            }
        }else{
            lawEnforcementAdvice = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_enforcement", @""),self.currentSpecie.specieEnforcementAdvice];
        }
    }
    
    boldRange = [lawEnforcementAdvice rangeOfString:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"species_details_label_enforcement", @"")]];
    attributedName = [[NSMutableAttributedString alloc]initWithString:lawEnforcementAdvice];
    [attributedName setAttributes:@{NSFontAttributeName:boldFont, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:boldRange];
    self.lblLawAdvice.attributedText = attributedName;
    
    
    
    NSString *consumerAdvice=@"";
    if ([dlg.languageISO isEqualToString:@"en"]) {
        
    
        consumerAdvice = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_consumer", @""),self.currentSpecie.specieConsumerAdvice];
    }else{
        if (speciesTranslation!=nil) {
            if ([speciesTranslation.specieConsumerAdvice isEqualToString:@""] || speciesTranslation.specieConsumerAdvice== nil) {
                consumerAdvice = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_consumer", @""),self.currentSpecie.specieConsumerAdvice];
            }else{
                consumerAdvice = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_consumer", @""),speciesTranslation.specieConsumerAdvice];
            }
            
        }else{
            consumerAdvice = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_consumer", @""),self.currentSpecie.specieConsumerAdvice];
        }
    }
    
    boldRange = [consumerAdvice rangeOfString:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"species_details_label_consumer", @"")]];
    attributedName = [[NSMutableAttributedString alloc]initWithString:consumerAdvice];
    [attributedName setAttributes:@{NSFontAttributeName:boldFont, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:boldRange];
    self.lblConsumerAdvice.attributedText = attributedName;
    
    
    NSString *firstResponderAdvice=@"";
    if ([dlg.languageISO isEqualToString:@"en"]) {
         firstResponderAdvice = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_responder", @""),self.currentSpecie.specieFirstResponder];
    }else{
        if (speciesTranslation !=nil) {
            if ([speciesTranslation.specieFirstResponder isEqualToString:@""]|| speciesTranslation.specieFirstResponder==nil) {
                 firstResponderAdvice = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_responder", @""),self.currentSpecie.specieFirstResponder];
            }else{
                 firstResponderAdvice = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_responder", @""),speciesTranslation.specieFirstResponder];
            }
            
        }else{
             firstResponderAdvice = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_responder", @""),self.currentSpecie.specieFirstResponder];
        }
    }
   
    boldRange = [firstResponderAdvice rangeOfString:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"species_details_label_responder", @"")]];
    attributedName = [[NSMutableAttributedString alloc]initWithString:firstResponderAdvice];
    [attributedName setAttributes:@{NSFontAttributeName:boldFont, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:boldRange];
    self.lblFirstResponderAdvice.attributedText = attributedName;
    
    
    NSString *tradedAs=@"";
    if ([dlg.languageISO isEqualToString:@"en"]) {
        tradedAs = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_traded_as", @""),self.currentSpecie.specieTradedAs];
    }else{
        if (speciesTranslation!=nil) {
            if (speciesTranslation.specieTradedAs == nil || [speciesTranslation.specieTradedAs isEqualToString:@""]) {
                tradedAs = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_traded_as", @""),self.currentSpecie.specieTradedAs];
            }else{
                tradedAs = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_traded_as", @""),speciesTranslation.specieTradedAs];
            }
        }else{
            tradedAs = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_traded_as", @""),self.currentSpecie.specieTradedAs];
        }
    }
    boldRange = [tradedAs rangeOfString:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"species_details_label_traded_as", @"")]];
    attributedName = [[NSMutableAttributedString alloc]initWithString:tradedAs];
    [attributedName setAttributes:@{NSFontAttributeName:boldFont, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:boldRange];
    self.lblTradedAs.attributedText = attributedName;
    
    NSString *commonTrafficking=@"";
    if ([dlg.languageISO isEqualToString:@"en"]) {
         commonTrafficking = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_common_methods", @""),self.currentSpecie.specieCommonTrafficking];
    }else{
        if (speciesTranslation!=nil) {
            if (speciesTranslation.specieCommonTrafficking == nil || [speciesTranslation.specieCommonTrafficking isEqualToString:@""]) {
                commonTrafficking = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_common_methods", @""),self.currentSpecie.specieCommonTrafficking];
            }else{
                commonTrafficking = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_common_methods", @""),speciesTranslation.specieCommonTrafficking];
            }
        }else{
            commonTrafficking = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_common_methods", @""),self.currentSpecie.specieCommonTrafficking];
        }
    }
    boldRange = [commonTrafficking rangeOfString:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"species_details_label_common_methods", @"")]];
    attributedName = [[NSMutableAttributedString alloc]initWithString:commonTrafficking];
    [attributedName setAttributes:@{NSFontAttributeName:boldFont, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:boldRange];
    self.lblCommonTraffickingMethods.attributedText = attributedName;
    
    NSString *alsoKnownAs=@"";
    if ([dlg.languageISO isEqualToString:@"en"]) {
        alsoKnownAs = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_aka", @""),self.currentSpecie.specieKnownAs];
    }else{
        if (speciesTranslation !=nil){
            if (speciesTranslation.specieKnownAs ==nil || [speciesTranslation.specieKnownAs isEqualToString:@""]) {
                alsoKnownAs = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_aka", @""),self.currentSpecie.specieKnownAs];
            }else{
                alsoKnownAs = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_aka", @""),speciesTranslation.specieKnownAs];
            }
        }else{
            alsoKnownAs = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_aka", @""),self.currentSpecie.specieKnownAs];
        }
    }
    boldRange = [alsoKnownAs rangeOfString:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"species_details_label_aka", @"")]];
    attributedName = [[NSMutableAttributedString alloc]initWithString:alsoKnownAs];
    [attributedName setAttributes:@{NSFontAttributeName:boldFont, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:boldRange];
    self.lblKnownAs.attributedText = attributedName;
    
    NSString *distribution=@"";
    distribution = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_distribution", @""),self.currentSpecie.specieExtantCountries];
    boldRange = [distribution rangeOfString:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"species_details_label_distribution", @"")]];
    attributedName = [[NSMutableAttributedString alloc]initWithString:distribution];
    [attributedName setAttributes:@{NSFontAttributeName:boldFont, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:boldRange];
    self.lblDistribution.attributedText = attributedName;
    
    NSString *averageSizeHeight=@"";
    if ([dlg.languageISO isEqualToString:@"en"]) {
        averageSizeHeight =[NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_size", @""),self.currentSpecie.specieAverageSizeWeight];
    }
    else{
        if (speciesTranslation!=nil) {
            if (speciesTranslation.specieAverageSizeWeight == nil || [speciesTranslation.specieAverageSizeWeight isEqualToString:@""]) {
                averageSizeHeight =[NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_size", @""),self.currentSpecie.specieAverageSizeWeight];

            }
            else{
                averageSizeHeight =[NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_size", @""),speciesTranslation.specieAverageSizeWeight];

            }
        }else{
            averageSizeHeight =[NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_size", @""),self.currentSpecie.specieAverageSizeWeight];

        }
    }
    boldRange = [averageSizeHeight rangeOfString:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"species_details_label_size", @"")]];
    attributedName = [[NSMutableAttributedString alloc]initWithString:averageSizeHeight];
    [attributedName setAttributes:@{NSFontAttributeName:boldFont, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:boldRange];
    self.lblAverageSizeWeight.attributedText = attributedName;
    
    NSString *habitat=@"";
    if ([dlg.languageISO isEqualToString:@"en"]) {
        habitat = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_habitat", @""),self.currentSpecie.specieHabitat];
    }else{
        if (speciesTranslation!=nil) {
            if ([speciesTranslation.specieHabitat isEqualToString:@""] || speciesTranslation.specieHabitat == nil) {
                habitat = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_habitat", @""),self.currentSpecie.specieHabitat];
            }else{
                habitat = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_habitat", @""),speciesTranslation.specieHabitat];
            }
        }else{
            habitat = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_habitat", @""),self.currentSpecie.specieHabitat];
        }
    }
    boldRange = [habitat rangeOfString:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"species_details_label_habitat", @"")]];
    attributedName = [[NSMutableAttributedString alloc]initWithString:habitat];
    [attributedName setAttributes:@{NSFontAttributeName:boldFont, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:boldRange];
    self.lblHabitat.attributedText = attributedName;
    
    
    NSString *dieases=@"";
    if ([dlg.languageISO isEqualToString:@"en"]) {
         dieases = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_diseases", @""),self.currentSpecie.specieDieaseName];
    }else{
        if (speciesTranslation!=nil) {
            if (speciesTranslation.specieDieaseName == nil || [speciesTranslation.specieDieaseName isEqualToString:@""]) {
                 dieases = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_diseases", @""),self.currentSpecie.specieDieaseName];
            }else{
                 dieases = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_diseases", @""),speciesTranslation.specieDieaseName];
            }
        }else{
            dieases = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_diseases", @""),self.currentSpecie.specieDieaseName];
        }
        
    }
    boldRange = [dieases rangeOfString:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"species_details_label_diseases", @"")]];
    attributedName = [[NSMutableAttributedString alloc]initWithString:dieases];
    [attributedName setAttributes:@{NSFontAttributeName:boldFont, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:boldRange];
    self.lblZoontaciDiease.attributedText = attributedName;
    
    NSString *notes=@"";
    if ([dlg.languageISO isEqualToString:@"en"]) {
        notes = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_notes", @""),self.currentSpecie.specieNotes];
    }else{
        if (speciesTranslation!=nil) {
            if ([speciesTranslation.specieNotes isEqualToString:@""] || speciesTranslation.specieNotes == nil) {
                notes = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_notes", @""),self.currentSpecie.specieNotes];
            }else{
                notes = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_notes", @""),speciesTranslation.specieNotes];
            }
        }else{
            notes = [NSString stringWithFormat:@"%@:\n%@\n",NSLocalizedString(@"species_details_label_notes", @""),self.currentSpecie.specieNotes];
        }
    }
    
    boldRange = [notes rangeOfString:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"species_details_label_notes", @"")]];
    attributedName = [[NSMutableAttributedString alloc]initWithString:notes];
    [attributedName setAttributes:@{NSFontAttributeName:boldFont, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:boldRange];
    self.lblNotes.attributedText = attributedName;

    
    // Do any additional setup after loading the view.
}
-(void)tapGesture:(UITapGestureRecognizer*)tap{
    NSString *alertString = [NSString stringWithFormat:@"Photo license:\nCreative Commons Attribution-Share Alike 2.5 Generic"];
  
    [SVProgressHUD showImage:nil status:alertString];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Left Swipe");
        ++i;
        if (i<=imagesArray.count-1) {
            SpeciesImages *currentObj = [imagesArray objectAtIndex:i];
			UIImage * img = [UIImage imageNamed:currentObj.specieImagePath];
			if (img == nil) {
				self.mainImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory,currentObj.specieImagePath]];
				;
			} else {
				self.mainImageView.image = img;
			}
            self.lblImageCopyRight.text = [NSString stringWithFormat:@"@%@",currentObj.specieImageCredit];

        }
        if (i==imagesArray.count) {
            i=0;
            SpeciesImages *currentObj = [imagesArray objectAtIndex:i];
			UIImage * img = [UIImage imageNamed:currentObj.specieImagePath];
			if (img == nil) {
				self.mainImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory,currentObj.specieImagePath]];
				;
			} else {
				self.mainImageView.image = img;
			}
            self.lblImageCopyRight.text = [NSString stringWithFormat:@"@%@",currentObj.specieImageCredit];
        }
        
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        --i;
        if (i<=imagesArray.count-1) {
            SpeciesImages *currentObj = [imagesArray objectAtIndex:i];
			UIImage * img = [UIImage imageNamed:currentObj.specieImagePath];
			if (img == nil) {
				self.mainImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory,currentObj.specieImagePath]];
				;
			} else {
				self.mainImageView.image = img;
			}
            self.lblImageCopyRight.text = [NSString stringWithFormat:@"@%@",currentObj.specieImageCredit];
            
        }
        if (i==0 || i <0) {
            i=imagesArray.count-1;
            SpeciesImages *currentObj = [imagesArray objectAtIndex:i];
			UIImage * img = [UIImage imageNamed:currentObj.specieImagePath];
			if (img == nil) {
				self.mainImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory,currentObj.specieImagePath]];
				;
			} else {
				self.mainImageView.image = img;
			}
            self.lblImageCopyRight.text = [NSString stringWithFormat:@"@%@",currentObj.specieImageCredit];

        }
    }
    
}

- (IBAction)btnFavoritePressed:(id)sender {
    if ([self.currentSpecie.specieIsFavorite boolValue]) {
        self.currentSpecie.specieIsFavorite = [NSNumber numberWithInt:NO];
        [self.btnFavorite setSelected:NO];
    }else{
        self.currentSpecie.specieIsFavorite = [NSNumber numberWithInt:YES];
        [self.btnFavorite setSelected:YES];
    }
    
    [self.moc save:nil];
}

- (IBAction)btnReportSpeciePressed:(id)sender {
    [[NSUserDefaults standardUserDefaults]setValue:self.currentSpecie.specieID forKey:@"reportSpecie"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    ImageSelectionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"imageVC"];
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
    return imagesArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageGalleryCollectionViewCell *cell= (ImageGalleryCollectionViewCell*)[self.galleryView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    SpeciesImages *currentObj = [imagesArray objectAtIndex:indexPath.row];
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	UIImage * img = [UIImage imageNamed:currentObj.specieImagePath];
	if (img == nil) {
		cell.galleryImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory,currentObj.specieImagePath]];
		;
	} else {
		cell.galleryImage.image = img;
	}
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    SpeciesImages *currentObj = [imagesArray objectAtIndex:indexPath.row];
	UIImage * img = [UIImage imageNamed:currentObj.specieImagePath];
	if (img == nil) {
		self.mainImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory,currentObj.specieImagePath]];
	} else {
		self.mainImageView.image = img;
	}
    self.lblImageCopyRight.text = [NSString stringWithFormat:@"@%@",currentObj.specieImageCredit];
}


@end
