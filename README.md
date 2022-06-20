<img width="1700" alt="KCM Logo" src="https://user-images.githubusercontent.com/56252259/174294532-7bea849e-82f3-40ad-903c-701a0756f0ae.png">

# Keychain Manager
**Keychain Manager** is a Layer-2 framework built over Keychain API which helps in using Keychain in all your Apple devices with easiness and flexibility. It focuses on using all the power of Keychain with high simplicity. The easy to use methods of Keychain Manager helps to setup Keychain on any Apple device with great convenience.

## 📔 Usage

### ⚙️ Intilisation
Before using any Keychain Manager methods we need to intialise the class. Keychain Manager supports various types of inilisation which depends upon variety of use cases

### 🗳 Basic Initialisation  
* This initilisation stores all the Keychain items on the local device. 
* Such initilisations are best used when the app is single login based.

```swift
let KCM = KeychainManager()
```

### 🗳 Prefix Initiliser
* This initiliser helps to add a prefix value in your account string. 
* Such initilisations are best used when performing tests (***Eg: test_account1_***).
```swift
 let KCM = KeychainManager(keyPrefix: "test")
```


### 🗳 Sharable Initiliser
* Keychain Manger allowes developers to share the keychain values to other apps also synchronise with iCloud.
* Such initilisations are best used when you need to share Keychain values among apps.
* ***Eg: A same app running on two different devices with same iCloudID & To share data between Different apps running on same or different device***

```swift
let KCM = KeychainManager(accessGroup: "TeamID.KeychainGroupID", synchronizable: true)
```
* To use this you need to enable the Keychain sharing in capabilities. ([How to add Keychain Sharing Capability?](https://github.com/gokulnair2001/KeychainManager#-keychain-sharing))
* Here **TeamID** is which you get from your developer profile from [Developer Account](http://developer.apple.com).
* **KeychainGroupID** is the string which you add in the Keychain Sharing Capability.
 
 
### 🗳 Prefix + Sharable
* When you need to add both prefix and sharable propert on keychain then this initialisation is the best one to use

```swift
 let KCM = KeychainManager(keyPrefix: "test", accessGroup: "TeamID.KeychainGroupID", synchronizable: true)
```
## 🛠 Operations

Following are the methods which help to perfrom various operations:

## 🔑 SET 
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


## 🔑 GET 
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
* Generic Password
```swift
 let value = KCM.getAllValues(secClass: .genericPassword)
```
* Web Credentials
```swift
 let value = KCM.getAllValues(secClass: .webCredentials)
```

## 🔑 UPDATE 

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

## 🔑 DELETE
* Used to delete Keychain Items

#### Service Deletion
```swift
 do {
    try KCMTest.delete(service: service_ID, isCustomObjectType: false)
 }
 catch {
    print(error.localizedDescription)
}
```
* **isCustomObjectType** is used to explicitly tell Keychain Manager to delete a custom Object type.
* By default the value of **isCustomObjectType** is ```false```

#### Server Deletion
```swift
 do {
    try KCMTest.delete(server: server_ID)
 }
 catch {
    print(error.localizedDescription)
}
```

## 🔑 VALIDATE
* Is used to check if a certain Server or Service based keychain is valid/present.

#### Service
```swift
 if KCM.isValidService(service: service_ID, account: account_name) {
        print("🙂")
 } else {
        print("☹️")
 }
```
#### Server
```swift
 if KCM.isValidService(server: server_ID, account: account_name) {
     print("🙂")
 } else {
     print("☹️")
 }
```

## ☁️ iCloud Sync
* iCloud synchronisation needs to be set during initilisation.
* Make sure to use the sharable initialisation at every method to save all changes on cloud.


## 📱 Device Supported
| No | Device | Version |
| -- | -- | -- |
| 1 | iOS | 13.0.0 + |
| 2 | iPadOS | 13.0.0 + |
| 3 | WatchOS | 6.0.0 +|
| 4 | MacOS | 11.0.0 + |
| 5 | tvOS | 11.0.0 + |

## 📌 Keynotes
Make sure you know these keynotes before using Keychain Manager
* GET Bool will return false even after deleting the Keychain item.
* To delete a custom object make sure you explicitly tell Keychain Manager that its a custom object in the delete method.
* By enabling iCloud sync you also enable Keychain Access Group, thus adding Keychain Sharing capability is important ([How to do it?](https://github.com/gokulnair2001/KeychainManager#-keychain-sharing)).
* Every Keychain item stored through MacOS is also saved in form of iOS, making it easy for developers to share same keychain data among all platforms. Thus keychain manager will give access to your MacOS based keychain items on other platforms too ([Read this](https://developer.apple.com/documentation/security/ksecusedataprotectionkeychain)).
* Keychain Items stored on tvOS will not sync with other platforms ([Read this](https://developer.apple.com/documentation/security/ksecattrsynchronizable)).


## 📦 SPM 
Keychain Manger is available through [Swift Package Manager](https://github.com/apple/swift-package-manager/). To add Keychain Manager through SPM
* Open project in Xcode
* **Select ```File > Add Packages```**

```swift
https://github.com/gokulnair2001/KeychainManager
```
<img width="1089" alt="SPM Dialogue" src="https://user-images.githubusercontent.com/56252259/174320479-34dc4437-34ba-49c9-880c-343ef337a485.png">

## 🌐 Keychain Sharing
* Open your project target
* Select ```Signing & Capabilities``` option
* Click plus button and search for ```Keychain Sharing```

<img width="600" alt="Keychain Sharing Capability" src="https://user-images.githubusercontent.com/56252259/174277242-1f2a1491-44f5-422a-b69a-3a7a4a3fbea8.png">

<img width="1306" alt="Screenshot 2022-06-17 at 3 38 39 PM" src="https://user-images.githubusercontent.com/56252259/174277607-d9dfe23c-701b-4362-b8e2-9cace0a8a574.png">

* Make sure to use the same Keychain Item in other apps you add the Keychain access group ID of the initial project.

## 🪄 How to contribute ?

* Use the framework through SPM
* If you face issues in any step open a new issue.
* To fix issues: Fork this repository, make your changes and make a Pull Request.

## ⚖️ License
* Keychain Manager is available under GNU General Public [License](https://github.com/gokulnair2001/KeychainManager/blob/master/LICENSE).

## Like the framework ?
* If you liked ```Keychain Manager``` do consider buying me a coffee 😊

[<img width="200" alt="BMC logo+wordmark - Black" src="https://cdn.buymeacoffee.com/buttons/v2/default-red.png">](https://www.buymeacoffee.com/gokulnair)

<p align="center" width="100%">
   Made with ❤️ in 🇮🇳 By Gokul Nair   
</p>
