# Miscellaneous

This page lists some info about the app in general that don't really fit into any particular story or section in the sibling docs.

For a more general overview of the app see the [main README.md](../README.md)

## Glossary

* PDP - Product description page
* Individual - A user who is not affiliated with a professional organisation
* Business - A user acting on behalf of a business
* Member - an account on the Whoppah system. Associated with a user (with first and last names) and has an email address.
* Merchant - Can be an individual or business. Anyone who is selling on Whoppah is a merchant. A merchant can have 1...* members, mirroring the setup of a real organisation. The app assumes currently that each member is associated with a single merchant, this may not necessarily be the case in the future.

## Core Library

You will notice a WhoppahCore library in the app. As much core models and logic has been put into this library, to guarantee that the model layer cannot know about the UI and that data flow is unidirectional.
There is still a good deal move over into this library (the service layer for example) but this can be done on an on-going basis.

## Localization

The app is localized into two languages, English and Dutch. Most designs are in Dutch and previously devs would use that text directly in storyboards etc.
This made it difficult for non-native speakers to fully understand, so now I default all text to English instead.

Existing localization solutions recommended by Apple for storyboards are terrible at best, require a bunch of silly steps to merge generated string files. I wanted to work off a single master list of strings (except for Info.plist strings of course) for all screens.
We have some utilities that work with storyboards that help with this problem. If you check `Localizable+UI` you can see that several UIKit classes have @IBInspectable extensions that expose `l8nKey`. If this value is set in Interface Builder to a string key then the control will take that key. It's currently implemented for UILabel, UIButton, UINavigationBar and UIViewController.
There's also a build phase script (`find_missing_strings.sh`) that checks Interface Builder for any `l8nKey` that references a string that isn't present in Localisable.strings. An error is displayed with the missing key(s) output in the build log.

### Lokalise

The app uses Lokalise to fetch strings dynamically. Lokalise pulls down strings from it's server, gives the app a callback but also swizzles the main bundle to ensure the `localizedString` returns the right values.

Generally when working with Lokalise when writing new features we often create new strings instead of changing existing. This is so UI doesn't get messed up but also it means we don't have copy that may not make sense in the existing app be changed all of a sudden if we need to do a release. There's a feature called 'branches' in Lokalise but it's not yet available to us.

You can update the current strings in the app by running

    fastlane update_lokalise

## Media Caching

