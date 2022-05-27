# Search

The search screen is a scrollable infinite (paginated) list, driven by filters applied on the `search` GraphQL endpoint.

## Architecture

The search data is driven primarily by the `SearchService`. Here different parts of the app can apply search criteria, navigate to the search screen and the viewmodel fetches ads based off the applied search filters.
The search response from the GraphQL schema returns now just the list of products but also the available filters. Filters are reductive. That is, the filters available are based on the products returned in the search list and allow a user to further narrow down the selection.
For example, if we fitler by tables then we get back a list of child categories of tables. We will also only see colours returned that are listed in the products returned.
The returned filters are sent through to the filters screen, which is driven entirely from the results of the search. This screen cannot be presented without the results of a search. The filters screen configures the available categories, brands/artists, colours, materials based on the input filters from the search screen.
Min/max price and location are always present.
Size filtering is not performed currently, it would need a range selector.

### Autocomplete

You may notice references to auto-complete in several places. The old REST-based API had a facility to show suggestions for users as they typed in the search field. This functionality is not present (currently) in the GraphQL API. It hasn't been fully removed from the app.

### Saved searches

When saving searches we simple send the current filters (mapping to the GraphQL input).
When we then load the saved search we get the filters back and re-apply them again to the search screen.

### AdAttribute vs FilterAttribute

You may see these used around the place and wonder what the difference between them is. They are named quite similar, probably poorly to be fair.
There is a significant differences between these two, never though they look sort of similar from the outset.

An `AdAttribute` is a base protocol that several models conform to, such as Brands, Categories, Styles, Artists, Material etc. It allows for us to have shared code to operate on these attributes, primarily for selection.
A `FilterAttribute` on the other hand is related to the faceted search that our search results return. Each faceted search only returns the type (e.g. category) and the slug. So for us to work with it in a practical way we need to do a lookup on title text based off the search. Within the filter screens we also pass in lists of these filter attributes as the user can select them and narrow their search results further.
