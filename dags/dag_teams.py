from datetime import datetime
from airflow.decorators import dag, task

BASE_URL = "https://btibert-bu--ba882-mlb-api-serve.modal.run"
DB_PATH = "/usr/local/airflow/mlb.duckdb"


@dag(schedule_interval="@once", start_date=datetime(2026, 9, 29), catchup=False)
def teams():

    @task
    def fetch_teams():
        import requests
        import pandas as pd
        import duckdb

        resp = requests.get(f"{BASE_URL}/teams")
        resp.raise_for_status()
        df = pd.DataFrame(resp.json())

        con = duckdb.connect(DB_PATH)
        # duckdb (and motherduck) let us write SQL and the know how to ingest/import data 
        # from the dataframe df referenced by the command!
        con.execute("CREATE OR REPLACE TABLE raw_teams AS SELECT * FROM df")
        con.close()

    fetch_teams()


teams()
