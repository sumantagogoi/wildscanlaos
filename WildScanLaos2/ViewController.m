
//
//  ViewController.m
//  WildScan
//
//  Created by Shabir Jan on 11/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "ViewController.h"
#import "Events.h"
#import "reverseGeoCoder.h"
#import "Content.h"
#import "Region.h"
#import "RegionStats.h"
@interface ViewController ()
{
    reverseGeoCoder *reverseGeo;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *dateFormatter2;
}
@property (nonatomic,strong)NSMutableArray *speciesDicCopy;

@end

@implementation ViewController
int i = 0;
@synthesize speciesDicCopy;
- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    reverseGeo  = [[reverseGeoCoder alloc]init];
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    dateFormatter2 = [[NSDateFormatter alloc]init];
    // [dateFormatter2 setDateFormat:@""];
    [dateFormatter2 setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter2 setTimeStyle:NSDateFormatterNoStyle];
    
    self.loaderView.progress = 0.0;
    
    
    self.loaderView.tintColor = [UIColor grayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 20.0)];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.userInteractionEnabled = NO; // Allows tap to pass through to the progress view.
    self.loaderView.centralView = label;
    
    self.loaderView.progressChangedBlock = ^(UAProgressView *progressView, CGFloat progress) {
        [(UILabel *)self.loaderView.centralView setText:[NSString stringWithFormat:@"%2.0f%%", progress * 100]];
    };
    
    */
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString *selectedr = [[NSUserDefaults standardUserDefaults] stringForKey:SELECTEDREGIONS];
    if (!selectedr) {
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:REPORTINGREGION];
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:SELECTEDREGIONS];
        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:LASTSYNC];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    DashboardViewController *dashboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"dashboardVC"];
    dashboardVC.moc = self.moc;
    [self.navigationController pushViewController:dashboardVC animated:YES];
    
    /*
    NSArray *contacts = [Contacts getAllContacts:self.moc];
    if (contacts.count>0) {
        DashboardViewController *dashboardVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"dashboardVC"];
        dashboardVC.moc = self.moc;
        [self.navigationController pushViewController:dashboardVC animated:YES];
    }else{
        if ([self IsMainThread]) {
            NSLog(@"main thread");
        }else{
            NSLog(@"issue hy bhai");
        }
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"contact %@",json);
        if ([NSThread isMainThread]) {
            NSLog(@"Main Thread");
        }else{
            NSLog(@"background thread");
        }
         [self performSelectorInBackground:@selector(updateText:) withObject:NSLocalizedString(@"sync_progress_contacts", @"")];
        [self saveContacts:[[json valueForKey:@"data"] valueForKey:@"contacts"]];
    }
    */
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fetchSpecies{
    [self.loaderView setProgress:0.0];
    [self performSelectorInBackground:@selector(updateText:) withObject:NSLocalizedString(@"sync_progress_species", @"")];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"species" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    [self saveSpecies:json];
    
    
}
-(void)saveSpecies:(NSDictionary*)species{
    i = 0;
    NSArray *speciesDic = [[species valueForKey:@"data"] valueForKey:@"species"];
    NSInteger specieCount = speciesDic.count;
    [self.loaderView setProgress:0.01];
    
    
    for (NSDictionary *dic in speciesDic) {
        ++i;
        NSString *specieID= [dic valueForKey:@"id"];
        NSString *specieRegion = [dic valueForKey:@"region"];
        NSString *specieIsGlobal = [dic valueForKey:@"is_global"];
        NSString *specieType = [dic valueForKey:@"type"];
        NSString *specieCommonName = [dic valueForKey:@"common_name"];
        NSString *specieScientificName = [dic valueForKey:@"scientific_name"];
        NSString *specieCites = [dic valueForKey:@"cites"];
        NSString *specieCitesOther = [dic valueForKey:@"cites_other"];
        NSString *specieExtantCountries = [dic valueForKey:@"extant_countries"];
        NSString *specieStatus = [dic valueForKey:@"status"];
        NSString *specieWarnings = [dic valueForKey:@"warnings"];
        NSString *specieHabitat = [dic valueForKey:@"habitat"];
        NSString *specieBasicIDCues =[dic valueForKey:@"basic_id_cues"];
        NSString *specieConsumerAdvice = [dic valueForKey:@"consumer_advice"];
        NSString *specieEnforcementAdvice = [dic valueForKey:@"enforcement_advice"];
        NSString *specieSimilarAnimals = [dic valueForKey:@"similar_animals"];
        NSString *specieKnownAs = [dic valueForKey:@"known_as"];
        NSString *specieAverageSizeWeight = [dic valueForKey:@"average_size_weight"];
        NSString *specieFirstResponder = [dic valueForKey:@"first_responder"];
        NSString *specieTradedAs = [dic valueForKey:@"traded_as"];
        NSString *specieCommonTrafficking = [dic valueForKey:@"common_trafficking"];
        NSString *specieNotes = [dic valueForKey:@"notes"];
        NSString *specieKeywordTags = [dic valueForKey:@"keywords_tags"];
        NSString *specieReference = [dic valueForKey:@"reference"];
        NSString *specieDieaseName = [dic valueForKey:@"disease_name"];
        NSString *specieDieaseRiskLevel = [dic valueForKey:@"disease_risk_level"];
        NSString *specieCreatedBy = [dic valueForKey:@"created_by"];
        NSString *specieCreatedDate = [dic valueForKey:@"created_date"];
        NSString *specieUpdatedBy = [dic valueForKey:@"updated_by"];
        NSString *specieUpdatedDate = [dic valueForKey:@"updated_date"];
        NSString *specieImageUrl = [dic valueForKey:@"image"];
        NSArray *urlComponents = [specieImageUrl componentsSeparatedByString:@"/"];
        specieImageUrl = [urlComponents lastObject];
        UIImage *image = [UIImage imageNamed:specieImageUrl];
        if (image == nil) {
            NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://wildscan.org/laos/wildscan-uploads/%@",[dic valueForKey:@"image"]]];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if ( urlData )
            {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString  *documentsDirectory = [paths objectAtIndex:0];
                NSString *fileName = [NSString stringWithFormat:@"%@.png",specieImageUrl];
                NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fileName];
                [urlData writeToFile:filePath atomically:YES];
                specieImageUrl = filePath;
                i++;
            }
        }
        ++i;
        
        
        [Species createSpecie:specieID region:specieRegion isGlobal:specieIsGlobal type:specieType commonname:specieCommonName scientificname:specieScientificName cities:specieCites citiesother:specieCitesOther extantcountries:specieExtantCountries status:specieStatus warnings:specieWarnings habitat:specieHabitat basicues:specieBasicIDCues consumeradvice:specieConsumerAdvice enforcementadvice:specieEnforcementAdvice similarAnimals:specieSimilarAnimals knownas:specieKnownAs averagesizeweight:specieAverageSizeWeight firstresponder:specieFirstResponder tradedas:specieTradedAs commontrafficing:specieCommonTrafficking notes:specieNotes keywordtags:specieKeywordTags references:specieReference dieasename:specieDieaseName dieaserisklevel:specieDieaseRiskLevel createdby:specieCreatedBy createddate:specieCreatedDate updatedby:specieUpdatedBy updateddate:specieUpdatedDate image:specieImageUrl moc:self.moc];
        double value = (double)i/(specieCount*2);
        
        [self performSelectorInBackground:@selector(updateProgressBar:) withObject:[NSNumber numberWithDouble:value]];
    }
    
    [self saveSpeciesTranslation];
}

