//
//  CCStoreProduct.h
//  HelloCpp
//
//  Created by 陈欢 on 13-10-30.
//
//

#ifndef __HelloCpp__CCStoreProduct__
#define __HelloCpp__CCStoreProduct__

#include "cocos2d.h"

class CCStoreProduct : public cocos2d::CCObject
{
public:
    static CCStoreProduct* productWithId(const char* productIdentifier,
                                         const char* localizedTitle,
                                         const char* localizedDescription,
                                         float price,
                                         const char* priceLocale);
    
    const std::string& getProductIdentifier(void)
    {
        return m_productIdentifier;
    }
    
    const std::string& getLocalizedTitle(void)
    {
        return m_localizedTitle;
    }
    
    const std::string& getLocalizedDescription(void)
    {
        return m_localizedDescription;
    }
    
    float getPrice(void)
    {
        return m_price;
    }
    
    const std::string& getPriceLocale(void)
    {
        return m_priceLocale;
    }
    
private:
    CCStoreProduct(void) {}
    bool initWithId(const char* productIdentifier,
                    const char* localizedTitle,
                    const char* localizedDescription,
                    float price,
                    const char* priceLocale);
    
    std::string m_productIdentifier;
    std::string m_localizedTitle;
    std::string m_localizedDescription;
    float       m_price;
    std::string m_priceLocale;
};

#endif /* defined(__HelloCpp__CCStoreProduct__) */
