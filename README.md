# iMessage
A chat app made with firebase insipired by Apple iMessage app

## Goal
Learn how to use firebase and real time chat features (deleting, typing notif, ...)
Through the time I will add some features or design improvements. I will also try to improve the code architecture to have a clean, reusable and logic code and not a spagethi one.

## Framework used
- UIKit
- Firebase
- Lottie
- ChameleonFramework

## V1
The goal of the v1 version is to be able create a discussion beteween two peoples.
Below you can see how I implemented this features

- Seting Firebase to my app with Cocoapods
- Creating of a simple UI to make the app usable
- Creation of a Database on Firestore
- Add communication stuff between the app and firestore
- Create bubble text message to dispaly messages

<img width="902" alt="Screenshot 2020-05-25 at 20 03 34" src="https://user-images.githubusercontent.com/38114983/82834967-f5a07880-9ec2-11ea-8a88-4dd3477d7370.png">

## V1.1
Fix keyboards Issues, add logScreen and improve code quality.

- Now when keyboard resign first responder, message box is moving up above it and table view is scrolling down to the last cell message. We can drag the table view to dismiss the keyboard
- I implemented the logScreen that I had previously created inisde another project.
- I regrouped every firebase functions responsible for the communication with the data base inside a unique class called DBCommunication. It allows to get cleaner and better maintainability.

<img width="408" alt="Screenshot 2020-05-29 at 13 48 48" src="https://user-images.githubusercontent.com/38114983/83257330-7b1e7400-a1b4-11ea-9402-62c66c90abd8.png">



