
CREATE PROCEDURE [dbo].[Blog_Delete]
	@BlogId INT
As 
	UPDATE [dbo].[BlogComment]
	SET [ActiveInd] = CONVERT(BIT, 0)
	WHERE [BlogId] = @BlogId;
	
	UPDATE [dbo].[Blog]
	SET
		[PhotoId] = NULL, 
		[ActiveInd] = CONVERT(BIT, 0)
	WHERE
		[BlogId] = @BlogId
-------------------------------------------------
CREATE PROCEDURE [dbo].[Blog_Get]
	@BlogId INT
AS 
	SELECT 
		[BlogId]
		,[ApplicationUserId]
		,[Username]
		,[Title]
		,[Content]
		,[PhotoId]
		,[PublishDate]
		,[UpdateDate]
		,[ActiveInd]
	 FROM 
		[aggregate].[Blog] t1
	WHERE 
		t1.[BlogId] = @BlogId AND
		t1.ActiveInd = CONVERT(BIT,1)
---------------------------------------------------------

CREATE PROCEDURE [dbo].[Blog_GetAll]
	@Offset INT,
	@PageSize INT
AS
	SELECT 
		 [BlogId]
		,[ApplicationUserId]
		,[Username]
		,[Title]
		,[Content]
		,[PhotoId]
		,[PublishDate]
		,[UpdateDate]
		,[ActiveInd]
	 FROM 
		[aggregate].[Blog] t1
	WHERE
		t1.[ActiveInd] = CONVERT(BIT,1)
	ORDER BY
		t1.[BlogId]
	OFFSET @Offset ROWS
	FETCH NEXT @PageSize ROWS ONLY;
	
	SELECT COUNT(*) FROM [aggregate].[Blog] t1 
	WHERE t1.[ActiveInd] = CONVERT(BIT,1)

--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[Blog_GetAllFamous]
AS
	SELECT 
	TOP 6
		 t1.[BlogId]
		,t1.[ApplicationUserId]
		,t1.[Username]
		,t1.[Title]
		,t1.[Content]
		,t1.[PhotoId]
		,t1.[PublishDate]
		,t1.[UpdateDate]
		,t1.[ActiveInd]
	FROM 
		[aggregate].[Blog] t1
	INNER JOIN 
		[dbo].[BlogComment] t2 ON t1.BlogId = t2.BlogId
	WHERE
		t1.ActiveInd = CONVERT(BIT,1) AND
		t2.ActiveInd = CONVERT(BIT,1)
	GROUP BY
		 t1.[BlogId]
		,t1.[ApplicationUserId]
		,t1.[Username]
		,t1.[Title]
		,t1.[Content]
		,t1.[PhotoId]
		,t1.[PublishDate]
		,t1.[UpdateDate]
		,t1.[ActiveInd]
	ORDER BY
		COUNT(t2.BlogCommentId)
	DESC

-----------------------------------------------------------------
CREATE PROCEDURE [dbo].[Blog_GetByUserID]
	@ApplicationUserId INT
AS 
	SELECT 
		 [BlogId]
		,[ApplicationUserId]
		,[Username]
		,[Title]
		,[Content]
		,[PhotoId]
		,[PublishDate]
		,[UpdateDate]
		,[ActiveInd]
	 FROM 
		[aggregate].[Blog] t1
	WHERE 
		t1.[ApplicationUserId] = @ApplicationUserId AND
		t1.[ActiveInd] =CONVERT(BIT,1)
		
------------------------------------------------------------------
CREATE PROCEDURE [dbo].[Blog_Upsert]
	@Blog BlogType READONLY,
	@ApplicationUserId INT 
AS
	MERGE INTO [dbo].[Blog] TARGET 
	USING (
		SELECT 
			BlogId,
			@ApplicationUserId [ApplicationUserId],
			Title,
			Content,
			PhotoId
		FROM
			@Blog
		) AS SOURCE 
		ON
		(
			TARGET.BlogId = SOURCE.BlogId AND TARGET.ApplicationUserId = SOURCE.ApplicationUserId
		)
		WHEN MATCHED THEN
			UPDATE SET
				TARGET.[Title] = SOURCE.[Title],
				TARGET.[Content] = SOURCE.[Content],
				TARGET.[PhotoId] = SOURCE.[PhotoId],
				TARGET.[UpdateDate] = GETDATE()
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT(
				[ApplicationUserId],
				[Title],
				[Content],
				[PhotoId]
			)
			VALUES (
				SOURCE.[ApplicationUserId],
				SOURCE.[Title],
				SOURCE.[Content],
				SOURCE.[PhotoId]
				);
		SELECT CAST(SCOPE_IDENTITY() AS INT);
------------------------------------------------------------