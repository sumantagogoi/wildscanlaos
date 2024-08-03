//
//  SynchHelper.m
//  WildScan
//
//  Created by Shabir Jan on 15/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "SynchHelper.h"
#import "Species.h"
#import "SpeciesImages.h"
#import "SpeciesTranslation.h"
#import "Contacts.h"
#import "ContactsTranslation.h"
#import "Content.h"
#import "Events.h"
#import "Region.h"
#import "RegionStats.h"
#import "reverseGeoCoder.h"
#import "SVProgressHUD.h"
#import "AFHTTPSessionManager.h"
#import "UserReport.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSDictionary+SJDictionaryAddition.h"
@implementation SynchHelper

-(void)startSync{
    isBackSync = [[NSUserDefaults standardUserDefaults]boolForKey:ISBACGROUNDKSYNC];
    
//    if (isBackSync) {
		[SVProgressHUD showWithStatus:NSLocalizedString(@"sync_progress_species", @"")];
//        [self fetchAllSpecies];
//    }else{
        NSArray *unsubmittedReports = [UserReport getAllUnsubmittedReports:self.moc];
        if(unsubmittedReports.count>0){
            UserReport *currentObj =[unsubmittedReports firstObject];
            NSDictionary *mainDic = [[NSDictionary alloc]initWithObjectsAndKeys:currentObj.userReportString,@"json", nil];
            NSString *url = [NSString stringWithFormat:@"https://wildscan.org/laos/api/submit-report-json.php"];
			
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            [manager POST:url parameters:mainDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //NSLog(@"JSON: %@", responseObject);
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSString *myString = [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
                NSLog(@"Error: %@", myString);
               
            }];
//        }
        }
		[self fetchAllRegions];
}
-(void)saveSpecies:(NSDictionary*)species{
    
    NSArray *speciesDic = [[species valueForKey:@"data"] valueForKey:@"species"];
    for (NSDictionary *dic in speciesDic) {
        NSDictionary *replacedDict = [dic dictionaryByReplacingNullsWithStrings];
        NSString *specieID= [replacedDict valueForKey:@"id"];
        NSString *specieRegion = [replacedDict valueForKey:@"region"];
        NSString *specieIsGlobal = [replacedDict valueForKey:@"is_global"];
        NSString *specieType = [replacedDict valueForKey:@"type"];
        NSString *specieCommonName = [replacedDict valueForKey:@"common_name"];
        NSString *specieScientificName = [replacedDict valueForKey:@"scientific_name"];
        NSString *specieCites = [replacedDict valueForKey:@"cites"];
        NSString *specieCitesOther = [replacedDict valueForKey:@"cites_other"];
        NSString *specieExtantCountries = [replacedDict valueForKey:@"extant_countries"];
        NSString *specieStatus = [replacedDict valueForKey:@"status"];
        NSString *specieWarnings = [replacedDict valueForKey:@"warnings"];
        NSString *specieHabitat = [replacedDict valueForKey:@"habitat"];
        NSString *specieBasicIDCues =[replacedDict valueForKey:@"basic_id_cues"];
        NSString *specieConsumerAdvice = [replacedDict valueForKey:@"consumer_advice"];
        NSString *specieEnforcementAdvice = [replacedDict valueForKey:@"enforcement_advice"];
        NSString *specieSimilarAnimals = [replacedDict valueForKey:@"similar_animals"];
        NSString *specieKnownAs = [replacedDict valueForKey:@"known_as"];
        NSString *specieAverageSizeWeight = [replacedDict valueForKey:@"average_size_weight"];
        NSString *specieFirstResponder = [replacedDict valueForKey:@"first_responder"];
        NSString *specieTradedAs = [replacedDict valueForKey:@"traded_as"];
        NSString *specieCommonTrafficking = [replacedDict valueForKey:@"common_trafficking"];
        NSString *specieNotes = [replacedDict valueForKey:@"notes"];
        NSString *specieKeywordTags = [replacedDict valueForKey:@"keywords_tags"];
        NSString *specieReference = [replacedDict valueForKey:@"reference"];
        NSString *specieDieaseName = [replacedDict valueForKey:@"disease_name"];
        NSString *specieDieaseRiskLevel = [replacedDict valueForKey:@"disease_risk_level"];
        NSString *specieCreatedBy = [replacedDict valueForKey:@"created_by"];
        NSString *specieCreatedDate = [replacedDict valueForKey:@"created_date"];
        NSString *specieUpdatedBy = [replacedDict valueForKey:@"updated_by"];
        NSString *specieUpdatedDate = [replacedDict valueForKey:@"updated_date"];
     __block   NSString *specieImageUrl = [replacedDict valueForKey:@"image"];
//        specieUpdatedBy = !([specieUpdatedBy isEqual:[NSNull null]])?specieUpdatedBy:@"";
//        specieUpdatedBy = !([specieUpdatedBy isEqual:[NSNull null]])?specieUpdatedBy:@"";
        NSArray *urlComponents = [specieImageUrl componentsSeparatedByString:@"/"];
        specieImageUrl = [urlComponents lastObject];
        
        UIImage *image = [UIImage imageNamed:specieImageUrl];
        if (image == nil) {
            NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://wildscan.org/laos/wildscan-uploads%@",[replacedDict valueForKey:@"image"]]];
			//NSLog(@"%@",url);
            dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(q, ^{
                /* Fetch the image from the server... */
                NSData *data = [NSData dataWithContentsOfURL:url];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    /* This is the main thread again, where we set the tableView's image to
                     be what we just fetched. */
                    if ( data )
                    {
                        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        NSString *fileName = [NSString stringWithFormat:@"%@",specieImageUrl];
                        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fileName];
						//NSLog(@"%@",filePath);
                        [data writeToFile:filePath atomically:YES];
                        specieImageUrl = filePath;
                    }
                    [Species createSpecie:specieID region:specieRegion isGlobal:specieIsGlobal type:specieType commonname:specieCommonName scientificname:specieScientificName cities:specieCites citiesother:specieCitesOther extantcountries:specieExtantCountries status:specieStatus warnings:specieWarnings habitat:specieHabitat basicues:specieBasicIDCues consumeradvice:specieConsumerAdvice enforcementadvice:specieEnforcementAdvice similarAnimals:specieSimilarAnimals knownas:specieKnownAs averagesizeweight:specieAverageSizeWeight firstresponder:specieFirstResponder tradedas:specieTradedAs commontrafficing:specieCommonTrafficking notes:specieNotes keywordtags:specieKeywordTags references:specieReference dieasename:specieDieaseName dieaserisklevel:specieDieaseRiskLevel createdby:specieCreatedBy createddate:specieCreatedDate updatedby:specieUpdatedBy updateddate:specieUpdatedDate image:specieImageUrl moc:self.moc];
                });
            });
            
            
        }
        else{
            [Species createSpecie:specieID region:specieRegion isGlobal:specieIsGlobal type:specieType commonname:specieCommonName scientificname:specieScientificName cities:specieCites citiesother:specieCitesOther extantcountries:specieExtantCountries status:specieStatus warnings:specieWarnings habitat:specieHabitat basicues:specieBasicIDCues consumeradvice:specieConsumerAdvice enforcementadvice:specieEnforcementAdvice similarAnimals:specieSimilarAnimals knownas:specieKnownAs averagesizeweight:specieAverageSizeWeight firstresponder:specieFirstResponder tradedas:specieTradedAs commontrafficing:specieCommonTrafficking notes:specieNotes keywordtags:specieKeywordTags references:specieReference dieasename:specieDieaseName dieaserisklevel:specieDieaseRiskLevel createdby:specieCreatedBy createddate:specieCreatedDate updatedby:specieUpdatedBy updateddate:specieUpdatedDate image:specieImageUrl moc:self.moc];
        }
    }
    if (isBackSync) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"sync_progress_translations", @"")];
    }
    [self fetallAllSpeciesTranslation];
    
}
-(void)saveSpeciesTranslation:(NSDictionary*)speciesTranlsation{
    
    
    NSMutableArray *species = [[speciesTranlsation valueForKey:@"data"] valueForKey:@"speciesTranslations"];
    
    for (NSDictionary *dic in species) {
        
        NSString *specieID= [dic valueForKey:@"species_id"];
        NSArray *specieTranslations = [dic valueForKey:@"translations"];
        for (NSDictionary *dic in specieTranslations) {
            
            if ([specieID isEqualToString:@"325"]) {
                //NSLog(@"translation %@",dic);
            }
            
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
            
            
            
            [SpeciesTranslation createSpecieTranslation:species commonname:specieCommonName habitat:specieHabitat basicues:specieBasicIDCues consumeradvice:specieConsumerAdvice enforcementadvice:specieEnforcementAdvice similarAnimals:specieSimilarAnimals knownas:specieKnownAs averagesizeweight:specieAverageSizeWeight firstresponder:specieFirstResponder tradedas:specieTradedAs commontrafficing:specieCommonTrafficking notes:specieNotes dieasename:specieDieaseName specieLangauge:language moc:self.moc];
            
            
        }
    }
    if (isBackSync) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"sync_progress_photos", @"")];
    }
	
    [self fetchAllSpecieImagePaths];
    
}
-(void)saveSpeciesImages:(NSDictionary*)speciesImages{
    
    NSMutableArray *species = [[speciesImages valueForKey:@"data"] valueForKey:@"speciesImages"];
	
    for (NSDictionary *dic in species) {
        
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
             SpeciesImages *currentObj = [SpeciesImages getImage:specieImagePath moc:self.moc];
            if (currentObj == nil) {
                 [SpeciesImages createSpecieImage:specieID imagePath:specieImagePath credit:specieImageCredit order:specieImageOrder licence:specieImageLicense moc:self.moc];
            }
        }
    }
    
    if (isBackSync) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"sync_progress_contacts", @"")];
    }
    
    [self fetchAllContacts];
    
}

-(void)saveContacts:(NSDictionary*)contacts{
    NSMutableDictionary *allContacts  = [[contacts valueForKey:@"data"] valueForKey:@"contacts"];
    for (NSDictionary *dic in allContacts) {
        NSString *contactID = [dic valueForKey:@"id"];
        NSString *contactName = [dic valueForKey:@"name"];
        __block NSString *contactAvatarUrl = [dic valueForKey:@"avatar"];
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
            NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://wildscan.org/laos/wildscan-uploads%@",[dic valueForKey:@"avatar"]]];
            
            dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(q, ^{
                /* Fetch the image from the server... */
                NSData *data = [NSData dataWithContentsOfURL:url];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    /* This is the main thread again, where we set the tableView's image to
                     be what we just fetched. */
                    if ( data )
                    {
                        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString  *documentsDirectory = [paths objectAtIndex:0];
                        NSString *fileName = [NSString stringWithFormat:@"%@.png",contactAvatarUrl];
                        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fileName];
                        [data writeToFile:filePath atomically:YES];
                        contactAvatarUrl = filePath;
                        
                    }
                    [Contacts createContact:contactID name:contactName avatar:contactAvatarUrl type:contactType agency:contactAgency jurisdiction:contactJurisdictionScope scapacity:contactSpecialcapacityNote email:contactEmail phone:contactPhone address1:contactAddress1 address2:contactAddress2 city:contactCity country:contactCountry region:contactRegion website:contactWebsite availability:contactAvailablity lat:contactLat lon:contactLon utm:contactUTM createdBy:contactCreatedBy createdDate:contactCreatedDate updatedBy:contactUpdatedBy updatedDate:contactUpdatedDate moc:self.moc];
                });
            });
            
            
            
        }else{
            [Contacts createContact:contactID name:contactName avatar:contactAvatarUrl type:contactType agency:contactAgency jurisdiction:contactJurisdictionScope scapacity:contactSpecialcapacityNote email:contactEmail phone:contactPhone address1:contactAddress1 address2:contactAddress2 city:contactCity country:contactCountry region:contactRegion website:contactWebsite availability:contactAvailablity lat:contactLat lon:contactLon utm:contactUTM createdBy:contactCreatedBy createdDate:contactCreatedDate updatedBy:contactUpdatedBy updatedDate:contactUpdatedDate moc:self.moc];
        }
        
        
        
        
    }
