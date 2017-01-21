//
//  queue.m
//  bjsubway
//
//  Created by apple on 14/12/13.
//  Copyright (c) 2014年 bangtech. All rights reserved.
//

//#import <Foundation/Foundation.h>
#include<stdio.h>
#include<stdlib.h>
#include "queue.h"

// queue invariant : new integers are added to the back of the queue
//                   integers are only removed from the front of the queue

// operations for queue are defined as follows

// queue empty()
//    returns an empty queue
queue empty()
{
    queue q;
    q.head = q.tail = NULL;
    return q;
}

// int empty_huh(queue q)
//    returns 1 (true) if q is empty
//    returns 0 (false) if q is not empty
int empty_huh(queue q)
{
    if(q.head == NULL)
        return 1;
    else
        return 0;
}

// queue enqueue(int in, queue q)
//    returns a queue with in added to the back of q
queue enqueue(int in, queue q)
{
    struct node * item = (struct node *)malloc(sizeof(struct node));
    item->value = in;
    item->next = NULL;
    
    if(empty_huh(q))
        q.head = q.tail = item;
    else
    {
        q.tail->next = item;
        q.tail = item;
    }
    return q;
};

// queue dequeue(queue q)
//    returns a queue with the element at the front of q removed
//    returns empty if q is empty
//    this operation is *destructive*
queue dequeue(queue q)
{
    struct node * temp;
    if(q.head)
    {
        temp = q.head;
        q.head = q.head->next;
        free(temp);
    }
    if(empty_huh(q))
        return empty();
    return q;
}

// int next(queue q)
//    returns the element at the front of q 
int next(queue q)
{
    return q.head->value;
}