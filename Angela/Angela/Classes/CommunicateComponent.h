#pragma once
#include "cocos2d.h"
#include "Component.h"


NS_CC_BEGIN

class CommunicateComponent:public Component
{
public:

	CCArray* sendData;
	CCArray* recvData;
	CommunicateComponent();
	~CommunicateComponent();
 	CCString* ClassName();
		inline bool init(){ return true;}
	CREATE_FUNC(CommunicateComponent);
	
};
NS_CC_END
