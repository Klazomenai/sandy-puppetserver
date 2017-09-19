FROM centos:6.9

# Comment out before first push
RUN yum update -y

RUN rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
RUN yum install -y puppetserver

# ADD the puppet/hiera dirs
# Sadpanda until we don't need to checkout a repo within a repo and
# puppet/hiera are closed
ADD puppet-modules /etc/puppet/modules
ADD puppet-nodes-hiera /etc/puppet/hieradata/nodes
ADD puppet-nodes-hiera /etc/puppet/hieradata/role
ADD etc/puppet/hieradata/common.yaml /etc/puppet/hieradata/common.yaml
ADD etc/puppet/hieradata/environment/ /etc/puppet/hieradata/environment/
ADD etc/puppet/environments /etc/puppet/environments

# Load the puppet/hiera config
ADD etc/puppet/puppet.conf /etc/puppet/puppet.conf
ADD etc/puppet/hiera.yaml /etc/puppet/hiera.yaml

# Straight from Centos puppetserver init.d script
ENTRYPOINT /usr/bin/java \
  -XX:OnOutOfMemoryError="kill -9 %p" \
  -Djava.security.egd=/dev/urandom \
  -Xms2g \
  -Xmx2g \
  -XX:MaxPermSize=256m \
  -cp /usr/share/puppetserver/puppet-server-release.jar clojure.main \
  -m puppetlabs.trapperkeeper.main \
  --config /etc/puppetserver/conf.d \
  --debug \
  -b /etc/puppetserver/bootstrap.cfg
