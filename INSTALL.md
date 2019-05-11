# sýnesis&trade; Lite for Syslog Installation

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/robcowart)

sýnesis&trade; Lite for Syslog is built using the Elastic Stack, including Elasticsearch, Logstash and Kibana. To install and configure sýnesis&trade; Lite for Syslog, you must first have a working Elastic Stack environment.

Refer to the following compatibility chart to choose a release of sýnesis&trade; Lite for Syslog that is compatible with the version of the Elastic Stack you are using.

Elastic Stack | 1.x
:---:|:---:
7.0.x | &#10003; v1.1.0
6.x.x | &#10003; v1.0.1

## Setting up Elasticsearch

Previous versions of sýnesis&trade; Lite for Syslog required no special configuration for Elasticsearch. However changes made to Elasticsearch 7.x, require that the following settings be made in `elasticsearch.yml`:

```
indices.query.bool.max_clause_count: 8192
search.max_buckets: 100000
```

At high ingest rates (>10K logs/s), or for data redundancy and high availability, a multi-node cluster is recommended.

## Setting up Logstash

Follow these steps to ensure that Logstash and sýnesis&trade; Lite for Syslog are optimally configured to meet your needs. 

### 1. Set JVM heap size.

To increase performance, sýnesis&trade; Lite for Syslog takes advantage of the caching and queueing features available in many of the Logstash plugins. These features increase the consumption of the JVM heap. The JVM heap space used by Logstash is configured in `jvm.options`. It is recommended that Logstash be given at least 512MB of JVM heap. If DNS lookups (requires version 3.0.10 or later of the DNS filter), are enabled increase this to 1GB. This is configured in `jvm.options` as follows:

```
-Xms1g
-Xmx1g
```

### 2. Copy the pipeline files to the Logstash configuration path.

There are three sets of configuration files provided within the `logstash/synesis_lite_syslog` folder:

```plaintext
logstash
  `- synesis_lite_syslog
      |- conf.d  (contains the Logstash pipeline)
      |- patterns (contains grok patterns)
      `- templates  (contains the index template)
```

Copy the `synesis_lite_syslog` directory to the location of your Logstash configuration files (e.g. on RedHat/CentOS or Ubuntu this would be `/etc/logstash/synesis_lite_syslog` ). If you place the sýnesis&trade; Lite for Syslog pipeline within a different path, you will need to modify the following environment variables to specify the correct location:

Environment Variable | Description | Default Value
--- | --- | ---
SYNLITE_SYSLOG_TEMPLATE_PATH | The location of the index template. | /etc/logstash/synesis_lite_syslog/templates
SYNLITE_SYSLOG_GROK_PATTERNS_DIR | The location of the grok pattern files. | /etc/logstash/synesis_lite_syslog/patterns

### 3. Setup environment variable helper files

