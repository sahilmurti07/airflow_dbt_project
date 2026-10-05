from datetime import datetime, timezone
import time
from airflow.decorators import dag, task
from airflow.operators.bash import BashOperator

@dag(
    
    start_date=datetime(2024, 1, 1, tzinfo=timezone.utc), 
    schedule="0 12 * * *", 
    catchup=False
    )
def orchestrate(): 
    
    @task
    def ingest_cdc():
        from databricks.sdk import WorkspaceClient
        from databricks.sdk.service.jobs import RunLifeCycleState, RunResultState

        ws = WorkspaceClient(
        host="https://dbc-70a4493d-4d3e.cloud.databricks.com",
        token="dapi248c2071a1aa9295d2db89348cbd9484"
        )
        
        job_trigger = ws.jobs.run_now(job_id=565619473391434)

        while True:
            job_run = ws.jobs.get_run(run_id=job_trigger.run_id)
            print(f"Job run state: {job_run.state.life_cycle_state}, result state: {job_run.state.result_state}")
            if job_run.state.life_cycle_state in [RunLifeCycleState.TERMINATED, RunLifeCycleState.SKIPPED, RunLifeCycleState.INTERNAL_ERROR]:
                if job_run.state.result_state == RunResultState.SUCCESS:
                    print("Job completed successfully.")
                    break    
                else:
                    raise Exception(f"Job failed with state: {job_run.state.result_state}")  # noqa: TRY002
        
            time.sleep(10) 
        return "Ingesting CDC data"
    
    clean_target = BashOperator(
        task_id="clean_target",
        bash_command="rm -rf /opt/airflow/walmart/target && rm -rf /opt/airflow/walmart/logs && rm -rf /opt/airflow/walmart/dbt_packages",
    )
    
    source_freshness = BashOperator(
        task_id="source_freshness",
        bash_command="cd /opt/airflow/walmart && dbt source freshness",
    )

    silver_technical = BashOperator(
        task_id = "silver_technical",
        bash_command = "cd /opt/airflow/walmart && dbt run --select silver_t"
    )
    
    silver_technical_test = BashOperator(
        task_id = "silver_technical_test",
        bash_command = "cd /opt/airflow/walmart && dbt test --select models/silver_t",
    )
    
    silver_business = BashOperator(
        task_id = "silver_business",
        bash_command = "cd /opt/airflow/walmart && dbt run --select models/silver_b",
    )
    
    silver_business_test = BashOperator(
        task_id = "silver_business_test",
        bash_command = "cd /opt/airflow/walmart && dbt test --select models/silver_b",
    )
    
    gold_ephemeral = BashOperator(
        task_id = "gold_ephemeral",
        bash_command = "cd /opt/airflow/walmart && dbt run --select models/gold/ephemeral",
    )
    
    gold_dimension = BashOperator(
        task_id = "gold_dimension",
        bash_command = "cd /opt/airflow/walmart && dbt run --select snapshots",
    )
    
    gold_fact = BashOperator(
        task_id = "gold_fact",
        bash_command = "cd /opt/airflow/walmart && dbt run --select models/gold/fact",
    )
    
    ingest_cdc() >> clean_target >> source_freshness >> silver_technical >> silver_technical_test >> silver_business >> silver_business_test >> gold_ephemeral >> gold_dimension >> gold_fact

orchestrate_dag = orchestrate()    
