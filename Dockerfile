FROM node

# Install dependencies
RUN apt-get update && \
    apt-get install -y xvfb iceweasel fonts-takao fonts-wqy-zenhei
  
ENV NPM_CONFIG_LOGLEVEL error

#Install manet with modules
RUN npm install -g slimerjs phantomjs manet@0.4.16
	
# Clean up
WORKDIR /
RUN apt-get remove -y curl automake build-essential \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /usr/share/doc-base /usr/share/man /usr/share/locale /usr/share/zoneinfo \
    && rm -rf /var/lib/cache /var/lib/log \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && npm cache clear
	
# Copy startup file, expose port 8891 and define entrypoint
COPY bin/startup.sh /usr/local/bin/startup.sh

EXPOSE 8891

ENTRYPOINT ["startup.sh", "--host=0.0.0.0 "]
CMD ["--engine=slimerjs"]
