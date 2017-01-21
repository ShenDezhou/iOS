#include "BulletComponent.h"
USING_NS_CC;
BulletComponent::BulletComponent(){}
BulletComponent::~BulletComponent(){}
CCString* BulletComponent::ClassName(){
	return CCString::create("BulletComponent");
}