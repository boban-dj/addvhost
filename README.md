# Script for adding vhhost to Apache on Archlinux.

## Usage

call like this: `# ./addvhost.sh (# = root)`

It will ask for `url` and `directory` for your new vhost.

or run like: `./addvhost -u newsite.com -d newsite`

## **Preparations:**

* Comment the default line for vhost in `/etc/httpd/conf/httpd.conf`: `#Include conf/extra/httpd-vhosts.conf` if you have no other vhosts setup.

* make a vhosts directory in `/etc/httpd/conf/vhosts`

* the script looks for a vhost skeleton file in `/etc/httpd/conf/vhosts` see `vhost.skeleton.conf`


## **The script edits the following:** 

* adds line in `/etc/httpd/conf/httpd.conf` : `Include conf/vhosts/newsite.conf`
* adds line in `/etc/hosts` : 127.0.0.1 newsite.com
* makes vhost file in `/etc/httpd/conf/vhost` copied and populated `/etc/httpd/conf/vhosts/vhost.skeleton.conf`
* makes directory in `/srv/http` for the new vhost site with index.html
* restarts apache: `systemctl restart httpd`


### TODO: 

	# echo owner of generated files/folders, add as var (http:http)
	# cleanup
	# add sed function disable ($siteurl) of ($relative_doc_root)
	# comment/disable vhost: sed -i '/Include conf\/vhosts\/$relative_doc_root/s/^/#/g' httpd.conf 
	# uncomment:enable vhost: sed -i '/Include conf\/vhosts\/$relative_doc_root.conf/s/^#//g' httpd.conf
	# remove all new vhost entries: hosts,vhosts,dir,httpd.conf,logs,restart
	# add httpd -S output
