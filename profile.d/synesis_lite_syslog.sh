#------------------------------------------------------------------------------
# Copyright (C)2019 Robert Cowart
# 
# The contents of this file and/or repository are subject to the Robert Cowart
# Public License (the "License") and may not be used or distributed except in
# compliance with the License. You may obtain a copy of the License at:
# 
# http://www.koiossian.com/public/robert_cowart_public_license.txt
# 
# Software distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
# the specific language governing rights and limitations under the License.
# 
# The Original Source Code was developed by Robert Cowart. Portions created by
# Robert Cowart are Copyright (C)2019 Robert Cowart. All Rights Reserved.
#------------------------------------------------------------------------------

# synesis Lite - Syslog 
export SYNLITE_SYSLOG_TEMPLATE_PATH=/etc/logstash/synesis_lite_syslog/templates
export SYNLITE_SYSLOG_GROK_PATTERNS_DIR=/etc/logstash/synesis_lite_syslog/patterns

export SYNLITE_SYSLOG_RESOLVE_IP2HOST=true
export SYNLITE_SYSLOG_NAMESERVER=127.0.0.1
export SYNLITE_SYSLOG_DNS_HIT_CACHE_SIZE=10000
export SYNLITE_SYSLOG_DNS_HIT_CACHE_TTL=900
export SYNLITE_SYSLOG_DNS_FAILED_CACHE_SIZE=25000
export SYNLITE_SYSLOG_DNS_FAILED_CACHE_TTL=3600


# Elasticsearch connection settings
export SYNLITE_SYSLOG_ES_USER=elastic
export SYNLITE_SYSLOG_ES_PASSWORD=changeme

# If you need Logstash to connect to only one Elasticsearch server, use the following environment variable.
export SYNLITE_SYSLOG_ES_HOSTS=127.0.0.1:9200

# If you need Logstash to connect to one of an array of three Elasticsearch servers, use the following environment variables.
# It is also necessary to rename the output files to disable single node output, and enable multi-node.
export SYNLITE_SYSLOG_ES_HOST_1=127.0.0.1:9200
export SYNLITE_SYSLOG_ES_HOST_2=127.0.0.2:9200
export SYNLITE_SYSLOG_ES_HOST_3=127.0.0.3:9200

# If SYNLITE_SYSLOG_ES_SSL_VERIFY is true then you must edit the output and set the path where the cacert can be found.
export SYNLITE_SYSLOG_ES_SSL_ENABLE=false
export SYNLITE_SYSLOG_ES_SSL_VERIFY=false


# IPv4
export SYNLITE_SYSLOG_TCP_IPV4_HOST=0.0.0.0
export SYNLITE_SYSLOG_TCP_IPV4_PORT=514
# IPv6
export SYNLITE_SYSLOG_TCP_IPV6_HOST=[::]
export SYNLITE_SYSLOG_TCP_IPV6_PORT=50514

# IPv4
export SYNLITE_SYSLOG_UDP_IPV4_HOST=0.0.0.0
export SYNLITE_SYSLOG_UDP_IPV4_PORT=514
# IPv6
export SYNLITE_SYSLOG_UDP_IPV6_HOST=[::]
export SYNLITE_SYSLOG_UDP_IPV6_PORT=50514
# UDP input options
export SYNLITE_SYSLOG_UDP_WORKERS=4
export SYNLITE_SYSLOG_UDP_QUEUE_SIZE=2048
export SYNLITE_SYSLOG_UDP_RCV_BUFF=33554432


export SYNLITE_SYSLOG_MSG_TIMESTAMP=true
export SYNLITE_SYSLOG_TZ=UTC
