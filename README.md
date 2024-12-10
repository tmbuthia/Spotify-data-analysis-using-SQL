![spotify_logo](https://github.com/user-attachments/assets/28d48f60-b1a6-4069-9e9d-acf8921df85b)
Overview
This project involves analyzing a Spotify dataset with detailed attributes about tracks, albums, and artists using SQL. It includes the entire process from understanding and cleaning the dataset to writing and optimizing SQL queries of varying complexities. By exploring artist metrics, track popularity, and platform trends, the project demonstrates how SQL can be used to uncover meaningful insights from raw data while improving query performance.

Project Steps
1. Data Exploration
The initial step was to understand the dataset, which contains the following attributes:

Artist: Name of the track performer.
Track: Title of the song.
Album: The collection the track belongs to.
Album Type: Format of the album (e.g., single, album).
Metrics:
Danceability: How suitable the track is for dancing.
Energy: Intensity and activity level of the track.
Tempo: Beats per minute (BPM) of the track.
Liveness: Likelihood of the track being performed live.
Streaming Platforms: Track performance metrics on Spotify and YouTube, including views, streams, likes, and comments.
2. Data Cleaning
Removed invalid records, such as tracks with a duration_min of 0.
Verified the dataset to ensure completeness and accuracy before analysis.
3. Data Modeling
A normalized table structure was created for efficient storage and querying:

```sql
 SQL Project Spotify
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```
4. Querying the Data
SQL queries were categorized into three levels to progressively enhance SQL skills:

## Easy Queries
````
  Retrieve the names of all tracks that have more than 1 billion streams.
  Get the total number of comments for tracks where licensed = TRUE.
  Find all tracks that belong to the album type single.
  Count the total number of tracks by each artist.
````
## Medium Queries
````
  Calculate average danceability for tracks in each album.
  Identify the top 5 tracks with the highest energy values.
  List all tracks along with their views and likes where official_video = TRUE
  For each album, calculate the total views of all associated tracks.
  Retrieve the track names that have been streamed on Spotify more than YouTube
````
## Advanced Queries
````
  Find the top 3 most-viewed tracks for each artist using window functions.
  CTEs: Calculate energy differences between tracks in albums.
  Subqueries: Find tracks with above-average liveness scores.
````
5. Query Optimization
After running advanced queries, performance was further improved using optimization techniques:

  1. Indexing: Added indexes on frequently queried columns like artist and track.
  2. Query Execution Plan: Used EXPLAIN ANALYZE to identify and refine performance bottlenecks.
  3. Optimization Example: Improved the CTE query for energy difference calculations
```sql
Find the top 3 most-viewed tracks for each artist using window functions.
-- first find each artists and total view for each track
-- track with highest view for each artist(we need top)
-- dense rank
-- cte and filter rank

WITH ranking_artist AS
(SELECT 
	artist,
	track,
	SUM(views) AS totalviews,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC)AS rank
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_artist
WHERE RANK<=3
````

```sql
Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH CTE
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energy
FROM spotify
GROUP BY 1
)
SELECT album,highest_energy -lowest_energy AS energy_diff
FROM cte
ORDER BY 2 DESC
````
