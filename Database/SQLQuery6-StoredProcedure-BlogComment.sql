Use BlogDB
CREATE PROCEDURE [dbo].[BlogComment_Delete]
	@BlogCommentId INT
AS 
	DROP TABLE IF EXISTS #BlogCommentsToBeDeleted;
	WITH cte_blogComments AS(
	SELECT	 
		t1.[BlogCommentId],
		t1.[ParentBlogCommentId]
	FROM
		[dbo].[BlogComment] t1
	WHERE
		t1.[BlogCommentId] = @BlogCommentId
	UNION ALL
	SELECT 
		t2.[BlogCommentId],
		t2.[ParentBlogCommentId]
	FROM
		[dbo].[BlogComment] t2
		INNER JOIN cte_blogComments t3
			ON t3.[blogCommentId] = t2.[ParentBlogCommentId]
	)
	SELECT 
		[BlogCommentId],
		[ParentBlogCommentId]
	INTO
		#BlogCommentsToBeDeleted
	FROM
		cte_blogComments;
		
	UPDATE t2
	SET
		t1.[ActiveInd] = CONVERT(BIT,1),
		t1.[UpdateDate] = GETDATE()
	FROM
		[dbo].[BlogComments] t1
		INNER JOIN #BlogCommentsToBeDeleted t2
			ON t1.[BlogCommentId] = t2.[BlogCommentId];
GO

--------------------------------------------------------------------
CREATE PROCEDURE [dbo].[BlogComment_Get]
	@BlogCommentId INT
AS 
	SELECT 
		t1.[BlogCommentId]
	   ,t1.[ParentBlogCommentId]
       ,t1.[BlogId]
       ,t1.[ApplicationUserId]
	   ,t1.[UserName]
       ,t1.[Content]
       ,t1.[PublishDate]
       ,t1.[UpdateDate]
	FROM 
		[aggregate].[BlogComment] t1
	WHERE
		t1.[BlogCommentId] = @BlogCommentId AND
		t1.[ActiveInd] = CONVERT(BIT,1)

------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[BlogComment_GetAll]
	@BlogId INT
AS
	SELECT 
		t1.[BlogCommentId]
	   ,t1.[ParentBlogCommentId]
       ,t1.[BlogId]
       ,t1.[ApplicationUserId]
	   ,t1.[UserName]
       ,t1.[Content]
       ,t1.[PublishDate]
       ,t1.[UpdateDate]
	FROM 
		[aggregate].[BlogComment] t1
	WHERE
		t1.[BlogId] = @BlogId AND
		t1.[ActiveInd] = CONVERT(BIT,1)
	ORDER BY 
		t1.[UpdateDate]
	DESC
	

------------------------------------------


CREATE PROCEDURE [dbo].[BlogComment_Upsert]
	@BlogComment BlogCommentType READONLY,
	@ApplicationUserId INT
AS
	MERGE INTO [dbo].[BlogComment] TARGET
	USING(
		SELECT 
			[BlogCommentId],
			[ParentBlogCommentId],
			[BlogId],
			[Content],
			@ApplicationUserId [ApplicationUserId]
		FROM
		@BlogComment
	) AS SOURCE
	ON 
	(
		TARGET.[BlogCommentId] = SOURCE.[BlogCommentId] AND TARGET.[ApplicationUserId] = SOURCE.[ApplicationUserId]
	)
	WHEN MATCHED THEN 
		UPDATE SET
			TARGET.[Content] = SOURCE.[Content],
			TARGET.[UpdateDate] = GETDATE()
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (
		[ParentBlogCommentId],
		[BlogId],
		[ApplicationUserId],
		[Content]
	)
	VALUES
	(
		SOURCE.[ParentBlogCommentId],
		SOURCE.[BlogId],
		SOURCE.[ApplicationUserId],
		SOURCE.[Content]
	);
	
	SELECT CAST(SCOPE_IDENTITY() AS INT);
------------------------------------------------------------