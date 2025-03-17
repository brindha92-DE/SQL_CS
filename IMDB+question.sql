USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

show tables;

SELECT table_name, table_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';

/* 
ANSWER: 
We have  3867,14662,8234,26768,8230,15658 rows in director_mapping,genre,movie,names,ratings, and 
 role mapping tables respectively */






-- Q2. Which columns in the movie table have null values?
-- Type your code below:
desc movie;
SELECT
    COUNT(1) - COUNT(title) title_null_count,
    COUNT(1) - COUNT(year) year_null_count,
    COUNT(1) - COUNT(date_published) date_published_null_count,
    COUNT(1) - COUNT(country) country_null_count,
    COUNT(1) - COUNT(worlwide_gross_income) worlwide_gross_income_null_count,
    COUNT(1) - COUNT(languages) languages_null_count,
    COUNT(1) - COUNT(production_company) production_company_null_count
FROM movie;

-- There are NULL values in 4 columns - Country, Worlwide Gross, Languages, Production Company
/*
ANSWER:
-- We have 20,3724,194,528 null values in country,worlwide_gross_income,languages,
production_company columns
*/





-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Q3
SELECT 
    year, COUNT(*) AS number_of_movies
FROM
    movie
GROUP BY year;


SELECT 
    MONTH(date_published) AS month_num,
    COUNT(*) AS number_of_movies
FROM
    movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published);

/*
ANSWER:
3052,2944,2001 movies were released in 2017,2018 and 2019.
March month tops the list with 824 movies 
*/






/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(*) as Movie_count
FROM
    movie
WHERE
    (country LIKE '%India%'
        OR country LIKE '%USA%')
        AND year = 2019;

/*
ANSWER:
India and USA produced 1059 movies in total in the year of 2019
*/







/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    genre
FROM
    genre;

/*
ANSWER:
We have 13 distinct genre in total
*/








/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    g.genre, COUNT(*) AS Number_of_Movies
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY COUNT(*) DESC limit 1;


/*
ANSWER:
Drama genre has highest number of movies when compared to other genres - 4285
*/







/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH one_genre as 
(SELECT 
    COUNT(g.genre) as count, m.title
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY m.title)
SELECT 
    COUNT(*) as movie_count
FROM
    one_genre
WHERE
    count = 1;
    
    
/*
ANSWER:
3245 movies belong to only one genre.
*/    







/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT     genre,
           Avg(duration) AS avg_duration
FROM       movie                  AS m
INNER JOIN genre                  AS g
ON      g.movie_id = m.id
GROUP BY   genre
ORDER BY avg_duration DESC;
 /*
 ANSWER:
 Action has highest average duration with 112.88 followed by Romance & drama
 */
    

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     g.genre  AS genre,
           Count(*) AS movie_count,
           Rank() over (ORDER BY count(*) DESC) as genre_rank
FROM       genre g
INNER JOIN movie m
WHERE      m.id=g.movie_id
GROUP BY   g.genre
ORDER BY   count(*) DESC;




/*
Drama,Comedy and Thriller constitue the top 3 genre with 4285,2412,1484 movie_counts. 
Thriller is in the third rank
*/




/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;

/*
ANSWER:
Following are inferences got from the above query,
Min Avg Rating - 1
Max Avg Rating - 10
Min total votes - 100
Max total votes - 725138
Min Median Rating - 1
Max Median Rating - 10
*/



    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT     m.title      AS title,
           r.avg_rating AS avg_rating,
           Dense_rank() OVER (ORDER BY r.avg_rating DESC) as movie_rank
FROM       movie m
INNER JOIN ratings r
where      m.id=r.movie_id
ORDER BY   r.avg_rating DESC limit 10;

/*
ANSWER:
The top movies are Kirket,Love in Kilnerry,Gini Helida Kathe,Runam,Fan..
*/





/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT r.median_rating AS median_rating,
       Count(*)        AS movie_count
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
GROUP  BY r.median_rating
ORDER  BY r.median_rating;

/*
ANSWER:
Median Rating 7 has highest number of movie count with 2257 movies 
*/





/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company        AS production_company,
       Count(*)                    AS movie_count,
       Dense_rank()
         OVER (
           ORDER BY Count(*) DESC) AS prod_company_rank
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  r.avg_rating > 8 
AND m.production_company IS NOT NULL
GROUP  BY m.production_company
ORDER  BY Count(*) DESC; 

