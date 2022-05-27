# Home

## Architecture

The home screen is quite curious in terms of architecture.

The bottom of the screen has a collection view which has an infinite scroll (via pagination) for new/random items that have been added to the platform.
The entire screen is meant to scroll as one. The rest of the screen is made up of a set of 'blocks', which are sections of content delivered from gateway, driven from the CMS.

I tried several different ways of building this but the 'best' way I found to work nicely was to have a single collection view that has a header view that contains the rest of the content.

It is worth knowing what a 'slug' is, read more [here](https://medium.com/dailyjs/web-developer-playbook-slug-a6dcbe06c284)

### Product blocks

A product block is a section that displays a 2x3 block of products with a title and 'see all' link.
The following rules apply to a block from the CMS:

1. The entire block is hidden if no products are returned. This can happen for something like 'New specials' as users buy items in these blocks.
2. We take a product block's slug (based off the block title in the CMS) and display the title that is equivalent to `<slug>-title`
3. If the product has a link we display the 'See all' button.
4. If there is a link then we look up `<slug>-button`, else display the default text.

### Text blocks

A text block is sort of being hijacked as a sort of image block at the moment.
In the CMS a user can add a number of sections to a text block.
The following rules apply to the top level text block:

1. We take a text block's slug (based off the section title in the CMS) and display the title that is equivalent to `<slug>-title`.
2. If the block has a link in the CMS we display the button on the block.
3. If there is a link then we look up `<slug>-button`, else display the default 'See all' text.

The following rules apply to a text block section from the CMS:

1. We take a text section's slug (based off the section title in the CMS) and display the title that is equivalent to `<slug>-title`.
2. If the section has a link in the CMS we display the button on the block.
3. If there is a link then we look up `<slug>-button`, else display the default text.

If there are more than one text block sections we display the sections as a horizontally swipable carousel.

### Attribute blocks

An attribute is very similar to a text block. The same rules apply to the top level.

1. We take a attribute block's slug (based off the section title in the CMS) and display the title that is equivalent to `<slug>-title`.
2. If the block has a link in the CMS we display the button on the block.
3. If there is a link then we look up `<slug>-button`, else display the default 'See all' text.

If there are multiple attributes available for a block we pick one at random to display.
The image displayed randomly picks from the images associated with the given attribute, there may be more than one image.
The text displayed is also based off the attribute. We take the attribute slug and append '-title' to the end.
They generally follow the pattern `<attribute_type>-<slug>-<title>`.

Some examples:

    material-glass-title
    color-green-title
    style-design-title
    wonen-title-title

