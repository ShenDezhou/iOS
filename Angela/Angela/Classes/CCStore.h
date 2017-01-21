//
//  CCStore.h
//  HelloCpp
//
//  Created by 陈欢 on 13-10-31.
//
//

#ifndef __HelloCpp__CCStore__
#define __HelloCpp__CCStore__

#include "cocos2d.h"
#include "CCStoreProduct.h"
#include "CCStorePaymentTransaction.h"
#include "CCStoreTransactionDelegate.h"
#include "CCStoreProductsRequestDelegate.h"


typedef bool CCStoreIsSandbox;

typedef std::map<const std::string, CCStorePaymentTransaction*> CCStorePaymentTransactions;
typedef CCStorePaymentTransactions::iterator                    CCStorePaymentTransactionsIterator;

class CCStore: public CCStoreTransactionDelegate
{
public:
    static CCStore* sharedStore(void);
    static void purgeSharedStore(void);
    
    ~CCStore(void);
    
    // 初始化
    void postInitWithTransactionDelegate(CCStoreTransactionDelegate* delegate);
    
    // 确认当前是否可以进行交易
    bool canMakePurchases(void);
    
    // 载入指定产品的信息
    void loadProducts(cocos2d::CCArray* productsId, CCStoreProductsRequestDelegate* delegate);
    
    // 取消载入产品信息的操作
    void cancelLoadProducts(void);
    
    /** @brief 确定指定的产品是否已经载入
     
     @param productId 要检查的产品 ID
     */
    bool isProductLoaded(const char* productId);
    
    /** @brief 购买指定的产品
     
     @param productId 要购买产品的 ID
     
     指定 ID 的产品信息必须之前成功调用 loadProducts() 载入。如果指定的产品尚未载入，则返回 false。
     */
    bool purchase(const char* productId);
    
    /** @brief 结束交易 */
    void finishTransaction(CCStorePaymentTransaction *transaction);
    
    // 确定当前的收据验证模式
    CCStoreReceiptVerifyMode getReceiptVerifyMode(void);
    
    // 设置收据验证模式
    void setReceiptVerifyMode(CCStoreReceiptVerifyMode mode, CCStoreIsSandbox isSandbox = true);
    
    // 确定验证收据的服务器 URL
    const char* getReceiptVerifyServerUrl(void);
    
    // 设置验证收据的服务器 URL
    void setReceiptVerifyServerUrl(const char* url);
    
#pragma mark -
#pragma mark delegates
    
    virtual void transactionCompleted(CCStorePaymentTransaction* transaction);
    virtual void transactionFailed(CCStorePaymentTransaction* transaction);
    virtual void transactionRestored(CCStorePaymentTransaction* transaction);
    
private:
    CCStore(void)
    : m_delegate(NULL)
    , m_isLoadProductsLuaNotCompleted(false)
    {
    }
    bool init(void);
    
    static CCStore*             s_sharedStore;
    CCStoreTransactionDelegate* m_delegate;

    bool                        m_isLoadProductsLuaNotCompleted;
    CCStorePaymentTransactions  m_transactions;
    
};

#endif /* defined(__HelloCpp__CCStore__) */
