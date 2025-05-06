
# Betto

**Betto** is a small racing app which demoes new [Swift 6](https://www.swift.org/blog/announcing-swift-6/) features including [Swift Testing](https://developer.apple.com/documentation/testing/), [Strict Concurrency Checking](https://developer.apple.com/documentation/swift/adoptingswift6), and uses the latest and greatest SwiftUI/Swift Concurrency APIs.

## Getting Started
To run the app, clone the repository and open `Betto.xcodeproj`.

## Requirements

To run Betto, the following minimum requirements apply:

- Xcode 16.3 (Swift 6)
- iOS 18.4

## Architecture & Considerations

### Design Pattern

The app follows an MVVM design pattern with a SwiftUI lifecycle. It uses the new [Observation](https://developer.apple.com/documentation/observation) framework to manage state and handle view updates.

In our view models, Betto adopts a `LoadingState` enum which manages the possible states of the view, and that state is mapped to a computed property which represents the view state of the UI.

For a simple screen interacting with a rest API, it might make more sense to leave the loading of data up to APIs like `.task` and then allow the SwiftUI lifecycle to manage the cancellation of that task as needed, but in the case of racing, we need to manage a continuous stream of data that is polled based on a `ttl` setting. Hence, in the case of Betto, we choose to manually manage the loading task in a similar fashion to how a combine publisher subscription might be managed. Given more time/resources, a socketed connection could potentially offer a more reliable solution.

### Networking

In `RacesView` this task represents an `AsyncStream` which is created in our repository layer. This repository/gateway pattern is something that could be reliably scaled to other areas of the app. Currently the gateway being used is quite simple, but if this was scaled, it would make sense to build out a more robust gateway/client framework or lean into a third party library like `Alamofire`.

### Mapper Pattern

Another pattern I've enjoyed using here is a `Mapper` pattern where any technical client side mapping that's required is done in a mapper layer that can be tesed independently from the view/viewmodel flow. `RaceInfoMapper` exists as a class with the idea that some properties might be shared across mapping functions in the future, and so those properties could be stored there. However, this is a bit overkill for the current implementation and a static enum might've been a better solution.

### Accessibility

I've demoed a few a11y improvements with voiceover and the use of a scroll view. However, many more accessibility improvements can be made given more time. Improving hints and labels, and auditing more advanced features like Voice Control would be something I'd like to do. I purposely used system fonts, colors, icons, and components to ensure that a11y was as supported as could be out of the box and this also had the benefit of supporting dark mode right away.

### Things I would do differently & Bugs

#### Race Countdown Timer (Documented in Project)
Given the time constraint, using the Text `init(_:style:)` makes the most sense to display relative start time with ease. I would likely do a full formatter implementation if I had more time.
Making a `start time` component in its self where the id of the view updates based on a timer makes more sense as well.
Right now a new response has to come in from the repository for the view to redraw. This causes a bug where for a short instance the time will not update to show a the relative date with the (-) marker.

#### TTL Management (Documented in Project)
We use an extremely aggressive `TTL` of 5 seconds. I'm not sure what the actual limits/standards are for this endpoint.
With more time, I'd optimize to request a more optimized `TTL` depending on the urgency of a specific race's start time.
i.e. if a race's start time was in 30 minutes, we might request every 2 minutes, but if a race starts in 90 seconds, we might request every 15 seconds.

#### Displaying 5 Next To Go Races When Filtering
Something that I missed is ensuring that at least 5 races are displayed even when the API did not return at least 5 races with the selected filtered category id.
This would be something to improve with more time where I could request more races if there was not enough meeting the criteria to display 5.

#### Repository/Polling
There are many options when polling and if sticking to using no `Combine` and only `Swift Concurrency` there might be better paths depending on the needs.
For example, I believe `AsyncStream` is limited in how clients consume its data. Possibly using an actor that manages some state could provide a better path.

## Background/Overall Thoughts
I used to work at GoDaddy on the auctions app, and we had to face a lot of similar problems so this was a very fun jump back into that world. Enjoyed it very much!
  
## Author

Galen Quinn
