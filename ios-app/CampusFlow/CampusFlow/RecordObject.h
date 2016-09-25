//
//  RecordObject.h
//  CampusFlow
//
//  Created by Ellie on 9/25/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordObject : NSObject <NSCoding>
@property (strong, nonatomic) NSString *setting;
@property (strong, nonatomic) NSString *lighting;
@property (strong, nonatomic) NSString *food;
@property (strong, nonatomic) NSString *outlets;
@property (strong, nonatomic) NSString *whiteboards;
@property (strong, nonatomic) NSString *tablespace;
@property (strong, nonatomic) NSString *traffic;
@property (strong, nonatomic) NSString *location;
@property (nonatomic) int sound;
@property (nonatomic) int dev;
@property (nonatomic) int temp;
@property (nonatomic) double rating;
- (id)initWithSetting:(NSString*)setting withLighting:(NSString*)lighting withFood:(NSString*)food withOutlets:(NSString*)outlets withWhiteboards:(NSString*)whiteboards withTablespace:(NSString*)tablespace withTraffic:(NSString*)traffic withSound:(int)sound withDev:(int)dev withTemp:(int)temp withLocation:(NSString*)loc withRating:(double)rat;

+ (void)addRecord:(RecordObject*)rec;
+ (NSMutableArray*)retrieveRecords;
@end
