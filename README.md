# sýnesis&trade; Lite for Syslog
sýnesis&trade; Lite for Syslog provides basic log analytics for syslog messages using Elastic Stack.

![synesis_lite_syslog](https://user-images.githubusercontent.com/10326954/34677300-f7b4a946-f48f-11e7-882a-b35f2c5e29dd.png)
## Getting Started
sýnesis&trade; Lite for Syslog was developed using Elastic Stack 6.1.1, including Elasticsearch, Logstash and Kibana. Currently there is no specific configuration required for Elasticsearch. As long as Kibana and Logstash can talk to your Elasticsearch cluster you should be ready to go.

> NOTE! Kibana 6.1.x suffers from undersized rendering of visualizations due to excessive padding. To workaround these issues see https://github.com/robcowart/kibana_6.1.x_vis_scaling_fixes

### Setting up Logstash
To configure Logstash, copy the directory `logstash/synesis_lite_syslog` to your Logstash configuration folder (e.g. `/etc/logstash/synesis_lite_syslog`). This directory contains the following sub-directories:
```
synesis_lite_syslog
|-- conf.d  (contains the Logstash pipeline)
|-- patterns (contains grok patterns)
+-- templates  (contains the index template)
```
Using the multiple pipeline feature introduced in Logstash 6.0 add the pipeline to your `pipelines.yml` file similar to this:

```
- pipeline.id: synesis_lite_syslog
  path.config: "/etc/logstash/synesis_lite_syslog/conf.d"
```
Alternatively you can start Logstash using the `--path.config` option to specify the location of the `synesis_lite_syslog/conf.d` directory.

Rather than edit the pipeline files in `synesis_lite_syslog/conf.d` for your environment, environment variables can be used. The supported environment variables are:

Environment Variable | Description | Default Valaue
--- | --- | ---
SYNLITE_SYSLOG_TEMPLATE_PATH | The location of the index template. | /etc/logstash/synesis_lite_syslog/templates
SYNLITE_SYSLOG_GROK_PATTERNS_DIR | The location of the grok pattern files. | /etc/logstash/synesis_lite_syslog/patterns
SYNLITE_SYSLOG_RESOLVE_IP2HOST | Enable/Disable DNS requests. | true
SYNLITE_SYSLOG_NAMESERVER | The DNS server to which the `dns` filter should send requests. | 127.0.0.1
SYNLITE_SYSLOG_ES_HOSTS | The Elasticsearch nodes to which events are to be sent. | 127.0.0.1:9200
SYNLITE_SYSLOG_ES_USER | The username to connect to Elasticsearch. | elastic
SYNLITE_SYSLOG_ES_PASSWORD | The password to connect to Elasticsearch. | changeme
SYNLITE_SYSLOG_TCP_HOST | The IP address from which to listen for Syslog messages via TCP. | 0.0.0.0
SYNLITE_SYSLOG_TCP_PORT | The port on which to listen for Syslog messages via TCP. | 514
SYNLITE_SYSLOG_UDP_HOST | The IP address from which to listen for Syslog messages via UDP. | 0.0.0.0
SYNLITE_SYSLOG_UDP_PORT | The port on which to listen for Syslog messages via TCP. | 514
SYNLITE_SYSLOG_MSG_TIMESTAMP | Whether to use the timestamp from the received message to set `@timestamp`. | true
SYNLITE_SYSLOG_TZ | The timezone of the timestamp of the incoming messages. | UTC

> NOTE! Caching is disabled for the `dns` filter as this causes performance issues due to the blocking nature of the cache lookups. For the best DNS performance it is recommended to use a local `dnsmasq` process to handle caching and to forward any unresolved lookups to upstream DNS servers. This is the reason that `SYNLITE_SYSLOG_NAMESERVER` defaults to `127.0.0.1`.

### Setting up Kibana
You will need to setup an Index Pattern in Kibana for the Syslog data. The index name pattern must be `syslog-*`, as indexes will be created daily. The Time-field should be set to `@timestamp`.

Finally the vizualizations and dashboards can be loaded into Kibana by importing the `synesis_lite_kibana.kibana.json` file from within the `kibana` directory.

## Dashboards
The following dashboards are provided.

### Overview
The Overview dashboard provides a summary of received Syslog messages by severity, node and process.

![Overview](https://user-images.githubusercontent.com/10326954/34675404-cfb1899c-f489-11e7-8c71-a0361d2f8397.png)

### Raw Messages
The Raw Messages dashboard allows for easy browsing of the raw Syslog messages that have been received.

![Raw Messages](https://user-images.githubusercontent.com/10326954/34675429-e3ba04be-f489-11e7-8834-4e62a996c211.png)

## License

The contents of this repository are subject to the Robert Cowart Public License (the "License") and may not be used or distributed except in compliance with the License. You may obtain a copy of the License at:

http://www.koiossian.com/public/robert_cowart_public_license.txt

Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the specific language governing rights and limitations under the License.

The Original Source Code was developed by Robert Cowart. Portions created by Robert Cowart are Copyright (C)2018 Robert Cowart. All Rights Reserved.
