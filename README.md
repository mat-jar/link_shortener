# Mat-Links (link shortener app)
## tl;dr
- https://mat-links.fly.dev (deployed to Fly.io)
- Ruby on Rails API-only + JSON
- PostgreSQL + db uniqueness constraint + belongs_to/has_many
- Rspec, request tests, factory, faker, shared context
- url validation with URI module
- user registration and login: jwt, bcrypt, has_secure_password
- service objects
- redirect with OG Tags (response.body)
- scrape OG Tags from source page: httparty, selenium-webdriver, nokogiri
- dotenv-rails

## About
Mat-Links (link shortener app) provides a simple api service to shorten links sent via http requests. It accepts and renders data in JSON format. It allows users to register and login. Authenticated user can manage their account and create/update/list/view/delete their short links. An authorised request with a valid url is responded with a shortened link consisting of the host address and a slug (eg. https://mat-links.fly.dev/slug).

User can provide OG Tags in a separate request or scrape them from original source (yet not all pages allow scraping with headless browser - https://www.filmweb.pl/ entries should work fine). App records date of the last link use and number of uses ("usage counter").

Requests are authorised with JWT, see [Authorization](#authorization) for details.  

## Endpoints Schema

Endpoints beginning: `https://mat-links.fly.dev/api/v1`

For example: `https://mat-links.fly.dev/api/v1/login` </br> or `https://mat-links.fly.dev/api/v1/short_links/show`

### User registration, login and account management endpoints:

URL / ENDPOINT    |    VERB    |    DESCRIPTION   
----------------- | ---------- | --------------
[/login](#post-login)            |    POST    | Generate token
[/users](#post-users)            |    POST    | Register user      
[/users](#get-users)           |    GET     | Return all users
[/users/show](#get-usersshow)       |    GET     | Return user details      
[/users](#put-users)            |    PUT     | Update user      
[/users](#delete-users)            |   DELETE   | Destroy user   


### Short links creation and management endpoints:

URL / ENDPOINT             |    VERB    |    DESCRIPTION   
-------------------------- | ---------- | --------------
[/short_links](#post-short_links)               |    POST    | Create new short link
[/short_links](#get-short_links)               |    GET     | Return all short links   
[/short_links](#put-short_links)               |    PUT     | Update short link
[/short_links](#delete-short_links)               |   DELETE   | Destroy short link
[/short_links/show](#post-short_linksshow)          |    POST    | Return short link details
[/short_links/fetch_og_tags](#post-short_linksfetch_og_tags) |    POST    | Scrape OG Tags from source page  

### Authorization

All requests must contain JWT except for user registration and user login. In order to be authorised a request must contain 'Authorization' header with the JWT obtained upon successful login (with or without the Bearer schema).

## Endpoints Detailed description

#### POST /login
```
POST https://mat-links.fly.dev/api/v1/login
```
Logs in already registered user, requires email and password as params, returns JWT and expiry date. No other params accepted, JWT is not required.
```
{
  "user": {
    "email": "new@email.com",
    "password": "secret_password"
  }
}
```

#### POST /users
```
POST https://mat-links.fly.dev/api/v1/users
```
Registers new user, requires email and password as params, returns user id, email and creation date. No other params accepted, JWT is not required.
```
{
  "user": {
    "email": "new@email.com",
    "password": "secret_password"
  }
}
```

#### GET /users
```
GET https://mat-links.fly.dev/api/v1//users
```
Lists all registered users (complete records). JWT is required.

#### GET /users/show
```
GET https://mat-links.fly.dev/api/v1/users/show
```
Shows details of a specific user identified with JWT. Includes all short links that belong to the user. JWT is required.

#### PUT /users
```
PUT https://mat-links.fly.dev/api/v1/users
```
Edits user details, accepts email and password as params. Returns user id, email, creation date and update date. User is identified with JWT, JWT is required.
```
{
  "user": {
    "email": "updated@email.com",
    "password": "updated_secret_password"
  }
}
```

#### DELETE /users
```
DELETE https://mat-links.fly.dev/api/v1/users
```
Deletes user record. User is identified with JWT, JWT is required.

#### POST /short_links
```
POST https://mat-links.fly.dev/api/v1/short_links
```
Creates a new short link, requires original_url and accepts slug and og_tags as params. A given original_url must be a valid URL (starting with either "https://" or "https://"). A slug must consist from letters only, they can be both capital and lowercase, substrings can be separated with hyphens.

When slug is not provided it will be generated randomly, composed of 8 letters, both capital and lowercase, no special or numeric characters. Returns original_url, ready to use short_url and og_tags. JWT is required.
```
{
  "new_short_link": {
    "original_url": "https://www.filmweb.pl/ranking/film",
    "slug": "films"
  }
}
```
```
{
  "new_short_link": {
    "original_url": "https://www.filmweb.pl/ranking/film"
  },
  "og_tags": {
    "og:title": "Page Title",
    "og:type": "video:movie"
  }
}
```

#### GET /short_links
```
GET https://mat-links.fly.dev/api/v1/short_links
```
Lists all short links that belong to a user identified with JWT. Returns full records. JWT is required.
#### PUT /short_links
```
PUT https://mat-links.fly.dev/api/v1/short_links
```
Edits existing short link. Params with "short_link" key are used to identify desired short link (one of original_url, short_url or slug is needed). Params with "update_short_link" are used as attributes of an updated record.

A given original_url must be a valid URL (starting with either "https://" or "https://"). A slug must consist from letters only, they can be both capital and lowercase, substrings can be separated with hyphens. Original_url, slug and og_tags are accepted.  JWT is required.
```
{
  "short_link": {
    "slug": "films"
  },
  "update_short_link": {
    "original_url": "https://www.updated.filmweb.pl/ranking/film",
    "slug": "updated-films"
  }
}
```
```
{
  "short_link": {
    "original_url": "https://www.filmweb.pl/ranking/film"
  },
  "og_tags": {
    "og:title": "Page Title",
    "og:type": "video:movie"
  }
}
```
```
{
  "short_link": {
    "short_url": "https://mat-links.fly.dev/filmy",
  },
  "update_short_link": {
    "slug": "updated-slug"
  }
}
```
#### DELETE /short_links
```
DELETE https://mat-links.fly.dev/api/v1/short_links
```
Deletes existing short link. Params with "short_link" key are used to identify desired short link (one of original_url, short_url or slug is needed). JWT is required.
```
{
  "short_link": {
    "original_url": "https://www.filmweb.pl/ranking/film"
  }
}
```
```
{
  "short_link": {
    "slug": "filmy",
  }
}
```
```
{
  "short_link": {
    "short_url": "https://mat-links.fly.dev/filmy",
  }
}
```
#### POST /short_links/show
```
POST https://mat-links.fly.dev/api/v1/short_links/show
```
Shows short link's details. Params with "short_link" key are used to identify desired short link (one of original_url, short_url or slug is needed). Returns full short link record with short_url, formatted last use date and og_tags. JWT is required.
```
{
  "short_link": {
    "original_url": "https://www.filmweb.pl/ranking/film",
  }
}
```
```
{
  "short_link": {
    "slug": "filmy",
  }
}
```
```
{
  "short_link": {
    "short_url": "https://mat-links.fly.dev/filmy",
  }
}
```

#### POST /short_links/fetch_og_tags
```
POST https://mat-links.fly.dev/api/v1/short_links/fetch_og_tags
```
Scrapes original OG Tags from source page. Uses HTTParty and Selenium to fetch the html document and Nokogiri to parse it. Uses headless mode and since some webpages black access for headless browsers, scraping is sometimes impossible.

Params with "short_link" key are used to identify desired short link (one of original_url, short_url or slug is needed). Returns original_url, ready to use short_url and og_tags. JWT is required.
```
{
  "short_link": {
    "original_url": "https://www.filmweb.pl/ranking/film",
  }
}
```
```
{
  "short_link": {
    "slug": "filmy",
  }
}
```
```
{
  "short_link": {
    "short_url": "https://mat-links.fly.dev/filmy",
  }
}
```
