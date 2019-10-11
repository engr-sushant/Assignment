# ASSIGNMENT

•    Shows list of items to be delivered. Detail page shows delivery location of an item in map view and its details.


# INSTALLATION

•    Open Podfile from project directory.
\n•    Open terminal and cd to the directory containing the Podfile.
•    Run the "pod install" command. (Incase of error: [!] CocoaPods could not find compatible versions for pod "MaterialComponents/ActivityIndicator".  Please use command: pod install --repo-update)
•    Open xcworkspace 


# REQUIREMENT

•    Xcode : 10.2
•    Supported OS version: iOS (10.x,11.x, 12.x)


# LANGUAGE

•    Swift 5.0


# VERSION

•    1.0


# DESIGN PATTERN

![Untitled Diagram-2](https://user-images.githubusercontent.com/52284944/61196360-bd011180-a6eb-11e9-8776-31950705e8ee.png)


•    MVVM
The Model View ViewModel (MVVM) is an architectural pattern. 

•    Model: 
A Model is responsible for exposing data in a way that is easily accessible. It manages and stores data received from server and core data.

•    View: 
View controllers come under this layer. View controller is responsible for laying out user interface and interact with users.

•    ViewModel: 
All business logics are handled in view model. View model is responsible to update model, based on events received from view and pass data to view to update UI elements for user action.


# LIBRARIES USED
•    Alamofire
•    GoogleMaps 
•    MaterialComponents/Activity Indicator
•    Firebase
•    Crashlytics
•    OHHTTPStubs/Swift
•    SDWebImage


# GOOGLE MAP SDK

•    We need to create google developer account to integrate Google Maps.
•    Please get API KEY from - https://developers.google.com/maps/documentation/embed/get-api-key
•    Replace GOOGLEAPIKEY with API KEY in Constants.swift


# LINTING
•    Integration of SwiftLint into an Xcode scheme to keep a codebase consistent and maintainable .
•    Install the swiftLint via brew and need to add a new "Run Script Phase" with:
if which swiftlint >/dev/null; then
swiftlint
else
echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
•    .swiftlint.yml file is used for basic set of rules . It is placed inside the project folder.


# FEATURES

•    CACHING
-    Core Data is used for data caching. 
-    Items fetched from server are displayed to UI and saved using CoreData. 
-    Next time when user launch app, if data is available in db then it fetches data using CoreData and displays on table view.


•    REFRESH
-    Pull to refresh is implemented to refresh delivery item list. 
-    In case of pull to refresh, refreshed data from server will be updated on table view and also data saved previously in database will be deleted and refreshed data will be saved for next time loading.

•    PAGINATION
-    When user scroll down to the table, server request is made to fetch more items and it is displayed on table and saved using CoreData. 

•    ITEM DETAILS
-    User can get details of items listed by tapping on the item. It will redirect to new screen. 
-    Detail screen shows the delivery location of item on map view and details of user to whom item is to be delivered. 


# UNIT TESTING
•    Unit testing is done by using XCTest.
•    To run tests click Product->Test or (cmd+U)


# ASSUMPTIONS
•    App is designed for iPhones only.
•    Localization is supported but only English localize string file is maintained.

# IMPROVEMENTS
•    UI could be done more interactive and user friendly.
•    UI Testing is not implemented.

# LICENSE
MIT License
Copyright (c) 2019
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

