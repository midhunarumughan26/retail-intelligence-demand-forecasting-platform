from datetime import datetime

from airflow.sdk import DAG
from airflow.providers.standard.operators.bash import BashOperator


with DAG(
    dag_id="retail_intelligence_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["retail", "analytics"],
) as dag:

    run_etl = BashOperator(
        task_id="run_python_etl",
        bash_command="python /opt/airflow/python/etls/retail_etl.py",
    )

    run_dbt = BashOperator(
        task_id="run_dbt",
        bash_command="cd /opt/airflow/dbt/retail_analytics && dbt run",
    )

    test_dbt = BashOperator(
        task_id="test_dbt",
        bash_command="cd /opt/airflow/dbt/retail_analytics && dbt test",
    )

    run_etl >> run_dbt >> test_dbt