//
//  RecordObject.m
//  CampusFlow
//
//  Created by Ellie on 9/25/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import "RecordObject.h"

@implementation RecordObject
@synthesize setting, lighting, food, outlets, whiteboards, tablespace, traffic, sound, dev, temp, location, rating;

- (id)initWithSetting:(NSString *)setting withLighting:(NSString *)lighting withFood:(NSString *)food withOutlets:(NSString *)outlets withWhiteboards:(NSString *)whiteboards withTablespace:(NSString *)tablespace withTraffic:(NSString *)traffic withSound:(int)sound withDev:(int)dev withTemp:(int)temp withLocation:(NSString*)loc withRating:(double)rat{
    self = [super init];
    if (self) {
        self.setting = setting;
        self.lighting = lighting;
        self.food = food;
        self.outlets = outlets;
        self.whiteboards = whiteboards;
        self.tablespace = tablespace;
        self.traffic = traffic;
        self.sound = sound;
        self.dev = dev;
        self.temp = temp;
        self.location = loc;
        self.rating = rat;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.setting = [decoder decodeObjectForKey:@"setting"];
        self.lighting = [decoder decodeObjectForKey:@"lighting"];
        self.food = [decoder decodeObjectForKey:@"food"];
        self.outlets = [decoder decodeObjectForKey:@"outlets"];
        self.whiteboards = [decoder decodeObjectForKey:@"whiteboards"];
        self.tablespace = [decoder decodeObjectForKey:@"tablespace"];
        self.traffic = [decoder decodeObjectForKey:@"traffic"];
        self.sound = [decoder decodeIntForKey:@"sound"];
        self.dev = [decoder decodeIntForKey:@"dev"];
        self.temp = [decoder decodeIntForKey:@"temp"];
        self.location = [decoder decodeObjectForKey:@"location"];
        self.rating = [decoder decodeDoubleForKey:@"rating"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:setting forKey:@"setting"];
    [encoder encodeObject:lighting forKey:@"lighting"];
    [encoder encodeObject:food forKey:@"food"];
    [encoder encodeObject:outlets forKey:@"outlets"];
    [encoder encodeObject:whiteboards forKey:@"whiteboards"];
    [encoder encodeObject:tablespace forKey:@"tablespace"];
    [encoder encodeObject:traffic forKey:@"traffic"];
    [encoder encodeInteger:sound forKey:@"sound"];
    [encoder encodeInteger:dev forKey:@"dev"];
    [encoder encodeInteger:temp forKey:@"temp"];
    [encoder encodeObject:location forKey:@"location"];
    [encoder encodeDouble:rating forKey:@"rating"];
}

+ (void)addRecord:(RecordObject *)rec {
    NSMutableArray *records = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"records.dat"]];
    if (records == nil) {
        records = [[NSMutableArray alloc] initWithCapacity:100];
    }
    [records addObject:rec];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"records.dat"]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"records.dat"] error:nil];
    }
    [[NSFileManager defaultManager] createFileAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"records.dat"] contents:[NSKeyedArchiver archivedDataWithRootObject:records] attributes:[[NSDictionary alloc] init]];
}

+ (NSMutableArray*)retrieveRecords {
    NSMutableArray *records = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"records.dat"]];
    NSLog(@"rec: %@", records);
    return records;
}

@end
