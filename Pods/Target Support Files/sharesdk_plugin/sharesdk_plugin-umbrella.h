#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SharesdkPlugin.h"

FOUNDATION_EXPORT double sharesdk_pluginVersionNumber;
FOUNDATION_EXPORT const unsigned char sharesdk_pluginVersionString[];