/*
ANSWER:
Dream warrior Pictures & National theatre live jointly share the First Rank 
followed by Marvel Studios
*/




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH mar_genre
     AS (SELECT m.id,
                m.title,
                g.genre,
                m.date_published
         FROM   movie m
                INNER JOIN genre g
                        ON m.id = g.movie_id
         WHERE  Month(m.date_published) = 3
                AND Year(m.date_published) = 2017 AND m.country like '%USA%' )
SELECT m.genre  AS genre,
       Count(*) AS movie_count
FROM   mar_genre m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  r.total_votes > 1000
GROUP  BY m.genre
ORDER  BY Count(*) DESC; 

/*
ANSWER:
Drama genre with 24 movies had highest number of movies released in USA in the year of 2017 and the month
of March
*/




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH the_titles
     AS (SELECT m.id,
                m.title,
                g.genre
         FROM   movie m
                INNER JOIN genre g
                        ON m.id = g.movie_id
         WHERE  m.title LIKE 'the%')
SELECT the.title,
       r.avg_rating AS avg_rating,
       the.genre
FROM   the_titles the
       INNER JOIN ratings r
               ON the.id = r.movie_id
WHERE  r.avg_rating > 8
ORDER  BY the.title; 

/*
15 movies(including duplicates start with title 'THE', however since many movies belong to multiple genres, 
8 movies unique movies start with the substring 'THE'
*/


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT Count(*)
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  ( m.date_published BETWEEN '2018-04-01' AND '2019-04-01' )
       AND r.median_rating = 8 ;

/*
ANSWER:
361 movies have median rating of 8 which were released between '2018-04-01' AND '2019-04-01'
*/





-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
/* Approach 1 - Using Languages Parameter */
SELECT sum(r.total_votes), m.languages
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE m.languages LIKE 'German' OR m.languages LIKE 'Italian'
GROUP BY m.languages
ORDER BY sum(r.total_votes) DESC; 

/* Approach 2 - Using Country as Parameter */

SELECT sum(r.total_votes), m.country
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE m.country = 'Germany' OR m.country = 'Italy'
GROUP BY m.country
ORDER BY sum(r.total_votes) DESC; 

/* 
ANSWER:
While using Approach 1, when using Language as parameter, italian language movies got more votes
than German language movies.
While using Approach 2, when using Country as Parameter, German movies got more votes than
Italian movies.
*/




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

desc names;

SELECT
    COUNT(1) - COUNT(name) name_null_count,
    COUNT(1) - COUNT(height) height_null_count,
    COUNT(1) - COUNT(date_of_birth) date_of_birth_null_count,
    COUNT(1) - COUNT(known_for_movies) known_for_movies_null_count
FROM names;

