

gfish="glassfish.zip"
gfishdir="glassfish"

if [ ! -e $gfish ]; then

   wget -O $gfish https://download.eclipse.org/ee4j/glassfish/glassfish-7.0.4.zip

fi


if [ -e $gfish && ! -e $gfishdir ]; then

   unzip -d glassfish $gfish

fi




