#include "CommunicateComponent.h"

USING_NS_CC;

CCString* CommunicateComponent::ClassName()
{
	return CCString::create("CommunicateComponent");
}
CommunicateComponent::CommunicateComponent()
{
	sendData = CCArray::create();
	sendData->retain();
	recvData = CCArray::create();
	recvData->retain();
}

CommunicateComponent::~CommunicateComponent()
{
	
}