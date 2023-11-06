--[Account_GetByUsername]
-----------------------
CREATE PROCEDURE [dbo].[Account_GetByUsername]
	@NormalizedUsername VARCHAR(20)
AS
	SELECT 
		[ApplicationUserId]
		,[Username]
		,[NormalizedUsername]
		,[Email]
		,[NormalizedEmail]
		,[Fullname]
		,[PasswordHash]
	  FROM 
		[dbo].[ApplicationUser] t1
	  WHERE
		t1.[NormalizedUsername] = @NormalizedUsername
------------------------------------------------------------
CREATE PROCEDURE [dbo].[Account_Insert]
	@Account AccountType READONLY
AS 
	INSERT INTO [dbo].[ApplicationUser]
           ([Username]
           ,[NormalizedUsername]
           ,[Email]
           ,[NormalizedEmail]
           ,[Fullname]
           ,[PasswordHash])
	SELECT
			[Username]
           ,[NormalizedUsername]
           ,[Email]
           ,[NormalizedEmail]
           ,[Fullname]
           ,[PasswordHash]
	FROM
		@Account;
	SELECT CAST(SCOPE_IDENTITY() AS INT);
------------------------------------------------------------------








