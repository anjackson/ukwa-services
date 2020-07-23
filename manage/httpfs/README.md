HttpFS
------

This is a Docker Stack for deploying a load-balanced service based on the [UKWA fork of HttpFS](https://github.com/ukwa/httpfs).

It uses an embedded load balancer, [based on HAProxy](https://github.com/docker-archive/dockercloud-haproxy), as this provides support for detailed stats, which can then be used with [haproxy_exporter](https://github.com/prometheus/haproxy_exporter) to integrate with our Prometheus monitoring service.

It exposes HttpFS over port 14000, HAProxy stats on port 1937 (username/password is stats/stats), and metrics for Prometheus on port 19101. The `hdfs.[d|b|]api.wa.bl.uk` endpoints should be directed to `[swarm-host]:14000`.

It has an embedded Hadoop configuration, specifying the information needed to run the service. The namenode is defined as `hdfs://namenode:54310`, and so when deploying the stack the namenode hostname-to-IP address mapping must be provided as an extra host.

The HttpFS service must be running under a _username_ that is allowed to proxy requests for other users. The configuration of which usernames can impersonate with other names is on the NameNode, not embedded here[^1]. The same _username_ must also be defined in the container, but the resulting `UID` may correspond to a different user on the Docker Swarm host. Currently, the container uses the `tomcat` user, in the same way as the original HttpFS service.

[^1]: As per [the documentation](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/Superusers.html#Configurations) we should consider limiting the users that the HttpFS service can impersonate.

