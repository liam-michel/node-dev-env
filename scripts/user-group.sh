#!/bin/bash

USER_ID=${1:-1000}
GROUP_ID=${2:-1000}

USERNAME=dev-user
USER_HOME_DIR=/home/$USERNAME

#simple function to shift the user and group ids of the user and group

function shift_user_group_ids(){
    local type=$1 ## user or group
    local name=$2 #original name
    local new_id=$3 #new id to assign
    local temp_name="${name}_temp" #temporary name to avoid conflicts

    if [ "$type" == "user" ]; then
        #change the user id
        usermod -u $new_id $name
    elif [ "$type" == "group" ]; then
        #change the group id
        groupmod -g $new_id $name
    else 
        echo "Invalid type: $type. Must be 'user' or 'group'."
        exit 1
    fi

}

#check if the group with GROUP+ID already exists.
if getent group $GROUP_ID ; then 
    echo "Group ID $GROUP_ID already exists."
    EXISTING_GROUP=$(getent group $GROUP_ID | cut -d: -f1)
    if [ "$EXISTING_GROUP" != "$USERNAME" ] ; then
        shift_user_group_ids "group" $EXISTING_GROUP 9999
    fi
fi

#check if the user with USER_ID already exists
if getent passwd $USER_ID ; then 
    EXISTING_USER=$(getent passwd $USER_ID | cut -d: -f1)
    if [ "$EXISTING_USER" != "$USERNAME" ] ; then 
        shift_user_group_ids "user" $EXISTING_USER 9999
    fi
fi



#ensure dev-user user and group exists
getent group $GROUP_ID || addgroup --gid $GROUP_ID $USERNAME
getent passwd $USER_ID || adduser --disabled-password --gecos "" --uid $USER_ID --gid $GROUP_ID $USERNAME

#set dev-user to sudoers
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME
chmod 440 /etc/sudoers.d/$USERNAME  

#change ownership of files in dev-user user's home directory to dev-user
find $USER_HOME_DIR -user $USER_ID -exec chown -h $USER_ID:$GROUP_ID {} \;


