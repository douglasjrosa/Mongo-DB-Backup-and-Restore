# Mongo DB Backup and Restore

Shell script for backing up and Restoring Mongo Databases on a given server.  
You can have your Mongo Database backed up and compressed in a directory created automatically in this repository root.

## Configuration

In order to make this code work for you, the first thing you must to do is to make a copy of the `.env.example` file in the repository root. The name of this new file has to be just `.env`.
After that, get into the file and fill all the enviroment variables with your own access data.
The way you have to do that is described bellow with more details.

## Backup Defaults (in the .env file)

	HOST
	* Example: localhost or cluster0.0000.gcp.mongodb.net

	PORT
	* Example: 27017

	BACKUP_CONNECTION_STRING
	* Example: mongodb+srv://<username>:<password>@cluster0.0000.gcp.mongodb.net

	BACKUP_DB_NAME
	* Example: "users"


## Restore Defaults (also in the .env file)

	RESTORE_CONNECTION_STRING
	* This may be empty in case you are not using username and password;
	* This may be the same as the BACKUP_CONNECTION_STRING if you want to restore the data at the original source;
	* This may be another connection string in case you whant to send the data to another Database like a DB migration for example.
	
	RESTORE_DB_NAME
	* Format: yyyy-mm-dd
	* In the `Backups` folder created automatically in this repository source there must exist a sub-directory named with that date.


## Lounching the backup

Once it you configured correctly the `.env` file, at the root of this repository, all you need to do is louch the backup by typing that command in the shell: `./backup.sh` and after that, if your configs are right, you should see the backup running in the shell.
IMPORTANT: the command must to be executed in the root folder of this repository.

## Script Output

As the code runs, some messages will be printed in the shell. Since the initial steps until the success or error in the end.

## Restoring from Backup

Restore a backup using the `./restore.sh` command in the shell also in this repository root.
IMPORTANT: Before using that command don't forget to fill correctly the `.env` file variables:
	
	RESTORE_CONNECTION_STRING
	RESTORE_DATE
	RESTORE_DB_NAME

That restore command uses the mongorestore command from Mongo DB tools.
	
	mongorestore [options] [directory or filename to restore from]

For more information, check out the mongoDB site:

http://www.mongodb.org/display/DOCS/Import+Export+Tools#ImportExportTools-mongodumpandmongorestore


# License (MIT)

Copyright (c) 2021 Douglas José Rosa <douglasjrosa@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
