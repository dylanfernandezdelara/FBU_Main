Original App Design Project - README Template
===

# FindFood
Latest Gifs:

General User:

![ezgif com-gif-maker (12)](https://user-images.githubusercontent.com/65196174/127723743-a057e22c-a526-485d-960b-eee1b1c8a6e7.gif)

![ezgif com-gif-maker (14)](https://user-images.githubusercontent.com/65196174/127723866-695231b7-f839-4e4d-afa2-a54e70a896bb.gif)

Food Truck:

![ezgif com-gif-maker (13)](https://user-images.githubusercontent.com/65196174/127723811-f8fb0aa7-ba7b-4db2-99d9-c5a347fb6a98.gif)

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
* Consumer Users are able to see a real-time map of food truck locations near them
* Consumer Users are able to select a location and view their hours
* Consumer Users can favorite food trucks
* Business Users are able to create a location for their food truck which adds their location to the Consumer's map
* Both Consumer and Business Users can edit their profile
* Technical Challenge: Adding filtering for the general user when searching on the Map View

**Optional Nice-to-have Stories**

* Consumer Users are able to see a list view of food truck locations near them
* Consumer Users can leave reviews and rate the location
* Consumer Users have a profile screen where they can see reviews they have left
* Social media tab
  - Consumer Users can make posts at locations and view a feed of photos from other users

### 2. Screen Archetypes

* Login Screen
   * User can login to the applciation
* Signup Screen
   * User can create a Consumer or Business user account
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

* Map View Screen (for Consumer only)
* Profile Screen
* (OPTIONAL) Social Media Feed Screen

**Flow Navigation** (Screen to Screen)

* Map View Screen
   * Click a location and it switches to Details Screen
* Profile Screen
   * Can click profile photo on Details Screen that takes user to the Profile Screen

## Wireframes
https://www.figma.com/file/c7HaAJtrsg89o7IXk4c6TA/findfood?node-id=0%3A1
<img width="1240" alt="Screen Shot 2021-07-09 at 3 31 52 PM" src="https://user-images.githubusercontent.com/65196174/125133033-d5ce1300-e0ca-11eb-97ff-5ddbdf5314e8.png">

V2:

<img width="782" alt="Screen Shot 2021-07-12 at 4 48 19 PM" src="https://user-images.githubusercontent.com/65196174/125362956-60b24600-e335-11eb-9f3c-87eae32ae461.png">

## Schema 
### Models
Model: Post - Food Truck
| Property | Type  | Description  |
| :---:   | :-: | :-: |
| objectId | String | unique id for the food truck posting |
| author | Pointer to user | author id |
| author type | String | business classification |
| profileImage | File | food truck pfp |
| foodImage | File | details view main photo |
| linkToWebsite | String | link to food truck website if exists |
| location | String | unsure right now of how to save this type |
| weeklyHoursOpen | DateTime | unsure right now of how to save this type |
| rating | Number | average rating of reviews |

Model: Post - General User
| Property | Type  | Description  |
| :---:   | :-: | :-: |
| objectId | String | unique id for the user account |
| author | Pointer to user | author id |
| author type | String | consumer classification |
| profileImage | File | user pfp |
| ratings | Number | all reviews left by user |

(Optional Model if Reviews Story is added)
Model: Review
| Property | Type  | Description  |
| :---:   | :-: | :-: |
| objectId | String | unique id for the review |
| author | Pointer to user | author id |
| rating | Number | review score by user |
| caption | String | written review |

### Networking
Food Truck Object:
| CRUD | HTTP Verb  | Example  |
| :---:   | :-: | :-: |
| Create | POST | Create a new food truck |
| Read | GET | Fetch food truck description and photo |
| Update | PUT | Changing a user's profile picture or unfavoriting a food truck |
| Delete | DELETE | Deleting a review |

General User Object:
| CRUD | HTTP Verb  | Example  |
| :---:   | :-: | :-: |
| Create | POST | Create a new general user |
| Read | GET | Fetch food truck objects near a user's location |
| Update | PUT | Changing a user's profile picture or unfavoriting a food truck |
| Delete | DELETE | Deleting a review |

Network Outline (for Required Stories):
* Sign Up Screen - User
  * (Create/POST) Creates a new user account
* Map View Screen - User
  * (Read/GET) Fetch truck data and locations near current location
* Details Screen - User
  * (Update/PUT) Favorite a food truck and set truck value as favorited in database
* Edit Profile Screen - User
  * (Update/PUT) Update user information
 
* Sign Up Screen - Business
  * (Create/POST) Creates a new business account
* Edit Profile Screen - Business
  * (Update/PUT) Update food truck hours or other profile information
