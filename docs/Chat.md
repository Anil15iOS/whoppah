
# Chat

The chat screen is easily the most complex part of the app.

The main complication is how the server messages relate to what is displayed on screen.

There is **not** a 1:1 mapping, a server message often displays more than one visual chat cell in the collection view.
Also, depending on the state of the associated object with a given server message, updating a single message may require for a totally different set of generated messages to appear. Because of this the system is complex by nature...I will attempt to explain it here. The core logic for what messages are displayed in what scenarios is within `ChatMessageFactory`.

## Glossary

* Server message. A message from the server, often contains an associated GraphQL object.
* Chat message. A displayed chat cell on screen, this includes bot messages, bid messages etc.
* MessageId. An integer that represents a given chat message.

### MessengerKit

We use an SDK called [MessengerKit](https://github.com/steve228uk/MessengerKit), I think that really we do not need to use this framework any more. It provided a lot of advantages for the initial design of the system but since the great architecture change of 2019™ the chat system changed a lot and it's benefits became reduced. Also since the initial integration it has moved from beta and the API has changed _a lot_.
I am constantly fighting with it, in the past someone took the decision to not use the provided input view and we now use our own custom one. This has had some interesting knock-ons such as combine back from the checkout screen the bottom input view occupied the entire screen. Fixing it was non-trivial and required a hack in the set up of the chat view controller.  

### DifferenceKit

This is used to determine and apply differences to collection views. At the time of writing the Diffable data sources aren't available as they're iOS 13 as a minimum. In the future the project could be migrated to user this. For now we use DifferenceKit, it works quite well for our purposes.

## Architecture

The screen is effectively a collection view where the latest items at the bottom. It is sectioned according to who sent the last message. If a user sent multiple messages in a row then these messages would be in the same section until the other user or a bot sent a message. This sectioning is also visually represented as we display the time and the received tick at the bottom of the section.

The data stored by the Chat view model may not be clear at first but is largely in place to allow for quick lookups given the sectioned data.

The chat view model maintains a flat array of all chat messages. It was implemented this way because it is much easier to go from a flat array to a sectioned one than it is to deal with a multi-dimensional array everywhere. We did originally have a multi-dimensional array and it was difficult to deal with and reason about. This list is effectively used as the datasource for the collection view.

The chat view model also keeps a message to IndexPath dictionary. This is a lookup that takes a given chat message and returns it's index path. The index path is effectively the section and row that the message occupies.
The chat view model also contains a section to MessageId dictionary. This is a multi-dimensional array that takes a given section and row and returns the index into the messages array. This is also used to generate diffs and index into our flat array for the collection view datasource.
The above data structures allow us to quickly look up messages and sections. The main thing to be aware of is that they must remain in sync with the each other.

### Message Structure

For each server message we pass it into the ChatMessageFactory. If the message is a plain text message then an array with a single chat message is generated. For each type of server object that the server message contains (Bid, Product, Order, Shipment) we look at the state of the object. Depending on whether the user is a buyer or seller the factory we then generate an array of chat messages. These could be a set of bot messages (automated appearing from Whoppah as tips), cells that require some action or just some other cell. Each chat message is assigned an id which is an Int. This is required for the MessengerKit library. The ChatMessageFactory maintains a dictionary that maps the server message (UUID) to the chat messages ([Int]). This helps with determining changes in the message lists later.

#### Message Hashing

The hashing of chat messages are critical to the efficient operation of the chat system. Each chat message has a hash calculated based on the associated payload. The payload is either the content of the message itself i.e. the text or hashes the state and properties of the associated server message object.

For a trivial example. We receive a server message that contains a bid. The bid state will be `new`.
The generate three messages, a bot message with the text "hey you have a bid", a bid cell that has accept/reject buttons and another bot message saying "you have two hours to respond".
The bot message here is hashed based on the content of the text. The bid cell is hashed based on the server Bid object, this takes the id, status and order id (if present). These could look like:

    [4398349784,
    9472737837,
    124750676]

### Message Processing

The basic process for processing messages is the following:

1. The app requests messages from the server. The server responds with a list of messages (paginated)
2. Take a snapshot of the current state of the sections. This is effectively a multi-dimensional array that contains all the hashes of all messages in each section.
3. For each server message we get back the list of existing messages from the ChatMessageFactory. We map this list to fetch back the actual indices of the exsting messages from the flat messages array.
4. Generate the set of chat messages for the given server message from the ChatMessageFactory.
5. Remove existing chat messages from the flat messages list.
6. Add the new messages to the flat messages list. Depending on whether we're just fetching latest or paging upwards in the chat message list we will insert messages at the front or back of the message list.
7. Generate a new snapshot of the new state of the chat sections.
8. Perform a diff between the snapshot in 1. and the new snapshot. This will cause the collection view insert, delete or shuffle around cells based on the hashing matches.

Going back to the earlier example where a bid has arrived in from the server. If the user clicks accept then we fetch the latest messages from the server.
We see that the server message is already present.
Then we generate a new set of chat messages. The difference is now that the bid state is now `accepted`. In the ChatMessageFactory this now generates 2 messages:
A bid message that has the cell disabled and visually shows that the bid has been accepted and another bot message saying "The buyer needs to pay within 48 hours".
This could look like:
  
    [8749348348,
    6428383833]

When checking the snapshots the diff calculator will see that it needs to remove three messages with the hash `4398349784`, `9472737837`, `124750676` and add in two new messages with the hashes `8749348348` and `6428383833`.

If the user now again reflects the chat and there's been no changes to the server objects then the same messages with the same hashes will be generated. The diff algorithm will see that there are zero changes to be applied and nothing will change.

This approach works quite well, if only one message moves then the diff algorithm will remove it, if the messages change order (and they do) the collection view will do this automatically. If the section completely disappears then this will also be handled.

### Fetching latest messages

Every time the user drags down on the bottom of the list or we receive a push from the server about a new message being available we fetch latest messages.
This will pull down the first page (latest 25 messages). We then let the diffing to handle the modifications to the list.

NOTE: there is a potential issue with the current implementation of the chat. If the user receives many messages from another user and the first set of messages move off the first screen then fetching the latest messages will not update the second page of messages. If the user leaves the screen and scrolls upwards then of course the latest is fetched at this point. I'm sure this could be resolved somehow in future if it becomes a bit issue.

### Sizing

The sizing of the chat cells is really fiddly. MessengerKit supports prefetching of messages and so does not query the cell directly but instead asks the _MSGMessengerStyle_ for the size of the cell. It also caches the sizes of the 

## Testing

All chat cells receive through (via MSGMessage) a payload. This payload is a POSO that contains only the necessary information needed for display of that cell.
We don't expose the raw model data to the cell, it could be done but I decided against it because the UI really shouldn't know about that data.
However that being said it does add some extra code for the creation of these structs. It does allow for nice testing of the outputs of the chat message factory.
Because it's not tied to the raw GraphQL models it allows us to easily create cells both for manual and automated testing. It can be quite useful when testing variants of messages to directly create different variants in the ChatMessageFactory.

## Performance

Every time the server messages are fetched we iterate over the entire list of messages and sort them. This is O(n) + O(log n).
While this is not terrible for a reasonably small amount of messages, if we hit thousands of messages then we will start to see issues.

## Simulator

Chat is driven by silent push notifications from the backend. Any time a message is received from the backend we do a refresh of a thread (if open). However in the simulator push notifications don't work, although recently there has been some developments there they still don't work fully. The same situation applies to users who have denied push notification permission to the app, however we definitely don't handle this very well currently in terms of UI and education at least. 