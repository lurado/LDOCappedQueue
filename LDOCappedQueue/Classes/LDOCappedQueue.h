//
//  LDOCappedQueue.h
//  Pods
//
//  Created by Sebastian Ludwig on 18.10.16.
//  Copyright (c) 2016 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDOCappedQueue<ObjectType> : NSObject

@property (nonatomic, readonly) NSUInteger capacity;
@property (nonatomic, readonly) NSUInteger count;

- (nullable instancetype)init NS_UNAVAILABLE;
- (nullable instancetype)initWithCapacity:(NSUInteger)capacity NS_DESIGNATED_INITIALIZER;

- (void)enqueueObject:(nonnull ObjectType)object;
- (void)enqueueObjectsFromArray:(nonnull NSArray<ObjectType> *)array;
- (nullable ObjectType)dequeueObject;
- (nonnull NSArray<ObjectType> *)dequeueObjects:(NSUInteger)maxCount;

@end
