#!/bin/bash

sudo apt-get -y install git

cd /opt/

git clone https://github.com/openstack-dev/devstack.git
git clone https://github.com/stackforge/mistral.git
git clone https://github.com/stackforge/python-mistralclient.git
git clone https://github.com/stackforge/mistral-extra.git
# TODO(enykeev): make mistral-dashboard a devstack service
git clone https://github.com/stackforge/mistral-dashboard.git

cp /vagrant/local.conf /opt/devstack/
cp /opt/mistral/contrib/devstack/lib/* /opt/devstack/lib/
cp /opt/mistral/contrib/devstack/extras.d/* /opt/devstack/extras.d/

cd /opt/devstack
chown -R vagrant:vagrant /opt/

su vagrant - -c "./stack.sh"

cd /opt/python-mistralclient
sudo python setup.py install

cd /opt/mistral-dashboard
sudo python setup.py install

export OS_USERNAME=admin
export OS_PASSWORD=StorminStanley
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://172.16.80.100:35357/v2.0

# Since Mistral is deployed on the same VM with horizon, you don't need to define the service.
# export MISTRAL_URL="http://172.16.80.100:8989/v1"
# keystone service-create --name mistral --type workflow
# keystone endpoint-create --service_id mistral --publicurl $MISTRAL_URL \
#   --adminurl $MISTRAL_URL --internalurl $MISTRAL_URL

keystone user-role-add --user=mistral --tenant=admin --role=admin
keystone user-role-add --user=mistral --tenant=demo --role=admin

# Devstack's Horison service, for some reason, defines OPENSTACK_KEYSTONE_URL to v2 API instead of v3.
# Mistral, at the same time, requires v3. I'd say we should create a ticket in devstack, probably include
# someone from keystone and horizon to finally figure that out. For now, here is a hack.
echo 'OPENSTACK_KEYSTONE_URL="http://172.16.80.100:5000/v3"' >> /opt/stack/horizon/openstack_dashboard/local/local_settings.py
echo 'OPENSTACK_API_VERSIONS = {"identity": 3}' >> /opt/stack/horizon/openstack_dashboard/local/local_settings.py

cd /opt/mistral-dashboard
sudo pip install -r requirements.txt
sudo cp _50_mistral.py.example /opt/stack/horizon/openstack_dashboard/local/enabled/_50_mistral.py
sudo service apache2 restart
