echo "bringing all dockers up"
docker-compose up -d

echo "starting es"
nohup elasticsearch &> es.log &

echo "starting kibana"
nohup kibana &> kibana.log &

echo "starting logstash"
nohup logstash -f logstash.conf --config.reload.automatic &> logstash.log &


sleep 10

./es.sh


docker exec  -it ksqldb-cli ksql http://ksqldb-server:8088
RUN SCRIPT '/parent/sla-queries.kql';

#curl -s -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" -d "{\"ksql\": \"RUN SCRIPT '/parent/sla-queries.kql' ;\", \"streamsProperties\": {}}"

nohup python datagen.py 1 | kafka-console-producer --broker-list localhost:29092  --topic raw_sla_reports &> datagen.log &