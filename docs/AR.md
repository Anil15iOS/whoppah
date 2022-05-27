# AR

The AR in Whoppah is pretty rudimentary. The setup for the app is partly based on this [Apple example](https://developer.apple.com/documentation/arkit/placing_objects_and_handling_3d_interaction).
It has been modified in several ways of course but the core of it largely remains the same.

Currently AR is only supported for artwork in the Whoppah app.
It is an ideal use-case because it's pretty easy to add a textured plane to a vertical surface.

## Valid Devices

AR isn't supported on all iOS devices, we detect this and hide the AR icon if so. Hence you may get people asking why the icon doesn't appear, this is normally why....or else there may be missing data.

## Steps

The following steps occur when using AR:

1. Plane detection
2. Plane/object placement
3. Image/asset download
4. Active

### Plane detection

When ARKit is started we first check for surfaces, either vertically or horizontally. The orientation depends on the setup from the CMS.
We render a focus rectangle, which is filled or empty depending on if there's a valid surface found or not.

The app is very much limited by the detection capabilities of the device, white walls (perfect for paintings) are particularly poor at surface detection. Hopefully things will be improved in future in this respect.

### Place/object placement

When a user has scanned a valid surface they are no able to place the object in the AR space. To do so they tap the screen.
At this point we create a plane. The size of the plane is based off the width/height of the real item. This is captured as part of the ad creation.
Ads which do not have dimensions are not eligible for display in AR as without the size we cannot create the correct plane.

### Image/asset download

Once placed we then fetch the image from the server.
I recommend to all users (internal and external) that images used for AR should not contain ANY frame and should be a clean image.
Image's aspect ratio also should match the dimensions of the item exactly, as otherwise there'll be cropping which could remove some important detail of the image.
Unfortunately both internally and externally people do not get this and we just crop the image on the fly anyway.

### Active

When the image is downloaded we then let ARKit do it's thing, the picture tracks. The user is able to pan and rotate the image (if enabled on the CMS) around the surfaces.
It is possible for the ARKit tracking to become limited or to be lost altogether for various reasons (check ARKit for these). If this happens we attempt to recover the AR session but if this fails then we're left with no option but to reset the user back to step 1.

## Objects

One R&D project that was worked on for a while at Whoppah is using an object scanning app called Trnio. The idea is that a seller could scan their item from several angles, a 3d model of the item is generated (with textures) and delivered to Whoppah. A pipeline was developed to process this model, including converting it into a model optimal GDB format for consumption in the app.
This pipeline is fully supported in the app, the biggest question marks are still about the dimensions of the scanned item and the quality of the scanning service. Trnio took a long time to develop their service, they said a REST service would be available to send assets to. We'd also need to deploy our backend processing pipeline and allow users to take pictures in the app to scan the item. The UI and process for gathering photos is still yet to be defined. 