-(void)saveSpeciesTranslation{
    [self performSelectorInBackground:@selector(updateText:) withObject:NSLocalizedString(@"sync_progress_translations", @"")];
  //  self.lblSyncText.text = @"";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"speciesTranslation" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSMutableArray *species = [[json valueForKey:@"data"] valueForKey:@"speciesTranslations"];
    NSInteger specieCount = species.count;
    
    
    
    for (NSDictionary *dic in species) {
        ++i;
        NSString *specieID= [dic valueForKey:@"species_id"];
        NSArray *specieTranslations = [dic valueForKey:@"translations"];
        for (NSDictionary *dic in specieTranslations) {
            
            
            NSString *specieCommonName = [dic valueForKey:@"common_name"];
            
            NSString *specieHabitat = [dic valueForKey:@"habitat"];
            NSString *specieBasicIDCues =[dic valueForKey:@"basic_id_cues"];
            NSString *specieConsumerAdvice = [dic valueForKey:@"consumer_advice"];
            NSString *specieEnforcementAdvice = [dic valueForKey:@"enforcement_advice"];
            NSString *specieSimilarAnimals = [dic valueForKey:@"similar_animals"];
            NSString *specieKnownAs = [dic valueForKey:@"known_as"];
            NSString *specieAverageSizeWeight = [dic valueForKey:@"average_size_weight"];
            NSString *specieFirstResponder = [dic valueForKey:@"first_responder"];
            NSString *specieTradedAs = [dic valueForKey:@"traded_as"];
            NSString *specieCommonTrafficking = [dic valueForKey:@"common_trafficking"];
            NSString *specieNotes = [dic valueForKey:@"notes"];
            NSString *language = [dic valueForKey:@"language"];
            NSString *specieDieaseName = [dic valueForKey:@"disease_name"];
            
            Species *species = [Species getSpecieByID:specieID moc:self.moc];
            ++i;
            
            
            [SpeciesTranslation createSpecieTranslation:species commonname:specieCommonName habitat:specieHabitat basicues:specieBasicIDCues consumeradvice:specieConsumerAdvice enforcementadvice:specieEnforcementAdvice similarAnimals:specieSimilarAnimals knownas:specieKnownAs averagesizeweight:specieAverageSizeWeight firstresponder:specieFirstResponder tradedas:specieTradedAs commontrafficing:specieCommonTrafficking notes:specieNotes dieasename:specieDieaseName specieLangauge:language  moc:self.moc];
            
            double value = (double)i/(specieCount);
            
            [self performSelectorInBackground:@selector(updateProgressBar:) withObject:[NSNumber numberWithDouble:value]];
        }
    }
    [self saveSpeciesImages];
    
}
-(void)saveSpeciesImages{
    i = 0;
    [self performSelectorInBackground:@selector(updateText:) withObject:NSLocalizedString(@"sync_progress_photos", @"")];
   
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"specisImagePath" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSMutableArray *species = [[json valueForKey:@"data"] valueForKey:@"speciesImages"];
    NSInteger specieCount = species.count;
    
    for (NSDictionary *dic in species) {
        ++i;
        NSString *specieID= [dic valueForKey:@"species_id"];
        NSArray *speciesImages = [dic valueForKey:@"images"];
        for (NSDictionary *dic in speciesImages) {
            
            
            NSString *specieImageCredit = [dic valueForKey:@"credit"];
            
            NSString *specieImageLicense = [dic valueForKey:@"license"];
            
            NSString *specieImageOrder =[dic valueForKey:@"image_order"];
            NSString *specieImagePath = [dic valueForKey:@"image_path"];
            
            specieImageCredit = !([specieImageCredit isEqual:[NSNull null]])?specieImageCredit:@"";
            specieImageLicense = !([specieImageLicense isEqual:[NSNull null]])?specieImageLicense:@"";
            
            
            
            
            NSArray *imageComponents = [specieImagePath componentsSeparatedByString:@"/"];
            specieImagePath = [imageComponents lastObject];
            
            
            
            ++i;
            SpeciesImages *currentObj = [SpeciesImages getImage:specieImagePath moc:self.moc];
            if (currentObj==nil) {
                 [SpeciesImages createSpecieImage:specieID imagePath:specieImagePath credit:specieImageCredit order:specieImageOrder licence:specieImageLicense moc:self.moc];
            }else{
                
            }
            
           
            
            double value = (double)i/(specieCount);
            
            [self performSelectorInBackground:@selector(updateProgressBar:) withObject:[NSNumber numberWithDouble:value]];
        }
    }
    /*
    ServiceHelper *sv = [[ServiceHelper alloc]init];
    sv.delegate = self;
    [sv fetchAllEvents];
    */
}

