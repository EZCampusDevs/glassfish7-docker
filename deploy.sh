#!/bin/sh

USE_LOG_FILE_ARGUMENT="USE_LOG_FILE"

if [ $# != 0 ]; then

   echo "Processing start arguments"

   for arg in "$@"; do

      if [ "$arg" = "$USE_LOG_FILE_ARGUMENT" ]; then

         echo "Writing all stdout and stderr to file"

         log_dir="$HOME/log/jenkins-ssh"
         mkdir -p $log_dir

         log_file="$log_dir/glassfish7-dockerrun-log.out"
         touch log_file

         exec 3>&1 4>&2
         trap 'exec 2>&4 1>&3' 0 1 2 3
         exec 1>$log_file 2>&1

      fi

   done

fi


DOCKER_IMAGE="glassfish7"

WAIT_SCRIPTS_DIR="./wait_scripts"

container_name="glassfish_prod"

container_a="${container_name}_a"
container_a_port="8081"
container_a_admin="4849"

container_b="${container_name}_b"
container_b_port="8082"
container_b_admin="4850"


is_container_running() {

   container_name="$1"

   if [ "$(docker inspect -f '{{.State.Running}}' "$container_name" 2>/dev/null)" = "true" ]; then

      return 0

   else 

      return 1

   fi

}


run_container() {

   container_name="$1"
   port="$2"
   admin_port="$3"

   echo "Docker run container: $container_name on port: $port on admin: $admin_port"

   docker run -itd \
      --rm \
      -p "$port:8080" \
      -p "127.0.0.1:$admin_port:4848" \
      --name "$container_name" \
      --network EZnet \
      -e MS1_USERNAME="$MS1_USERNAME" \
      -e MS1_PASSWORD="$MS1_PASSWORD" \
      $DOCKER_IMAGE 

}


kill_and_wait_until_container_stopped() {

   container_name="$1"

   while is_container_running $container_name; do

      docker stop "$container_name" || true

      echo "Waiting for container to stop..."

      sleep 1
   done
}


wait_until_container_deployed() {

   wait_at_least="$1"
   use_wait_scripts="$2"

   echo "Waiting at least $wait_at_least seconds for container to deploy"

   sleep $wait_at_least

   if [ $use_wait_scripts -eq 1 ]; then

      if [ ! -d $WAIT_SCRIPTS_DIR ]; then 

         echo "WAIT_SCRIPTS_DIR with value $WAIT_SCRIPTS_DIR is not a directory!!!"

         return 1
      fi

      root_host="$3"


      for wait_script in "$WAIT_SCRIPTS_DIR"/*.sh; do

         if [ -x "$wait_script" ]; then 

            echo "Running wait script: $wait_script"

            sh "$wait_script" "$root_host"

         else 

            echo "Skipping wait script: $wait_script. No execute perms"

         fi

      done

   fi

   return 0
}


if ! is_container_running $container_a; then

   run_container $container_a $container_a_port $container_a_admin 

   if wait_until_container_deployed 5 0 "localhost:$container_a_port"; then 

      kill_and_wait_until_container_stopped $container_b

   fi

   exit 0

fi


if ! is_container_running $container_b; then

   run_container $container_b $container_b_port $container_b_admin 

   if wait_until_container_deployed 5 0 "localhost:$container_b_port"; then 

      kill_and_wait_until_container_stopped $container_a

   fi

   exit 0

fi

# there is two instances of the glassfish docker running, this is probably a mistake
exit 1

