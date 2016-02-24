#!/bin/bash
set -e

if [ "${1}" = "run" ];then
    set -- catalina.sh "$@"
fi

mkdir -p $CATALINA_HOME/conf/Catalina/localhost

for webapp in $(ls /dspace/webapps/); do
    # Exclue jspui parce qu'il n'est pas compilable avec tomcat8
    if [ "$webapp" != "jspui" ]; then
	if [ "$webapp" == "solr" ]; then
	{
	    echo "<Context docBase=\"/dspace/webapps/$webapp\" reloadable=\"true\">"
	    echo "<Valve className=\"org.apache.catalina.valves.RemoteAddrValve\" allow=\"127\.0\.0\.1|172\.17\.0\.1|172\.16\.0\.57|111\.222\.233\.d+\"/>"
	    echo "<Parameter name=\"LocalHostRestrictionFilter.localhost\" value=\"false\" override=\"false\" />"
	    echo "</Context>"
	} > $CATALINA_HOME/conf/Catalina/localhost/$webapp.xml
	else	
       {
          echo "<?xml version='1.0'?>"
            echo "<Context"
            echo docBase=\"/dspace/webapps/$webapp\"
            echo 'reloadable="true"'
            echo 'cachingAllowed="false"/>'
        } > $CATALINA_HOME/conf/Catalina/localhost/$webapp.xml
	fi
    fi
done

cp $CATALINA_HOME/conf/Catalina/localhost/{xmlui,ROOT}.xml
sed -i "s/localhost:5432/db:5432/" /dspace/config/dspace.cfg
chown dspace:dspace /dspace/assetstore

#service cron start

sh /sbin/create-admin.sh

exec "$@"
