#!/bin/bash

sudo apt-get -y install git

cd /opt/

git clone https://github.com/openstack-dev/devstack.git
git clone https://github.com/stackforge/mistral.git
git clone https://github.com/stackforge/python-mistralclient.git
git clone https://github.com/stackforge/mistral-extra.git

cp /vagrant/local.conf /opt/devstack/
cp /opt/mistral/contrib/devstack/lib/* /opt/devstack/lib/
cp /opt/mistral/contrib/devstack/extras.d/* /opt/devstack/extras.d/

cd /opt/devstack
sudo cp /vagrant/stackrc /opt/devstack/
chown -R vagrant:vagrant /opt/

su vagrant - -c "./stack.sh"

cd /opt/python-mistralclient
sudo python setup.py install


#export MISTRAL_URL="http://172.16.80.100:8989/v1"
export OS_USERNAME=admin
export OS_PASSWORD=StorminStanley
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://172.16.80.100:35357/v2.0

keystone service-create --name mistral --type workflow
#keystone endpoint-create --service_id mistral --publicurl $MISTRAL_URL \
#				  --adminurl $MISTRAL_URL --internalurl $MISTRAL_URL

keystone user-role-add --user=mistral --tenant=admin --role=admin
keystone user-role-add --user=mistral --tenant=demo --role=admin

nova flavor-create m1.micro 101 128 0 1
nova flavor-create m1.nano 102 64 0 1

cd /opt/python-mistralclient/horizon_dashboard
sudo pip install -r requirements.txt
sudo cp /vagrant/local_settings.py /opt/python-mistralclient/horizon_dashboard/demo_dashboard/local/
sudo python manage.py runserver 172.16.80.100:8000 &> /tmp/dashboard.log &
