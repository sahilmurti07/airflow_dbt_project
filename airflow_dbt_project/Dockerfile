FROM apache/airflow:2.7.0-python3.10

USER root

RUN rm -f /etc/apt/sources.list.d/pgdg.list \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends gcc \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

USER airflow

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt
