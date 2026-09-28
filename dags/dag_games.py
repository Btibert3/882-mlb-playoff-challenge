from datetime import datetime
from airflow.decorators import dag, task

BASE_URL = "https://btibert-bu--ba882-mlb-api-serve.modal.run"
DB_PATH = "/usr/local/airflow/mlb.duckdb"


@dag(
    schedule="@daily",
    start_date=datetime(2026, 8, 1),
    end_date=datetime(2026, 9, 28),
    catchup=True,
)
def games():

    @task
    def fetch_games(ds=None):
        import requests
        import pandas as pd
        import duckdb

        date = ds  # Airflow passes the execution date as YYYY-MM-DD

        resp = requests.get(f"{BASE_URL}/games", params={"date": date})
        resp.raise_for_status()
        df = pd.DataFrame(resp.json())

        con = duckdb.connect(DB_PATH)
        con.execute("CREATE TABLE IF NOT EXISTS raw_games AS SELECT * FROM df LIMIT 0")
        con.execute("INSERT INTO raw_games SELECT * FROM df")
        con.close()

    fetch_games()


games()
