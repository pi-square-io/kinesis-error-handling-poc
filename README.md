# KDS_ERROR_HANDLING_POC
## _Solve kinesis blocked streams issues_

Kinesis Data Streams (KDS) allows to collect and push data in real time, allowing to process your data in real time from thousands of data sources. 



### Main Kinesis Streams cons :

- Can easily become  a bottelneck. 
- If one message is not proceessed correctly, the stream is blocked. 

## Objective 

The goal of this code is to : 

- Automate the cretion of a Dead Letter Queue (SQS queue containing failed messages) 
- Split batch messages from kinesis to isolate the error. 
- Automatically handle messages in error and send them to SQS. 

## Schema

![](https://github.com/pi-square-io/kinesis-error-handling-poc/blob/main/schema.png)

## Lambda Error Handling (poison messages):

Considering  the case of a specific corrupt record which should be rejected by the Lambda. If this is not handled, the Lambda function will retry until the record is eventually expired by the Kinesis stream. In this case, there are two options to handle message failures. 

The first one is to configure the following retry and failure behaviors settings with Lambda as the consumer for Kinesis Data Streams:

- On-failure destination : Automatically send records that fail processing to an SQS queue.
- Retry attempts: Control the maximum retries per batch.
- Split batch on error : Split a failed batch into two batches. Retrying with smaller batches isolates bad records.
