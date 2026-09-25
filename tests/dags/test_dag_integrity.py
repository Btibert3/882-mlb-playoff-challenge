"""Basic DAG integrity test — runs automatically in CI."""
import pytest
from airflow.models import DagBag


@pytest.fixture()
def dagbag():
    return DagBag(dag_folder="dags/", include_examples=False)


def test_no_import_errors(dagbag):
    assert not dagbag.import_errors, dagbag.import_errors


def test_dag_exists(dagbag):
    assert "mlb_pipeline" in dagbag.dags
