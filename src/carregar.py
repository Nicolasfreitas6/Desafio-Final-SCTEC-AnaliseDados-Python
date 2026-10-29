import pandas as pd
from src import banco, config

def ler(nome, **opcoes):
    return pd.read_csv(config.PASTA_PROCESSED / f"{nome}.csv", keep_default_na=False, na_values=[""], **opcoes)

def tuplas(tabela, colunas):
    dados = tabela[colunas].astype(object)
    dados = dados.where(dados.notna(), None)
    return [tuple(linha) for linha in dados.itertuples(index=False, name=None)]

def inserir(con, tabela, colunas, dados):
    """Monta o INSERT INTO ... VALUES (%s, %s, ...) e envia todas as linhas de uma vez."""
    marcadores = ", ".join(["%s"] * len(colunas))
    sql = f"INSERT INTO {tabela} ({', '.join(colunas)}) VALUES ({marcadores})"
    banco.inserir_em_lote(con, sql, tuplas(dados, colunas))
    print(f"   {tabela}: {len(dados)} linhas")

def main():
    # 1) Banco (o recriar_banco apaga e cria de novo) e tabelas
    banco.recriar_banco()
    con = banco.conectar()
    banco.executar_script(con, config.PASTA_SQL / "01_criar_banco.sql")

    # 2) Dimensoes PRIMEIRO: a fato tem chave estrangeira para elas, entao elas precisam existir antes.
    print("Carga:")
    for nome, colunas in [("dim_orgao", ["sk_orgao", "cnpj_orgao", "nome_orgao", "poder"]),
                          ("dim_fornecedor", ["sk_fornecedor", "ni_fornecedor", "nome_fornecedor", "tipo_pessoa", "porte"]),
                          ("dim_modalidade", ["sk_modalidade", "modalidade_id", "nome_modalidade"]),
                          ("dim_localidade", ["sk_localidade", "uf_sigla", "uf_nome", "regiao"])]:
        # dtype=str: o CNPJ nao pode perder o zero da esquerda ao ser lido
        inserir(con, nome, colunas, ler(nome, dtype=str))

    # 3) Fato (depois das dimensoes)
    fato = ler("fato_item_contratado")
    fato["dias_ciclo"] = fato["dias_ciclo"].astype("Int64")
    colunas = ["numero_controle_pncp", "numero_item", "sk_orgao", "sk_fornecedor", "sk_modalidade", "sk_localidade",
               "data_publicacao", "data_homologacao", "descricao_item", "perfil_gasto", "quantidade",
               "valor_unitario_estimado", "valor_total_estimado", "valor_unitario_homologado", "valor_total_homologado",
               "comparavel", "economia_valor", "dias_ciclo"]
    inserir(con, "fato_item_contratado", colunas, fato)

    # 4) Conferencia: o que esta no banco tem que bater com a prova real (anexo 8 do enunciado)
    print("Conferencia:")
    for tabela, esperado in [("fato_item_contratado", 6126), ("dim_orgao", 363), ("dim_fornecedor", 2652),
                             ("dim_modalidade", 7), ("dim_localidade", 27)]:
        n = banco.consultar(con, f"SELECT COUNT(*) FROM {tabela}")[0][0]
        print(f"   {tabela}: {n} (esperado {esperado}) -> {'OK' if n == esperado else 'DIVERGENTE'}")
    con.close()

if __name__ == "__main__":
    main()
