#import json
import base64
from typing import Sequence
import sys
import rds_config
import pymysql

def lambda_handler(event, context):
    rds_host  = rds_config.rds_host
    name = rds_config.db_username
    password = rds_config.db_password
    db_name = rds_config.db_name
    try:
        conn = pymysql.connect(host=rds_host, user=name, passwd=password, db=db_name)
    except pymysql.MySQLError as e:
        print("ERROR: Unexpected error: Could not connect to MySQL instance.")
        sys.exit()
    with conn.cursor() as cur:
        for record in event['Records']:
            payload=base64.b64decode(record["kinesis"]["data"])
            payload=payload.decode("utf-8")
            print("Decoded payload: " + str(payload))
            if(payload[0].isnumeric()):
                SequenceNum=record["kinesis"]["sequenceNumber"]
                raise Exception("Failed")
            else:
                data='insert into hermes (content) values("{0}")'.format(payload)
                print(data)
                cur.execute(data)
        # cur.execute("create table hermes (id int NOT NULL AUTO_INCREMENT , content varchar(255), PRIMARY KEY(id) )")


                conn.commit()
    cur.close()