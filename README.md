# Keychain Manager
**Keychain Manager** is a Layer-2 framework built over Keychain API which helps in using Keychain in all your Apple devices with easiness and flexibility. It focuses on using all the power of Keychain with high simplicity. The easy to use methods of Keychain Manager helps to setup Keychain on any Apple device with great convenience.

## 📔 Usage

### ⚙️ Intilisation
Before using any Keychain Manager methods we need to intialise the class. Keychain Manager supports various types of inilisation which depends upon variety of use cases

#### Basic Initialisation  
* This initilisation stores all the Keychain items on the local device. 
* Such initilisations are best used when the app is single login based.

```swift
let KCM = KeychainManager()
```

## 

#### Prefix Initiliser
* This initiliser helps to add a prefix value in your account string. 
* Such initilisations are best used when performing tests (***Eg: test_account1_***).
```swift
 let KCM = KeychainManager(keyPrefix: "test")
```
## 

#### Sharable Initiliser
* Keychain Manger allowes developers to share the keychain values to other apps also synchronise with iCloud.
* Such initilisations are best used when you need to share Keychain values among apps.
* ***Eg: A same app runningon two different devices with same iCloudID & To share data between Different apps running on same or different device***

```swift
let KCM = KeychainManager(accessGroup: "TeamID.KeychainGroupID", synchronizable: true)
```
* To use this you need to enable the Keychain sharing in capabilities.
* Here **TeamID** is which you get from your developer profile from [Developer Account](http://developer.apple.com).
* **KeychainGroupID** is the string which you add in the Keychain Sharing Capability.
 
## 
 
#### Prefix + Sharable
* When you need to add both prefix and sharable propert on keychain then this initialisation is the best one to use

```swift
 let KCM = KeychainManager(keyPrefix: "test", accessGroup: "TeamID.KeychainGroupID", synchronizable: true)
```
## ⚙️ Basics

### 🔑 SET 
* Used to save data on keychain.
* Keychain Manager Supports variety of data storage

#### String
```swift
KCM.set(value: "value", service: service_ID, account: account_name)
```
#### Bool
```swift
KCM.set(value: true, service: service_ID, account: account_name)
```
#### Custom Object
```swift
KCM.set(object: Any_Codable_Object, service: service_ID, account: account_name)
```

#### Web Credentials
```swift
KCM.set(server: server_ID, account: account_name, password: password)
```
**Tip: Make sure Account, Service & Server parameter must be unique for every item.**

##

### 🔑 GET 
* Used to get Keychain Items. 
* Keychain Manager helps to GET variety of format of Data from Keychain Storage

#### String
```swift
let value = KCM.get(service: service_ID, account: account_name)
```
#### Bool
```swift
let value = KCM.getBool(service: service_ID, account: account_name)
```
#### Custom Object
```swift
 let value = KCM.get(object: Any_Codable_Object, service: service_ID, account: account_name)
```

#### Web Credentials
```swift
let value = KCM.get(server: server_ID, account: account_name)
```

#### Get All Values
* **Generic Password**
```swift
 let value = KCM.getAllValues(secClass: .genericPassword)
```
* **Web Credentials**
```swift
 let value = KCM.getAllValues(secClass: .webCredentials)
```
##

### 🔑 UPDATE 

* Used to update Kechain Item Values
* Since we have variety of SET and GET methods, similarly to update them we have variety of UPDATE methods

#### String
```swift
KCM.update(value: "value", service: service_ID, account: account_name)
```
#### Bool
```swift
KCM.update(value: true, service: service_ID, account: account_name)
```
#### Custom Object
```swift
KCM.update(object: Any_Codable_Object, service: service_ID, account: account_name)
```

#### Web Credentials
```swift
KCM.update(server: server_ID, account: account_name, password: password)
```
##

### 🔑 DELETE
## 
### 🔑 VALIDATE
## 
### ☁️ iCloud Sync
## 

### Device Supported
| Device | Version |
| -- | -- |
| iOS | 13.0.0 + |
| iPadOS | 13.0.0 + |
| WatchOS | 6.0.0 +|
| MacOS | 11.0.0 + |
| tvOS | 11.0.0 + |

## SPM 📦
Keychain Manger is available through [Swift Package Manager](https://github.com/apple/swift-package-manager/). To add Keychain Manager through SPM
* Open project in Xcode
* **Select ```File > Add Packages```**

```swift
https://github.com/gokulnair2001/KeychainManager
```
# Imageeee❌


<p align="center" width="100%">
   Made with ❤️ in 🇮🇳 By Gokul Nair   
</p>
