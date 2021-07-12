FROM python:3.9

LABEL br.com.github.vit0r.image.title="airflowdocker" \
    br.com.github.vit0r.image.authors="vit0r" \
    br.com.github.vit0r.image.vendor="vit0r" \
    br.com.github.vit0r.image.url="https://github.com/vit0r/airflowdocker" \
    br.com.github.vit0r.image.description="Image for apache-airflow" \
    br.com.github.vit0r.image.licenses="MIT"

ENV PYTHONWARNINGS=ignore
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8
ENV SLUGIFY_USES_TEXT_UNIDECODE=yes
ENV AIRFLOW_GPL_UNIDECODE=yes
ENV AIRFLOW_HOME=/usr/local/airflow
ENV PSYCOPG_DEBUG=1
ENV AIRFLOW_VERSION=2.1.1

RUN useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow

RUN chown -R airflow ${AIRFLOW_HOME}

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
    freetds-bin \
    libffi6 \
    libsasl2-2 \
    libsasl2-modules \
    libssl1.1 \
    locales  \
    lsb-release \
    sasl2-bin \
    sqlite3 \
    unixodbc \
    openssl \
    postgresql-client \
    postgresql-client-common

WORKDIR ${AIRFLOW_HOME}

ADD ./webserver ./webserver

RUN chown airflow: ./webserver/*.pem

RUN chmod 400 ./webserver/*.pem

RUN ls -la ./webserver/

ADD ./celery ./celery

RUN chown airflow: ./celery/*.pem

RUN chmod 400 ./celery/*.pem

USER airflow

RUN pip install --no-cache pip setuptools wheel pytz pyOpenSSL ndg-httpsclient pyasn1 psycopg2-binary==2.8.6 gspread-dataframe gspread-formatting oauth2client click azure-identity azure-keyvault-secrets --user --no-warn-script-location

ARG AIRFLOW_EXTRAS="facebook,telegram,sendgrid,zendesk,jira,sftp,imap,sqlite,async,celery,docker,dask,grpc,http,google,google_auth,rabbitmq,postgres,mysql,ssh,microsoft.azure,jdbc,crypto,virtualenv,cncf.kubernetes"

RUN pip install --no-cache apache-airflow[${AIRFLOW_EXTRAS}]==${AIRFLOW_VERSION} --user --no-warn-script-location

ENV PATH=${PATH}:${AIRFLOW_HOME}/.local/bin:${AIRFLOW_HOME}/.local/lib/python3.9/site-packages

ENTRYPOINT ["airflow"]
