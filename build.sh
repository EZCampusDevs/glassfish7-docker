#!/bin/sh


autodeploy="./glassfish/glassfish7/glassfish/domains/domain1/autodeploy"

mkdir -p $autodeploy | true

USE_LOG_FILE_ARGUMENT="USE_LOG_FILE"

if [ $# != 0 ]; then

   echo "Processing start arguments"

   for arg in "$@"; do

      if [ "$arg" = "$USE_LOG_FILE_ARGUMENT" ]; then

         echo "Writing all stdout and stderr to file"

         log_dir="$HOME/log/jenkins-ssh"
         mkdir -p $log_dir

         log_file="$log_dir/glassfish7-dockerbuild-log.out"
         touch log_file

         exec 3>&1 4>&2
         trap 'exec 2>&4 1>&3' 0 1 2 3
         exec 1>$log_file 2>&1

         continue

      fi

      if [ -d $arg ]; then

         echo "Adding all .war files in directory $arg"

         cp "$arg"/*.war "$autodeploy"/

         continue

      fi

      if [ -f "$arg" ] && [[ $arg == *.war ]]; then

         echo "Adding .war file $arg"

         cp "$arg" "$autodeploy"

      fi

   done

else 

   echo "No start arguments give"
   echo "Passing paths to .war files and directories containing them will add them to the autodeploy"
   echo "Passing the argument $USE_LOG_FILE_ARGUMENT will write all stdout and sderr to a logfile"
fi


docker build -t glassfish7 .

