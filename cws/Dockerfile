FROM node:8-alpine
MAINTAINER STARTX "dev@startx.fr"

ENV  NODE_ENV=development \
     APP_PATH=/usr/src/app \
     CONF_PATH=/conf \
     DATA_PATH=/data
RUN  mkdir -p $APP_PATH \
 &&  mkdir -p $CONF_PATH 
COPY ./core $APP_PATH/core
COPY ./static $APP_PATH/static
COPY ./test $APP_PATH/test
COPY ./*.j* $APP_PATH/
COPY ./sxapi.json $CONF_PATH/sxapi.json
COPY run.sh /bin/sxapi

RUN  cd $APP_PATH \
 &&  mkdir /usr/bin && touch /usr/bin/git \
 &&  ls /usr/bin/gi* \
 &&  npm install \
 &&  npm dedupe \
 &&  npm cache verify \
 &&  npm cache clean --force \
 &&  mkdir -p $CONF_PATH \
 &&  mkdir -p $DATA_PATH \
 &&  chmod ugo+x /bin/sxapi \
 &&  chown -R node:node $APP_PATH /bin/sxapi $CONF_PATH $DATA_PATH

USER node:node
EXPOSE 8081
WORKDIR $APP_PATH
CMD [ "/bin/sxapi" , "start" ]
