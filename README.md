# Drivemode Mobile Software Engineer Technical Test

Welcome to the Drivemode technical test assignment.

The test is a practical implementation test. First let's explain the project.

## Product Description

This app displays a list of books from a given subject and the book details. The user can type a subject and the app will search for all the books that fall within the subject and list them down. Tapping on an item will open a new screen that shows the details of the book.

## Technical requirements

1. Data source should be OpenLibrary API (https://openlibrary.org)
2. List View - the landing screen when you open the app. This screen should display the following
    * Search bar that allows you to search for a subject
    * Paginated list that displays the books that fall within the subject
    * Item view should display at least the book cover, title, and author
3. Detail View - this screen should display the following
    * Enlarged Book cover
    * Title
    * Author (or list of authors)
    * Publish date
    * Description
4. Offline first. The app should be able to work offline. If the user has already searched for a subject, the app should be able to display the results even if the user is offline.
5. Use Swift and SwiftUI. (Could use UIKit if no SwiftUI experience)
6. Any architectures are accepable, but please avoid one giant file for everything.
7. For concurrency frameworks, please use native SDKs like GCD, Combine, Async/Await, etc. (Third party libraries are also acceptable if you could give strong reasons.)
8. For persistence layer, please avoid using User Defaults.

## Deliverables

A junior engineer has started implementing the app but has not completely finished it. It's your time to reimplement the app. Create a separate branch and write the Pull Request. You can use any third party libraries to help you focus on what matters. You could rewrite parts or whole project based on your needs.

## Evaluation Criteria
1. Functionality - the application has the functionalities described in the requirements above, and does not crash
2. Quality of code - no design issues, complies with the current conventions and standards of modern iOS application development, and with a clear and progressive commit logs
3. User Interface and experience - the application should be intuitive and easy to use
4. Architecture - maintainability, extensibility and testability
5. Unit test

## Bonus points
1. User interface design: feel free to use additional data and implement new features to make the app more attractive
2. Production quality: consider what it takes to build a production-ready application, including handling of situations applicable to iOS mobile applications such as lack of network coverage, configuration changes, performance, etc.

## Notice
Please do not share this project or any details about this project with anyone else. We would like to keep this test private and only for the candidates who are applying for the position.
