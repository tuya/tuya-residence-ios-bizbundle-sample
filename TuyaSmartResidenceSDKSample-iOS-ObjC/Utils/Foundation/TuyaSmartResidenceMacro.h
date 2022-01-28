//
//  TuyaSmartResidenceMacro.h
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)


#ifndef TuyaSmartResidenceMacro_h
#define TuyaSmartResidenceMacro_h

#ifndef ty_weakify
    #define ty_weakify(object)  __weak __typeof__(object) weak##_##object = object;
#endif

#ifndef ty_strongify
    #define ty_strongify(object)  __typeof__(object) object = weak##_##object;
#endif

#ifndef TY_StringFromSEL
    #define TY_StringFromSEL(name) NSStringFromSelector(@selector(name))
#endif

#endif /* TuyaSmartResidenceMacro_h */
