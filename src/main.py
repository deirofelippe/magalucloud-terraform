from flask import Flask, request
import uuid
from sqlalchemy import text
from database import config

app = Flask(__name__)


engine = config.engine
lancamentos_table = config.lancamentos_table


def to_json(lancamento) -> dict:
    return {
        "id": lancamento[0],
        "classificacao": lancamento[1],
        "valor": lancamento[2],
        "data_pagamento": lancamento[3],
        "descricao": lancamento[4],
        "status": lancamento[5],
    }


@app.route("/healthz", methods=["GET"])
def healthz():
    with engine.connect() as conn:
        result = conn.execute(text("SELECT id FROM lancamentos LIMIT 1"))
        one = result.all()
    return {"message": "healthy"}


@app.route("/lancamentos", methods=["POST"])
def create_lancamento():
    lancamento = request.get_json()

    with engine.connect() as conn:
        insert = lancamentos_table.insert().values(
            id=uuid.uuid4(),
            classificacao=lancamento["classificacao"],
            valor=lancamento["valor"],
            data_pagamento=lancamento["data_pagamento"],
            descricao=lancamento["descricao"],
            status=lancamento["status"],
        )
        conn.execute(insert)
        conn.commit()
    return {}, 201


@app.route("/lancamentos", methods=["GET"])
def find_all_lancamentos():
    with engine.connect() as conn:
        result = conn.execute(text("SELECT * FROM lancamentos"))
        lancamentos = result.all()

    json = list(map(to_json, lancamentos))

    return json, 200


@app.route("/lancamentos/<id>", methods=["GET"])
def find_lancamento_by_id(id):
    with engine.connect() as conn:
        result = conn.execute(
            text("SELECT * FROM lancamentos WHERE id = :id"), {"id": id}
        )
        lancamentos = result.all()

    if len(lancamentos) <= 0:
        return {}, 404

    json = list(map(to_json, lancamentos))[0]

    return json, 200


@app.route("/lancamentos/<id>", methods=["DELETE"])
def delete_lancamento(id):
    with engine.connect() as conn:
        conn.execute(text("DELETE FROM lancamentos WHERE id = :id"), {"id": id})
        conn.commit()

    return {}, 204


@app.route("/lancamentos/<id>", methods=["PUT"])
def update_lancamento(id):
    lancamento = request.get_json()
    dict_update = {
        "id": id,
        "classificacao": lancamento["classificacao"],
        "valor": lancamento["valor"],
        "data_pagamento": lancamento["data_pagamento"],
        "descricao": lancamento["descricao"],
        "status": lancamento["status"],
    }

    with engine.connect() as conn:
        result = conn.execute(
            text("SELECT valor FROM lancamentos WHERE id = :id"), {"id": id}
        )
        lancamento = result.all()

        if len(lancamento) <= 0:
            return {}, 404

        query = """
            UPDATE lancamentos 
            SET classificacao = :classificacao, valor = :valor, 
                data_pagamento = :data_pagamento, descricao = :descricao, 
                status = :status
            WHERE id = :id
        """

        conn.execute(text(query), dict_update)
        conn.commit()

    return {}, 200