There are two caches in the app. For most media we use [Kingfisher](https://github.com/onevcat/Kingfisher) to fetch and cache images. Kingfisher manages all the media lifecycle itself and purges media if required.
In some situations we use [Cache](https://github.com/hyperoslo/Cache) in the app to cache media. The `MediaCacheService` has a fairly well documented API that interacts with Cache in the implementation. We use the manual Cache for new adverts and video primarily. Kingfisher doesn't support caching of video (it's really an image library). There are two core uses for the `Cache` library:

1. When an ad is saved to a draft we do not upload the media to the server but instead save the media locally viav the `MediaCacheService`
2. When a user uploads a new ad, it takes the server some time to process the media. However the user is dropped straight into the My Whoppah where they expect to see all media present, from there it's possible to view how the product would look in the PDP. So when we save the ad we save the media (images and video) to the cache for a short period of time. Then if the user navigates to the PDP or My Whoppah we check the local cache for the media and display that if there.

## Dependency Injection

We use the service locator pattern for accessing many services. There is a global version of this but the problem with this is that it makes testing very difficult. It's better to pass in the service locator object into whereven needs access to it so it can be mocked and have the implementation swapped out. In many places the constructor of view models, repositories etc. take in the service provider and store it. With the advent of property wrappers in Swift 5.1 some useful libraries have popped up that offer dependency injection. On such library that I've started using is [Resolver](https://github.com/hmlongco/Resolver) as it is reasonably straight forward in terms of it's implementation and usage.

## Deeplinking

The deeplinking in the app is largely straight forward enough. See Navigator.swift for the full set of options. 
The base of the url is: `https://www.whoppah.com/search`, `whoppah://` also works.

* `ad`. Link to an ad. Example: `https://www.whoppah.com/ad?id=314a0382-7cde-4b44-b28e-7a346477d569`. Get the `id` value from the CMS.
* `usp`. Link to the 'safe shopping' screen
* `profile`. Link to a public profile. Example `https://www.whoppah.com/profile?id=314a0382-7cde-4b44-b28e-7a346477d569`. Get the `id` value for a merchant the CMS.
* `map`. Link to the map view
* `looks`. Link to the Shop the look screen
* `create-ad`. Link to the Create an ad screen
* `my-whoppah`. Link to the My Whoppah screen. It's also possible to link to subscreens
  * `ad`, link to a my whoppah ad. Example `https://www.whoppah.com/my-whoppah/ad?id=314a0382-7cde-4b44-b28e-7a346477d569`
  * `account`, link to a my whoppah account. Example `https://www.whoppah.com/my-whoppah/account`
  * `account-settings`, link to a my whoppah account settings screen. Example `https://www.whoppah.com/my-whoppah/account-settings`
  * `payment`, link to a my whoppah payment screen. Example `https://www.whoppah.com/my-whoppah/payment`
  * `contact`, link to a my whoppah contact. Example `https://www.whoppah.com/my-whoppah/contact`
  * `saved-search`, link to a my whoppah saved search screen. Example `https://www.whoppah.com/my-whoppah/saved-search`
* `chat`. Link to the chat screen

Search is a deeplink schema that merits more detail.

After this there are a number of query parameters:

* `brand`, `artist`, `designer`, `color`, `material`, `style`, `category`. Take the slug from the CMS and set the values. It is possible to set multiple e.g. brands in a single query
* `min-price`, `max-price`. The min and max price, in Euro
* `quality`. Possible values: `good`, `great`, `perfect`
* `sort`. Possible values: `default`, `price`, `created`, `distance`
* `order`. Possible values: `asc`, `desc`
* `query`. A search phrase, same as typing into the search field. NOTE: You should url encode (https://www.urlencoder.org/) to ensure there isn't any special characters in the url.
* `ar_ready`. Possible values: `true`, `false`

### Search Examples

https://www.whoppah.com/search?category=wonen&category=fauteuils&category=stoelen-en-fauteuils

Search by wonen, stoelen-en-fauteuils fauteuils, categories.

https://www.whoppah.com/search?max-price=500&category=wonen&category=tafels

Search for wonen, tafels for a price < 500

https://www.whoppah.com/search?brand=artifort&brand=vitra

Search for artifort and vitra brands

https://whoppah.com/search?ar_ready=true&sort=price&order=desc

Search for AR products with a sort of price in descending order

https://whoppah.com/search?query=Nice%20table

Search for all products matching the query 'Nice table'

## Code Debt

Every project has code debt and this is no different. There have been various times where speed was chosen over a longer but nicer solution. Below are the top level items:

* Chat. Chat is fiddly, the sizing of cells is not pretty. The diffing system is quite cool but I don't like that there are 3 different collections at play, there's a chance that they'll get out of sync with one another and that'll cause crazy bugs. It is probably a good idea to encapsulate these in a class or something where the public mutations are through narrow interfaces that make it impossible to do bad things™. The sizing of the chat cells is also quite nasty, with magic numbers around the place. This was mostly due to fighting with the MessengerKit framework and how the styling and sizing of cells is handled there. I would prefer to not have a dependency at all on this library and control it all ourselves.
* The AdDetailsViewController is too big, I'm regularly just about keeping it ~1000 lines when the SwiftLint warning comes it. It can be split up into child VCs (media views might be a good candidate) but needs to be split up one way or other.
* Some of the ViewModels have got quite big.
* Media handling leaves a lot to be desired. There is a good deal of code to load up the media views for the PDP and My Whoppah sections. Could do with some abstraction here to isolate the UI from having to know about draft media etc.
* When we moved from the REST to GraphQL system certain improvements were made to the schema in the anticipation we'd use them in the app. For example, the artists & brands list was previously 40k entries. It made sense to split the brands into designers and brands. However it was felt at the time that this extra designer was too much for users to select and so we removed it again. However there is still quite a lot of code in the app that refers to designers even though they're not displayed anywhere.
* Pagination is a bit clunky currently. I haven't found a nice way to centralise the logic for both the results and the UITableView and UICollectionView. I've tried to centralise some of the core logic for determining when new results are needed but each view still records the pagination data (current page, number of results etc.)
* The usage of `observedLocalizedString` and `localizedString` has not been consistent. The idea with Lokalise is that we may be delivered text asynchronously, which means that some piece of text may be missing, empty or contain some text but may well change later after the latest text is fetched from Lokalise. The `observedLocalizedString` will update all subjects when the text is fetched but it hasn't always been possible to use this. There are places where it is assumed that the text has been fetched but it may not have been fetched yet and so it would display empty or the incorrect text. It would require a good deal of reworking of course but worth bearing in mind.
* There is some inconsistency in the code. Partly due to conventions previously that were applied that changed over time. For example, initially all strings used `_` but the convention moved towards using `-`. Also initially identifiers used `ID` but I was moving more towards `Id`.
* Using Rx in the project has been a bit of a learning experience. Converting the app from massive view controllers to MVVM I quickly realised that it wouldn't scale  nicely without either rolling my own observer system or instead use RxSwift. The streams are also so powerful and allow us to transform data easily which is tremendously useful in many many places.
Combine still isn't an option at this point. So I started with RxSwift initially and learning a little as I went along. There are some bad practices that could be improved. For example, I should be making a lot more use of Drivers in the view model outputs especially. Also the input/output architecture has some flaws. 
  1) It requires a fair bit of boilerplate to ensure the outputs are not exposed as raw Behaviour/Publish subjects/relays. This is improved with Swift 5.1 but still requires 2 vars for each property
  2) Sometimes it is necessary to map the inputs directly to the outputs. This is often for when we are initialising a view with existing data but when submitting a form we take the input values. In this case we set both the outputs and inputs to be the same value which seems a bit wrong.
* There is lots of code still in the app that refers to the map view. It was removed during the GraphQL revamp for several reasons. I never worked that well, the interaction in that screen is quite odd. It may be brought back again in the future but I think it would be best to maybe re-write it from scratch when that does happen.
* There are still some VCs that haven't been upgraded to MVVM. Generally they're pretty simple VCs but we should upgrade them as we go along.
* There are several AutoLayout warnings in the console. Some of these are caused by third parties (IQKeyboardManager being one in particular) but there are several from our code. I'd like to spend time to remove all of these, I _think_ they don't cause any major issues as things stand.
* Several keys for third party libraries are referenced directly in the code. We should have them obfuscated if possible. I was hoping to investigate something along the lines of [this](https://nshipster.com/secrets/)
