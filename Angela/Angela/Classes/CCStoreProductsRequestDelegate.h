//
//  CCStoreProductsRequestDelegate.h
//  HelloCpp
//
//  Created by 陈欢 on 13-10-30.
//
//

#ifndef HelloCpp_CCStoreProductsRequestDelegate_h
#define HelloCpp_CCStoreProductsRequestDelegate_h

#include "cocos2d.h"

static const int CCStoreProductsRequestErrorPreviousRequestNotCompleted = -2;
static const int CCStoreProductsRequestErrorCancelled = -1;

class CCStoreProductsRequestDelegate
{
public:
    virtual void requestProductsCompleted(cocos2d::CCArray* products,
                                          cocos2d::CCArray* invalidProductsId = NULL) = 0;
    virtual void requestProductsFailed(int errorCode, const char* errorString) = 0;
};

#endif
