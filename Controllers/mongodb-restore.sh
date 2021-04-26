
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
source $PWD"/.env"

# Gets Tar bin path
TAR_BIN_PATH="$(which tar)"

# Set where database backups will be stored
# keyword DATE gets replaced by the current date, you can use it in either path below
BACKUP_PATH=$PWD"/Backups/$RESTORE_DATE/$BACKUP_DB_NAME" # do not include trailing slash
FILE_NAME="$BACKUP_DB_NAME.tar.gz" #defaults to [currentdate].tar.gz ex: 2011-12-19.tar.gz

# Auto detect unix bin paths, enter these manually if script fails to auto detect
MONGO_RESTORE_BIN_PATH=$PWD"/Controllers/mongo-tools/bin/mongorestore.exe"

# Ensure directory exists before restoring from it
if [ -d "$BACKUP_PATH" ]; then

    # Getting inside the directory
	cd $BACKUP_PATH
    if [ -f $FILE_NAME ]; then
        # run restore on mongoDB
        echo "=> Mongo server restore target: $HOST"
        echo "=> Restoring up from backup date: $RESTORE_DATE"
        
        # Unpacking dumped files
        echo "=> Unpacking $FILE_NAME..."
        $TAR_BIN_PATH -xzf $FILE_NAME
        OK=$?
        
        if [ $OK == "0" ] && [ -f $FILE_NAME ]; then
            echo "=> Removing $FILE_NAME..."
            rm -rf $FILE_NAME
        fi

        echo "=> Sending data to DB Server..."
        if [ "$RESTORE_CONNECTION_STRING" != "" ]; then
            $MONGO_RESTORE_BIN_PATH $RESTORE_CONNECTION_STRING --db=$RESTORE_DB_NAME "./"
            OK=$?
        else 
            $MONGO_RESTORE_BIN_PATH --host $HOST:$PORT --db=$RESTORE_DB_NAME "./"
            OK=$?
        fi

        if [ $OK == "0" ]; then
            echo
            echo "=> Re-compressing files in the backup folder..."
            $TAR_BIN_PATH --remove-files -czf $FILE_NAME *
            OK=$?
        else
            echo "!!!=> Fail to connect with the DB server!"
        fi
        
        if [ $OK == "0" ] && [ -f "$FILE_NAME" ]; then
            echo "=> Restore completed successfully!"
        else
            "!!!=> The restore seems to be donne successfully, but something went wrong with the backup files :("
        fi

    else
        echo "!!!=> Failed! The backup/restore directory doesn't exist: $BACKUP_PATH"
    fi
else

	echo "!!!=> Failed! The chosen restore date is not available: $RESTORE_DATE"

fi
