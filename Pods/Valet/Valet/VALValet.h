//
//  VALValet.h
//  Valet
//
//  Created by Dan Federman on 3/16/15.
//  Copyright 2015 Square, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, VALAccessibility) {
    /// Valet data can only be accessed while the device is unlocked. This attribute is recommended for data that only needs to be accesible while the application is in the foreground. Valet data with this accessibility will migrate to a new device when using encrypted backups.
    VALAccessibilityWhenUnlocked = 1,
    /// Valet data can only be accessed once the device has been unlocked after a restart. This attribute is recommended for data that needs to be accesible by background applications. Valet data with this attribute will migrate to a new device when using encrypted backups.
    VALAccessibilityAfterFirstUnlock,
    /// Valet data can always be accessed regardless of the lock state of the device. This attribute is not recommended. Valet data with this attribute will migrate to a new device when using encrypted backups.
    VALAccessibilityAlways,
    
    /// Valet data can only be accessed while the device is unlocked. This class is only available if a passcode is set on the device. This is recommended for items that only need to be accessible while the application is in the foreground. Valet data with this attribute will never migrate to a new device, so these items will be missing after a backup is restored to a new device. No items can be stored in this class on devices without a passcode. Disabling the device passcode will cause all items in this class to be deleted.
    VALAccessibilityWhenPasscodeSetThisDeviceOnly __OSX_AVAILABLE_STARTING(__MAC_10_10, __IPHONE_8_0),
    /// Valet data can only be accessed while the device is unlocked. This is recommended for data that only needs to be accesible while the application is in the foreground. Valet data with this attribute will never migrate to a new device, so these items will be missing after a backup is restored to a new device.
    VALAccessibilityWhenUnlockedThisDeviceOnly,
    /// Valet data can only be accessed once the device has been unlocked after a restart. This is recommended for items that need to be accessible by background applications. Valet data with this attribute will never migrate to a new device, so these items will be missing after a backup is restored to a new device.
    VALAccessibilityAfterFirstUnlockThisDeviceOnly,
    /// Valet data can always be accessed regardless of the lock state of the device. This option is not recommended. Valet data with this attribute will never migrate to a new device, so these items will be missing after a backup is restored to a new device.
    VALAccessibilityAlwaysThisDeviceOnly,
};

extern NSString *const VALMigrationErrorDomain;

typedef NS_ENUM(NSUInteger, VALMigrationError) {
    /// Migration failed because the keychain query was not valid.
    VALMigrationErrorInvalidQuery = 1,
    /// Migration failed because no items to migrate were found.
    VALMigrationErrorNoItemsToMigrateFound,
    /// Migration failed because the keychain could not be read.
    VALMigrationErrorCouldNotReadKeychain,
    /// Migraiton failed because a key in the query result could not be read.
    VALMigrationErrorKeyInQueryResultInvalid,
    /// Migraiton failed because some data in the query result could not be read.
    VALMigrationErrorDataInQueryResultInvalid,
    /// Migraiton failed because two keys with the same value were found in the keychain.
    VALMigrationErrorDuplicateKeyInQueryResult,
    /// Migraiton failed because a key in the keychain duplicates a key already managed by Valet.
    VALMigrationErrorKeyInQueryResultAlreadyExistsInValet,
    /// Migraiton failed because writing to the keychain failed.
    VALMigrationErrorCouldNotWriteToKeychain,
    /// Migration failed because removing the migrated data from the keychain failed.
    VALMigrationErrorRemovalFailed,
};


/// Reads and writes keychain elements.
@interface VALValet : NSObject <NSCopying>

/// Creates a Valet that reads/writes keychain elements with the desired accessibility.
- (nullable instancetype)initWithIdentifier:(NSString *)identifier accessibility:(VALAccessibility)accessibility __attribute((objc_designated_initializer));

/// Creates a Valet that reads/writes keychain elements that can be shared across applications written by the same development team. The sharedAccessGroupIdentifier must correspond with the value for keychain-access-groups in your Entitlements file.
- (nullable instancetype)initWithSharedAccessGroupIdentifier:(NSString *)sharedAccessGroupIdentifier accessibility:(VALAccessibility)accessibility __attribute((objc_designated_initializer));

@property (copy, readonly) NSString *identifier;
@property (readonly, getter=isSharedAcrossApplications) BOOL sharedAcrossApplications;
@property (readonly) VALAccessibility accessibility;

/// @return YES if otherValet reads from and writes to the same sandbox within keychain as the receiver.
- (BOOL)isEqualToValet:(VALValet *)otherValet;

/// Checks whether the keychain is currently accessible by writing a value to the keychain and then reading it back out.
- (BOOL)canAccessKeychain;

/// Inserts data into the keychain.
/// @return NO if the keychain is not accessible.
- (BOOL)setObject:(NSData *)value forKey:(NSString *)key;
/// Retreives data from the keychain.
- (nullable NSData *)objectForKey:(NSString *)key;

/// Convenience method for adding a string to the keychain.
- (BOOL)setString:(NSString *)string forKey:(NSString *)key;
/// Convenience method for retrieving a string from the keychain.
- (nullable NSString *)stringForKey:(NSString *)key;

- (BOOL)containsObjectForKey:(NSString *)key;
- (NSSet *)allKeys;

/// Removes a key/object pair from the keychain.
/// @return NO if the keychain is not accessible.
- (BOOL)removeObjectForKey:(NSString *)key;
/// Removes all key/object pairs accessible by this Valet instance from the keychain.
/// @return NO if the keychain is not accessible.
- (BOOL)removeAllObjects;

/// Migrates objects matching the secItemQuery into the receiving Valet instance. Error domain will be VALMigrationErrorDomain, and codes can will be from VALMigrationError. The keychain is not modified if a failure occurs.
- (nullable NSError *)migrateObjectsMatchingQuery:(NSDictionary *)secItemQuery removeOnCompletion:(BOOL)remove;
/// Migrates objects from the passed-in Valet into the receiving Valet instance.
- (nullable NSError *)migrateObjectsFromValet:(VALValet *)valet removeOnCompletion:(BOOL)remove;

@end


NS_ASSUME_NONNULL_END
