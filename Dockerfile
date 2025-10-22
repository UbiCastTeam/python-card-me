FROM debian:bookworm

RUN apt update
RUN apt install -y python3-venv make

RUN python3 -m venv /opt/venv
ENV VIRTUAL_ENV="/opt/venv"
ENV PATH="/opt/venv/bin:/usr/sbin:/usr/bin:/sbin:/bin"
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

WORKDIR /opt/src

COPY pyproject.toml pyproject.toml
COPY card_me card_me
RUN pip install --no-cache-dir --editable '.[dev]'
