# Hlamnik

## Table of content

  * [Description](#description)
  * [Pre-requisites](#pre-requisites)
  * [Getting started](#getting-started)
  * [Screenshots](#screenshots)
  * [License](#license)


## Description

Hlamnik is an app developed with [Flutter](https://flutter.dev/) and [Dart](https://dart.dev/). 
The goal of the app is to allow the user to manage his clothing items.
For now the user can:
* See a list of all his items
* Filter the list according to ratings, category, season, color
* Add and edit item
* See a detailed view of the item
* Delete an item
* Add new colors and categories

You can see Future<void>developments by checking the [issues](https://github.com/malain96/Hlamnik/issues). Feel free to add new issues.
You are more than welcome to use and modify the app as you please. 

:warning: Note: I don't own a Mac, so the project isn't configured for IOS.
 
## Pre-requisites

* [Flutter](https://flutter.dev/docs/get-started/install)
* [Android Studio](https://developer.android.com/studio)
* [Visual Studio Code](https://code.visualstudio.com/) (If you don't like Android Studio as an IDE but you should install some [plugins](https://flutter.dev/docs/get-started/editor?tab=vscode))

## Getting started

* Clone or download the repository 
* Open the project in your favorite IDE (Android Studio or VS Code)
* Generate the database using `flutter packages pub run build_runner build`
* Generate the localizations using `flutter pub run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart`
* Launch an emulator or connect your phone
* Run the app

## Screenshots

<p float="left">
  <img src="https://github.com/malain96/Hlamnik/blob/master/screenshots/item_list.jpg?raw=true"  height="500">
  <img src="https://github.com/malain96/Hlamnik/blob/master/screenshots/item_list_filters.jpg?raw=true"  height="500">
  <img src="https://github.com/malain96/Hlamnik/blob/master/screenshots/item_details.jpg?raw=true"  height="500">
  <img src="https://github.com/malain96/Hlamnik/blob/master/screenshots/add_item.jpg?raw=true"  height="500">
  <img src="https://github.com/malain96/Hlamnik/blob/master/screenshots/brand_crud.jpg?raw=true"  height="500">
<p>

## License

[MIT](https://github.com/malain96/Hlamnik/blob/master/LICENSE.md)
