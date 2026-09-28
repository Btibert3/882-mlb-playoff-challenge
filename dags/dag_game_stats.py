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
def game_stats():

    @task
    def fetch_game_stats(ds=None):
        import requests
        import pandas as pd
        import duckdb

        date = ds

        resp = requests.get(f"{BASE_URL}/game_stats", params={"date": date})
        resp.raise_for_status()
        df = pd.DataFrame(resp.json())

        if df.empty:
            return

        con = duckdb.connect(DB_PATH)
        con.execute("CREATE TABLE IF NOT EXISTS raw_game_stats AS SELECT * FROM df LIMIT 0")
        con.execute("INSERT INTO raw_game_stats SELECT * FROM df")
        con.close()

    fetch_game_stats()


game_stats()
