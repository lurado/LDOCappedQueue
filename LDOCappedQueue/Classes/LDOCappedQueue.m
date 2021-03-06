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

- (instancetype)initWithCapacity:(NSUInteger)capacity
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

- (NSArray *)allObjects
{
    return [self.buffer copy];
}

- (void)enqueueObject:(nonnull id)object
{
    if (self.count == self.capacity) {
        [self.buffer removeObjectAtIndex:0];
    }
    
    [self.buffer addObject:object];
}

- (void)enqueueObjectsFromArray:(NSArray *)array
{
    NSUInteger newEntriesCount = MIN(array.count, self.capacity);
    if (self.count + newEntriesCount > self.capacity) {
        NSInteger excessObjects = (self.count + newEntriesCount - self.capacity);
        [self.buffer removeObjectsInRange:NSMakeRange(0, excessObjects)];
    }
    
    if (newEntriesCount != array.count) {
        array = [array subarrayWithRange:NSMakeRange(array.count - newEntriesCount, newEntriesCount)];
    }
    
    [self.buffer addObjectsFromArray:array];
}

- (void)prequeueObject:(nonnull id)object
{
    if (self.count == self.capacity) {
        return;
    }
    
    [self.buffer insertObject:object atIndex:0];
}

- (void)prequeueObjectsFromArray:(nonnull NSArray *)array
{
    NSUInteger newEntriesCount = MIN(array.count, self.capacity - self.count);
    
    for (NSUInteger i = 1; i <= newEntriesCount; ++i) {
        [self.buffer insertObject:array[array.count - i] atIndex:0];
    }
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

- (nonnull NSArray *)dequeueObjects:(NSUInteger)maxCount
{
    NSRange range = NSMakeRange(0, MIN(self.count, maxCount));
    NSArray *objects = [self.buffer subarrayWithRange:range];
    [self.buffer removeObjectsInRange:range];
    return objects;
}

@end
