#final project stored_procedures

/**
	Genre
*/ 

# Stored procedure to list Movies with all the genres 
delimiter //
DROP PROCEDURE IF EXISTS ListMovieswithGenres // 
CREATE PROCEDURE ListMovieswithGenres()
	BEGIN
	SELECT DISTINCT m.Title, g.genre_name
	FROM Movies as m, Has_Genre as h, Genres as g
	WHERE m.MovieID = h.MovieID and h.genreID = g.genreID;
	END //
delimiter ;


# Stored procedure to List Genres of the input Movie
delimiter //
DROP PROCEDURE IF EXISTS ListGenre //
CREATE PROCEDURE ListGenre(IN movie VARCHAR(255))
	BEGIN
	IF EXISTS(SELECT REPLACE(REPLACE(REPLACE(REPLACE(m.Title, '"', ''), '.', ''), '\'', ''), '_', '') AS cna 
	FROM Movies as m HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(movie, '"', ''), '.', ''), '\'', ''), '_', '')),'%'))
	THEN SELECT DISTINCT m.Title, g.Genre_name FROM Movies as m, Genres as g, Has_Genre as h 
	WHERE m.MovieID = h.MovieID and h.genreID = g.genreID and m.Title in 
	(SELECT REPLACE(REPLACE(REPLACE(REPLACE(m.Title, '"', ''), '.', ''), '\'', ''),'_', '') AS cna 
	FROM Movies as m HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(movie, '"', ''), '.', ''), '\'', ''), '_', '')),'%'));
	ELSE SELECT 'ERROR: No such movie exists in the database' AS 'Result';
	END IF;
	END //
delimiter ;

# Stored procedure to list movies of the genre 
delimiter //
DROP PROCEDURE IF EXISTS MovieswithGenre //
CREATE PROCEDURE MovieswithGenre(IN genre VARCHAR(255))
	BEGIN
	IF EXISTS(SELECT g.genreId FROM Genres as g WHERE g.genre_name = genre)
	THEN SELECT m.title FROM Movies as m, Genres as g, Has_Genre as h 
	WHERE m.movieId = h.movieId and h.genreId = g.genreId and g.genre_name = genre;
	ELSE SELECT 'ERROR: No such genre exists' AS 'Result';
	END IF;
	END //
delimiter ; 

# Stored procedure to List the names of all the movies that are cross-listed between the following 2 genres
delimiter //
DROP PROCEDURE IF EXISTS Crosslisted //
CREATE PROCEDURE Crosslisted (In genre1 VARCHAR(10), genre2 VARCHAR(10))
	BEGIN
	IF EXISTS(SELECT g.genreID, g2.genreID FROM Genres as g, Genres as g2 WHERE genre1 = g.Genre_name or genre2 = g2.Genre_name) 
	THEN SELECT m.Title FROM Movies as m, Has_genre as h, Has_genre as h2,
	(SELECT g.genreID as g1, g2.genreID as g2 FROM Genres as g, Genres as g2 WHERE g.Genre_name = genre1 and g2.Genre_name = genre2) as g 
	WHERE h.genreID = g.g1 and h2.genreID = g.g2 and h.MovieID = h2.MovieID and h.MovieID = m.MovieID;
	ELSE SELECT 'ERROR: No such movie cross-listed with two genres' AS 'Result';
	END IF;
	END//
delimiter ;



/**
	Tags 
*/

# Stored procedure to list all the tags of all Movies 
delimiter //
DROP PROCEDURE IF EXISTS ListMovieswithTag // 
CREATE PROCEDURE ListMovieswithTag()
	BEGIN
	SELECT DISTINCT m.Title, t.Tag 
	FROM Movies as m, User_Tags as t
	WHERE m.MovieID = t.MovieID;
	END //
delimiter ;

# Stored procedure to print the related tags of the input Movie
delimiter //
DROP PROCEDURE IF EXISTS ListTags //
CREATE PROCEDURE ListTags(IN movie VARCHAR(255))
	BEGIN
	IF EXISTS(SELECT REPLACE(REPLACE(REPLACE(REPLACE(m.Title, '"', ''), '.', ''), '\'', ''), '_', '') AS cna 
	FROM Movies as m HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(movie, '"', ''), '.', ''), '\'', ''), '_', '')),'%'))
	THEN SELECT DISTINCT m.Title, t.Tag FROM Movies as m, User_Tags as t
	WHERE t.MovieID = m.MovieID and m.Title in 
	(SELECT REPLACE(REPLACE(REPLACE(REPLACE(m.Title, '"', ''), '.', ''), '\'', ''), '_', '') AS cna 
	FROM Movies as m HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(movie, '"', ''), '.', ''), '\'', ''), '_', '')),'%'));
	ELSE SELECT 'ERROR: No such movie exists in the database' AS 'Result';
	END IF;
	END //