-(void)saveContacts:(NSMutableArray*)contacts{
    i = 0;
    
    [self.loaderView setProgress:0.01];
    NSInteger contactCount = contacts.count;
    for (NSDictionary *dic in contacts) {
        
        
        NSString *contactID = [dic valueForKey:@"id"];
        NSString *contactName = [dic valueForKey:@"name"];
        NSString *contactAvatarUrl = [dic valueForKey:@"avatar"];
        NSString *contactType = [dic valueForKey:@"type"];
        NSString *contactAgency = [dic valueForKey:@"agency"];
        NSString *contactJurisdictionScope = [dic valueForKey:@"jurisdiction_scope"];
        NSString *contactSpecialcapacityNote = [dic valueForKey:@"specialcapacity_note"];
        NSString *contactEmail = [dic valueForKey:@"email"];
        NSString *contactPhone = [dic valueForKey:@"phone"];
        NSString *contactAddress1 = [dic valueForKey:@"address1"];
        NSString *contactAddress2 = [dic valueForKey:@"address2"];
        NSString *contactCity = [dic valueForKey:@"city"];
        NSString *contactCountry = [dic valueForKey:@"country"];
        NSString *contactRegion = [dic valueForKey:@"region"];
        NSString *contactWebsite = [dic valueForKey:@"website"];
        NSString *contactAvailablity = [dic valueForKey:@"availability"];
        NSString *contactLat = [dic valueForKey:@"lat"];
        NSString *contactLon = [dic valueForKey:@"lon"];
        NSString *contactUTM = [dic valueForKey:@"utm"];
        NSString *contactCreatedBy = [dic valueForKey:@"created_by"];
        NSString *contactCreatedDate = [dic valueForKey:@"created_date"];
        NSString *contactUpdatedBy = [dic valueForKey:@"updated_by"];
        NSString *contactUpdatedDate = [dic valueForKey:@"updated_date"];
        
        
        // zip = zip?zip:@"";
        contactID = !([contactID isEqual:[NSNull null]])?contactID:@"";
        contactName = !([contactName  isEqual:[NSNull null]])?contactName:@"";
        contactAvatarUrl = !([contactAvatarUrl isEqual:[NSNull null]])?contactAvatarUrl:@"";
        contactType = !([contactType isEqual:[NSNull null]])?contactType:@"";
        contactAgency = !([contactAgency isEqual:[NSNull null]])?contactAgency:@"";
        contactJurisdictionScope = !([contactJurisdictionScope isEqual:[NSNull null]])?contactJurisdictionScope:@"";
        contactSpecialcapacityNote = !([contactSpecialcapacityNote isEqual:[NSNull null]])?contactSpecialcapacityNote:@"";
        contactEmail = !([contactEmail isEqual:[NSNull null]])?contactEmail:@"";
        contactPhone = !([contactPhone isEqual:[NSNull null]])?contactPhone:@"";
        contactAddress1 = !([contactAddress1 isEqual:[NSNull null]])?contactAddress1:@"";
        contactAddress2 = !([contactAddress2 isEqual:[NSNull null]])?contactAddress2:@"";
        contactCity = !([contactCity isEqual:[NSNull null]])?contactCity:@"";
        contactCountry = !([contactCountry isEqual:[NSNull null]])?contactCountry:@"";
        contactWebsite = !([contactWebsite isEqual:[NSNull null]])?contactWebsite:@"";
        contactAvailablity = !([contactAvailablity isEqual:[NSNull null]])?contactAvailablity:@"";
        contactLat = !([contactLat isEqual:[NSNull null]] )?contactLat:@"";
        contactLon = !([contactLon isEqual:[NSNull null]])?contactLon:@"";
        contactUTM = !([contactUTM isEqual:[NSNull null]])?contactUTM:@"";
        contactCreatedBy = !([contactCreatedBy isEqual:[NSNull null]])?contactCreatedBy:@"";
        contactCreatedDate = !([contactCreatedDate isEqual:[NSNull null]])?contactCreatedDate:@"";
        contactUpdatedBy = !([contactUpdatedBy isEqual:[NSNull null]])?contactUpdatedBy:@"";
        contactUpdatedDate = !([contactUpdatedDate isEqual:[NSNull null]])?contactUpdatedDate:@"";
        NSArray *urlArray = [contactAvatarUrl componentsSeparatedByString:@"/"];
        contactAvatarUrl = [urlArray lastObject];
        UIImage *image = [UIImage imageNamed:contactAvatarUrl];
        if (image == nil) {
            NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://wildscan.org/laos/wildscan-uploads/%@",[dic valueForKey:@"avatar"]]];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if ( urlData )
            {
                NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString  *documentsDirectory = [paths objectAtIndex:0];
                NSString *fileName = [NSString stringWithFormat:@"%@.png",contactAvatarUrl];
                NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fileName];
                [urlData writeToFile:filePath atomically:YES];
                contactAvatarUrl = filePath;
                i++;
            }
        }
        ++i;
        
        [Contacts createContact:contactID name:contactName avatar:contactAvatarUrl type:contactType agency:contactAgency jurisdiction:contactJurisdictionScope scapacity:contactSpecialcapacityNote email:contactEmail phone:contactPhone address1:contactAddress1 address2:contactAddress2 city:contactCity country:contactCountry region:contactRegion website:contactWebsite availability:contactAvailablity lat:contactLat lon:contactLon utm:contactUTM createdBy:contactCreatedBy createdDate:contactCreatedDate updatedBy:contactUpdatedBy updatedDate:contactUpdatedDate moc:self.moc];
        double value = (double)i/(contactCount*2);
        
        [self performSelectorInBackground:@selector(updateProgressBar:) withObject:[NSNumber numberWithDouble:value]];
    }
    if ([NSThread isMainThread]) {
        NSLog(@"Main Thread");
    }else{
        NSLog(@"background thread");
    }
    [self saveContactsTranslation];
}
-(void)saveContactsTranslation{
    [self performSelectorInBackground:@selector(updateText:) withObject:NSLocalizedString(@"sync_progress_translations", @"")];
   // self.lblSyncText.text = @"CHECKING FOR CONTACT TRANSLATIONS";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"contactsTranslation" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSMutableArray *contacts = [[json valueForKey:@"data"] valueForKey:@"contactsTranslations"];
    NSInteger contactCount = contacts.count;
    for (NSDictionary *dic in contacts) {
        
        
        NSString *contactID = [dic valueForKey:@"contact_id"];
        NSArray *contactTranslation = [dic valueForKey:@"translations"];
        for (NSDictionary *dic2 in contactTranslation) {
            NSString *contactName = [dic2 valueForKey:@"name"];
            
            NSString *contactAgency = [dic2 valueForKey:@"agency"];
            
            NSString *contactSpecialcapacityNote = [dic2 valueForKey:@"specialcapacity_note"];
            
            NSString *contactAddress1 = [dic2 valueForKey:@"address1"];
            NSString *contactAddress2 = [dic2 valueForKey:@"address2"];
            NSString *contactCity = [dic2 valueForKey:@"city"];
            NSString *contactLanguage = [dic2 valueForKey:@"language"];
            
            
            contactID = !([contactID isEqual:[NSNull null]])?contactID:@"";
            contactName = !([contactName  isEqual:[NSNull null]])?contactName:@"";
            contactLanguage = !([contactLanguage isEqual:[NSNull null]])?contactLanguage:@"";
            contactAgency = !([contactAgency isEqual:[NSNull null]])?contactAgency:@"";
            
            contactSpecialcapacityNote = !([contactSpecialcapacityNote isEqual:[NSNull null]])?contactSpecialcapacityNote:@"";
            contactAddress1 = !([contactAddress1 isEqual:[NSNull null]])?contactAddress1:@"";
            contactAddress2 = !([contactAddress2 isEqual:[NSNull null]])?contactAddress2:@"";
            contactCity = !([contactCity isEqual:[NSNull null]])?contactCity:@"";
            Contacts *contact = [Contacts getContactByID:contactID moc:self.moc];
            [ContactsTranslation createContactTranslation:contact language:contactLanguage name:contactName agency:contactAgency specailityNote:contactSpecialcapacityNote address1:contactAddress1 address2:contactAddress2 city:contactCity moc:self.moc];
        }
        
        
        double value = (double)i/contactCount;
        
        [self performSelectorInBackground:@selector(updateProgressBar:) withObject:[NSNumber numberWithDouble:value]];
    }
    [self fetchSpecies];
}

