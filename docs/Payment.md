# Payment

The payment screen is one of the most complex screens in the app. 
There are several ways a user can come into the screen, existing orders that a user should be able to continue with, the payment methods are complex and interaction with the backend is fiddly.

## Architecture

The screen is set up mostly in the same way as the others, with a view model and coordinator.
There are several steps before the user can interact with the screen:

1. Fetch the user. We need to know if the user is a merchant or not and what their addresses are so we can enable/disable parts of the screen
2. Fetch the product information. This includes the selected delivery methods, costs for shipping etc.
3. If there's already a pending order associated with a given bid, we need to fetch the order information.

## Payment Methods

A user can select either credit card, iDeal or Bancontact for payment. These are called our 'payment providers' or 'methods'. iDeal and Bancontact lead users out of the app, over to the user's banking apps where they can initiate payment. Then the banking apps re-direct the user back to the source app with a callback indicating that payment has succeeded or failed (with a cavaet below).
Bancontact is similar, though it has a dedicated card. https://help.mollie.com/hc/en-us/articles/213208685-What-is-Bancontact-

iDeal and Bancontact are known as [Stripe Sources](https://stripe.com/docs/sources)

When a user selects the credit card option Stripe displays a list of existing cards to the user. If no cards exist they can add cards to their wallet. When a user has done they they can select the card they wish to use to pay for the item. Each card has an associated Stripe id. This stripe id we call the 'payment method id'.
Credit cards are known as [Stripe Payments](https://stripe.com/docs/payments)

### Payment Totals

The total charged to a user changes depending on what the user decides for shipping and also the payment method selected. We request the current totals to display in the app based on the current selected options.

Payment totals are refreshed in various scenarios detailed below:

* If pickup is an option, the cost for shipping is zero.
* If delivery is chosen then different delivery methods have different costs associated with them, for example registered post costs more than standard post. 
* The address chosen for shipment also can change the cost also. It costs more to send an item from NL to GB than it does to send it internally within the NL.
* The payment method also changes total. An iDeal payment only costs 1.99. Paying by credit card also incurs a percentage cost of the overall price. So depending on what method the user uses we also need to update the totals from the backend.

### Collecting Payment

Once the user has selected a payment method we create an order on the server (or re-use the existing but update the payment method selected if possible). We then ask the Stripe iOS SDK to take payment.

* If using a Stripe Source this will then link out of the app potentially and redirect to another app.
* If using a card then _generally_. There is a special case for 3D secure which leads a user out to a browser (maybe even an app?) to verify the card. This re-direct flow is similar to the Stripe Source redirection.

When the payment is completed we ask the Whoppah server to pull down the order status from Stripe directly. We have a polling system, as recommended (unfortunately) by Stripe. The app requests the current order status from the Whoppah server, which in turn pulls the status from Stripe. If the payment is fulfilled then we go back to chat and display the order confirmation. If the order is still pending then we retry another 3 times before finally bailing out and flagging the payment as failing.

### Abandoned payment

One side affect of this redirection is that there is a high probability that a user may decide during payment that they actually don't want to continue at all and just return to the app. The Stripe SDK only provides callbacks to the app when the user returns to the app due to a programatic redirection due to a payment completion/failure event. It does not handle cancellation due to a user abandoning the payment process. This is where the polling also kicks in, we poll the server three times and if the end of this the order hasn't changed then return the user to the payment screen.

## Buy Now

For all payments we first need an accepted bid. Buy now in the app is no different. When the user clicks the buy now button behind the scenes we create a bid for the asking price. This can then be used to create the order and complete payment. 
However in the UI users quite often click buy now and decide against completing payment. In this case we withdraw the bid, which on the backend cancels the bid and ensures other users can bid on it.