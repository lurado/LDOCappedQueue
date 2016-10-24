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
@property (nonatomic, readonly, nonnull) NSArray<ObjectType> *allObjects;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCapacity:(NSUInteger)capacity NS_DESIGNATED_INITIALIZER;

/**
 * @brief Adds an object at the end of the queue.
 */
- (void)enqueueObject:(nonnull ObjectType)object;

/**
 * @brief Adds an array of objects at the end of the queue.
 */
- (void)enqueueObjectsFromArray:(nonnull NSArray<ObjectType> *)array;

/**
 * @brief Adds an object at the front of the queue.
 *
 * If the queues capacity is reached, the object won't be added.
 */
- (void)prequeueObject:(nonnull ObjectType)object;

/**
 * @brief Adds an array of objects at the front of the queue.
 *
 * Objects are only added to fill the queue up to its capacity, skipping the first elements in the array.
 */
- (void)prequeueObjectsFromArray:(nonnull NSArray<ObjectType> *)array;

/**
 * @brief Removes and returns an object from the front of the queue.
 */
- (nullable ObjectType)dequeueObject;

/**
 * @brief Removes and returns the given number of objects from the front of the queue.
 */
- (nonnull NSArray<ObjectType> *)dequeueObjects:(NSUInteger)maxCount;

@end
