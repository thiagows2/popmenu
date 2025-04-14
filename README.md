# Restaurant Menu Management API

A Ruby on Rails API for managing restaurant menus, allowing creation and management of restaurants, menus, and menu items with support for importing data from JSON files.

## Contents

- [Prerequisites](#prerequisites)
- [Setup and Running the Application](#setup-and-running-the-application)
- [Running Tests](#running-tests)
- [API Documentation](#api-documentation)

## Prerequisites

Make sure you have the following installed:

* [Docker](https://www.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)

## Setup and Running the Application

1. **Clone the Repository**
  ```bash
  git clone https://github.com/thiagows2/popmenu.git
  cd popmenu
  ```

2. **Build and Start the Application**
  ```bash
  docker-compose build
  docker-compose up
  ```

3. **Initialize the Database**
  In a separate terminal window:
  ```bash
  docker-compose run app bundle exec rails db:setup
  ```

4. **Access the Application**
  The API will be available at:
  ```
  http://localhost:3000
  ```

## Running Tests

Run the test suite using:
```bash
docker-compose run app bundle exec rspec
```

## API Documentation

### Restaurant Endpoints

```bash
GET /restaurants                # List all restaurants
GET /restaurants/:id            # Get restaurant details
GET /restaurants/:id/menus      # Get menus for a restaurant
GET /restaurants/:id/menu_items # Get menu items for a restaurant
```

### Menu Endpoints

```bash
GET /menus # List all menus
```

### Menu Item Endpoints

```bash
GET /menus_items # List all menu items
```

### Import Functionality

```bash
POST /imports/restaurants # Import restaurant data from JSON file
```

Example using curl

```bash
curl -X POST "http://localhost:3000/imports/restaurants" \
  -H "Content-Type: application/json" \
  -d '@/Users/{user}/restaurants.json'
```

Example with Rails console

```ruby
# With JSON file
Imports::RestaurantImporter.call(File.open('spec/fixtures/restaurants.json'))

# With ruby hash
Imports::RestaurantImporter.call({
  restaurants: [
    {
      name: 'Restaurant Name',
      menus: [
        {
          name: 'Menu Name',
          menu_items: [
            { name: 'Menu Item 1', price: 10.0 },
            { name: 'Menu Item 2', price: 15.0 }
          ]
        }
      ]
    }
  ]
})
```
