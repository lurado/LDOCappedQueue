//
//  LDOCappedQueue.m
//  Pods
//
//  Created by Sebastian Ludwig on 18.10.16.
//  Copyright (c) 2016 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import "LDOCappedQueue.h"

@interface LDOCappedQueue ()

@property (nonatomic) NSMutableArray *buffer;

@end

@implementation LDOCappedQueue

- (nullable instancetype)initWithCapacity:(NSUInteger)capacity
{
    if (self = [super init]) {
        _capacity = capacity;
        _buffer = [NSMutableArray arrayWithCapacity:capacity];
    }
    return self;
}

- (NSUInteger)count
{
    return self.buffer.count;
}

- (void)enqueueObject:(nonnull id)object
{
    if (self.count + 1 > self.capacity) {
        [self.buffer removeObjectAtIndex:0];
    }
    
    [self.buffer addObject:object];
}

- (void)enqueueObjectsFromArray:(NSArray<id> *)array
{
    NSUInteger newEntriesCount = MIN(array.count, self.capacity);
    if (self.count + newEntriesCount > self.capacity) {
        [self.buffer removeObjectsInRange:NSMakeRange(0, newEntriesCount)];
    }
    
    if (newEntriesCount != array.count) {
        array = [array subarrayWithRange:NSMakeRange(array.count - newEntriesCount, newEntriesCount)];
    }
    
    [self.buffer addObjectsFromArray:array];
}

- (nullable id)dequeueObject
{
    if (self.count == 0) {
        return nil;
    }
    id object = [self.buffer firstObject];
    [self.buffer removeObjectAtIndex:0];
    return object;
}

- (nonnull NSArray<id> *)dequeueObjects:(NSUInteger)maxCount
{
    NSRange range = NSMakeRange(0, MIN(self.count, maxCount));
    NSArray<id> *objects = [self.buffer subarrayWithRange:range];
    [self.buffer removeObjectsInRange:range];
    return objects;
}

@end
