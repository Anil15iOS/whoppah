# Services

Below is a list of the services in the Whoppah app.

The Service provider contains references to all of the below interfaces. Using the new `Resolver` dependency injection framework it is possible now to pick which services you need for a given view model/coordinator etc.
The service provider itself is just a protocol/interface. The concrete implementation of it is provided at runtime.

## Ads Services

Services to create, delete and publish ads.

## Apollo Services

Wrapper for the Apollo library, to query and mutate the backend GraphQL server.

## Media Service

Upload and delete video and photos for products and merchants.

## Merchant Service

Fetch, update merchants, including adding and removing images and addresses.

## Auction Service

Create, accept and reject bids

## Auth Service

Login, signup and password reset

## User Service

Get and update members and saved searches (this should probably be moved elsewhere)

## Chat Service

Fetch threads, unread counts and send chat & product messages

## Payment Service

Handles order and payment creation along with transitioning between different order states.

## Feature Service

Any features that are enabled in the app, currently only SSL pinning is present there.

## Recognition Service

Perform recognition on the backend, primarily for search by photo.

## Search Service

Currently applied search filters in the app. Also provides an API to go to and from the saved search requests.

## Cache Service

Contains some commonly used repositories so they don't need to refetch their contents and can be re-used in several places in the app.

## Location Services

Does reverse geocoding on a given address using CoreLocation

## Media Cache Service

Provides facilities to download, cache and fetch image and raw Data objects from a server.

## Push Notification Service

Registers for push notifications (including permissions) with the backend, handles push paylaods including routing commands.

## Ad Creator Service

Contains the ad template which is used during ad creation, the media manager and several functions to create, update and publish live and draft ads.

## Event Tracking Service

Used to track analytics events from the app

## Store Service

Determines if an update to the app is available on the app store.