-- Step 1: Create the new table with an auto-incremental surrogate key
CREATE TABLE [dbo].[person_info_with_surrkey] (
    surrkey INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-incremental surrogate key
    id INT,
    name NVARCHAR(100),
    gender NVARCHAR(50),
    country NVARCHAR(100),
    IsActive BIT
);

-- Step 2: Insert data from the original table into the new table
INSERT INTO [dbo].[person_info_with_surrkey] (id, name, gender, country, IsActive)
SELECT id, name, gender, country, IsActive
FROM [dbo].[person_info];

-- Optional: If you want to insert new rows directly into this new table
INSERT INTO [dbo].[person_info_with_surrkey] (id, name, gender, country, IsActive)
VALUES (101, 'John Doe', 'Male', 'USA', 1);

INSERT INTO [dbo].[person_info_with_surrkey] (id, name, gender, country, IsActive)
VALUES (102, 'Jane Smith', 'Female', 'Canada', 1);

INSERT INTO [dbo].[person_info_with_surrkey] (id, name, gender, country, IsActive)
VALUES (103, 'Alex Johnson', 'Non-binary', 'UK', 1);

