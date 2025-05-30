# Fetchly – Recipe App

## Summary

Fetchly is a SwiftUI-based recipe app that displays a list of recipes from the provided Fetch API. Each recipe includes its name, cuisine, and photo. Users can tap into a detailed view to see additional information like full-size images, source links, and YouTube videos. The app supports pull-to-refresh, on-demand image loading, persistent disk caching, and dynamic filtering by cuisine.

Screenshots:
- List view with small recipe photos, dynamic cuisine filter, and cuisine tags.
- Detail view with large image, external links, and clean layout.
- Graceful handling of loading states, empty data, and errors.

RecipeView
<img width="596" alt="Screenshot 2025-05-30 at 2 20 40 AM" src="https://github.com/user-attachments/assets/7fa95b9c-e83d-4c03-8204-7d499c0e5ce3" />

RecipeDetailView
![Screenshot 2025-05-29 at 5 16 40 PM](https://github.com/user-attachments/assets/66096838-f9de-4b07-b797-cc1060cd25dc)

Viewing Source Website
![Screenshot 2025-05-29 at 5 16 36 PM](https://github.com/user-attachments/assets/1e4e583c-5382-4f5f-b831-eadbf7b3b29b)

Viewing Youtube Video
![Screenshot 2025-05-29 at 5 16 49 PM](https://github.com/user-attachments/assets/ee48e531-5382-4aa6-abe0-fbe692b8a916)

When the recipe data is malformed
![Screenshot 2025-05-29 at 5 15 26 PM](https://github.com/user-attachments/assets/59b4475e-17bc-4d9c-b49f-9354bed525cb)

When the recipes are empty
![Screenshot 2025-05-29 at 5 12 11 PM](https://github.com/user-attachments/assets/5f65e4c7-8c35-46ae-ab09-c8884726253a)

## Focus Areas

I prioritized:

- Efficient image caching: Implemented a custom `ImageCacheManager` to cache images to disk and reduce redundant network requests.
- Swift Concurrency: Used `async/await` across the entire project for clean and modern asynchronous code.
- Clean SwiftUI architecture: Leveraged `@StateObject`, `.task`, and `.refreshable` to build a responsive and modular UI.
- Cuisine Filtering: Users can filter recipes by cuisine using a horizontal segmented control, populated dynamically from the fetched data.
- Error handling and edge case coverage: Malformed and empty responses are handled with user feedback and retry options.
- Main thread safety: Carefully dispatched UI updates using `@MainActor` and `MainActor.run` to avoid UI glitches or concurrency issues.
- Preview support: Created preview mocks for `RecipeRowView` and `RecipeDetailView` for isolated UI iteration.

## Time Spent

I spent approximately 7–8 hours on this project, with the following breakdown:

- 3.5 hrs: Networking, data modeling, and parsing logic.
- 2 hrs: UI layout for list and detail views, including the cuisine filter.
- 1 hr: Disk-based image caching and async loading.
- 0.5 hr: Error states, retry buttons, and pull-to-refresh.
- 0.5–1 hr: README, screenshots, and final polish.

## Trade-offs and Decisions

- Opted for a custom caching mechanism using `FileManager` to adhere strictly to the no `URLCache` or third-party library requirement.
- Created a new `ImageLoader` per view using `@StateObject(wrappedValue:)` to avoid shared image loading across cells.
- Added a dynamic cuisine filter using a segmented control. This enhances the user experience but could benefit from additional styling and accessibility improvements.
- Focused on performance and clarity over UI animation polish due to the project's time constraints.

## Weakest Part of the Project

- Visual depth: There are opportunities to enhance the visual hierarchy and styling (theming, dynamic typography).
- Test coverage: Core logic is tested, including data fetching, error handling, and cuisine filtering, but UI-level tests (like SwiftUI previews and snapshot tests) were deprioritized due to time constraints.

## Additional Information

- All requirements were completed, including handling malformed and empty data cases.
- Disk caching ensures images persist between launches without triggering unnecessary downloads.
- The app gracefully handles no network or error scenarios, with retry support.
- The code follows a clean MVVM structure, making it easy to scale or extend.
- To prevent file name collisions in the disk cache (especially with image URLs that shared the same filename), I implemented a SHA256 hashing utility to convert each URL string into a unique cache key. This solved the issue where different image URLs with the same `lastPathComponent` were overwriting each other on disk.
