
/*
=============================================================
Create Database and Schemas - Microsoft Azure
=============================================================
Using Microsoft Azure
It is also possible to use a Microsoft Azure account to set up and run this project. In this case, it is not necessary to install
MS SQL Server Express locally, as the database can be hosted in Azure.

To use this approach, you must activate a free subscription in Microsoft Azure and configure the following resources:

- Create a Resource Group: Create a new resource group to organize and manage the resources associated with the project.
- Configure the SQL Server: Specify the server name and its geographical location.
- Create the Database: Create a database associated with the SQL Server instance.
- Configure Authentication: Select the authentication method. For this project, SQL Authentication was used.
- Set Credentials: Define the SQL administrator username and password. Make sure to store these credentials securely.
- Configure Firewall Rules: If access to the SQL Server is restricted by firewall rules, add the client's public IP address
to the server's firewall configuration to allow the application to establish a connection.
- Once these resources have been configured, the database can be accessed remotely through Azure, eliminating the need for a
local MS SQL Server Express installation.
	
DATABASE:
You can create a database named datawarehouse directly. Then, use the SQL QUERY EDITOR to create the corresponding schemas 
and verify that they have been created successfully.
  
*/


-- To verify that the server and database were created successfully.
SELECT
    @@SERVERNAME AS Server,
    DB_NAME() AS DataBase;    

-- Create Schema (Execute each line separately in the Azure SQL Editor.)
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

-- To verify that the schemas were created successfully
SELECT name
FROM sys.schemas
ORDER BY name;