//    if (isBackSync) {
//        [SVProgressHUD showWithStatus:NSLocalizedString(@"sync_progress_translations", @"")];
//    }
	
    [self fetchAllContactsTranslation];
    
}
-(void)saveContactTranslation:(NSDictionary*)contactTranlsation{
    NSMutableArray *contacts = [[contactTranlsation valueForKey:@"data"] valueForKey:@"contactsTranslations"];
    
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
            NSLog(@"here the language is %@",contactLanguage);
            
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
        
    }
    
    if (isBackSync) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"sync_progress_content", @"")];
    }
    
    [self fetchAllContent];
}
-(void)saveEvents:(NSDictionary*)eventss{
    NSMutableArray *events = [[eventss valueForKey:@"data"] valueForKey:@"submitReports"];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDateFormatter* dateFormatter2 = [[NSDateFormatter alloc]init];
    
    [dateFormatter2 setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter2 setTimeStyle:NSDateFormatterNoStyle];
    
    reverseGeoCoder * reverseGeo  = [[reverseGeoCoder alloc]init];
    if(events.count>0){
        [Events deleteAllEvents:self.moc];
    }
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
        __block NSString *imageUrl = [event valueForKey:@"image"];
        //contactID = !([contactID isEqual:[NSNull null]])?contactID:@"";
        
        region = !([region isEqual:[NSNull null]])?region:@"";
        updatedBy = !([updatedBy isEqual:[NSNull null]])?updatedBy:@"";
        updatedDate = !([updatedDate isEqual:[NSNull null]])?updatedDate:@"";
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[locationLat doubleValue] longitude:[locationLong doubleValue]];
        NSString *country = [reverseGeo getCountryDetailWithKey:KeyName withLocation:location];
        
        
        NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://wildscan.org/laos/wildscan-uploads%@",imageUrl]];
        
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(q, ^{
            /* Fetch the image from the server... */
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                /* This is the main thread again, where we set the tableView's image to
                 be what we just fetched. */
                if ( data )
                {
                    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString  *documentsDirectory = [paths objectAtIndex:0];
                    NSString *fileName = [NSString stringWithFormat:@"%@.png",eventid];
                    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fileName];
                    [data writeToFile:filePath atomically:YES];
                    imageUrl = filePath;
                    
                }else{
                    
                    imageUrl = @"";
                }
                [Events createEvent:eventid
                       incidentDate:incidentDate
                   internetIncident:internetIncident
                    locationAddress:locationAddress
                         webAddress:webAddress
                        locationLat:locationLat
                       locationLong:locationLong
                             region:region
                           incident:incident
                            species:species
                             number:number
                         numberUnit:numberUnit
                  incidentCondition:incidentCondition
                        offenseType:offenseType
                 offenseDescription:offenseDescription
                             method:method
                  valueEstimatedUSD:valueUSD
                      originAddress:originAddress
                      originCountry:originCountry
                          originLat:originLat
                         originLong:originLong
                 destinationAddress:destinationAddress
                 destinationCountry:destinationCountry
                     destinationLat:destinationLat
                    destinationLong:destinationLon
           vehicelVesselDescription:vehicleVesselDescription
         vehicleVesselLisenseNumber:vehicleVesselLisence
                         vesselName:vesselName
                          shareWith:shareWith
                          syndicate:syndicate
                             status:status
                          createdBy:createdBy
                        createdDate:createdDate
                          updatedBy:updatedBy
                        updatedDate:updatedDate
                           imageUrl:imageUrl
                            country:country
                           dateTime:eventDateTime
                                moc:self.moc];

            });
        });
    }
	if (isBackSync) {
		[SVProgressHUD showWithStatus:NSLocalizedString(@"sync_progress_content", @"")];
	}
	
    [self fetchAllContent];
}
-(void)saveContent:(NSDictionary*)content{
    
    NSMutableArray *contents = [[content valueForKey:@"data"] valueForKey:@"staticContents"];
    if (content.count>0){
        [Content deleteAllContent:self.moc];
    }
    for (NSDictionary *dic in contents) {
        
        NSString *contentType = [dic valueForKey:@"type"];
        NSString *contentLang = [dic valueForKey:@"language"];
        NSString *contentBody = [dic valueForKey:@"content"];
        [Content createContent:contentLang contentType:contentType content:contentBody moc:self.moc];
    }

	if (isBackSync) {
		//[SVProgressHUD showWithStatus:NSLocalizedString(@"sync_progress_photos", @"")];
	}
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
	[dateFormatter setTimeZone:timeZone];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
	//NSLog(@"%@",dateString);
	[[NSUserDefaults standardUserDefaults]setValue:dateString forKey:LASTSYNC];
	[[NSUserDefaults standardUserDefaults]synchronize];
	[self verifyPhotos];
}

