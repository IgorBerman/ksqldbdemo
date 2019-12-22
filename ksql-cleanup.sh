echo "terminate all queries:"
curl -s -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" -d '{"ksql": "show queries;", "streamsProperties": {}}' 2>/dev/null | jq -r '.[].queries[].id' | xargs -t -I {} curl -s -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" -d'{"ksql": "terminate {};"}' | jq

echo "terminate all streams"
curl -s -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" -d $'{"ksql": "show streams;", "streamsProperties": {}}' 2>/dev/null | jq -r '.[].streams[].name' | grep -v KSQL_PROCESSING_LOG | xargs -t -I {} curl -s -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" -d'{"ksql": "DROP STREAM IF EXISTS {}  DELETE TOPIC; "}' | jq

echo "terminate tables"
curl -s -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" -d $'{"ksql": "show tables;", "streamsProperties": {}}' 2>/dev/null | jq -r '.[].tables[].name' | grep -v KSQL_PROCESSING_LOG | xargs -t -I {} curl -s -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" -d'{"ksql": "DROP TABLE IF EXISTS {}  DELETE TOPIC; "}' | jq




#curl -s -X "POST" "http://localhost:8088/ksql/terminate"   -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" -d'{}'