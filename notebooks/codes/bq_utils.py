from google.cloud import bigquery

def bq_query_to_dataframe(sql_query):
  client = bigquery.Client()
  rows = client.query(sql_query).result()
  df = rows.to_dataframe()
  return df