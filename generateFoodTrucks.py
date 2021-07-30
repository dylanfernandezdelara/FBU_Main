import json
import copy
import random

template = {
    "username": "truck",
      "password": "password",
      "truckLocation": {
        "__type": "GeoPoint",
        "latitude": 29.6670002,
        "longitude": -98.4254288
      },
      "streetName": "24226 Waterwell Oaks",
      "email": "truck1@gmail.com",
      "truckDescription": "description text",
      "detailsImage": {
        "__type": "File",
        "name": "8d2ff83bb95d1baf2fafd81cf1056937_detailsPhoto.png",
        "url": "https://parsefiles.back4app.com/KKMFllzbDrpuIx5zW1KoGWfgjx7SvhpnD9QzQNYI/8d2ff83bb95d1baf2fafd81cf1056937_detailsPhoto.png"
      },
      "userType": "FoodTruck",
      "fullName": "truck1",
      "Image": {
        "__type": "File",
        "name": "bef83915e31dd019c7cea8aca25b730f_profilePhoto.png",
        "url": "https://parsefiles.back4app.com/KKMFllzbDrpuIx5zW1KoGWfgjx7SvhpnD9QzQNYI/bef83915e31dd019c7cea8aca25b730f_profilePhoto.png"
      },
      "numClicks": 0,
      "friOpenTime": "08:00",
      "thuOpenTime": "08:00",
      "monCloseTime": "05:00",
      "friCloseTime": "05:00",
      "satCloseTime": "05:00",
      "sunOpenTime": "08:00",
      "satOpenTime": "08:00",
      "tueOpenTime": "08:00",
      "sunCloseTime": "05:00",
      "wedOpenTime": "08:00",
      "monOpenTime": "08:00",
      "wedCloseTime": "05:00",
      "thuCloseTime": "05:00",
      "tueCloseTime": "05:00",
      "mexicanType": False,
      "pizzaType": False,
      "priceLevel": 1,
      "sandwichesType": False,
      "bbqType": False,
      "seafoodType": False,
      "brunchType": True,
      "favoriteCount": 0,
      "ACL": {
        "*": {
          "read": True
        },
        "LG6EtQ0AiP": {
          "read": True,
          "write": True
        }
      }
}

arrayOfDicts = []
arrrayOfBool = [True, False]

# change # here to add or remove objects
numberOfTrucks = 50

for x in range(numberOfTrucks):
    temp = copy.deepcopy(template)

    temp["username"] = "truck" + str(x)
    temp["fullName"] = "truck" + str(x)
    temp["truckLocation"]["latitude"] = round(29.6670002 + (x / random.randint(1000, 10000)), 7)
    temp["truckLocation"]["longitude"] = round(-98.4254288 + (x / random.randint(1000, 10000)), 7)
    temp["email"] = "truck" + str(x) + "@gmail.com"
    temp["numClicks"] = random.randint(0, 1000)

    temp["mexicanType"] = random.choice(arrrayOfBool)
    temp["pizzaType"] = random.choice(arrrayOfBool)
    temp["sandwichesType"] = random.choice(arrrayOfBool)
    temp["bbqType"] = random.choice(arrrayOfBool)
    temp["seafoodType"] = random.choice(arrrayOfBool)
    temp["brunchType"] = random.choice(arrrayOfBool)

    temp["priceLevel"] = random.randint(0, 2)
    temp["favoriteCount"] = random.randint(0, 99)

    arrayOfDicts.append(temp)

outline = {
    "className": "User",
    "rows": arrayOfDicts
}

with open('truckData.json', 'w') as f:
    json.dump(outline, f, indent=4)
