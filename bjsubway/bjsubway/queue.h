//
//  queue.h
//  bjsubway
//
//  Created by apple on 14/12/13.
//  Copyright (c) 2014年 bangtech. All rights reserved.
//

#ifndef bjsubway_queue_h
#define bjsubway_queue_h
struct node{
    int value;
    struct node * next;  // 队列一般是访问受限制的链表
};
typedef struct queue{
    struct node * head, * tail; // 每个队列维护头/尾指针
}queue;

// queue invariant : new integers are added to the back of the queue
//                   integers are only removed from the front of the queue

// operations for queue are defined as follows

// queue empty()
//    returns an empty queue
queue empty();

// int empty_huh(queue q)
//    returns 1 (true) if q is empty
//    returns 0 (false) if q is not empty
int empty_huh(queue q);

// queue enqueue(int in, queue q)
//    returns a queue with in added to the back of q
queue enqueue(int in, queue q);

// queue dequeue(queue q)
//    returns a queue with the element at the front of q removed
//    returns empty if q is empty
//    this operation is *destructive*
queue dequeue(queue q);

// int next(queue q)
//    returns the element at the front of q
int next(queue q);

#endif
