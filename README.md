# Movie App

## Description
A Flutter application that displays a list of movies fetched from the TMDB API. Users can:

- View the latest and trending movies on the main page.
- Click on a movie card to navigate to a detailed movie page.
- Mark movies as favorites.
- Toggle between displaying all movies and only favorite movies.
- Search for movies using a search field.

## Features

1. **Movie List**:
    - Displays a grid of movies with their posters and titles.
    - Fetches data from the TMDB API.
    - <img src="https://i.ibb.co/Sdvt5BS/Whats-App-Image-2024-12-28-at-18-03-03.jpg" alt="Example Image" width="200">

2. **Movie Details Page**:
    - Displays detailed information about a movie when clicked.
    - <img src="https://i.ibb.co/xmPm8G8/Whats-App-Image-2024-12-28-at-18-03-09.jpg" alt="Example Image" width="200">

3. **Favorites**:
    - Users can mark or unmark movies as favorites.
    - Favorite movies are stored locally using Hive.
    

4. **Favorites Toggle**:
    - A toggle to switch between viewing all movies and only favorite movies.
    - <img src="https://i.ibb.co/3C890ff/Whats-App-Image-2024-12-28-at-19-05-36-1.jpg" alt="Example Image" width="200">

5. **Search**:
    - A search field to filter movies by title.
    - <img src="https://i.ibb.co/Y2kzk92/Whats-App-Image-2024-12-28-at-19-08-24.jpg" alt="Example Image" width="200">

## State Management
The app uses BLoC (Business Logic Component) for state management, with two primary BLoCs:

1. **MovieBloc**:
    - Manages the state of loading and displaying movies fetched from the TMDB API or Hive Storage.

2. **MovieFavoriteBloc**:
    - Manages the state of marking and unmarking movies as favorites.

## Getting Started

### Prerequisites
- Install [Flutter](https://flutter.dev/docs/get-started/install).
- Obtain an API key from [TMDB](https://www.themoviedb.org/).

### Installation
1. Clone the repository in your local environment.
2. Create a .env file in the root folder.
3. Add the environment variables
    ```dart
    TMDB_API_ACCESS_TOKEN=<>
    TMDB_API_KEY=<>
    ```
4. Run the application:
   ```bash
   flutter run
   ```
