# iMessage
A chat app made with firebase insipired by Apple iMessage app

## Goal
Learn how to use firebase and real time chat features (deleting, typing notif, ...)

## Framework used
- UIKit
- Firebase
- Lottie
- ChameleonFramework

## V1
The goal of the v1 version is to be able to create a discussion beteween two people.
Below you can see how I implemented this features

- Seting Firebase to my app with Cocoapods
- Create a simple UI to make the app usable
- Create a Database on Firestore
- Add communication logic between the app and firestore

<img width="902" alt="Screenshot 2020-05-25 at 20 03 34" src="https://user-images.githubusercontent.com/38114983/82834967-f5a07880-9ec2-11ea-8a88-4dd3477d7370.png">

## V1.1
Fix keyboards Issues, add log Screen and improve code quality.

- When the keywoard is on screen, message box is moving up above it and table view is scrolling down to the last cell message. We can drag the table view to dismiss the keyboard
- I implemented the log Screen that I had previously created inisde another project.
- I regrouped every firebase functions responsible for the communication with the data base inside a unique class called DBCommunication. It allows to get cleaner and better maintainability.

<img width="408" alt="Screenshot 2020-05-29 at 13 48 48" src="https://user-images.githubusercontent.com/38114983/83257330-7b1e7400-a1b4-11ea-9402-62c66c90abd8.png">

## V2.0
Fix a lot of issues and add some features.
The app is useable and works fine at this stage.

- Update message cell to have a dynamic height
- Improve database structure in firebase
- Add a CreateDiscussionViewController
- Improve discussion view controller UI
- And lot more ...

