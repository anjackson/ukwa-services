

useradd -u 50000 -G docker airflow

./deploy-airflow.sh /home/anj/gitlab/ukwa-services-env/dev.env

DockerOperator work fine but must return 1 on errors to get picked up. Presumably stderr gets logged and stdout is for XCom and should return JSON.

http://dev1.n45.wa.bl.uk:5050/admin/metrics/


https://eugeneyan.com/writing/why-airflow-jobs-one-day-late/
