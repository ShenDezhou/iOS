#include "ItemComponent.h"

USING_NS_CC;

ItemComponent::ItemComponent(){
	createTime = GetTickCount();
}
CCString* ItemComponent::ClassName()
{
	return CCString::create("ItemComponent");
}