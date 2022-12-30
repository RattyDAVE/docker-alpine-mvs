FROM alpine:edge

RUN apk add bzip2 libnsl zlib binutils alpine-sdk && \
	mkdir ~/build && \
	cd ~/build && \
	wget http://downloads.hercules-390.eu/hercules-3.13.tar.gz && \
	tar -xvf hercules-3.13.tar.gz && \
	cd hercules-3.13 && \
	./configure --prefix=/usr --enable-optimization=-O3 && \
	make -j $(nproc) && \
	make install && \
	rm -rf ~/build && \
	apk del alpine-sdk 

RUN cd /opt && \
      mkdir hercules && \
      cd hercules && \
      mkdir tk4 && \
      cd tk4 && \
      wget --no-check-certificate https://wotho.ethz.ch/tk4-/tk4-_v1.00_current.zip && \
      unzip tk4-_v1.00_current.zip && \
      rm  tk4-_v1.00_current.zip

EXPOSE      3270 8038

ENV HERCULES_RC scripts/tk4-.rc
ENV TK4CONS extcons

WORKDIR     /opt/hercules/tk4/

CMD hercules -f conf/tk4-.cnf
