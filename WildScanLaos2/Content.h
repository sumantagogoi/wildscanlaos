//
//  Content.h
//  WildScan
//
//  Created by Shabir Jan on 09/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Content : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(Content*)createContent:(NSString*)language contentType:(NSString*)type content:(NSString*)content moc:(NSManagedObjectContext*)moc;
+(NSArray*)getAllContents:(NSManagedObjectContext*)moc;
+(Content*)getContent:(NSString*)lanaguage type:(NSString*)contentType moc:(NSManagedObjectContext*)moc;
+(void)deleteAllContent:(NSManagedObjectContext*)moc;
@end

NS_ASSUME_NONNULL_END

#import "Content+CoreDataProperties.h"