-(void)verifyPhotos{
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	__block int numberofqueueditems = 0;
	__block int numberofdoneitems = 0;
 
	NSMutableArray *allSpecies = [NSMutableArray arrayWithArray:[Species getAllSpeciesImages:self.moc]];
	NSLog(@"%@",allSpecies);
	for(int i=0 ; i<allSpecies.count; i++){
		SpeciesImages *currentObj = [allSpecies objectAtIndex:i];
		UIImage *img = [UIImage imageNamed:currentObj.specieImagePath];
		if (img == nil) {
			img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory,currentObj.specieImagePath]];
			if (img == nil){
				NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://wildscan.org/laos/wildscan-uploads/species/%@/%@",currentObj.specieImageSpecieID,currentObj.specieImagePath]];
				NSLog(@"%@",url);
				dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
				numberofqueueditems = numberofqueueditems + 1;
				dispatch_async(q, ^{
					/* Fetch the image from the server... */
					NSData *data = [NSData dataWithContentsOfURL:url];
					dispatch_async(dispatch_get_main_queue(), ^{
						/* This is the main thread again, where we set the tableView's image to
						 be what we just fetched. */
						numberofdoneitems  = numberofdoneitems + 1;
						if ( data )
							{
							NSString *fileName = [NSString stringWithFormat:@"%@",currentObj.specieImagePath];
                            NSString *fileName1 = [fileName stringByReplacingOccurrencesOfString:@" " withString:@"-" options: NSRegularExpressionSearch range:NSMakeRange(0, fileName.length)];
							NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fileName1];
                            NSLog(@"Writing image file to - %@",filePath);
							[data writeToFile:filePath atomically:YES];
						}
						if (numberofdoneitems == numberofqueueditems) {
							if ([self.delegate respondsToSelector:@selector(synchHelper:didSyncSuccess:)]) {
								[self.delegate synchHelper:self didSyncSuccess:YES];
							}
							
						}
					});
				});
			}
		}
	}
    if ([self.delegate respondsToSelector:@selector(synchHelper:didSyncSuccess:)]) {
        [self.delegate synchHelper:self didSyncSuccess:YES];
    }
}

