# Single-Stroke Pattern Recognition in GameMaker
A simple algorithm to recognize/identify different user-inputted drawn patterns and gestures. They are compared against a set of Paths (as in the GameMaker resource type) and the closest fitting one is returned.

## How it Works
This algorithm simply compares user input points with evenly spaced points along all possible patterns, calculating how far they are from their intended location on that pattern. The pattern that differs from the user input the least is, obviously, the most accurate.

### Preparation Steps
The recognition patterns are defined as Gamemaker Path resources with points between the 0,0 and 64,64 coordinates (and divided by 64 to normalize them in the algorithm step, though this can be easily changed), and they are stored in a global array.

User input is stored in a ds_list as size-2 arrays containing x and y coordinates. The points are normalized to 0-1 values as the algorithm is ran, like the Path points, though that's also very easy to edit and move to outside the algorithm itself. In this project, that step is executed as the algorithm runs, both to keep the project simple and for performance (not having to edit the list).

This normalization, as the project is set up, does not respect aspect ratio unless specified in the relevant function argument, or unless the user input has a very non-square aspect ratio. This results in better recognition, while also making sure that very "mono-dimensional" patterns such as a single horizontal or vertical stroke are still recognizeable.

### The Algorithm
The algorithm splits the Paths into a set of evenly spaced points. It also picks an equal number of points from the user input, splitting them evenly along the array (or rather, ds_list).

The points are matched against each other, calculating the distance from the user input points to the target path points. This is repeated again, going backwards through the Path, if the algorithm is told to ignore stroke direction.

This is repeated for each possible path. At the end, the path with the lowest average distance is the closest fit.

## Downsides
There are a few issues with how the algorithm is implemented, though most of them are with the setup steps.

For example, if the user input isn't very evenly spaced, it can easily throw off point distances. Though this can be solved easily by having an extra pass to manipulate the user input, so that the points are more evenly spaced.

Additionally, unlike similar algorithms such as $1 and $Q, this system is natively single-stroke only (though that can be adapted such as how the $N recognizer does) and doesn't recognize rotated shapes.

## Alternatives & Changes
A few things can be done to fix some issues and tweak the algorithm.

### Input Point Spacing
First of all as described in the Downsides section, better results are obtained when the input points are more evenly spaced. This can be achieved with an extra step to process the points, or by calculating them in a different manner to begin with, such as interpolating fake "inbetween" points when the input method is moving too fast.

Similarly, converting the user inputs to a Path resource instead of having raw point coordinates in a ds_list would lead to the best results, as the points would be exactly evenly spaced. However this step would use more memory and time to create the Path to begin with.

### Point-to-Path Comparison
In terms of the recognition itself, the project source code offers two options: squared distance and actual point distance. The difference between the two is mostly just a tiny bit of performance.

However, these could be replaced with other things, such as standard deviation from the path (so that stray inputs at the start or end don't cause massive issues) or manhattan distance for even better performance (though in my testing this came with a massive loss in accuracy).

## Crediting
This code is provided as is, under the Unlicense. However, any form of credit is appreciated.
