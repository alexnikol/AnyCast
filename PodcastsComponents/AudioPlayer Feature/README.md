# **Episode Show, Play, Save, Delete, Show Plaing item**

## **(BDD) Play audio by Spec**
### Story: Client requests to show, play, save to cache for offline usage, delete from cache for offline usage, showing current playing episode

### Narrative #1

```
As a client
I want the app shows episode screen and plays by request
```

#### Scenarios (Acceptance criteria)

```
Given the client has connectivity
When the client requests to select episode
Then the app should open player
 And display episode data
 And show if episode is saved or not


Given the client has connectivity
 And saved episode in cache
When the client requests to play episode
Then the app should play an episode from the cache
 And show the current playing episode


Given the client doesn't have connectivity
 And there’s a cached version of the episode
When the client requests to play episode
Then the app should play an episode from the cache
 And show the current playing episode


Given the client doesn't have connectivity
 And the cache is empty
When the client requests to play episode
Then the app should display error state with no connectivity


Given the client plays episode
 And close the app
When the client opens the app
Then the app should show last played episode


Given the client has empty saved episodes list
When the client requests to save episode
Then the app should save and display episode in saved episodes section


Given the client has empty saved episodes list
When the client requests to see saved episodes
Then the app should display no saved items


Given the client has non empty saved episodes list
When the client requests to see saved episodes
Then the app should display saved items in saved episodes section


Given the client has non empty saved episodes list
When the client requests to see remove saved episode
Then the app should display updated items without removed episode in saved episodes section
```
---
## **Use Cases**

### Play Episode from remote server by url

#### Data:
- Episode Model

#### Primary course (happy path):
1. Execute "Play Episode by selected Episode item from list" command with above data.
2. System start playing episode.
3. System saves episode in "Current Playing Episode Storage" if episode started to play.
4. System notifies clients that "Current Playing Episode" changed.
4. System notifies clients that "Current Playing Episode" state changed.

#### Invalid episode – error course (sad path):
1. System notifies clients that "Current Playing Episode" not exist.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.
2. System notifies clients that "Current Playing Episode" not exist.

---

### Load Episode Cache Item From Cache Use Case

#### Primary course:
1. Execute "Load Episode Cache Item by ID" command with above data.
2. System retrieves episode with audio from cache.
3. System creates Episode Cache Item from cached data.
4. System delivers Episode Cache Item.

#### Retrieval error course (sad path):
1. System delivers error.

#### Empty cache course (sad path): 
1. System delivers no Episode Cache Item.

---

### Save Episode with its audio data for offline usage Use Case

#### Data:
- Episode model

#### Primary course (happy path):
1. Execute "Save Episode with audio data to Cache" command with above data.
2. System deletes old data.
3. System encodes Episode.
4. System timestamps the new cache.
5. System saves new cache data.
6. System delivers success message.

#### Deleting error course (sad path):
1. System delivers error.

#### Saving error course (sad path):
1. System delivers error.

---

### Remove Episode from cache with its audio data Use Case 
 
#### Primary course (happy path):
1. Execute "Remote Episode with audio data by ID" command with above data.
2. System deletes cache.
3. System delivers success message.

#### Deleting error course (sad path):
1. System delivers error.
 
---

### Save episode playback progress Use Case 
 
#### Data:
- PlayingItem Model
 
#### Primary course (happy path):
1. Execute "Save PlayingItem playback progress" command with above data.
2. System deletes old data.
3. System encodes PlayingItem.
4. System timestamps the new cache.
5. System saves new cache data.
6. System delivers success message.

#### Deleting error course (sad path):
1. System delivers error.

#### Saving error course (sad path):
1. System delivers error.
 
---
