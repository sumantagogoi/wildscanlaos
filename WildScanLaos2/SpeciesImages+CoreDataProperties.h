//
//  SpeciesImages+CoreDataProperties.h
//  WildScan
//
//  Created by Shabir Jan on 20/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SpeciesImages.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpeciesImages (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *specieImageCredit;
@property (nullable, nonatomic, retain) NSString *specieImageLicence;
@property (nullable, nonatomic, retain) NSString *specieImageOrder;
@property (nullable, nonatomic, retain) NSString *specieImagePath;
@property (nullable, nonatomic, retain) NSString *specieImageSpecieID;

@end

NS_ASSUME_NONNULL_END