-(void)saveEvents:(NSDictionary*)json{
    /*
    i = 0;
    [self performSelectorInBackground:@selector(updateText:) withObject:NSLocalizedString(@"sync_progress_events", @"")];
   // self.lblSyncText.text = @"CHECKING FOR EVENTS";
    NSMutableArray *events = [[json valueForKey:@"data"] valueForKey:@"submitReports"];
    
    NSInteger eventCount = events.count;
    
    for (NSDictionary *event in events) {
        NSString *eventid = [event valueForKey:@"id"];
        NSString *incidentDate= [event valueForKey:@"incident_date"];
        NSString *eventDateTime = incidentDate;
        NSDate *eventDate = [dateFormatter dateFromString:incidentDate];
        incidentDate = [dateFormatter2 stringFromDate:eventDate];
        
        NSString *internetIncident  = [event valueForKey:@"internet_incident"];
        NSString *locationAddress = [event valueForKey:@"location_address"];
        NSString *webAddress = [event valueForKey:@"web_address"];
        NSString *locationLat = [event valueForKey:@"location_lat"];
        NSString *locationLong = [event valueForKey:@"location_lon"];
        NSString *region = [event valueForKey:@"region" ];
        NSString *incident = [event valueForKey:@"incident"];
        NSString *species = [event valueForKey:@"species"];
        NSString *number = [event valueForKey:@"number"];
        NSString *numberUnit = [event valueForKey:@"number_unit"];
        NSString *incidentCondition = [event valueForKey:@"incident_condition"];
        NSString *offenseType = [event valueForKey:@"offense_type"];
        NSString *offenseDescription = [event valueForKey:@"offense_description"];
        NSString *method = [event valueForKey:@"method"];
        NSString *valueUSD = [event valueForKey:@"value_estimated_usd"];
        NSString *originAddress =[event valueForKey:@"origin_address"];
        NSString *originCountry = [event valueForKey:@"origin_country"];
        NSString *originLat = [event valueForKey:@"origin_lat"];
        NSString *originLong = [event valueForKey:@"origin_lon"];
        NSString *destinationAddress = [event valueForKey:@"destination_address"];
        NSString *destinationCountry = [event valueForKey:@"destination_country"];
        NSString *destinationLat = [event valueForKey:@"destination_lat"];
        NSString *destinationLon = [event valueForKey:@"destination_lon"];
        NSString *vehicleVesselDescription = [event valueForKey:@"vehicle_vessel_description"];
        NSString *vehicleVesselLisence =[event valueForKey:@"vehicle_vessel_license_number"];
        NSString *vesselName = [event valueForKey:@"vessel_name"];
        NSString *shareWith = [event valueForKey:@"share_with"];
        NSString *syndicate = [event valueForKey:@"syndicate"];
        NSString *status = [event valueForKey:@"status"];
        NSString *createdBy = [event valueForKey:@"created_by"];
        NSString *createdDate = [event valueForKey:@"created_date"];
        NSString *updatedBy = [event valueForKey:@"updated_by"];
        NSString *updatedDate = [event valueForKey:@"updated_date"];
        NSString *imageUrl = [event valueForKey:@"image"];
        //contactID = !([contactID isEqual:[NSNull null]])?contactID:@"";
        
        region = !([region isEqual:[NSNull null]])?region:@"";
        updatedBy = !([updatedBy isEqual:[NSNull null]])?updatedBy:@"";
        updatedDate = !([updatedDate isEqual:[NSNull null]])?updatedDate:@"";
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[locationLat doubleValue] longitude:[locationLong doubleValue]];
        NSString *country = [reverseGeo getCountryDetailWithKey:KeyName withLocation:location];
        
        
        NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://wildscan.org/laos/wildscan-uploads%@",imageUrl]];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            NSString *fileName = [NSString stringWithFormat:@"%@.png",eventid];
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fileName];
            [urlData writeToFile:filePath atomically:YES];
            imageUrl = filePath;
            i++;
        }else{
            i++;
            imageUrl = @"";
        }
        
        [Events createEvent:eventid incidentDate:incidentDate internetIncident:internetIncident locationAddress:locationAddress webAddress:webAddress locationLat:locationLat locationLong:locationLong region:region incident:incident species:species number:number numberUnit:numberUnit incidentCondition:incidentCondition offenseType:offenseType offenseDescription:offenseDescription method:method valueEstimatedUSD:valueUSD originAddress:originAddress originCountry:originCountry originLat:originLat originLong:originLong destinationAddress:destinationAddress destinationCountry:destinationCountry destinationLat:destinationLat destinationLong:destinationLon vehicelVesselDescription:vehicleVesselDescription vehicleVesselLisenseNumber:vehicleVesselLisence vesselName:vesselName shareWith:shareWith syndicate:syndicate status:status createdBy:createdBy createdDate:createdDate updatedBy:updatedBy updatedDate:updatedDate imageUrl:imageUrl country:country dateTime:eventDateTime  moc:self.moc];
        
        
        double value = (double)i/(eventCount);
        
        [self performSelectorInBackground:@selector(updateProgressBar:) withObject:[NSNumber numberWithDouble:value]];
        
        
    }
    if ([self IsMainThread]) {
        NSLog(@"main thread");
    }else{
        NSLog(@"issue hy bhai");
    }
    */
    ServiceHelper *sh = [[ServiceHelper alloc]init];
    sh.delegate = self;
     [self performSelectorInBackground:@selector(updateText:) withObject:NSLocalizedString(@"sync_progress_content", @"")];
     
    [sh fetchAllContent];
    
}
 -(BOOL)IsMainThread {
     return dispatch_get_main_queue() == dispatch_get_current_queue();
 }
