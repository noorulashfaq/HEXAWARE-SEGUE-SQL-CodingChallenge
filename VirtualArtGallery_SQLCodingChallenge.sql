-- Creating the DB

CREATE DATABASE VirtualArtGallery;
USE VirtualArtGallery;

-- Creating tables

CREATE TABLE Artists (
 ArtistID INT PRIMARY KEY,
 Name VARCHAR(255) NOT NULL,
 Biography TEXT,
 Nationality VARCHAR(100));

CREATE TABLE Categories (
 CategoryID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL);

CREATE TABLE Artworks (
 ArtworkID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 ArtistID INT,
 CategoryID INT,
 Year INT,
 Description TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));

CREATE TABLE Exhibitions (
 ExhibitionID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT);

CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));

-- Inserting values to the tables

INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

INSERT INTO Categories (CategoryID, Name) VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography');

INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picassos powerful anti-war mural.', 'guernica.jpg');

INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
 (4, 'Picasso', 2, 1, 1889, 'A famous Portrait.', 'picasso.jpg');

INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2);

-- Queries

/* 1. Retrieve the names of all artists along with the number of artworks they have in the gallery,
and list them in descending order of the number of artworks */
SELECT A.ArtistID, A.Name, COUNT(A.ArtistID) AS NumberOfArtworks FROM Artists AS A
INNER JOIN Artworks AS AW
ON A.ArtistID = AW.ArtistID
GROUP BY A.ArtistID, A.Name
ORDER BY COUNT(A.ArtistID) DESC;

/* 2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order 
them by the year in ascending order */
SELECT AW.Title, A.Nationality, AW.Year FROM Artworks AS AW
INNER JOIN Artists AS A
ON AW.ArtistID = A.ArtistID
WHERE A.Nationality IN ('Spanish', 'Dutch')
ORDER BY AW.Year;

/* 3. Find the names of all artists who have artworks in the 'Painting' category, and the number of 
artworks they have in this category */
SELECT A.Name, C.Name, COUNT(C.Name) AS NumberOfArtworks FROM Artworks AS AW
INNER JOIN Artists AS A
ON AW.ArtistID = A.ArtistID
INNER JOIN Categories AS C
ON AW.CategoryID = C.CategoryID
WHERE C.Name = 'Painting'
GROUP BY A.ArtistID, A.Name, C.Name

/* 4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their 
artists and categories */
SELECT AW.Title AS [Artwork Title], A.Name AS [Artist Name], C.Name AS [Category Name], E.Title AS [Exhibition Name]
FROM ExhibitionArtworks AS EA
INNER JOIN Exhibitions AS E
ON EA.ExhibitionID = E.ExhibitionID
INNER JOIN Artworks AS AW
ON AW.ArtworkID = EA.ArtworkID
INNER JOIN Categories AS C
ON C.CategoryID = AW.CategoryID
INNER JOIN Artists AS A
ON A.ArtistID = AW.ArtistID
WHERE E.Title = 'Modern Art Masterpieces';

--5. Find the artists who have more than two artworks in the gallery
SELECT A.ArtistID, A.Name, COUNT(A.ArtistID) AS NumberOfArtworks FROM Artists AS A
INNER JOIN Artworks AS AW
ON A.ArtistID = AW.ArtistID
GROUP BY A.ArtistID, A.Name
HAVING COUNT(A.ArtistID) > 2;

/* 6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 
'Renaissance Art' exhibitions */
SELECT AW.ArtworkID, AW.Title, E.Title FROM Artworks AS AW
INNER JOIN ExhibitionArtworks AS EA
ON AW.ArtworkID = EA.ArtworkID
INNER JOIN Exhibitions AS E
ON E.ExhibitionID = EA.ExhibitionID
WHERE E.Title IN ('Modern Art Masterpieces', 'Renaissance Art');

--7. Find the total number of artworks in each category
SELECT C.CategoryID, C.Name, COUNT(AW.ArtworkID) AS [No of Artworks] FROM Artworks AS AW
INNER JOIN Categories AS C
ON AW.CategoryID = C.CategoryID
GROUP BY C.CategoryID, C.Name;

--8. List artists who have more than 3 artworks in the gallery
SELECT A.ArtistID, A.Name, COUNT(AW.ArtworkID) AS [No of Artworks] FROM Artists AS A
INNER JOIN Artworks AS AW
ON A.ArtistID = AW.ArtistID
GROUP BY A.ArtistID, A.Name
HAVING COUNT(AW.ArtworkID) > 3;

