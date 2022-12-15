# **Search Content**

## **(BDD) Show search content Spec**
### Story: Client requests to see searched content

### Narrative #1

```
As a client
I want the app shows searched content by text
```

#### Scenarios (Acceptance criteria)

```
Given the client has connectivity
When the client requests to see search content by text
Then the app should fetch and display search result list from remote server


Given the client doesn't have connectivity
Then the app should display an error message
```
---

## **Use Cases**

### Load Searched Content From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Search content" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates Search content result from valid data.
5. System delivers Search content result.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

## Model Specs

### Remote `SearchContentResult` Model

| Property         | Type                                 |
|------------------|--------------------------------------|
| `terms`          | `[String]`                           |
| `genres`         | `[Genre]`, from `PodcastsGenresList` |
| `podcasts`       | `PodcastSearchResult`                |

### Remote `PodcastSearchResult` Model

| Property               | Type                                 |
|------------------------|--------------------------------------|
| `id`                   | `String`                             |
| `image`                | `URL`                                |
| `thumbnail`            | `URL`                                |
| `title_original`       | `String`                             |
| `publisher_original`   | `String`                             |


### Payload contract

```
GET /api/v2/genres

200 RESPONSE

{
  "terms": [
    "star wars"
  ],
  "genres": [
    {
      "id": 160,
      "name": "Star Wars",
      "parent_id": 68
    }
  ],
  "podcasts": [
    {
      "id": "ca3b35271db04291ba56fab8a4f731e4",
      "image": "https://production.listennotes.com/podcasts/rebel-force-radio-star-wars-podcast-star-wars-GSQTPOZCqAx-4v5pRaEg1Ub.1400x1400.jpg",
      "thumbnail": "https://production.listennotes.com/podcasts/rebel-force-radio-star-wars-podcast-star-wars-Na1ogntxKO_-4v5pRaEg1Ub.300x300.jpg",
      "title_original": "Rebel Force Radio: Star Wars Podcast",
      "explicit_content": false,
      "title_highlighted": "Rebel Force Radio: <span class=\"ln-search-highlight\">Star</span> <span class=\"ln-search-highlight\">Wars</span> Podcast",
      "publisher_original": "Star Wars",
      "publisher_highlighted": "<span class=\"ln-search-highlight\">Star</span> <span class=\"ln-search-highlight\">Wars</span>"
    },
    {
      "id": "8e90b8f0c9eb4c11b13f9dc331ed747c",
      "image": "https://production.listennotes.com/podcasts/inside-star-wars-wondery-F8ZBEqObITM-e8ydUYnAOJv.1400x1400.jpg",
      "thumbnail": "https://production.listennotes.com/podcasts/inside-star-wars-wondery-2Ep_n06B8ad-e8ydUYnAOJv.300x300.jpg",
      "title_original": "Inside Star Wars",
      "explicit_content": false,
      "title_highlighted": "Inside <span class=\"ln-search-highlight\">Star</span> <span class=\"ln-search-highlight\">Wars</span>",
      "publisher_original": "Wondery",
      "publisher_highlighted": "Wondery"
    }
  ]
}
```
---
