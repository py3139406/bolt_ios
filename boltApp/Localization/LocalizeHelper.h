//LocalizeHelper.h

#import <Foundation/Foundation.h>

// some macros (optional, but makes life easy)

// Use "LocalizedString(key)" the same way you would use "NSLocalizedString(key,comment)"
#define LocalizedString(key) [[LocalizeHelper sharedLocalSystem] localizedStringForKey:(key)]

// "language" can be (for american english): "en", "en-US", "english". Analogous for other languages.
#define LocalizationSetLanguage(language) [[LocalizeHelper sharedLocalSystem] setLanguage:(language)]

@interface LocalizeHelper : NSObject
    
+ (LocalizeHelper *) sharedLocalSystem;
    
    // this gets the string localized:
- (NSString *)localizedStringForKey:(NSString *)key;
    
    //set a new language:
- (void)setLanguage:(NSString *)lang;
    
@end
