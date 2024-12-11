FROM jupyter/datascience-notebook:x86_64-python-3.11

ARG HOST_UID=1000
ARG HOST_GID=1000
ARG HOST_USER='user'
ARG HOST_GROUP='user'
ARG TZ='Etc/UTC'

ENV TZ $TZ
ENV DEBIAN_FRONTEND noninteractive

USER root
ENV NB_USER="${HOST_USER}" \
    NB_UID="${HOST_UID}" \
    NB_GID="${HOST_GID}" \
    HOME="/home/${HOST_USER}"
RUN sed -i "s/jovyan/${HOST_USER}/g" /usr/local/bin/fix-permissions

RUN apt-get update && apt-get install -y zsh sudo pipx vim tzdata software-properties-common && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    if [ "${NB_UID}" = "1000" ]; then \
    echo "Modifying existing user..." && \
    # Get current jovyan group name (if exists)
    current_group=$(id -gn jovyan 2>/dev/null || echo "users") && \
    # Create new group if needed
    groupadd -f -g "${NB_GID}" "${HOST_GROUP}" && \
    # Modify user
    usermod -l "${HOST_USER}" jovyan && \
    usermod -d "/home/${HOST_USER}" -g "${HOST_GROUP}" "${HOST_USER}" && \
    mv /home/jovyan "/home/${HOST_USER}" 2>/dev/null || true; \
    else \
    echo "Creating new user..." && \
    groupadd -f -g "${NB_GID}" "${HOST_GROUP}" && \
    useradd -m -s /bin/bash -u "${NB_UID}" -g "${NB_GID}" "${HOST_USER}"; \
    fi && \
    # Common setup
    chsh -s /bin/zsh "${HOST_USER}" && \
    echo "${HOST_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    # Fix permissions
    fix-permissions "/home/${HOST_USER}" && \
    echo $TZ > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime

WORKDIR /home/${HOST_USER}/app

USER ${HOST_USER}

ENV PATH="$PATH:/home/${HOST_USER}/.local/bin" \
    PATH="$PATH:/home/${HOST_USER}/.venv/bin" \
    PATH="$PATH:/home/${HOST_USER}/.local/pipx/venvs/poetry/bin"

RUN pipx ensurepath && \
    pipx install poetry && \
    poetry config virtualenvs.in-project false && \
    poetry config virtualenvs.create true && \
    poetry config cache-dir /tmp/poetry_cache


COPY --chown=${HOST_USER}:${HOST_GROUP} pyproject.toml poetry.lock .

RUN poetry install --no-root