#pragma mark -
#pragma mark - ServiceHelper Delegatef
-(void)serviceHelper:(ServiceHelper *)client didFetchContent:(id)contentss{
    NSMutableArray *contents = [[contentss valueForKey:@"data"] valueForKey:@"staticContents"];
    for (NSDictionary *dic in contents) {
        NSString *contentType = [dic valueForKey:@"type"];
        NSString *contentLang = [dic valueForKey:@"language"];
        NSString *contentBody = [dic valueForKey:@"content"];
        [Content createContent:contentLang contentType:contentType content:contentBody moc:self.moc];
    }
    ServiceHelper *sh = [[ServiceHelper alloc]init];
    sh.delegate = self;
    [sh fetchAllRegions];
}
-(void)serviceHelper:(ServiceHelper *)client didFetchContentFailed:(NSError *)error{
    
    ServiceHelper *sh = [[ServiceHelper alloc]init];
    sh.delegate = self;
    [sh fetchAllRegions];
}
-(void)serviceHelper:(ServiceHelper *)client didFetchRegion:(id)regions{
    i = 0;
    [self performSelectorInBackground:@selector(updateText:) withObject:NSLocalizedString(@"sync_progress_regions", @"")];
    self.lblSyncText.text = @"CHECKING FOR REGIONS";
    NSMutableArray *regionss = [[regions valueForKey:@"data"] valueForKey:@"regions"];
    for (NSDictionary *dic in regionss) {
        NSString *rid = [dic valueForKey:@"id"];
        NSString *rcode =[dic valueForKey:@"code"];
        NSString *rname = [dic valueForKey:@"name"];
        NSString *rdesc = [dic valueForKey:@"description"];
        NSString *remail = [dic valueForKey:@"report_email"];
        rdesc = !([rdesc isEqual:[NSNull null]])?rdesc:@"";
        ++i;
        
        Region *region = [Region getRegionByID:rid moc:self.moc];
        if (region == nil) {
            [Region createRegion:rid code:rcode name:rname des:rdesc email:remail moc:self.moc];
        }else{
            region.regionID = rid;
            region.regionCode = rcode;
            region.regionName = rname;
            region.regionReportEmail = remail;
            region.regionDescription = rdesc;
            [self.moc save:nil];
        }
        double value = (double)i/(regionss.count);
        
        [self performSelectorInBackground:@selector(updateProgressBar:) withObject:[NSNumber numberWithDouble:value]];
    }
    
    ServiceHelper *sv =[[ServiceHelper alloc]init];
    sv.delegate = self;
    [sv fetchAllRegionStats];
    
   
}
-(void)serviceHelper:(ServiceHelper *)client didFetchRegionFailed:(NSError *)error{
    ServiceHelper *sv =[[ServiceHelper alloc]init];
    sv.delegate = self;
    [sv fetchAllRegionStats];

    
}
-(void)serviceHelper:(ServiceHelper *)client didFetchEvents:(id)events{
    [self saveEvents:events];
}
-(void)serviceHelper:(ServiceHelper *)client didFetchEventsFailed:(NSError *)error{
    ServiceHelper *sh = [[ServiceHelper alloc]init];
    sh.delegate = self;
    [sh fetchAllContent];
}
-(void)serviceHelper:(ServiceHelper *)client didFetchRegionStats:(id)regionStat{
    
    i = 0;
    [self performSelectorInBackground:@selector(updateText:) withObject:NSLocalizedString(@"sync_progress_regions_stat", @"")];
    self.lblSyncText.text = @"CHECKING FOR REGIONS STATS";
    NSMutableArray *regionss = [[regionStat valueForKey:@"data"] valueForKey:@"stats"];
    for (NSDictionary *dic in regionss) {
        NSString *rid = [dic valueForKey:@"region"];
        NSString *totalSpecies =[dic valueForKey:@"total_species"];
        NSString *totalContacts = [dic valueForKey:@"total_contacts"];
        NSString *totalUsers = [dic valueForKey:@"total_users"];
    
        ++i;
        
        RegionStats *region = [RegionStats getRegionStatForID:rid moc:self.moc];
        if (region == nil) {
            [RegionStats createRegionStat:rid tspecies:totalSpecies tcontacts:totalContacts tusers:totalUsers moc:self.moc];
        }else{
            region.regionStatRID = rid;
            region.regionStatTotalContacts = totalContacts;
            region.regionStatTotalSpecies = totalSpecies;
            region.regionStatTotalUsers = totalUsers;
           
            [self.moc save:nil];
        }
        double value = (double)i/(regionss.count);
        
        [self performSelectorInBackground:@selector(updateProgressBar:) withObject:[NSNumber numberWithDouble:value]];
    }
     [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:REPORTINGREGION];
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:SELECTEDREGIONS];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:LASTSYNC];
    [[NSUserDefaults standardUserDefaults]synchronize];
    DashboardViewController *dashboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"dashboardVC"];
    dashboardVC.moc = self.moc;
    [self.navigationController pushViewController:dashboardVC animated:YES];
    
}
-(void)serviceHelper:(ServiceHelper *)client didFetchRegionStatsFailed:(NSError *)error{
     [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:REPORTINGREGION];
    
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:SELECTEDREGIONS];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:LASTSYNC];
    [[NSUserDefaults standardUserDefaults]synchronize];
    DashboardViewController *dashboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"dashboardVC"];
    dashboardVC.moc = self.moc;
    [self.navigationController pushViewController:dashboardVC animated:YES];

    
}
#pragma mark -
#pragma mark - Helper
-(void)updateText:(NSString*)text{
    self.lblSyncText.text = text;
}
-(void)updateProgressBar:(NSNumber*)progressValue{
    
    [self.loaderView setProgress:[progressValue doubleValue] ];
}
@end
