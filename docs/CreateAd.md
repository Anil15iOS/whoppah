# Create an ad

## Architecture

There are multiple steps of the create ad flow. I've seperated them into VCS with each it's own view model and coordinator. There are some base objects for the VCs, view models and coordinators to share some code that is common across all the screens.

The ad 'template' is a critical componentto the ad creation progress.
The template is a data container that holds all data that can be set during the ad creation process, it is transformed into a GraphQL input when the user finishes the flow.
The template is shared across new ads and ads being edited. For an ad being edited the template is pre-filled with the existing ad data from the server. When the user eventually hits save then the template is persisted to the server.

When going through screens the template is only modified when the user hits save. This is so the user can hit back when editing and changes they've made aren't reflected in the summary screen. If the template was updated as soon as something chanaged in the screen e.g. title then back would be equivalent to hitting save but equally there may be missing validation as back does not validate. It is possible to clone a template, that could be one other option in future, back just discards the current template and restores to a previous one.

Create an ad in general is pretty straight forward, the main thing that needs a little bit of explaining is how drafts operate.

## Drafts

When a user saves a draft we save the ad to the server (by creating a new product) but do not save the media.

The reason we do this is to keep draft saving quick, uploading media would make the saving of a draft quite slow.
Instead the media is saved to a local device cache.

A new product requires a certain amount of mandatory information, for example it needs a price, whether bidding is enabled, a title and condition. If the user hasn't progressed to the screen that sets this info when saving then we default these values internally.

### Ad attributes

An ad attribute is used so several types of models can share the same UI for selection.
For example, brands, designers and artists have the same selection screens but different concrete types.
Similarly we have styles, materials and categories can in theory share the same screens for selection, they have in the past. It also allows for a single repository that returns a collection of ad attributes.

## Media Manager

The ad media manager is one of most complicated parts of the app and definitely could be worth a solid refactoring. The main problem is that it violates the single responsibility rule. It has APIs relating to loading, saving, moving, deleting, uploading, snapshotting and diffing. It does a lot and so has grown to be quite large over time.

### Slots

In the original vision of Whoppah it was possible to have all the media in a single collection view. If all media were images it was very simple. However video was complicated, because it there it occupied the second slot (index 1). This had widespead implications for the media, it affected adding, moving, deleting of media because it caused shuffling of media.
To solve this the media manager has a slot system designed, where each slot represented could be empty, a photo or a video. This allowed for me to much easier for the collection view and also resolving differences for uploads.
However a new redesign of the app meant that the video and photo elements were separated out so this has meant that some of this complication went away. However a lot of the slot mechanisms still exist, they could be simplified in future.

One issue that could be improved is that we do tend to load all existing images into RAM when loading an existing ad. This is not jus using a lot of memory but may cause a good bit of copying depending on what the user does. In future it could/should be lazy loading where it is only loaded on demand or instead use a URL if possible.

### Diff resolution

Each photo and video can be 'new' or 'existing'. Existing means it already exists on the server, 'new' means it is new media selected from the camera or gallery.
When creating an ad the process is simple, upload all the media.
When it comes to editing of an ad though, it's a bit more complex. A user could have deleted media, added other media, shuffled images, added or removed video. The way we tackle this is by taking a 'snapshot' of the slots at the start of ad creation. Then when resolving later we check against this snapshot and come up with a set of diffs and apply those diffs with the server.

A more formal diffing system would be less error prone, perhaps DifferenceKit could work. It would be pretty easy, the diff algorithm just checks the hash of the slot and each new or existing slot somehow comes up with a hash based on the content. We don't want the hashing to operate on the entire data of the slot because that'll be very slow to compute...perhaps there's some faster way.

Snapshots are also used when navigating from the Summary screen (last screen for creating an ad, first screen when edit is clicked) to the create ad media screens or going from the media screens into the camera views. The snapshot allows for those screens to make changes on the ad template but then reverting those changes if the user hits 'back' in the navigation bar. Perhaps a more formalised undo stack type system might be cleaner but this approach works fine as things stand.