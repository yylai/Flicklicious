# Project 1 - *Flicklicious*

**Flicklicious** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **15** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees an error message when there is a network error.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [ ] Implement segmented control to switch between list view and grid view.
- [x] Add a search bar.
- [x] All images fade in.
- [x] For the large poster, load the low-res image first, switch to high-res when complete.
- [ ] Customize the highlight and selection effect of the cell.
- [ ] Customize the navigation bar.

The following **additional** features are implemented:


## Video Walkthrough

Here's a walkthrough of implemented user stories:

### View a list of movies, view movie details, loading state, pull to refresh, tab bar, search, image fade, low res to high res
<img src='https://github.com/yylai/Flicklicious/blob/master/flick-walkthrough.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

### Network error message, loading state, pull to refresh reloads page after network is restored
<img src='https://github.com/yylai/Flicklicious/blob/master/flick-walkthrough-error.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

- Had trouble setting up Pods. My ruby was outdated and ran into a lot of package issues :X
- Still have trouble with creating and using icons on the tab bar. Can't seem to set the background color of tab bar and can't get the icon to use template mode (had to resort to use original image)

## License

    Copyright [2016] [Yin Yee Lai]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
