# Introduction 
A example project to create an elasticsearch and a subscription filter to get logs inside the CloudWatch and send to lambda. The lambda will send the data to elasticsearch.

# Getting Started
First of all, clone the repository.

1.	Installation process
  - You need to install terraform. See <a href="https://www.terraform.io/downloads.html">docs</a>.

# Build and Test
To deploy to AWS, you need to use some commands inside folder src:
  - terraform init
  - terraform plan (It will show what will be happen when you run the command apply)
  - terraform apply (This apply the configuration)

# Documentation Kibana
  - https://www.elastic.co/guide/en/kibana/7.4/index.html

# SQL Kibana
  - It's possible to access the data and do querys (SQL)
  - Documentation: https://www.elastic.co/guide/en/elasticsearch/reference/current/xpack-sql.html

# Deleting existing indexes
  - Inside the panel Kibana, access the tool Dev Tools, it will show a console.
  - Search the index: GET /_cat/indices?v
  - To delete, use the command: DELETE /INDEX_NAME_TO_DELETE

# Create a index pattern
  - https://localhost:9200/_plugin/kibana/app/kibana#/management/kibana/index_pattern?_g=()

# See more
<a href="https://www.terraform.io/docs/">https://www.terraform.io/docs/</a>