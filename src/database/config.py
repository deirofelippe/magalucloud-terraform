from sqlalchemy import (
    create_engine,
    URL,
    Table,
    MetaData,
    Column,
    CHAR,
    String,
    Numeric,
    DateTime,
)
import os
from dotenv import load_dotenv
from pathlib import Path

dotenv_path = Path("./.env")
load_dotenv(dotenv_path=dotenv_path)

url_object = URL.create(
    database=os.getenv("DB_DATABASE"),
    username=os.getenv("DB_USERNAME"),
    password=os.getenv("DB_PASSWORD"),
    host=os.getenv("DB_HOST"),
    port=5432,
    drivername="postgresql+psycopg2",
)
engine = create_engine(url_object)

metadata_obj = MetaData()
lancamentos_table = Table(
    "lancamentos",
    metadata_obj,
    Column("id", CHAR(36), primary_key=True),
    Column("classificacao", String(150)),
    Column("valor", Numeric(scale=2, precision=5)),
    Column("data_pagamento", DateTime(timezone=True)),
    Column("descricao", String(255)),
    Column("status", String(50)),
)

metadata_obj.create_all(engine)