//-(void)saveRegions:(NSDictionary*)regions{
-(void)saveRegions {
    /*
    NSMutableArray *regionss = [[regions valueForKey:@"data"] valueForKey:@"regions"];
    NSError *error = nil;
    for (NSDictionary *dic in regionss) {
        NSString *rid = [dic valueForKey:@"id"];
        NSString *rcode =[dic valueForKey:@"code"];
        NSString *rname = [dic valueForKey:@"name"];
        NSString *rdesc = [dic valueForKey:@"description"];
        NSString *remail = [dic valueForKey:@"report_email"];
        rdesc = !([rdesc isEqual:[NSNull null]])?rdesc:@"";
        
        
        Region *region = [Region getRegionByID:rid moc:self.moc];
        if (region == nil) {
            [Region createRegion:rid code:rcode name:rname des:rdesc email:remail moc:self.moc];
        }else{
            region.regionID = rid;
            region.regionCode = rcode;
            region.regionName = rname;
            region.regionReportEmail = remail;
            region.regionDescription = rdesc;
            if (![self.moc save:&error]) {
                NSLog(@"Failure to save: %@\n", error);
                abort();
            } else {
                NSLog(@"Region: %@\n",region.regionName);
            }
        }
    }
	
//    if (isBackSync) {
//        [SVProgressHUD showWithStatus:NSLocalizedString(@"sync_progress_regions_stat", @"")];
//    }
	*/
    [self fetchAllRegionStats];
    
}
//-(void)saveRegionStats:(NSDictionary*)regionStats{
-(void)saveRegionStats {
    /*
    NSMutableArray *regionss = [[regionStats valueForKey:@"data"] valueForKey:@"stats"];
    for (NSDictionary *dic in regionss) {
        NSString *rid = [dic valueForKey:@"region"];
        NSString *totalSpecies =[dic valueForKey:@"total_species"];
        NSString *totalContacts = [dic valueForKey:@"total_contacts"];
        NSString *totalUsers = [dic valueForKey:@"total_users"];
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
    }
	
//	if (isBackSync) {
//		[SVProgressHUD showWithStatus:NSLocalizedString(@"sync_progress_species", @"")];
//	}
	*/
	[self fetchAllSpecies];
}

