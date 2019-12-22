# http://localhost:5601/app/kibana#/dev_tools/console
echo "deleting index"
curl -XDELETE "http://localhost:9200/sla"

echo "creating index"
curl -XPUT "http://localhost:9200/sla" -H 'Content-Type: application/json' -d' 
{
    "mappings" : {
      "sla_mapping" : {
        "properties" : {
          "WINDOW_START" : {
            "type" : "date",
            "format": "epoch_millis"
          },
          "AGGKEY" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 1024
              }
            }
          },
          "MSGTYPE" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "SOURCEGROUP" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "TOTAL_PROTOS" : {
            "type" : "long"
          },
          "ZERO_TO_ONE_MIN" : {
            "type" : "long"
          },
          "ONE_TO_FIVE_MINS" : {
            "type" : "long"
          },
          "FIVE_TO_TEN_MINS" : {
            "type" : "long"
          },
          "TEN_TO_THIRTY_MINS" : {
            "type" : "long"
          },
           "MORE_THAN_THIRTY_MINS" : {
            "type" : "long"
          }
        }
      }
    }
}' | jq

echo "checking index"
curl "http://localhost:9200/sla" | jq


echo "searching in index"
curl "http://localhost:9200/sla/_search" | jq