delimiter ;

# Stored procedure to print the number of related tags of the input Movie
delimiter // 
DROP PROCEDURE IF EXISTS numTags //
CREATE PROCEDURE numTags(IN movie VARCHAR(255))
	BEGIN
	IF EXISTS(SELECT REPLACE(REPLACE(REPLACE(REPLACE(m.Title, '"', ''), '.', ''), '\'', ''), '_', '') AS cna 
	FROM Movies as m HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(movie, '"', ''), '.', ''), '\'', ''), '_', '')),'%'))
	THEN SELECT m.Title, count(t.Tag) FROM Movies as m, User_Tags as t
	WHERE t.MovieID = m.MovieID and m.Title in 
	(SELECT REPLACE(REPLACE(REPLACE(REPLACE(m.Title, '"', ''), '.', ''), '\'', ''), '_', '') AS cna 
	FROM Movies as m HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(movie, '"', ''), '.', ''), '\'', ''), '_', '')),'%'))
	GROUP BY m.movieId;
	ELSE SELECT 'ERROR: No such movie exists in the database' AS 'Result';
	END IF;
	END //
delimiter ; 

# Stored procedure to print the most popular tag of the input movie 
delimiter // 
DROP PROCEDURE IF EXISTS popularTag //
CREATE PROCEDURE popularTag(IN movie VARCHAR(255))
	BEGIN
	IF EXISTS(SELECT REPLACE(REPLACE(REPLACE(REPLACE(m.Title, '"', ''), '.', ''), '\'', ''), '_', '') AS cna 
	FROM Movies as m HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(movie, '"', ''), '.', ''), '\'', ''), '_', '')),'%'))

	THEN SELECT t.tag, COUNT(t.tagID) as cnt 
	FROM User_Tags as t, Movies as m
	WHERE t.MovieID = m.MovieID and m.Title in 
	(SELECT REPLACE(REPLACE(REPLACE(REPLACE(m.Title, '"', ''), '.', ''), '\'', ''), '_', '') AS cna 
	FROM Movies as m HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(movie, '"', ''), '.', ''), '\'', ''), '_', '')),'%'))
	GROUP BY t.tag
	ORDER BY cnt DESC LIMIT 1 ;
	ELSE SELECT 'ERROR: No such movie exists in the database' AS 'Result';
	END IF;
	END //
delimiter ; 

# Stored procedure to print all the movies with the input tag 
delimiter //
DROP PROCEDURE IF EXISTS MoviewithTags //
CREATE PROCEDURE MoviewithTags(In tag VARCHAR(255))
	BEGIN
	IF EXISTS(SELECT REPLACE(REPLACE(REPLACE(REPLACE(t.Tag, '"', ''), '.', ''), '\'', ''), '_', '') AS cna 
	FROM User_Tags as t HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(tag, '"', ''), '.', ''), '\'', ''), '_', '')),'%'))

	THEN SELECT DISTINCT m.Title
	FROM User_Tags as t, Movies as m
	WHERE t.MovieID = m.MovieID and t.Tag in 
	(SELECT REPLACE(REPLACE(REPLACE(REPLACE(t.Tag, '"', ''), '.', ''), '\'', ''), '_', '') AS cna 
	FROM User_Tags as t HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(tag, '"', ''), '.', ''), '\'', ''), '_', '')),'%'));

	ELSE SELECT 'ERROR: No such tag in the database' AS 'Result';
	END IF;
	END//
delimiter ;

# Stored procedure to list the tags of a user by userId#
delimiter // 
DROP PROCEDURE IF EXISTS Tagging //
CREATE PROCEDURE Tagging(In user INT(6))
	BEGIN
	IF EXISTS(SELECT t.UserID FROM User_Tags as t WHERE t.UserID = user) 
	THEN SELECT m.Title, t.Tag, t.Time_Stamp FROM User_Tags as t, Movies as m 
	WHERE t.UserID = user and m.MovieID = t.MovieID;
	ELSE SELECT 'ERROR: No such user made a tag' AS 'Result';
	END IF;
	END//
delimiter ; 



/**
	Links

*/

# Stored procedure to print the related links of the input Movie ## editing needed 
# 	THEN SELECT CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT('https://movielens.org/movies/', m.MovieID), ' and '),'http://www.imdb.com/title/'), l.ImdbId ), ' and '), 
# 'https://www.themoviedb.org/movie/'), l.TmdbId) AS 'RESULT' 

