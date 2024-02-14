-- DELETE DUPLICATES
CREATE TABLE temp_tweets AS
SELECT DISTINCT ON ("Username", "Tweets", "Date") *
FROM tweets
ORDER BY "Username", "Tweets", "Date"

DROP TABLE tweets
ALTER TABLE temp_tweets RENAME TO tweets

--- EXTRACTING HASHTAGS FROM TWEETS
SELECT *
FROM tweets


SELECT 
    *,
    (REGEXP_MATCHES("Tweets", '#(\w+)', 'g'))[1] AS hashtag
FROM 
    tweets;

ALTER TABLE tweets
ADD COLUMN hashtag TEXT

UPDATE tweets
SET hashtag = SUBSTRING("Tweets" FROM '#\w+');

SELECT *
FROM tweets
WHERE hashtag LIKE '#%'

--- Most Popular Hashtags

SELECT hashtag, COUNT (hashtag)
FROM tweets
GROUP by hashtag
ORDER BY COUNT (hashtag) DESC

SELECT *
FROM tweets

--- Word Cloud

SELECT
    word,
    COUNT(*) AS frequency
FROM
    (
        SELECT
            REGEXP_REPLACE(LOWER(regexp_split_to_table(tweets."Tweets", '\s+')), '[^\w]+', '', 'g') AS word
        FROM
            tweets
    ) AS split_words
WHERE
    word <> ''
    AND word NOT IN ('de', 'que', 'la', 'y', 'no', 'en', 'para', 'con', 'los', 'las', 'a', 'por', 'para', 'se', 'ello', 'eso', 'se', 'ser', 'hay', 'has', 'was', 'were', 'no', 'si', 'el', 'es', 'un', 'del', 'al', 'como', 'una', 'le', 'pero', 'q', 'te', 'su', 'mas', 'son', 'me', 'quien', 'va')
GROUP BY
    word
ORDER BY
    frequency DESC
LIMIT 500;
