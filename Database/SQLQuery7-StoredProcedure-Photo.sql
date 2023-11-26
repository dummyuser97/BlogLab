USE BlogDB
CREATE PROCEDURE [dbo].[Photo_Delete]
	@PhotoId INT
AS
	DELETE FROM [dbo].[Photo] WHERE [PhotoId] = @PhotoId
---------------------------------

CREATE PROCEDURE [dbo].[Photo_Get]
	@Photo_Id INT
AS 
	SELECT 
		 t1.[PhotoId]
		,t1.[ApplicationUserId]
		,t1.[PublicId]
		,t1.[ImageUrl]
		,t1.[Description]
		,t1.[PublishDate]
		,t1.[UpdateDate]
	  FROM 
		[dbo].[Photo] t1
	  WHERE 
		t1.[PhotoId] = @Photo_Id


GO

--------------------------------------------------------

CREATE PROCEDURE [dbo].[Photo_GetByUserId]
	@ApplicationUserId INT
AS
	SELECT 
		 t1.[PhotoId]
		,t1.[ApplicationUserId]
		,t1.[PublicId]
		,t1.[ImageUrl]
		,t1.[Description]
		,t1.[PublishDate]
		,t1.[UpdateDate]
	  FROM 
		[dbo].[Photo] t1
	  WHERE 
		t1.[ApplicationUserId] = @ApplicationUserId

----------------------------------------

CREATE PROCEDURE [dbo].[PhotoInsert]
	@Photo PhotoType READONLY, 
	@ApplicationUserId INT
AS
	INSERT INTO [dbo].[Photo]
		([ApplicationUserId],
		[PublicId],
		[ImageUrl],
		[Description])
	SELECT
		@ApplicationUserId,
		[PublicID],
		[ImageUrl],
		[Description]
	FROM
		@Photo;

	SELECT CAST(SCOPE_IDENTITY() AS INT);
	