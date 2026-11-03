# Desafio-Final-SCTEC-AnaliseDados-Python
Esse repositório é destinado à entrega do Projeto Avaliativo do Módulo 2 do curso de Análise de Dados com Python do SCTEC. O objetivo aqui é criar uma esteira analítica de ponta a ponta (End-to-End), transformando certas bases de dados em um ambiente analítico confiável, auditável e executivo.
# 📊 Painel Executivo de Auditoria de Compras (Controladoria)

## 🎯 Sobre o Projeto
Este projeto consiste num Dashboard de BI desenvolvido no Power BI para apoiar as ações de auditoria e conformidade da Controladoria. O objetivo é transformar a base de dados de contratações públicas numa ferramenta de tomada de decisão, permitindo auditar a economia gerada, a concentração de fornecedores, a morosidade dos ciclos processuais e o perfil de gasto governamental.

## 📈 Estrutura Analítica (Storytelling)
O painel foi desenhado com foco na clareza executiva, respondendo a 6 perguntas estratégicas de negócio divididas nas seguintes abas:
1. **Economia:** Quanto o governo economizou face ao valor estimado original?
2. **Fornecedores:** Existe risco de monopólio ou concentração orçamental no Top 10?
3. **Modalidades:** Qual o formato de contratação (ex: Pregão) que gera maior eficiência (deságio)?
4. **Ciclo:** Quais órgãos apresentam os maiores gargalos e morosidade no processo de compras?
5. **Regional:** Como se distribui a capilaridade de compradores e a eficiência por Estado?
6. **Perfil:** O orçamento é consumido predominantemente por Bens, Serviços ou Obras?

## 🛠️ Engenharia de Dados e DAX
O projeto conta com um modelo dimensional otimizado e **15 Medidas DAX** obrigatórias, desenhadas para garantir alta performance e cálculos dinâmicos. Entre as principais métricas, destacam-se:
- Cálculo de Economia Nominal e Percentual (`VAR`, `CALCULATE`, `DIVIDE`).
- Validação de Base Comparável (isolando itens que suportam análise de deságio).
- Identificação de Anomalias de Ciclo (`MAX`, `AVERAGE`).
- Índices de Concentração de Fornecedores.

## 🎨 UX/UI e Design de Interface
A construção visual seguiu rigorosamente os **Princípios CRAP** (Contraste, Repetição, Alinhamento e Proximidade) para evitar a poluição cognitiva:
- **Navegação UX:** Implementação de menu retrátil/interativo utilizando *Bookmarks* (Indicadores) e botões de ação para navegação fluida.
- **Detalhes Contextuais:** Uso de *Tooltip* (Dica de Ferramenta) personalizada, permitindo o aprofundamento da análise (drill-down) ao passar o rato sobre visuais estratégicos, sem necessidade de mudar de página.
- **Hierarquia Visual:** Leitura estruturada com KPIs (Cartões) no cabeçalho e gráficos de suporte no corpo, com cores de contraste aplicadas para destacar anomalias e riscos.

## 🚀 Como Executar
1. Faça o clone deste repositório.
2. Abra o ficheiro `.pbix` localizado na pasta `powerbi/` utilizando o Power BI Desktop.
3. Assistir o link do vídeo explicativo sobre o projeto e o que foi realizado: https://drive.google.com/file/d/1MgYqcOiY0a95u35J0MRK31xkTdPGD8GO/view?usp=sharing