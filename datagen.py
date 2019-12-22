import os,sys,json
import random

import uuid 
import time
'''
{"msgId": "xxx-yyy-zzzz-asdfas", "sourceLabels": {"sourceGroup": "trc", "srcSubGroup":"la","sourceId":"water201"}, "data":[{"logicalTime": 1576054800000, "processingTime":1576054800000, "labels": {"msgtype":"ProtoMultiRequest"}, "value":5}, {"logicalTime": 1576054800000, "processingTime":1576054800000, "labels": {"msgtype":"ProtoUserEvent"}, "value":10}]}
'''

def generateMsgId():
	return str(uuid.uuid1())

sourceGroups = [\
	{"sourceGroup": "trc", "srcSubGroup":"la","sourceId":"water201"},\
	{"sourceGroup": "trc", "srcSubGroup":"us","sourceId":"water101"},\
	{"sourceGroup": "kfc", "srcSubGroup":"","sourceId":"kfc001"},\
	{"sourceGroup": "kfc", "srcSubGroup":"","sourceId":"kfc002"},\
]

def generateSourceLabels():
	return random.choice(sourceGroups)

trc_produced_data = {}
TRC_RATE = 50*1000

def generateValue(logicalTime, sourceGroup):
	if sourceGroup == 'trc':
		trc =  random.randint(TRC_RATE,TRC_RATE);
		trc_produced_data[logicalTime] = trc_produced_data.get(logicalTime, 0) + trc
		return trc
	else:
		kfc = random.randint(0,trc_produced_data.get(logicalTime,0))
		delta = trc_produced_data.get(logicalTime, 0) - kfc
		if delta == 0 and logicalTime in trc_produced_data:
			del trc_produced_data[logicalTime]
		else:
			trc_produced_data[logicalTime] = trc_produced_data.get(logicalTime, 0) - kfc

		return kfc

current_milli_time = lambda secs: int(round(secs * 1000))
truncateToMinute = lambda millis: millis - millis%(60*1000)

types = ['ProtoMultiRequest', 'ProtoUserEvent']
def generateData(sourceGroup):
	logicalTime = truncateToMinute(current_milli_time(time.time()-random.randint(1,30)*60))
	
	if sourceGroup == 'kfc' and len(trc_produced_data) > 0:
		logicalTime = random.choice(list(trc_produced_data.keys()))

	return [ {\
				"logicalTime": logicalTime, \
				"processingTime": current_milli_time(time.time()), \
				"labels": \
					{\
						"msgtype":random.choice(types) \
					 	
					 }, \
				"value": generateValue(logicalTime, sourceGroup) \
			}
			for i in range(random.randint(1,5)) ]
	

def main(sleepTime):
	while(True):
		srcLabels = generateSourceLabels()
		msg={"msgId": generateMsgId(),\
			"sourceLabels": srcLabels,\
			"data": generateData(srcLabels['sourceGroup'])}

		json.dump(msg, sys.stdout)
		sys.stdout.write("\n")
		sys.stdout.flush()
		time.sleep(sleepTime)


#python datagen.py 1 | kafka-console-producer --broker-list localhost:29092  --topic raw_sla_reports
if __name__ == "__main__":
    main(int(sys.argv[1]))