Rather than directly editing the pipeline configuration files for your environment, environment variables are used to provide a single location for most configuration options. These environment variables will be referred to in the remaining instructions. A [reference](#environment-variable-reference) of all environment variables can be found [here](#environment-variable-reference).

Depending on your environment there may be many ways to define environment variables. The files `profile.d/synesis_lite_syslog.sh` and `logstash.service.d/synesis_lite_syslog.conf` are provided to help you with this setup.

Recent versions of both RedHat/CentOS and Ubuntu use `systemd` to start background processes. When deploying sýnesis&trade; Lite for Syslog on a host where Logstash will be managed by `systemd`, copy `logstash.service.d/synesis_lite_syslog.conf` to `/etc/systemd/system/logstash.service.d/synesis_lite_syslog.conf`. Any configuration changes can then be made by editing this file.

> Remember that for your changes to take effect, you must issue the command `sudo systemctl daemon-reload`.

### 4. Add the sýnesis&trade; Lite for Syslog pipeline to pipelines.yml

Logstash 6.0 introduced the ability to run multiple pipelines from a single Logstash instance. The `pipelines.yml` file is where these pipelines are configured. While a single pipeline can be specified directly in `logstash.yml`, it is a good practice to use `pipelines.yml` for consistency across environments.

Edit `pipelines.yml` (usually located at `/etc/logstash/pipelines.yml`) and add the sýnesis&trade; Lite for Syslog pipeline (adjust the path as necessary).

```plaintext
- pipeline.id: synesis_lite_syslog
  path.config: "/etc/logstash/synesis_lite_syslog/conf.d/*.conf"
```

### 5. Configure the input

By default flow data will be recieved on all IPv4 addresses of the Logstash host using the standard syslog port `514`. You can change both the IPs and ports used by modifying the following environment variables:

Environment Variable | Description | Default Value
--- | --- | ---
SYNLITE_SYSLOG_TCP_IPV4_HOST | The IPv4 address from which to listen for syslog messages over TCP | 0.0.0.0
SYNLITE_SYSLOG_TCP_IPV4_PORT | The TCP port on which to listen for syslog messages | 514
SYNLITE_SYSLOG_UDP_IPV4_HOST | The IPv4 address from which to listen for syslog messages over UDP | 0.0.0.0
SYNLITE_SYSLOG_UDP_IPV4_PORT | The UDP port on which to listen for syslog messages | 514

Collection of syslog messages over IPv6 is disabled by default to avoid issues on systems without IPv6 enabled. To enable IPv6 rename the following file in the `synesis_lite_syslog/conf.d` directory, removing `.disabled` from the end of the name: `10_input_ipv6.logstash.conf.disabled`. Similiar to IPv4, the IPv6 input can be configured using environment variables:

Environment Variable | Description | Default Value
--- | --- | ---
SYNLITE_SYSLOG_TCP_IPV6_HOST | The IPv6 address from which to listen for syslog messages over TCP | [::]
SYNLITE_SYSLOG_TCP_IPV6_PORT | The TCP port on which to listen for syslog messages | 50514
SYNLITE_SYSLOG_UDP_IPV6_HOST | The IPv6 address from which to listen for syslog messages over UDP | [::]
SYNLITE_SYSLOG_UDP_IPV6_PORT | The UDP port on which to listen for syslog messages | 50514

To improve UDP input performance for high volume log collection, the default values for UDP input `workers` and `queue_size` are increased. The default values are `2` and `2000` respecitvely. sýnesis&trade; Lite for Syslog increases these to `4` and `4096`. Further tuning is possible using the following environment variables.

Environment Variable | Description | Default Value
--- | --- | ---
SYNLITE_SYSLOG_UDP_WORKERS | The number of UDP input threads | 4
SYNLITE_SYSLOG_UDP_QUEUE_SIZE | The number of unprocessed UDP packets the input can buffer | 4096
SYNLITE_SYSLOG_UDP_RCV_BUFF | The UDP socket receive buffer size (bytes) | 33554432

> WARNING! Increasing `queue_size` will increase heap_usage. Make sure have configured JVM heap appropriately as specified in the [Requirements](#requirements)

### 6. Configure the Elasticsearch output

Obviously the data needs to land in Elasticsearch, so you need to tell Logstash where to send it.

The default is to send data to only a single Elasticsearch node. This node is specified using the following environment variable:

Environment Variable | Description | Default Value
--- | --- | ---
SYNLITE_SYSLOG_ES_HOST | The Elasticsearch host to which the output will send data | 127.0.0.1:9200

Optionally Logstash can be configured to use an array of three Elasticsearch nodes. This is done by completing the following steps:

1. Rename `30_output_10_single.logstash.conf` to `30_output_10_single.logstash.conf.disabled`
2. Rename `30_output_20_multi.logstash.conf.disabled` to `30_output_20_multi.logstash.conf`
3. Set the following environment variables:

Environment Variable | Description | Default Value
--- | --- | ---
SYNLITE_SYSLOG_ES_HOST_1 | The first Elasticsearch host to which the output will send data | 127.0.0.1:9200
SYNLITE_SYSLOG_ES_HOST_2 | The second Elasticsearch host to which the output will send data | 127.0.0.2:9200
SYNLITE_SYSLOG_ES_HOST_3 | The third Elasticsearch host to which the output will send data | 127.0.0.3:9200

To complete the setup of the Elasticsearch output, configure the following environment variables as required for your environment:

Environment Variable | Description | Default Value
--- | --- | ---
SYNLITE_SYSLOG_ES_USER | The username for the connection to Elasticsearch | elastic
SYNLITE_SYSLOG_ES_PASSWORD | The password for the connection to Elasticsearch | changeme
SYNLITE_SYSLOG_ES_SSL_ENABLE | Enable or disable SSL connection to Elasticsearch | false
SYNLITE_SYSLOG_ES_SSL_VERIFY | Enable or disable verification of the SSL certificate. If enabled, the output must be edited to set the path to the certificate. | false

> If you are only using the open-source version of Elasticsearch, it will ignore the username and password. In that case just leave the defaults.

> If `SYNLITE_SYSLOG_ES_SSL_ENABLE` and `SYNLITE_SYSLOG_ES_SSL_VERIFY` are both `true`, you must uncomment the `cacert` option in the Elasticsearch output and set the path to the certificate.

### 8. Enable DNS name resolution (optional)

In the past it was recommended to avoid DNS queries as the latency costs of such lookups had a devastating effect on throughput. While the Logstash DNS filter provides a caching mechanism, its use was not recommended. When the cache was enabled all lookups were performed synchronously. If a name server failed to respond, all other queries were stuck waiting until the query timed out. The end result was even worse performance.

Fortunately these problems have been resolved. Release 3.0.8 of the DNS filter introduced an enhancement which caches timeouts as failures, in addition to normal NXDOMAIN responses. This was an important step as many domain owner intentionally setup their nameservers to ignore the reverse lookups needed to enrich flow data. In addition to this change, I submitted am enhancement which allows for concurrent queries when caching is enabled. The Logstash team approved this change, and it is included in 3.0.10 of the plugin.

With these changes I can finally give the green light for using DNS lookups to enrich the incoming log data. You will see a little slow down in throughput until the cache warms up, but that usually lasts only a few minutes. Once the cache is warmed up, the overhead is minimal, and event rates averaging 10K/s and as high as 40K/s were observed in testing.

The key to good performance is setting up the cache appropriately. Most likely it will be DNS timeouts that are the source of most latency. So ensuring that a higher volume of such misses can be cached for longer periods of time is most important.

The DNS lookup features of sýnesis&trade; Lite for Syslog can be configured using the following environment variables:

Environment Variable | Description | Default Value
--- | --- | ---
SYNLITE_SYSLOG_RESOLVE_IP2HOST | Enable/Disable DNS requests. | false
SYNLITE_SYSLOG_NAMESERVER | The DNS server to which the dns filter should send requests | 127.0.0.1
SYNLITE_SYSLOG_DNS_HIT_CACHE_SIZE | The cache size for successful DNS queries | 10000
SYNLITE_SYSLOG_DNS_HIT_CACHE_TTL | The time in seconds successful DNS queries are cached | 900
SYNLITE_SYSLOG_DNS_FAILED_CACHE_SIZE | The cache size for failed DNS queries | 25000
SYNLITE_SYSLOG_DNS_FAILED_CACHE_TTL | The time in seconds failed DNS queries are cached | 3600

### 9. Specify how @timestamp is set

By default `@timestamp` is set to the time that Logstash received the message. Alternatively the timestamp from the syslog message can be used by configuring the following environment variables:

Environment Variable | Description | Default Value
--- | --- | ---
SYNLITE_SYSLOG_MSG_TIMESTAMP | Whether to use the timestamp from the received message to set `@timestamp`. | true
SYNLITE_SYSLOG_TZ | The timezone of the timestamp of the incoming messages. | UTC

### 10. Start Logstash

You should now be able to start Logstash and begin collecting syslog data. Assuming you are running a recent version of RedHat/CentOS or Ubuntu, and using `systemd`, complete these steps:

1. Run `systemctl daemon-reload` to ensure any changes to the environment variables are recognized.
2. Run `systemctl start logstash`

> NOTICE! Make sure that you have already setup the Logstash init files by running `LS_HOME/bin/system-install`. If the init files have not been setup you will receive an error.

To follow along as Logstash starts you can tail its log by running:

```
tail -f /var/log/logstash/logstash-plain.log
```

**Logstash takes a little time to start... BE PATIENT!**

Logstash setup is now complete. If you are receiving syslog messages, you should have a `syslog-` daily index in Elasticsearch.

## Setting up Kibana

Kibana 6.5 introduced the ability to export and import Index Patterns through the UI. This greatly simplifies the setup of Kibana.

### Kibana 7.0.0 and Later

The Index Patterns, vizualizations and dashboards can be loaded into Kibana by importing the `synesis_lite_kibana.kibana.<VER>.json` file from within the Kibana UI. This is done from the `Management -> Saved Objects` page.

### Recommended Kibana Advanced Settings

You may find that modifying a few of the Kibana advanced settings will produce a more user-friendly experience while using sýnesis&trade; Lite for Syslog. These settings are made in Kibana, under `Management -> Advanced Settings`.

Advanced Setting | Value | Why make the change?
--- | --- | ---
doc_table:highlight | false | There is a pretty big query performance penalty that comes with using the highlighting feature. As it isn't very useful for this use-case, it is better to just trun it off.
filters:pinnedByDefault | true | Pinning a filter will it allow it to persist when you are changing dashbaords. This is very useful when drill-down into something of interest and you want to change dashboards for a different perspective of the same data. This is the first setting I change whenever I am working with Kibana.
state:storeInSessionStorage | true | Kibana URLs can get pretty large. Especially when working with Vega visualizations. This will likely result in error messages for users of Internet Explorer. Using in-session storage will fix this issue for these users.
timepicker:quickRanges | [see below](#recommended-setting-for-timepicker:quickRanges) | The default options in the Time Picker are less than optimal, for most logging and monitoring use-cases. Fortunately Kibana now allows you to customize the time picker. Our recommended settings can be found [see below](#recommended-setting-for-timepicker:quickRanges).

## Environment Variable Reference

The supported environment variables are:

Environment Variable | Description | Default Value
--- | --- | ---
SYNLITE_SYSLOG_TEMPLATE_PATH | The location of the index template. | /etc/logstash/synesis_lite_syslog/templates
SYNLITE_SYSLOG_GROK_PATTERNS_DIR | The location of the grok pattern files. | /etc/logstash/synesis_lite_syslog/patterns
SYNLITE_SYSLOG_TCP_IPV4_HOST | The IPv4 address from which to listen for syslog messages over TCP | 0.0.0.0
SYNLITE_SYSLOG_TCP_IPV4_PORT | The TCP port on which to listen for syslog messages | 514
SYNLITE_SYSLOG_UDP_IPV4_HOST | The IPv4 address from which to listen for syslog messages over UDP | 0.0.0.0
SYNLITE_SYSLOG_UDP_IPV4_PORT | The UDP port on which to listen for syslog messages | 514
SYNLITE_SYSLOG_TCP_IPV6_HOST | The IPv6 address from which to listen for syslog messages over TCP | [::]
SYNLITE_SYSLOG_TCP_IPV6_PORT | The TCP port on which to listen for syslog messages | 50514
SYNLITE_SYSLOG_UDP_IPV6_HOST | The IPv6 address from which to listen for syslog messages over UDP | [::]
SYNLITE_SYSLOG_UDP_IPV6_PORT | The UDP port on which to listen for syslog messages | 50514
SYNLITE_SYSLOG_UDP_WORKERS | The number of UDP input threads | 4
SYNLITE_SYSLOG_UDP_QUEUE_SIZE | The number of unprocessed UDP packets the input can buffer | 4096
SYNLITE_SYSLOG_UDP_RCV_BUFF | The UDP socket receive buffer size (bytes) | 33554432
SYNLITE_SYSLOG_ES_HOST | The Elasticsearch host to which the output will send data | 127.0.0.1:9200
SYNLITE_SYSLOG_ES_HOST_1 | The first Elasticsearch host to which the output will send data | 127.0.0.1:9200
SYNLITE_SYSLOG_ES_HOST_2 | The second Elasticsearch host to which the output will send data | 127.0.0.2:9200
SYNLITE_SYSLOG_ES_HOST_3 | The third Elasticsearch host to which the output will send data | 127.0.0.3:9200
SYNLITE_SYSLOG_ES_USER | The username for the connection to Elasticsearch | elastic
SYNLITE_SYSLOG_ES_PASSWORD | The password for the connection to Elasticsearch | changeme
SYNLITE_SYSLOG_ES_SSL_ENABLE | Enable or disable SSL connection to Elasticsearch | false
SYNLITE_SYSLOG_ES_SSL_VERIFY | Enable or disable verification of the SSL certificate. If enabled, the output must be edited to set the path to the certificate. | false
SYNLITE_SYSLOG_RESOLVE_IP2HOST | Enable/Disable DNS requests. | false
SYNLITE_SYSLOG_NAMESERVER | The DNS server to which the dns filter should send requests | 127.0.0.1
SYNLITE_SYSLOG_DNS_HIT_CACHE_SIZE | The cache size for successful DNS queries | 10000
SYNLITE_SYSLOG_DNS_HIT_CACHE_TTL | The time in seconds successful DNS queries are cached | 900
SYNLITE_SYSLOG_DNS_FAILED_CACHE_SIZE | The cache size for failed DNS queries | 25000
SYNLITE_SYSLOG_DNS_FAILED_CACHE_TTL | The time in seconds failed DNS queries are cached | 3600
SYNLITE_SYSLOG_MSG_TIMESTAMP | Whether to use the timestamp from the received message to set `@timestamp`. | true
SYNLITE_SYSLOG_TZ | The timezone of the timestamp of the incoming messages. | UTC

## Recommended Setting for timepicker:quickRanges

I recommend configuring `timepicker:quickRanges` for the setting below. The result will look like this:

![timepicker:quickRanges](https://user-images.githubusercontent.com/10326954/57178139-9a8d8500-6e6c-11e9-8539-db61a81b321b.png)

```
[
  {
    "from": "now-15m",
    "to": "now",
    "display": "Last 15 minutes"
  },
  {
    "from": "now-30m",
    "to": "now",
    "display": "Last 30 minutes"
  },
  {
    "from": "now-1h",
    "to": "now",
    "display": "Last 1 hour"
  },
  {
    "from": "now-2h",
    "to": "now",
    "display": "Last 2 hours"
  },
  {
    "from": "now-4h",
    "to": "now",
    "display": "Last 4 hours"
  },
  {
    "from": "now-12h",
    "to": "now",
    "display": "Last 12 hours"
  },
  {
    "from": "now-24h",
    "to": "now",
    "display": "Last 24 hours"
  },
  {
    "from": "now-48h",
    "to": "now",
    "display": "Last 48 hours"
  },
  {
    "from": "now-7d",
    "to": "now",
    "display": "Last 7 days"
  },
  {
    "from": "now-30d",
    "to": "now",
    "display": "Last 30 days"
  },
  {
    "from": "now-60d",
    "to": "now",
    "display": "Last 60 days"
  },
  {
    "from": "now-90d",
    "to": "now",
    "display": "Last 90 days"
  },
  {
    "from": "now/d",
    "to": "now/d",
    "display": "Today"
  },
  {
    "from": "now/w",
    "to": "now/w",
    "display": "This week"
  },
  {
    "from": "now/M",
    "to": "now/M",
    "display": "This month"
  },
  {
    "from": "now/d",
    "to": "now",
    "display": "Today so far"
  },
  {
    "from": "now/w",
    "to": "now",
    "display": "Week to date"
  },
  {
    "from": "now/M",
    "to": "now",
    "display": "Month to date"
  }
]
```
