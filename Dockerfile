FROM jupyter/datascience-notebook

ARG HOST_UID
ARG HOST_GID
ARG TZ

ENV TZ $TZ

USER root
RUN apt update 
RUN ALREADY_GROUP="$(id -g $NB_USER -n)" ; ALREADY_HOST_GID="$(id -g $NB_USER)" ; if [ -n "$ALREADY_GROUP" ]; then \
    groupmod -g $HOST_GID $ALREADY_GROUP; \
    fi && \ 
    ALREADY_USER="$(id -u $NB_USER -n)" ; ALREADY_HOST_UID="$(id -u $NB_USER)" ; if [-n "$ALREADY_USER" ]; then \
    usermod -g $HOST_GID -u $HOST_UID -l $ALREADY_USER; \
    fi && \
    chown -R $HOST_UID:$HOST_GID /home/$ALREADY_USER

USER $NB_USER

WORKDIR "/home/$NB_USER/app"

ENV PYTHONPATH "/home/$NB_USER/app"
ENV GRANT_SUDO=yes
