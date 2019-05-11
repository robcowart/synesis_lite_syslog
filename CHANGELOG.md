## v1.1.0

v1.1.0 is a minor release. No migration of data from v1.0.x to v1.1.0 is required.

### Breaking Changes

sýnesis&trade; Lite for Syslog v1.1.0 provides support Elastic Stack 7.0.x. The support for document types has been completely removed in Elasticsearch 7.0.0. This has required changes to the index templates provided with sýnesis&trade; Lite for Syslog. You _MUST_ first successfully upgrade to Elastic Stack 7.0.x _PRIOR_ to using sýnesis&trade; Lite for Syslog v1.1.0.

### New Features

* Support for Elastic Stack 7.0.x
* Support for running Logstash in a Docker container.
* Support for RFC 5424 formatted messages.
* Listen on both IPv4 and IPv6 addresses.
* Optionally send data to multiple Elasticsearch nodes.
* Support caching of DNS responses.

### Updates

* Support for additional syslog timestamp formats.

---

## v1.0.1

v1.0.1 is a minor release. No migration of data from v1.0.0 to v1.0.1 is required.

### New Features

* Added config file to help setup ENV vars.

### Updates

* Updated timestamp matching.

### Fixes

* Fixed incorrect default grok pattern directory.
* Make hostnames lowercase.

---

## v1.0.0

Developed and tested with Elastic Stack 6.1.1.
