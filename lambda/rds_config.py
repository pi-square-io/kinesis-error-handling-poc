#config file containing credentials for RDS MySQL instance
import os
rds_host = os.environ['rds_host']
db_username = os.environ['db_username']
db_password = os.environ['db_password']
db_name = os.environ['db_name']