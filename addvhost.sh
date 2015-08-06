#!/bin/bash

# TODO: echo owner of generated files/folders
# TODO description preparation: vhost dir + vhost skeleton +root access + public dir
# cleanup
# 
# add sed function disable ($siteurl) of ($relative_doc_root) # nog te bepalen
# comment/disable vhost: sed -i '/Include conf\/vhosts\/$relative_doc_root/s/^/#/g' httpd.conf 
# uncomment:enable vhost: sed -i '/Include conf\/vhosts\/$relative_doc_root.conf/s/^#//g' httpd.conf 


# Call like this: ./addvhost.sh -u newsite.com -d newsite
# where -u is site url and -d site directory on server
 
# permissions
if [ "$(whoami)" != "root" ]; then
	echo "Root privileges are required to run this, try running with sudo..."
	exit 2
fi
 
current_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


hosts_path="/etc/hosts"
vhosts_path="/etc/httpd/conf/vhosts/"
vhost_skeleton_path="/etc/httpd/conf/vhosts/vhost.skeleton.conf"
web_root="/srv/http/"
 
 
# user input passed as options?
site_url=0
relative_doc_root=0
 
while getopts ":u:d:" o; do
	case "${o}" in
		u)
			site_url=${OPTARG}
			;;
		d)
			relative_doc_root=${OPTARG}
			;;
	esac
done
 
# prompt if not passed as options
if [ $site_url == 0 ]; then
	read -p "Please enter the desired URL: " site_url
fi
 
if [ $relative_doc_root == 0 ]; then
	read -p "Please enter the site path relative to the web root: $web_root_path" relative_doc_root
fi
 
# construct absolute path
absolute_doc_root=$web_root$relative_doc_root
 
# create directory if it doesn't exists
if [ ! -d "$absolute_doc_root" ]; then
 
	# create directory
	`mkdir "$absolute_doc_root/"`
 
	# create index file
	indexfile="$absolute_doc_root/index.html"
	`touch "$indexfile"`
	echo "<html><head></head><body>Welcome!</body></html>" >> "$indexfile"
	`chmod 755 "$indexfile"`
	`sudo chown -R http:http "$absolute_doc_root/"`
	echo "Created directory $absolute_doc_root/"
	echo "Created directory $indexfile"
fi
 
 
# update vhost
#vhost=`cat "$vhost_skeleton_path"`
#echo "$vhost" > "$vhosts_path$site_url.conf"
#echo "Updated vhosts in Apache config"


# sed -e 's/foo/spam/' test.txt ; replace all foo with spam in file test.txt
# Replace domain name into skeleton
#sed "s/%%DOMAIN%%/$site_url/g" "$vhost_skeleton_path" > "$vhosts_path$site_url.conf"
sed -e "s/%%DOCROOT%%/$relative_doc_root/g" -e "s/%%DOMAIN%%/$site_url/g" "$vhost_skeleton_path" > "$vhosts_path$relative_doc_root.conf"
echo "Copied defaults from /etc/httpd/conf/vhosts/vhost.skeleton.conf and generated the $vhosts_path$relative_doc_root.conf"


# update hosts file
echo 127.0.0.1    $site_url >> $hosts_path
echo "Updated the /etc/hosts file"

echo Include conf/vhosts/$relative_doc_root.conf >> /etc/httpd/conf/httpd.conf
echo "Updated the httpd.conf file with 'Include conf/vhosts/$relative_doc_root.conf' ; #comment this line to disable the vhost"



 
# restart apache
echo "Enabling site in Apache..."
systemctl restart httpd

echo "Apache succesfully restarted!"
 

echo "Process complete, check out the new site at http://$site_url"

 
exit 0
