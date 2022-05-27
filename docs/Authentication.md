
# Authentication

The app supports registration via email/password and social networks.
Social is only enabled for individuals and not businesses.
Currently much of the authentication still uses a REST api, but updating the member & merchant is done via the GraphQL API.

## Architecture

The sign up flow is split over several screens, especially for businesses. A single view model `RegistrationViewModel` is shared across all the screens.
This may not be the cleanest but saves passing data back and forth and it doesn't get out hand in terms of size. In the future if it got more complex it could be split up perhaps.
The account is only created on completion of the flow, at which point we create the account and then upload the details of the created merchant with the filled in data.
There are plans to move the authentication to the GraphQL schema (I believe the work has even been done).

The flow was recently re-writen entirely using code-only layout.