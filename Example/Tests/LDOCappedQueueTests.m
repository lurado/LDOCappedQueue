//
//  LDOCappedQueueTests.m
//  LDOCappedQueueTests
//
//  Created by Sebastian Ludwig on 10/18/2016.
//  Copyright (c) 2016 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

@import XCTest;
@import LDOCappedQueue;

@interface LDOCappedQueueTests : XCTestCase

@end

@implementation LDOCappedQueueTests
{
    LDOCappedQueue<NSString *> *queue;
}

- (void)setUp
{
    [super setUp];
    
    queue = [[LDOCappedQueue alloc] initWithCapacity:4];
}

- (NSString *)randomString
{
    return [[NSUUID UUID] UUIDString];
}

- (void)fillQueue:(LDOCappedQueue *)q withObjects:(NSUInteger)count
{
    for (int i = 0; i < count; ++i) {
        [q enqueueObject:[self randomString]];
    }
}

- (void)testCountsAddedObjects
{
    NSInteger count = (arc4random() % 2) + 1;
    [self fillQueue:queue withObjects:count];
    
    XCTAssertEqual(queue.count, count);
}

- (void)testDequeuesObjectsInOrder
{
    NSString *first = [self randomString];
    NSString *second = [self randomString];
    
    [queue enqueueObject:first];
    [queue enqueueObject:second];
    
    XCTAssertEqual([queue dequeueObject], first);
    XCTAssertEqual([queue dequeueObject], second);
    XCTAssertEqual(queue.count, 0);
    XCTAssertEqual([queue dequeueObject], nil);
}

- (void)testDoesNotContainMoreThanCapacity
{
    [self fillQueue:queue withObjects:6];
    
    XCTAssertEqual(queue.count, 4);
}

- (void)testOverwritesOldestEntry
{
    [self fillQueue:queue withObjects:4];
    
    NSString *newest = [self randomString];
    [queue enqueueObject:newest];
    
    for (int i = 0; i < 3; ++i) {
        [queue dequeueObject];
    }
    
    XCTAssertEqual([queue dequeueObject], newest);
}

- (void)testDequeueMultiple
{
    NSString *first = [self randomString];
    NSString *second = [self randomString];
    [queue enqueueObject:first];
    [queue enqueueObject:second];
    
    [self fillQueue:queue withObjects:2];
    
    NSArray<NSString *> *dequeued = [queue dequeueObjects:2];
    
    XCTAssertEqual(dequeued.count, 2);
    XCTAssertEqual(dequeued[0], first);
    XCTAssertEqual(dequeued[1], second);
}

- (void)testDequeueMultipleReturnsNumberOfContainedObjectsAtMost
{
    [queue enqueueObject:[self randomString]];
    
    XCTAssertEqual([queue dequeueObjects:2].count, 1);
}

- (void)testEnqueueMultipleEnqueues
{
    NSArray<NSString *> *entries = @[[self randomString], [self randomString]];
    
    [queue enqueueObjectsFromArray:entries];
    
    XCTAssertEqual(queue.count, 2);
    XCTAssertEqual([queue dequeueObject], entries[0]);
    XCTAssertEqual([queue dequeueObject], entries[1]);
}

- (void)testEnqueueMultipleTooMany
{
    NSArray<NSString *> *entries = @[[self randomString], [self randomString], [self randomString], [self randomString], [self randomString]];
    
    [queue enqueueObjectsFromArray:entries];
    
    XCTAssertEqual(queue.count, 4);
    
    for (int i = 1; i < entries.count; ++i) {
        XCTAssertEqual([queue dequeueObject], entries[i]);
    }
}

- (void)testEnqueueMultipleSlightlyTooMany
{
    NSString *first = [self randomString];
    NSString *second = [self randomString];
    [queue enqueueObjectsFromArray:@[first, second]];
    
    NSArray<NSString *> *newEntries = @[[self randomString], [self randomString], [self randomString]];
    [queue enqueueObjectsFromArray:newEntries];
    
    XCTAssertEqual(queue.count, 4);
    
    XCTAssertEqual([queue dequeueObject], second);
    for (NSString *newEntry in newEntries) {
        XCTAssertEqual([queue dequeueObject], newEntry);
    }
}

- (void)testPrequeueObjectAddsAtFront
{
    [self fillQueue:queue withObjects:2];
    NSString *new = [self randomString];
    [queue prequeueObject:new];
    
    XCTAssertEqual(queue.count, 3);
    XCTAssertEqual([queue dequeueObject], new);
}

- (void)testPrequeueObjectDoesNotAddIfCapacityReached
{
    [self fillQueue:queue withObjects:4];
    NSString *new = [self randomString];
    [queue prequeueObject:new];
    
    XCTAssertNotEqual([queue dequeueObject], new);
}

- (void)testPrequeueMultiple
{
    [self fillQueue:queue withObjects:2];
    NSArray<NSString *> *newEntries = @[[self randomString], [self randomString]];
    
    [queue prequeueObjectsFromArray:newEntries];
    
    XCTAssertEqual([queue dequeueObject], newEntries[0]);
    XCTAssertEqual([queue dequeueObject], newEntries[1]);
}

- (void)testPrequeueMultipleTooMany
{
    NSArray<NSString *> *newEntries = @[[self randomString], [self randomString], [self randomString], [self randomString], [self randomString]];
    
    [queue prequeueObjectsFromArray:newEntries];
    
    XCTAssertEqual(queue.count, 4);
}

- (void)testPrequeueMultipleAddsNewest
{
    NSArray<NSString *> *entries = @[[self randomString], [self randomString], [self randomString]];
    [queue enqueueObjectsFromArray:entries];
    NSArray<NSString *> *newEntries = @[[self randomString], [self randomString]];
    
    [queue prequeueObjectsFromArray:newEntries];
    
    XCTAssertEqual([queue dequeueObject], newEntries[1]);
    XCTAssertEqual([queue dequeueObject], entries[0]);
    XCTAssertEqual([queue dequeueObject], entries[1]);
    XCTAssertEqual([queue dequeueObject], entries[2]);
}

- (void)testDequeuePrequeue
{
    NSArray<NSString *> *entries = @[[self randomString], [self randomString], [self randomString], [self randomString]];
    [queue enqueueObjectsFromArray:entries];
    
    NSArray<NSString *> *dequeued = [queue dequeueObjects:2];
    [queue prequeueObjectsFromArray:dequeued];
    
    XCTAssertEqual([queue dequeueObject], entries[0]);
    XCTAssertEqual([queue dequeueObject], entries[1]);
    XCTAssertEqual([queue dequeueObject], entries[2]);
    XCTAssertEqual([queue dequeueObject], entries[3]);
}

- (void)allObjects
{
    NSArray<NSString *> *entries = @[[self randomString], [self randomString], [self randomString], [self randomString]];
    [queue enqueueObjectsFromArray:entries];
    
    NSArray<NSString *> *allObjects = queue.allObjects;
    
    for (int i = 0; i < entries.count; ++i) {
        XCTAssertEqual(allObjects[i], entries[i]);
    }
}

@end

