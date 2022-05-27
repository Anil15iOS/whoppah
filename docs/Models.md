# Model

## Model State

The system is a big state machine, products/bids/auction/orders have defined states and transitions cause events to trigger on both the front and backend.

### Product

A product has several states.

* **DRAFT** - when a product is created on the backend but not published it is in draft state. In this state the auction is also in draft.
* **CURATION** - when a product is published it automatically goes into curation state to be checked by Whoppah
* **REJECTED** - when the product has been rejected (from curation or even after) from the system. It can be edited and republished for curation again.
* **BANNED** - when a product is permanently banned from the system
* **CANCELLED** - when a product has been canceled from the system, and we don't want it to appear in any searches etc. This happens when a product has been withdrawn for example.
* **ACCEPTED** - product has been curated and accepted. Now will have an active auction present

### Auction

* **DRAFT** - product has not yet been published
* **PUBLISHED** - the auction is active, users can find the product and bid or buy it
* **CANCELLED** - when a product is canceled, the auction is also canceled. It won't appear in any public searches.
* **EXPIRED** - an auction can run for a limited time, defined by an end date. If this date is passed then it moves into expired state
* **RESERVED** - an auction is reserved when a user has an accepted bid (either through buy now or the seller accepting it) and they have initiated payment i.e. created an order. The auction remains in reserved until the item is received by the buyer. NOTE: The auction may still go back to published if the user does not complete payment in a given time period.
* **COMPLETED** - the product has been paid for and the other user has indicated they've received the item.
* **BANNED** - when a product is banned the auction is also banned.

### Bid

Bids can be sent by both the buyer or seller. Initially on a product only a buyer can sell a bid to the seller. Once a bid has been received the seller is able to counterbid. The front end disables bidding when there is an accepted bid or reserved auction (amongst other scenarios).

* **NEW** - The bid is new and pending response from the buyer or seller.
* **ACCEPTED** - The bid has been accepted and the buyer is presented with a pay button in chat.
* **CANCELED** - The bid has been canceled, this can happen if a bid is withdrawn. Bids are currently only withdrawn when a user backs out of `Buy now`.
* **PROCESSING** - The product has been paid for but not yet received by the buyer.
* **COMPLETED** - The product has been paid for and received by the buyer.
* **EXPIRED** - Once a bid has been accepted we set an end date by which the bid needs to be paid for. If this is passed then the bid goes into an expired state.
* **EXPIRED** - The bid has been rejected by the buyer or seller.

### Order

When a user clicks 'pay' in the checkout screen we create an order. The user then goes through and completes payment with a payment method via Stripe and the order moves into different states.

* **NEW** - The user has initiated payment, the order is new and pending payment.
* **CANCELED** - The order has been canceled, this only happens via the CMS currently.
* **EXPIRED** - Once the order has been created and in a new state a date is set for a user to finalise payment. If this date is lapsed the order goes into expired state.
* **ACCEPTED** - The new order has been paid for, we have checked with Stripe and the payment has been received.
* **SHIPPED** - The item has been shipped (for delivery items only). Currently the shipment is automatically generated on the backend.
* **DISPUTED** - The user has indicated that the item has not been received or did not match description or was in bad condition.
* **COMPLETED** - The user has indicates that the item has been received in good condition.