/* 
ANSWER:
There no null values in name column, 17335 null values in height, 13431 null values in date of birth
column, 15226 null values in known_for_movies column.
*/




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genres AS
(
           SELECT     genre,
                      Count(m.id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie                                  AS m
           INNER JOIN genre                                  AS g
           ON         g.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 )
SELECT     n.NAME            AS director_name ,
           Count(d.movie_id) AS movie_count
FROM       director_mapping  AS d
INNER JOIN genre G
using     (movie_id)
INNER JOIN names AS n
ON         n.id = d.name_id
INNER JOIN top_3_genres
using     (genre)
INNER JOIN ratings
using      (movie_id)
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 3 ;

/*
ANSWER:
James Mangold tops the list followed by Anthony Russo, & Soubin Shahir
*/


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name as Actor_Name,
       Count(r.median_rating) as Movie_count
FROM   movie m
       INNER JOIN role_mapping rm
               ON m.id = rm.movie_id
       INNER JOIN names n
               ON rm.name_id = n.id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  r.median_rating > 8
GROUP  BY n.name
ORDER  BY Count(r.median_rating) DESC
LIMIT  2; 

/*
ANSWER:
Mammootty and Mohanlal are the top two actors with movie count of 7 and 3 respectively
with more than 8 median rating.
*/





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     m.production_company                           AS production_company,
           Sum(r.total_votes)                             AS vote_count,
           Rank() OVER (ORDER BY Sum(r.total_votes) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id=r.movie_id
GROUP BY   m.production_company limit 3;


/*
ANSWER:
Marvel Studios, Twentieth Century Fox, Warner Bro's occupy the 1st,2nd,3rd rank
respectively
*/





/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



WITH top_actors
     AS (SELECT N.NAME
                AS
                actor_name,
                Sum(R.total_votes)
                AS
                   Total_votes,
                Count(R.movie_id)
                AS
                   movie_count,
                Round(Sum(R.avg_rating * R.total_votes) / Sum(R.total_votes), 2)
                AS
                actor_avg_rating
         FROM   movie AS M
                INNER JOIN ratings AS R
                        ON M.id = R.movie_id
                INNER JOIN role_mapping AS RM
                        ON M.id = RM.movie_id
                INNER JOIN names AS N
                        ON RM.name_id = N.id
         WHERE  category = 'ACTOR'
                AND country = "india"
         GROUP  BY actor_name
         HAVING movie_count >= 5)
SELECT actor_name,
       total_votes,
       movie_count,
       actor_avg_rating,
       Rank()
         OVER (
           ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM   top_actors; 

/*
ANSWER:
Vijay Sethupathi occupies the First Rank with 23114 votes, 5 Movies with a average rating
of 8.42 
*/


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_actress
     AS (SELECT N.NAME
                AS
                actress_name,
                Sum(R.total_votes)
                AS
                   Total_votes,
                Count(R.movie_id)
                AS
                   movie_count,
                Round(Sum(R.avg_rating * R.total_votes) / Sum(R.total_votes), 2)
                AS
                actress_avg_rating
         FROM   movie AS M
                INNER JOIN ratings AS R
                        ON M.id = R.movie_id
                INNER JOIN role_mapping AS RM
                        ON M.id = RM.movie_id
                INNER JOIN names AS N
                        ON RM.name_id = N.id
         WHERE  category = 'ACTRESS'
                AND languages = "Hindi"
         GROUP  BY actress_name
         HAVING movie_count >= 3)
SELECT *,
       Rank()
         OVER (
           ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM   top_actress; 

/*
ANSWER:
Tapsee Pannu is the top actress with 18061 total votes,  3 movie count with average 
rating of 7.74
*/






/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title,
       r.avg_rating,
       CASE
         WHEN avg_rating > 8 THEN 'Super Hit Movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit Movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch Movies'
         WHEN avg_rating < 5 THEN 'Flop Movies'
       END AS Category
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON g.movie_id = r.movie_id
WHERE  g.genre = 'Thriller'; 

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT g.genre,
		ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;







-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_genres AS
(
           SELECT     genre,
                      Count(m.id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie                                  AS m
           INNER JOIN genre                                  AS g
           ON         g.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 ), movie_summary AS
(
           SELECT     genre,
                      year,
                      title                                                                                                                                      AS movie_name,
                      Cast(Replace(Replace(Ifnull(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10))                                                     AS worlwide_gross_income ,
                      Dense_rank() OVER(partition BY year ORDER BY Cast(Replace(Replace(Ifnull(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10)) DESC ) AS movie_rank
           FROM       movie                                                                                                                                      AS m
           INNER JOIN genre                                                                                                                                      AS g
           ON         m.id = g.movie_id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top_genres))
SELECT *
FROM   movie_summary
WHERE  movie_rank <=5;

/*
ANSWER:
Star wars topped the list in the year of 2017, Avengers:Infinity war in 2018, Avengers
Endgame in 2019
*/
           




-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     m.production_company,
           Count(*)                             AS movie_count,
           Rank() over (ORDER BY count(*) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id=r.movie_id
WHERE      position(',' IN m.languages) > 0
AND        m.production_company IS NOT NULL
AND        r.median_rating >= 8
GROUP BY   m.production_company
ORDER BY   count(*) DESC
LIMIT      2;

/*
ANSWER:
Star Cinema & Twentieth Century Fox are the top production companies
*/



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT n.NAME,
       Sum(total_votes)                                              AS
       total_votes,
       Count(r.movie_id)                                             AS
       movie_count,
       Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes)) AS
       actress_avg_rating,
       Dense_rank()
         OVER (
           ORDER BY Count(r.movie_id) DESC, Round(Sum(r.avg_rating *
         r.total_votes) /
         Sum(r.total_votes)) DESC)                                   AS
       actress_rank
FROM   movie m
       INNER JOIN role_mapping rm
               ON m.id = rm.movie_id
       INNER JOIN names n
               ON rm.name_id = n.id
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  g.genre = 'Drama'
       AND rm.category = 'Actress'
       AND r.avg_rating > 8
GROUP  BY n.NAME
ORDER  BY movie_count DESC LIMIT 5; 

/* 
ANSWER:
Susan Brown,Amanda Lawrence, Denise Gough ,Parvathy Thiruvothu, Sangeetha Bhat share the first, 
second and Third Rank
*/





/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH next_date_published_summary AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping                                                                      AS d
           INNER JOIN names                                                                                 AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)               AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;

/*
ANSWER:
Top directors are Andrew Jones, AL Vijay, Sion Sono followed by other directors like 
Chris Stokes, Sam Liu etc.alter
*/



