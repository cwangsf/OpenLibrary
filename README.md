This is a testing project using API from https://openlibrary.org/developers/api. 
Tech stack:
* SwiftUI
* Combine
* async/await
* SwiftData

# Feature Finished

* Data source should be OpenLibrary API (https://openlibrary.org/developers/api)
* There are a lot of api from this site, for the feature described in the requirement, I only use these two end points:
    - [Subject API](https://openlibrary.org/dev/docs/api/subjects): Fetch books by subject name
    - [Book API](https://openlibrary.org/dev/docs/api/books): Retrieve a specific work or edition by identifier

## List View - the landing screen when you open the app. This screen should display the following

 * Search bar that allows you to search for a subject
  * Paginated list that displays the books that fall within the subject
  * Keep scroll up, at the end of the limit (or accumulated limit), it will get more from the offset.
  * Item view should display at least the book cover, title, and author
  * The Cover is use the small size image from the Cover API with AsyncImage.

## Detail View - this screen should display the following

  * Enlarged Book cover
  * Used the Medium sized image, which is recommend on the API page:
  * Title
  * Author (or list of authors)
  * Publish date
    There are multiple property has publish dates, I choose the key first_publish_date
  * Description
    As mentioned below in the issue section, the server returned some inconsistent format. Only handle the one with a string value in this version.

## Offline access using SwiftData
Saving data locally with SwiftData. When the device lost network connection, it will stay with the same screen, but show a text of indicate that no network. If you do follow up search, if the search text is not saved before, there will be no book; if the search text have saved before, will show the saved data. See the attached first video.

To help verify SwiftData is save on device, I added a debug button at the bottom of the home screen. If you click, is will show the retrieved book list. See the attached second video. This screen will be only shown in debug build, won't be shown in release build.

# Sample Test
This video shows retrieving book list from a search, then turned off network, show the offline data. Also showed the how the SwiftData debug screen.
https://github.com/user-attachments/assets/26c3a2a4-7834-4a4c-b990-fd1459df61b0
