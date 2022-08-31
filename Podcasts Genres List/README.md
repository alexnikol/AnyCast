# **Shows genres list feature**

## High level architecture diagram

![Architecture diagram](Genres%20List%20UI/main.drawio.svg)

## **(BDD) Show genres list Spec**
### Story: Client requests to see Podcasts Genres list

### Narrative #1

```
As a client
I want the app shows podcasts genres list
```

#### Scenarios (Acceptance criteria)

```
Given the client has connectivity
  And the cache is empty
 When the client requests to see the genres list
 Then the app should fetch and display genres list from remote server


 Given the client has connectivity
  And there’s a cached version of the genres list
  And the cache is less than 7 days old
 When the client requests to see the genres list
 Then the app should display the latest cached genres list


Given the client has connectivity
  And there’s a cached version of the genres list
  And the cache is 7 days old or more
 When the client requests to see the genres list
 Then the app should fetch and display genres list from remote server


Given the client doesn't have connectivity
  And there’s a cached version of the genres list
  And the cache is less than 7 days old
 When the client requests to see genres list
 Then the app should display the latest cached genres list


Given the client doesn't have connectivity
  And there’s a cached version of the genres list
  And the cache is 7 days old or more
 When the client requests to see the genres list
 Then the app should display an error message


Given the client doesn't have connectivity
  And the cache is empty
 When the client requests to see the genres list
 Then the app should display an error message
```
---
## **Use Cases**

### Load Genres list From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Genres list" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates Genres list from valid data.
5. System delivers Genres list.

#### Invalid data – error course (sad path):
1. System will retry 2 times.
2. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load Genres list From Cache Use Case

#### Primary course:
1. Execute "Load Genres list" command with above data.
2. System retrieves featured question data from cache.
3. System validates cache is less than 7 days old.
4. System creates Genres list from cached data.
5. System delivers Genres list.

#### Retrieval error course (sad path):
1. System delivers error.

#### Expired cache course (sad path): 
1. System delivers no Genres list.

#### Empty cache course (sad path): 
1. System delivers no Genres list.

---

### Validate featured Genres list Cache Use Case

#### Primary course:
1. Execute "Validate Cache" command with above data.
2. System retrieves Genres list data from cache.
3. System validates cache is less than 7 days old.

#### Retrieval error course (sad path):
1. System deletes cache.

#### Expired cache course (sad path): 
1. System deletes cache.

---

### Cache Genres list Data Use Case

#### Data:
- featured Genres list Data

#### Primary course (happy path):
1. Execute "Genres list Data" command with above data.
2. System caches news data.
3. System delivers success message.

#### Saving error course (sad path):
1. System delivers error.

---

## Model Specs

### Remote Podcast Genre Model

| Property      | Type                     |
|---------------|--------------------------|
| `id`          | `Int`                    |
| `name`        | `String`			           |

### Payload contract

```
GET /api/v2/genres

200 RESPONSE

{
    "genres": [
        {
            "id": 144,
            "name": "Personal Finance",
        },
        {
            "id": 151,
            "name": "Locally Focused",
        },
        ...
    ]
}
```
---

## UI Specs

The genres list feature should deliver Podcast Genres model with a specific color value for each genre item.
The list of available colors should be specific for each application that uses this feature.

![Podcasts Genres List UI](Genres%20List%20UI/podcasts-genres-ui-iphone-light.png) ![Podcasts Genres List UI](Genres%20List%20UI/podcasts-genres-ui-iphone-dark.png)
