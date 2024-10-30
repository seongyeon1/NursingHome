import bs4
from langchain import hub
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import WebBaseLoader
from langchain_community.vectorstores import Chroma, FAISS
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough


import os
from tqdm import tqdm

# API 키를 환경변수로 관리하기 위한 설정 파일
from dotenv import load_dotenv

# API 키 정보 로드
load_dotenv()

from glob import glob

from langchain_upstage import ChatUpstage, UpstageEmbeddings
from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate, ChatPromptTemplate, MessagesPlaceholder

patient_id = '남A'
persist_directory = f'.cache/db/{patient_id}'

import pandas as pd

qa = pd.read_csv('qa_all.csv')
questions = qa['question'].unique()

ans = []

def rag_model(patient_id, prompt, temperature):
    llm = ChatUpstage(temperature=temperature, api_key=os.getenv("UPSTAGE_API_KEY"))

    embeddings = UpstageEmbeddings(
    api_key=os.getenv("UPSTAGE_API_KEY"),
    model="solar-embedding-1-large"
    )

    vectordb = Chroma(
        persist_directory=f'.cache/db/{patient_id}',
        embedding_function=embeddings
    )

    retriever = vectordb.as_retriever()

    rag_prompt = ChatPromptTemplate.from_template(prompt)

    def format_docs(docs):
        return "\n\n".join(doc.page_content for doc in docs)

    # Define the RAG chain
    return (
        {
            "context": retriever | format_docs,
            "question": RunnablePassthrough(),
        }
        | rag_prompt
        | llm
        | StrOutputParser()
    )

from TEMPLATES.rag_template import *
# prompt_n1, prompt_n2, prompt 3개중에 하나 고를 수 있도록 parser

patient_id = '남A'

test = {}
test['questions'] = questions
temps = [0, 0.2, 0.4, 0.7]

for temp in temps:
    qa_chain = rag_model(patient_id, prompt_n1, temp)
    ans = []
    for q in questions:
        a = qa_chain.invoke(q)
        ans.append(a)

    test[f'ans_{str(temp)}'] = ans

result = pd.DataFrame(test)
result.to_csv(f'{patient_id}_{prompt}_kind.csv', index=False)