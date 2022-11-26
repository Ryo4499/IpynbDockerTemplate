FROM jupyter/datascience-notebook

ARG UID
ARG GID
ARG TZ

USER root
RUN apt update 
RUN ALREADY_GROUP="$(id -g $NB_USER -n)" ; ALREADY_GID="$(id -g $NB_USER)" ; if [ -n "$ALREADY_GROUP" ]; then \
 groupmod -g $GID $ALREADY_GROUP; \
 fi && \ 
 ALREADY_USER="$(id -u $NB_USER -n)" ; ALREADY_UID="$(id -u $NB_USER)" ; if [-n "$ALREADY_USER" ]; then \
 usermod -g $GID -u $UID -l $ALREADY_USER; \
 fi && chown -R $UID:$GID /home/$ALREADY_USER

USER $NB_USER
WORKDIR "/home/$NB_USER/app"
RUN unset UID GID
ENV TZ $TZ
ENV PYTHONPATH "/home/$NB_USER/app"
ENV GRANT_SUDO=yes
