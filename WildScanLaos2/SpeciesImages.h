//
//  SpeciesImages.h
//  WildScan
//
//  Created by Shabir Jan on 01/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Species;

NS_ASSUME_NONNULL_BEGIN

@interface SpeciesImages : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)createSpecieImage:(NSString*)specie imagePath:(NSString*)imagePath credit:(NSString*)imageCredit order:(NSString*)imageOrder licence:(NSString*)imageLicence moc:(NSManagedObjectContext*)moc;
+(NSArray*)getAllSpecieImages:(NSString*)specieID moc:(NSManagedObjectContext*)moc;
+(SpeciesImages*)getImage:(NSString*)imageName moc:(NSManagedObjectContext*)moc;
@end

NS_ASSUME_NONNULL_END

#import "SpeciesImages+CoreDataProperties.h"
