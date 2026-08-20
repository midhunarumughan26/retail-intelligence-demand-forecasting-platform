import pandas as pd
from pathlib import Path
from sqlalchemy import create_engine, text


# --------------------------------
# PROJECT CONFIGURATION
# --------------------------------

PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = PROJECT_ROOT / "retail_analytics_raw"

# --------------------------------
# DATABASE CONFIGURATION
# --------------------------------

DB_USER = "airflow"
DB_PASSWORD = "airflow"
DB_HOST = "postgres"
DB_PORT = "5432"
DB_NAME = "airflow"

engine = create_engine(
    f"postgresql+psycopg2://{"airflow"}:{"airflow"}@{"postgres"}:{"5432"}/{"airflow"}"
)



# --------------------------------
# SOURCE FILES
# --------------------------------

files = [
    "brands.csv",
    "categories.csv",
    "suppliers.csv",
    "customers.csv",
    "stores.csv",
    "products.csv",
    "orders.csv",
    "order_items.csv",
    "inventory.csv"
]

print("Starting PostgreSQL ETL...\n")

# --------------------------------
# CREATE RAW SCHEMA
# --------------------------------

with engine.begin() as connection:
    connection.execute(
        text("CREATE SCHEMA IF NOT EXISTS raw")
    )

# --------------------------------
# LOAD CSV → POSTGRESQL
# --------------------------------

for file in files:

    file_path = DATA_DIR / file

    df = pd.read_csv(file_path)

    # Clean column names
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
    )

    # Remove duplicates
    df = df.drop_duplicates()

    table_name = file.replace(".csv", "")

    df.to_sql(
        table_name,
        engine,
        schema="raw",
        if_exists="replace",
        index=False
    )

    print(
        f"✓ Loaded raw.{table_name:<15} "
        f"{len(df):>6} rows"
    )

print("\nPostgreSQL ETL completed successfully.")