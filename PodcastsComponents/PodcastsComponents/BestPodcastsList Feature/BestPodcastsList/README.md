# **Shows best podcasts by genre list feature**

## **(BDD) Show podcasts by genre Spec**
### Story: Client requests to see Podcasts by Genre list

### Narrative #1

```
As a client
I want the app shows best podcasts list by selected genre
```

#### Scenarios (Acceptance criteria)

```
Given the client has connectivity
  And the cache is empty
 When the client requests to see the podcasts list
 Then the app should fetch and display podcasts list from remote server


 Given the client has connectivity
  And there’s a cached version of the podcasts list
  And the cache is less than 7 days old
 When the client requests to see the podcasts list
 Then the app should fetch and display podcasts list from remote server


Given the client doesn't have connectivity
  And there’s a cached version of the podcasts list
  And the cache is less than 7 days old
 When the client requests to see podcasts list
 Then the app should display the latest cached podcasts list


Given the client doesn't have connectivity
  And there’s a cached version of the podcasts list
  And the cache is 7 days old or more
 When the client requests to see the podcasts list
 Then the app should display an empty list


Given the client doesn't have connectivity
  And the cache is empty
 When the client requests to see the podcasts list
 Then the app should display an empty list
```
---
## **Use Cases**

### Load Podcasts by Genre From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Podcasts by Genre" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates Podcasts list from valid data.
5. System delivers Podcasts list.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

### Load Podcasts Thumbnail Image Data From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Podcasts Thumbnail Image Data" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
5. System delivers image data.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load Podcasts list From Cache Use Case

#### Data:
- Max age (7 days)

#### Primary course:
1. Execute "Load Podcasts by Genre" command with above data.
2. System retrieves postcasts list data from cache.
3. System validates cache is less than 7 days old.
4. System creates Podcasts list from cached data.
5. System delivers Podcasts list.

#### Retrieval error course (sad path):
1 . System delivers error.

#### Expired cache course (sad path): 
1. System delivers no Podcasts list.

#### Empty cache course (sad path): 
1. System delivers no Podcasts list.

---

### Load Podcasts Thumbnail Image Data From Cache Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Podcasts Thumbnail Image" command with above data.
2. System retrieves data from the cache.
3. System delivers cached image data.

#### Cancel course:
1. System does not deliver image data nor error.

#### Retrieval error course (sad path):
1. System delivers error.

#### Empty cache course (sad path):
1. System delivers not found error.

---

### Validate Podcasts list Cache Use Case

#### Primary course:
1. Execute "Validate Cache" command with above data.
2. System retrieves Podcasts list data from cache.
3. System validates cache is less than 7 days old.

#### Retrieval error course (sad path):
1. System deletes cache.

#### Expired cache course (sad path): 
1. System deletes cache.

---

### Cache Podcasts list Data Use Case

#### Data:
- Podcasts list

#### Primary course (happy path):
1. Execute "Save Podcasts list" command with above data.
2. System deletes old data.
3. System encodes Podcasts list.
4. System timestamps the new cache.
5. System saves new cache data.
6. System delivers success message.

#### Deleting error course (sad path):
1. System delivers error.

#### Saving error course (sad path):
1. System delivers error.
 
---

## Model Specs

### Remote Podcasts Genre Model

#### Podcasts by Genre Object
| Property      | Type                     |
|---------------|--------------------------|
| `id`          | `Int`, (Genre id)        |
| `name`        | `String` (Genre name)    |
| `pocasts`        | `Array<Podcast>`      |

#### Podcast Object
| Property      | Type                     |
|---------------|--------------------------|
| `id`          | `String`                 |
| `title`       | `String`			       |
| `image`       | `String`			       |

### Payload contract

```
GET /api/v2/best_podcasts

200 RESPONSE

{
  "id": 93,
  "name": "Business",
  "podcasts": [
    {
      "id": "5f237b79824e4dfb8355f6dff9b1c542",
      "image": "https://production.listennotes.com/podcasts/the-indicator-from-planet-money-npr-fw5ISgUVsYh-G2EDjFO-TLA.1400x1400.jpg",
      "title": "The Indicator from Planet Money"
    },
    {
      "id": "34beae8ad8fd4b299196f413b8270a30",
      "image": "https://production.listennotes.com/podcasts/worklife-with-adam-grant-ted-KgaXjFPEoVc.1400x1400.jpg",
      "title": "WorkLife with Adam Grant"
    }
  ]
}
```
---
