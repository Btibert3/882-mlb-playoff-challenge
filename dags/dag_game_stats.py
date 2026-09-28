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
        """Fetch game stats for all games played on {{ ds }} and append to raw_game_stats.

        Read the /game_stats endpoint in the API docs before writing anything.
        Understand what one row represents and what field connects this table
        back to raw_games before you start coding.
        """
        pass

    fetch_game_stats()


game_stats()
