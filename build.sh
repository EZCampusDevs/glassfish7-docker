#!/bin/sh

gfish_url="https://download.eclipse.org/ee4j/glassfish/glassfish-7.0.4.zip"
gfish_sha256="4901824600668b01c55ca571d4230f987800b1cd4f09a93629b7b5f05058c577"

gfish_dl_dir="$HOME/.cache/ezcampus/glassfish"
gfish_dl_name=$(echo "$gfish_url" | awk -F"/" '{print $NF}')
gfish_dl_path="$gfish_dl_dir/$gfish_dl_name"

log_dir="$HOME/log/jenkins-ssh"
log_file="$log_dir/glassfish-install-log.out"

USE_LOG_FILE_ARGUMENT="USE_LOG_FILE"

mkdir -p "$gfish_dl_dir" || true


if [ $# != 0 ]; then

   echo "Processing start arguments"

   for arg in "$@"; do

      if [ "$arg" = "$USE_LOG_FILE_ARGUMENT" ]; then

         echo "Writing all stdout and stderr to file"

         mkdir -p "$log_dir"

         touch "$log_file"

         exec 3>&1 4>&2
         trap 'exec 2>&4 1>&3' 0 1 2 3
         exec 1>"$log_file" 2>&1

         continue

      fi

   done

fi



function hash_check() {

   real_hash=$(sha256sum "$1" | awk '{print $1}')

   if [ "$gfish_sha256" != "$real_hash" ]; then 

      return 1

   else 

      return 0

   fi
}



if [ -e "$gfish_dl_path" ]; then

   echo "Glassfish path already exists, checking file integrity..."

   if ! hash_check "$gfish_dl_path"; then

      echo "Existing glassfish path did not match expected sha256"

      rm -f "$gfish_dl_path"

   else 

      echo "File hash matched"

   fi

fi


if [ ! -e "$gfish_dl_path" ]; then

   if ! which "wget"; then

      wget -O "$gfish_dl_path" "$gfish_url"

   elif which "curl"; then 

      curl -L -o "$gfish_dl_path" "$gfish_url"

   fi

fi


if ! hash_check "$gfish_dl_path"; then

   echo "Downloaded file did not match expected hash!"

   exit 1

fi


cp "$gfish_dl_path" "glassfish.zip"


docker build -t glassfish7 .



