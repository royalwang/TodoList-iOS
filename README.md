# TodoList-iOS

TodoList-iOS is a sample application that allows you to simply keep track of things to be done. This sample application demonstrates how to leverage, in a mobile iOS 9 application, a Kitura-based server application written in Swift.


## Getting Started ##

## Note ##
Ensure correct versioning of todolist-couchdb and todolist-api. Currently there are versioning issues being fixed
### Run Locally ###

1. Build and Run TodoList-Server (Note versioning issue)
  - `build swift`
  - `./.build/debug/KituraTodoList`

2. Run Couchdb inside another terminal window
  - `couchdb`

3. Open `TodoList-iOS.xcworkspace` and run the simulator


### Deploy on Bluemix ###

[![Deploy to Bluemix](https://bluemix.net/deploy/button.png)](https://bluemix.net/deploy?repository=https://github.com/IBM-Swift/todolist-ios.git)
