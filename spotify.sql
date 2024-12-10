-- SQL Project Spotify
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

-- Exploratory data analysis
SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify where duration_min =0;

DELETE FROM spotify WHERE duration_min =0;

SELECT * FROM spotify where duration_min =0;

SELECT DISTINCT most_played_on FROM spotify;


--- Easy Level data analysis

-- Retrieve the names of all tracks that have more than 1 billion streams.

SELECT * FROM spotify
WHERE spotify.stream >1000000000;
--List all albums along with their respective artists.
SELECT DISTINCT album,artist 
FROM spotify
ORDER BY 1;

-- Get the total number of comments for tracks where licensed = TRUE.
SELECT count(comments) FROM spotify
where licensed = 'TRUE';

-- Find all tracks that belong to the album type single.
SELECT *
FROM spotify
WHERE album_type ILIKE 'single';

--Count the total number of tracks by each artist.
SELECT artist, count(*) as Artist_total_songs
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;

--Medium Level data analysis
--Calculate the average danceability of tracks in each album.
SELECT 
	spotify.album,
	avg(danceability) as averagedanceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;

--Find the top 5 tracks with the highest energy values.
SELECT track,max(energy) 
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
--List all tracks along with their views and likes where official_video = TRUE.
SELECT track,
	SUM(views) AS totalviews,
	SUM(likes) AS totallikes
FROM spotify
WHERE official_video = TRUE
GROUP BY 1
ORDER BY 2 DESC;

--For each album, calculate the total views of all associated tracks.
SELECT album,track, SUM(views) AS totalviews
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC;
--Retrieve the track names that have been streamed on Spotify more than YouTube
SELECT * FROM
(SELECT
	track,
	-- most_played_on,
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) AS streamed_on_youtube,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) AS streamed_on_spotify	
FROM spotify
GROUP BY 1
) AS t1
WHERE streamed_on_spotify >streamed_on_youtube
	AND
	streamed_on_spotify<>0
-- Advanced Level Data analysis
-- Find the top 3 most-viewed tracks for each artist using window functions.
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

-- Write a query to find tracks where the liveness score is above the average.
SELECT track,artist,liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness)FROM spotify)
-- Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
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