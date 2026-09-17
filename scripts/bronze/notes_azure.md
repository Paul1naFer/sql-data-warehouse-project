**Azure SQL Database and Azure Blob Storage Setup**

It is possible to use an Azure SQL Database to load source files stored in Azure Blob Storage.

First, create the following Azure resources:

- An Azure SQL Server and Azure SQL Database.
- A Resource Group to contain the resources.
- An Azure Storage Account with a Blob Storage container. In this case, the container is called Bronze.
- Upload the source files to the Bronze container. These files will later be used to populate the database tables.

**Authentication Options**

Before executing the data-loading procedure, there are two main options for authenticating Azure SQL Database against Blob Storage:

1) Use a SAS (Shared Access Signature) associated with the container or blob.
2) Use a Managed Identity for Azure SQL Database.

For the Managed Identity approach, enable a Managed Identity for the Azure SQL logical server and grant the required permissions to that identity through:

**Access Control (IAM) → Add role assignment**

After assigning the appropriate role to the Azure SQL Managed Identity, create a database-scoped credential in the Azure SQL Database.

**Create the Database-Scoped Credential**

Once connected to the Azure SQL Database, create a database-scoped credential using the Managed Identity:

CREATE DATABASE SCOPED CREDENTIAL [AzureBlobCredential]
WITH IDENTITY = 'MANAGED IDENTITY';

**Create the External Data Source**

Next, create an external data source that points to the Azure Blob Storage account:

CREATE EXTERNAL DATA SOURCE [AzureBlobStorage]
WITH
(
    TYPE = BLOB_STORAGE,
    LOCATION = 'https://name_of_storageaccount.blob.core.windows.net',
    CREDENTIAL = [AzureBlobCredential]
);


The LOCATION should contain the URL of the Azure Storage Account.

**Load the Data with BULK INSERT**

The BULK INSERT statement can then be modified to read the file directly from the Blob Storage container:

BULK INSERT bronze.crm_cust_info
FROM 'cust_info.csv' -- File uploaded directly to the Bronze container
WITH (
    DATA_SOURCE = 'AzureBlobStorage',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);


In this example, cust_info.csv is stored directly in the Bronze container, so the file name can be specified directly in the FROM clause.

**Summary**

The overall process is:

1)Create and configure the Azure Storage Account and the Bronze Blob Storage container.
2) Upload the source files to the container.
3) Configure the Azure SQL Managed Identity and assign the required permissions through IAM.
4) Create the DATABASE SCOPED CREDENTIAL using the Managed Identity.
5) Create the EXTERNAL DATA SOURCE pointing to the Blob Storage account.
6) Test the configuration with a BULK INSERT statement.
7) Modify the store procedure proc_load_bronze_azure.sql
8) Execute the procedure
9) Check the data in the tables