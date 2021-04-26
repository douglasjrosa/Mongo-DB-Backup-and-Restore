
#!/bin/bash
#
# Douglas José Rosa
# <douglasjrosa@gmail.com>
# April 2021
# 
# forked from Michael Mottola repo
# Creates backup files (bson) of all MongoDb databases on a given server.
# Default behaviour dumps the mongo database and tars the output into a file
# named after the current date. ex: 2011-12-19.tar.gz

##################################################################################
# You should not have to edit below this line unless you require special functionality
# or wish to make improvements to the script
##################################################################################

# Gets enviroment variables from env.sh wich is ommited by gitignore
source $PWD"/.env.sh"

# Set where database backups will be stored
# keyword DATE gets replaced by the current date, you can use it in either path below
BACKUP_PATH=$PWD"/Backups" # do not include trailing slash

# Gets Tar bin path
TAR_BIN_PATH="$(which tar)"

# Create BACKUP_PATH directory if it does not exist
[ ! -d $BACKUP_PATH ] && mkdir -p $BACKUP_PATH || :

# Defining backup directory
TMP_BACKUP_PATH="DATE" #defaults to [currentdate] example: 2011-12-19
# Get todays date to use in backup output directory

TODAYS_DATE=`date "+%Y-%m-%d"`
TMP_BACKUP_PATH=$TODAYS_DATE

# Ensure directory exists before dumping to it
if [ -d "$BACKUP_PATH" ]; then

	echo "............"
	echo "=> Backing up Mongo Server: $HOST"

	# Getting mongodump tool path
	MONGO_DUMP_BIN_PATH=$PWD"/Controllers/mongo-tools/bin/mongodump.exe"
	
	# Getting into the backup folder
	cd $BACKUP_PATH

	echo "=> Creating BACKUP_PATH directory if it does not exist..."
	[ ! -d $TMP_BACKUP_PATH ] && mkdir -p $TMP_BACKUP_PATH || :

	# check to see if mongoDb was dumped correctly
	if [ -d "$TMP_BACKUP_PATH" ]; then

		# run dump on mongoDB
		echo "=> Fetching files from DB Server..."
		if [ "$BACKUP_CONNECTION_STRING" != "" ]; then
			$MONGO_DUMP_BIN_PATH --uri=$BACKUP_CONNECTION_STRING --db=$BACKUP_DB_NAME --out=$TMP_BACKUP_PATH >> /dev/null
			OK=$?
		else 
			$MONGO_DUMP_BIN_PATH --host=$HOST:$PORT --db=$BACKUP_DB_NAME --out=$TMP_BACKUP_PATH >> /dev/null
			OK=$?
		fi
		
		FILE_NAME=$BACKUP_DB_NAME

		if [ -d "$TMP_BACKUP_PATH/$FILE_NAME" ] && [ $OK == "0" ]; then
			
			cd "$TMP_BACKUP_PATH/$FILE_NAME"

			# turn dumped files into a single tar file
			echo
			echo "=> Compressing backup files..."
			$TAR_BIN_PATH --remove-files -czf $FILE_NAME.tar.gz *

			# verify that the file was created
			echo "=> Backup donne successfully: `du -sh $FILE_NAME.tar.gz`"; echo;
	
			# forcely remove if files still exist and tar was made successfully
			# this is done because the --remove-files flag on tar does not always work
			if [ -f "$FILE_NAME" ]; then
				rm -rf "$FILE_NAME"
			fi
		else
			 echo "!!!=> Failed to create backup file: $TMP_BACKUP_PATH/$FILE_NAME.tar.gz"; echo;
		fi
	else 
		echo; echo "!!!=> Failed to backup mongoDB: Could not create the directory: $TMP_BACKUP_PATH"; echo;	
	fi
else

	echo "!!!=> Failed to create backup path: $BACKUP_PATH"

fi
