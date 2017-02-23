#!/bin/bash

#simple ELK installer with Docker

# need root auth
if [ "$(id -u)" != "0" ]; then echo -e "[!] Must be run with root auth: sudo bash $0"; exit 1; fi

# update and install curl for testing
apt update
apt install -y curl

# Elasticsearch
mkdir /esdata
docker run -d --name elasticsearch  -p 9200:9200 -p 9300:9300 -v /esdata:/usr/share/elasticsearch/data elasticsearch
curl -X GET http://localhost:9200

# Logstash
mkdir /logstash
echo -e '
input {
	beats {
		port => 5044
	}
}
filter {
	if [type] == "syslog" {
	grok {
		match => { "message" => "%{SYSLOGLINE}" }
	}

	date {
		match => [ "timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
	}
}

}
output {
	elasticsearch {
		hosts => ["elasticsearch:9200"] 
		index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
	}
	stdout {
		codec => rubydebug
	}
}
' > /logstash/logstash.conf
cd /logstash/
docker run -d --name logstash -p 5044:5044 --link elasticsearch:elasticsearch -v "$PWD":/logstash logstash -f /logstash/logstash.conf

# Kibana
docker run --name kibana --link elasticsearch:elasticsearch -p 5601:5601 -d kibana

# beats clients
# Packetbeat – Analyze network packet data.
# Filebeat – Real-time insight into log data.
# Topbeat – Get insights from infrastructure data.
# Metricbeat – Ship metrics to Elasticsearch.
#
# Filebeat ( http://www.itzgeek.com/how-tos/linux/ubuntu-how-tos/setup-elk-stack-ubuntu-16-04.html#filebeat )
# Config: vim /etc/filebeat/filebeat.yml
# Config Test: filebeat --configtest -c /etc/filebeat/filebeat.yml
# systemctl restart filebeat