--9. Find the artworks created by artists from a specific nationality (e.g., Spanish)
SELECT AW.ArtworkID, AW.Title, A.Nationality FROM Artworks AS AW
INNER JOIN Artists AS A
ON AW.ArtistID = A.ArtistID
WHERE A.Nationality = 'Spanish';

SELECT AW.ArtworkID, AW.Title, A.Nationality FROM Artworks AS AW
INNER JOIN Artists AS A
ON AW.ArtistID = A.ArtistID
WHERE A.Nationality = 'Dutch';

--10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci
SELECT E.Title, A.Name FROM Exhibitions AS E
INNER JOIN ExhibitionArtworks AS EA
ON E.ExhibitionID = EA.ExhibitionID
INNER JOIN Artworks AS AW
ON EA.ArtworkID = AW.ArtworkID
INNER JOIN Artists AS A
ON AW.ArtistID = A.ArtistID
WHERE A.Name IN ('Vincent van Gogh', 'Leonardo da Vinci');

--11. Find all the artworks that have not been included in any exhibition
SELECT AW.ArtworkID, AW.Title FROM Artworks AS AW
LEFT JOIN ExhibitionArtworks AS EA
ON AW.ArtworkID = EA.ArtworkID
WHERE EA.ExhibitionID IS NULL

--12. List artists who have created artworks in all available categories
SELECT A.ArtistID, A.Name FROM Artists AS A
INNER JOIN Artworks AS AW
ON A.ArtistID = AW.ArtistID
GROUP BY A.ArtistID, A.Name
HAVING COUNT(DISTINCT AW.CategoryID) = (SELECT COUNT(*) FROM Categories);

--13. List the total number of artworks in each category
SELECT C.CategoryID, C.Name, COUNT(AW.ArtworkID) AS [No of Artworks] FROM Artworks AS AW
INNER JOIN Categories AS C
ON AW.CategoryID = C.CategoryID
GROUP BY C.CategoryID, C.Name;

--14. Find the artists who have more than 2 artworks in the gallery
SELECT A.ArtistID, A.Name, COUNT(AW.ArtworkID) AS [No of Artworks] FROM Artists AS A
INNER JOIN Artworks AS AW
ON A.ArtistID = AW.ArtistID
GROUP BY A.ArtistID, A.Name
HAVING COUNT(AW.ArtworkID) > 2;

--15. List the categories with the average year of artworks they contain, only for categories with more than 1 artwork
SELECT C.CategoryID, C.Name, AVG(AW.Year) AS AvgYear, COUNT(AW.CategoryID) AS [No of Artworks] FROM Artworks AS AW
INNER JOIN Categories AS C
ON C.CategoryID = AW.CategoryID
GROUP BY C.CategoryID, C.Name
HAVING COUNT(AW.CategoryID) > 1;

--16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition
SELECT AW.ArtworkID, AW.Title, E.Title FROM Artworks AS AW
INNER JOIN ExhibitionArtworks AS EA
ON AW.ArtworkID = EA.ArtworkID
INNER JOIN Exhibitions AS E
ON E.ExhibitionID = EA.ExhibitionID
WHERE E.Title = 'Modern Art Masterpieces';

--17. Find the categories where the average year of artworks is greater than the average year of all artworks
SELECT C.CategoryID, C.Name, AVG(Year) AS AvgYear FROM Categories AS C
INNER JOIN Artworks AS AW
ON C.CategoryID = AW.CategoryID
GROUP BY C.CategoryID, C.Name
HAVING AVG(AW.Year) > (SELECT AVG(Year) FROM Artworks);

--18. List the artworks that were not exhibited in any exhibition
SELECT AW.ArtworkID, AW.Title FROM Artworks AS AW
LEFT JOIN ExhibitionArtworks AS EA
ON AW.ArtworkID = EA.ArtworkID
WHERE EA.ExhibitionID IS NULL

--19. Show artists who have artworks in the same category as "Mona Lisa."
SELECT A.ArtistID, A.Name, AW.Title, AW.CategoryID FROM Artists AS A
INNER JOIN Artworks AS AW
ON A.ArtistID = AW.ArtistID
WHERE AW.CategoryID IN
	(SELECT CategoryID FROM Artworks WHERE Title = 'Mona Lisa');

--20. List the names of artists and the number of artworks they have in the gallery
SELECT A.ArtistID, A.Name, COUNT(AW.ArtworkID) AS [Number of Artworks] FROM Artists AS A
INNER JOIN Artworks AS AW
ON A.ArtistID = AW.ArtistID
GROUP BY A.ArtistID, A.Name;

-- Tables --
SELECT * FROM Artworks
SELECT * FROM Artists
SELECT * FROM Categories
SELECT * FROM ExhibitionArtworks
SELECT * FROM Exhibitions
