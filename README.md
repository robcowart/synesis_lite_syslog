# sýnesis&trade; Lite for Syslog

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/robcowart)

sýnesis&trade; Lite for Syslog provides basic log analytics for syslog messages using the Elastic Stack.

![synesis_lite_syslog](https://user-images.githubusercontent.com/10326954/57570754-b7463180-7405-11e9-8dfb-f0323f072d9b.png)

## Getting Started

sýnesis&trade; Lite for Syslog is built using the Elastic Stack, including Elasticsearch, Logstash and Kibana. Please refer to [INSTALL.md](https://github.com/robcowart/synesis_lite_syslog/blob/master/INSTALL.md) for instructions on how to install and configure sýnesis&trade; Lite for Syslog.

If you are new to the Elastic Stack, this video goes beyond a simple default installation of Elasticsearch and Kibana. It discusses real-world best practices for hardware sizing and configuration, providing production-level performance and reliability.

[![es_install_thumbnail](https://user-images.githubusercontent.com/10326954/75727859-58301100-5ce6-11ea-9ed7-2c93bb1df111.png)](https://youtu.be/gZb7HpVOges)

## Dashboards

The following dashboards are provided.

### Overview

The Overview dashboard provides a summary of received Syslog messages by severity, node, process and facility.

![Overview](https://user-images.githubusercontent.com/10326954/57570745-a85f7f00-7405-11e9-97dd-0211defe0dfc.png)

### Top-N

![Top-N](https://user-images.githubusercontent.com/10326954/57570748-ad243300-7405-11e9-99ce-95bd46fcc1aa.png)

### Log Browser

The Log Browser dashboard allows for easy browsing of the raw Syslog messages that have been received.

![Log Browser](https://user-images.githubusercontent.com/10326954/57570750-b1505080-7405-11e9-8b2b-b434b79cf34d.png)