delimiter //
DROP PROCEDURE IF EXISTS ListLinks //
CREATE PROCEDURE ListLinks(IN movie VARCHAR(255))
	BEGIN
	IF EXISTS(SELECT REPLACE(REPLACE(REPLACE(REPLACE(m.Title, '"', ''), '.', ''), '\'', ''), '_', '') AS cna 
	FROM Movies as m HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(movie, '"', ''), '.', ''), '\'', ''), '_', '')),'%'))
	
	THEN SELECT m.Title, m.movieId, l.TmdbId, l.ImdbId
	FROM Movies as m, Links as l 
	WHERE m.MovieID = l.MovieID and m.Title in 
	(SELECT REPLACE(REPLACE(REPLACE(REPLACE(m.Title, '"', ''), '.', ''), '\'', ''), '_', '') AS cna 
	FROM Movies as m HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(movie, '"', ''), '.', ''), '\'', ''), '_', '')),'%'));
	ELSE SELECT 'ERROR: No such movie exists in the database' AS 'Result';
	END IF; 
	END //
delimiter ;

/**
	Relevance
*/

# Stored procedure to find the relevance of the input movie and its associated tag 
delimiter //
DROP PROCEDURE IF EXISTS FindRelevance //
CREATE PROCEDURE FindRelevance(IN movie VARCHAR(255), tag VARCHAR(255))
	BEGIN
	IF EXISTS(SELECT REPLACE(REPLACE(REPLACE(REPLACE(m.Title, '"', ''), '.', ''), '\'', ''), '_', '') AS cna 
	FROM Movies as m HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(movie, '"', ''), '.', ''), '\'', ''), '_', '')),'%'))

	THEN SELECT DISTINCT g.relevance FROM Movies as m, Tag_Relevance as g, User_Tags as t 
	WHERE g.MovieID = m.MovieID and t.TagId = g.TagId and tag = t.Tag and m.Title in 
	(SELECT REPLACE(REPLACE(REPLACE(REPLACE(m.Title, '"', ''), '.', ''), '\'', ''), '_', '') AS cna 
	FROM Movies as m HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(movie, '"', ''), '.', ''), '\'', ''), '_', '')),'%'));

	ELSE SELECT 'ERROR: No such tag in the input movie exists' AS 'Result';
	END IF;
	END //
delimiter ;


/**
ratings
*/

# Stored procedure to list the ratings of a user by userId#
delimiter // 
DROP PROCEDURE IF EXISTS Ratings //
CREATE PROCEDURE Ratings(In user INT(6))
	BEGIN
	IF EXISTS(SELECT r.UserID FROM Has_Ratings as r WHERE r.UserID = user) 
	THEN SELECT m.Title, r.Rating, r.Time_Stamp FROM Has_Ratings as r, Movies as m 
	WHERE r.UserID = user and m.MovieID = r.MovieID;
	ELSE SELECT 'ERROR: No such user made a rating' AS 'Result';
	END IF;
	END//
delimiter ;

# Stored procedure to list Movies by highest rating to lowest rating 
delimiter //
DROP PROCEDURE IF EXISTS ListMovieswithRate // 
CREATE PROCEDURE ListMovieswithRate()
	BEGIN
	SELECT m.Title, g.rate 
	FROM Movies as m, (SELECT avg(r.Rating) as rate, r.MovieID as movie FROM Has_Ratings as r GROUP BY r.MovieID) as g
	WHERE m.MovieID = g.movie
	ORDER BY g.rate DESC;
	END //
delimiter ;

# Stored procedure to find the average rate of the input movie 
delimiter //
DROP PROCEDURE IF EXISTS Find_rate//
CREATE PROCEDURE Find_rate(IN movie VARCHAR(255))
	BEGIN
	IF EXISTS(SELECT REPLACE(REPLACE(REPLACE(REPLACE(m.Title, '"', ''), '.', ''), '\'', ''), '_', '') AS cna 
	FROM Movies as m HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(movie, '"', ''), '.', ''), '\'', ''), '_', '')),'%'))
	
	THEN SELECT DISTINCT m.Title, avg(r.Rating) as average_rate FROM Movies as m, Has_Ratings as r 
	WHERE r.MovieID = m.MovieID and m.Title in 
	(SELECT REPLACE(REPLACE(REPLACE(REPLACE(m.Title, '"', ''), '.', ''), '\'', ''), '_', '') AS cna 
	FROM Movies as m HAVING cna LIKE   
	CONCAT(CONCAT('%',REPLACE(REPLACE(REPLACE(REPLACE(movie, '"', ''), '.', ''), '\'', ''), '_', '')),'%'))
	GROUP BY m.Title; 

	ELSE SELECT 'ERROR: No such movie exists in the database' AS 'Result';
	END IF;
	END //
delimiter ;

#







































