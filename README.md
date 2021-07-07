Original App Design Project - README Template
===

# FindFood

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
FindFood is an app that makes it easy to find the location of food trucks near you! It looks up your current location and provides a map of where the nearest food trucks are along with their hours and a menu. 

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Travel / Food
- **Mobile:** Uses real-time location to allow users to find places to eat on the go.
- **Story:** Everyone wants to find great places to go eat and we all know small businesses usually have some of the tastiest food. This makes it easier for the consumer and the producer.
- **Market:** The app would be targeted at those who are looking to try new places to eat. 
- **Habit:** Travelers could use this as a go to app in order to find hole in walls in areas they aren't familiar with. Locals can use this app to discover new food trucks they have never eaten at before.
- **Scope:** The core feature of this app would be using real-time location and the Google Maps API. I wouldn't need to create this API from scratch, so completing the core functionality of this app is well within the scope of this program. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Users are able to login/signup/logout from the application
  - Users have two possible accounts: Consumer or Business
* Consumer Users are able to see a map of food truck locations near them
* Consumer Users are able to select a location and view their hours and menu
* Business Users are able to create a location for their food truck and complete a profile description

**Optional Nice-to-have Stories**

* Consumer Users are able to see a list view of food truck locations near them
* Consumer Users can leave reviews and rate the location
* Consumer Users can order food through the app
* Business Users can promote limited time events / specials / deals / discounts

**EXTRA Optional Nice-to-have Stories**
* Social media tab
  - Consumer Users can make posts at locations and view a feed of photos from other users

### 2. Screen Archetypes

* Login Screen
   * User can login to the applciation
* Signup Screen
   * User can create a Consumer or Business user account and login
     - Creation of a business account requires the user to complete profile with their food truck descriptions 
* Map View Screen
   * User can see food truck locations around their real-time location
* Details Screen
   * User can view a detailed description of a food truck, hours, and menu 
* Profile Screen
   * Business users can view their profile / update any data
   * Consumer users can view their account / update any data
      - (OPTIONAL) Consumer user can view their past reviews / ratings

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Map View Screen
* Profile Screen
* (OPTIONAL) Social Media Feed Screen

**Flow Navigation** (Screen to Screen)

* Map View Screen
   * Click a location and it switches to Details Screen
* Profile Screen
   * Can click profile photo on Details Screen that takes user to the Profile Screen

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