#pragma mark -
#pragma mark - Webservices
-(void)fetchAllRegions{
    /*
    NSLog(@"Getting reions");
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-regions&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N"];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Get Region Successfully");
        [self saveRegions:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Get Region Failed");
        [SVProgressHUD dismiss];
        if ([self.delegate respondsToSelector:@selector(synchHelper:didSyncFailed:)]) {
            [self.delegate synchHelper:self didSyncFailed:error];
        }
        
    }];
    //[self saveRegions:responseObject];
    */
    [self saveRegions];
}
-(void)fetchAllRegionStats{
    /*
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-regions-stats&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N"];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    */
    // [self saveRegionStats:responseObject];
    [self saveRegionStats];
    /*
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        if ([self.delegate respondsToSelector:@selector(synchHelper:didSyncFailed:)]) {
            [self.delegate synchHelper:self didSyncFailed:error];
        }
    }];
    */
}
-(void)submitReport:(NSDictionary *)dic{
    /*
    NSArray *unsubmittedReports = [UserReport getAllUnsubmittedReports:self.moc];
    UserReport *currentObj =[unsubmittedReports firstObject];
    NSDictionary *mainDic = [[NSDictionary alloc]initWithObjectsAndKeys:currentObj.userReportString,@"json", nil];
    NSString *url = [NSString stringWithFormat:@"http://techmicro.co/wildscan-webapp/submit-report-json.php"];
	
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:mainDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *myString = [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
        NSLog(@"Error: %@", myString);
       
    }];
    */
}
-(void)fetchAllEvents{
    /*
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-submit-reports&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N"];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self saveEvents:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        if ([self.delegate respondsToSelector:@selector(synchHelper:didSyncFailed:)]) {
            [self.delegate synchHelper:self didSyncFailed:error];
        }
        
        
    }];
     */
}
-(void)fetchAllContent{
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-static-contents&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N"];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self saveContent:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        if ([self.delegate respondsToSelector:@selector(synchHelper:didSyncFailed:)]) {
            [self.delegate synchHelper:self didSyncFailed:error];
        }
    }];
}
-(void)fetchAllContacts{
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-contacts&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N&later_than=%@",[[NSUserDefaults standardUserDefaults]valueForKey:LASTSYNC]];
    url  =[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self saveContacts:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        if ([self.delegate respondsToSelector:@selector(synchHelper:didSyncFailed:)]) {
            [self.delegate synchHelper:self didSyncFailed:error];
        }
    }];
}

-(void)fetchAllContactsTranslation{
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-contacts-translations&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N&later_than=%@",[[NSUserDefaults standardUserDefaults]valueForKey:LASTSYNC]];
    url  =[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self saveContactTranslation:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        if ([self.delegate respondsToSelector:@selector(synchHelper:didSyncFailed:)]) {
            [self.delegate synchHelper:self didSyncFailed:error];
        }
    }];
}

-(void)fetchAllSpecies{
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-species&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N&later_than=%@",[[NSUserDefaults standardUserDefaults]valueForKey:LASTSYNC]];
    url  =[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self saveSpecies:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        if ([self.delegate respondsToSelector:@selector(synchHelper:didSyncFailed:)]) {
            [self.delegate synchHelper:self didSyncFailed:error];
        }
    }];
}
-(void)fetallAllSpeciesTranslation{
	NSString *lastSynced = [[NSUserDefaults standardUserDefaults]valueForKey:LASTSYNC];
	
	if ([lastSynced isEqualToString:@""] || lastSynced == nil){
		lastSynced = @"2016-7-20 19:00:00";
	}
	
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-species-translations&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N&later_than=%@",lastSynced];
    url  =[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self saveSpeciesTranslation:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        if ([self.delegate respondsToSelector:@selector(synchHelper:didSyncFailed:)]) {
            [self.delegate synchHelper:self didSyncFailed:error];
        }
        
        
    }];
}
-(void)fetchAllSpecieImagePaths{
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-species-images&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N&later_than=%@",[[NSUserDefaults standardUserDefaults]valueForKey:LASTSYNC]];
    url  =[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self saveSpeciesImages:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        if ([self.delegate respondsToSelector:@selector(synchHelper:didSyncFailed:)]) {
            [self.delegate synchHelper:self didSyncFailed:error];
        }
    }];
}

@end
