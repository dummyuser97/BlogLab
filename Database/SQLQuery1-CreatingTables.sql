--- Create Important tables
------------
CREATE DATABASE BlogDB;
---------------
USE BlogDB;
-------------
CREATE TABLE ApplicationUser(
	ApplicationUserId INT NOT NULL IDENTITY(1,1),
	Username VARCHAR (20) NOT NULL, 
	NormalizedUsername VARCHAR(20) NOT NULL, 
	Email VARCHAR(30) NOT NULL, 
	NormalizedEmail VARCHAR(30) NOT NULL,
	Fullname varchar(30) NULL, 
	PasswordHash Nvarchar(Max) NOT NULL, 
	Primary key(ApplicationUserId)
)

-------------

Create Index [IX_ApplicationUser_NormalizedUsername] ON [dbo].[ApplicationUser] ([NormalizedUsername])

Create Index [IX_ApplicationUser_NormalizedEmail] ON [dbo].[ApplicationUser] (NormalizedEmail)

Select * From ApplicationUser
----------------

--- Photo Table ------------

Create table Photo(
	PhotoId INT NOT NULL IDENTITY(1,1),
	ApplicationUserId INT NOT NULL, 
	PublicId VARCHAR(50) NOT NULL, 
	ImageUrl VARCHAR(250) NOT NULL, 
	[Description] VARCHAR(30) NOT NULL, 
	PublishDate DATETIME NOT NULL DEFAULT GETDATE(),
	UpdateDate DATETIME NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY(PhotoId), 
	FOREIGN KEY (ApplicationUserId) REFERENCES ApplicationUser(ApplicationUserId)
)

--------------


CREATE TABLE Blog (
	BlogId INT NOT null IDENTITY(1,1),
	ApplicationUserId INT NOT NULL, 
	PhotoId INT NOT NULL, 
	Title VARCHAR(50) NOT NULL, 
	Content VARCHAR(MAX) NOT NULL, 
	PublishDate DATETIME NOT NULL DEFAULT GETDATE(),
	UpdateDate DATETIME NOT NULL DEFAULT GETDATE(),
	ActiveInd BIT NOT NULL DEFAULT CONVERT (BIT,1)
	Primary KEY (BlogId)
	FOREIGN KEY (ApplicationUserId) REFERENCES ApplicationUser(ApplicationUserId),
	FOREIGN KEY (PhotoId) REFERENCES Photo(PhotoId)
)
--------------------------

CREATE TABLE BlogComment (
	BlogCommentId INT NOT null IDENTITY(1,1),
	ParentBlogCommentId INT NULL, 
	BlogId INT NOT NULL, 
	ApplicationUserId INT NOT NULL, 
	Content VARCHAR(300) NOT NULL, 
	PublishDate DATETIME NOT NULL DEFAULT GETDATE(),
	UpdateDate DATETIME NOT NULL DEFAULT GETDATE(),
	ActiveInd BIT NOT NULL DEFAULT CONVERT (BIT,1),
	Primary KEY (BlogCommentId),
	FOREIGN KEY (ApplicationUserId) REFERENCES ApplicationUser(ApplicationUserId),
	FOREIGN KEY (BlogId) REFERENCES Blog(BlogId)
)

Select * From BlogComment
--------------------------

	
