##### Base Setup #####

# Apply python base image
FROM tiangolo/uwsgi-nginx-flask:python3.8 as python-base

# Conda dependencies
ENV PATH /opt/conda/bin:$PATH
RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 apt-transport-https apt-utils ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py38_4.9.2-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# Install extra libraries
RUN apt-get update -yqq \
    && ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    libssl-dev \
    libboost-all-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

##### App Environment Setup #####

# Set active directory
WORKDIR /app

# Install app environment dependencies
COPY conf/environment.yml /app/environment.yml
ENV PIP_CONFIG_FILE /app/pip.conf
RUN conda config --add channels conda-forge \
    && conda env create -n py-debian-conda-flask-template -f environment.yml \
    && rm -rf /opt/conda/pkgs/*

# Set environment path to execute within conda env
ENV PATH /opt/conda/envs/py-debian-conda-flask-template/bin:$PATH
RUN conda install --name py-debian-conda-flask-template -c conda-forge uwsgi==2.0.19.1

EXPOSE 5000

ENV UWSGI_INI=/app/uwsgi.ini

# Copy custom supervisord conf to run with non-root user
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add non-root user
RUN adduser --disabled-password --gecos '' appuser

# Change owner to non-root user
RUN chown appuser \
    /app \
    /etc/nginx/conf.d \
    /etc/nginx/nginx.conf \
    /etc/supervisor/conf.d/supervisord.conf \
    /etc/uwsgi/uwsgi.ini \
    /usr/bin/supervisord \
    /usr/local/bin/uwsgi \
    /usr/sbin/nginx \
    /var/cache/nginx \
    /var/log/supervisor \
    /var/run

# Copy configuration components then application code
COPY /conf/start.sh \
     /conf/test_runner.sh \
     /conf/nginx.conf \
     /conf/uwsgi.ini ./
COPY /app ./app

# Assign start shell script permission privilege to non-root user
RUN chmod +x /app/start.sh /app/test_runner.sh

# Set non-root user
USER appuser

# Set default command to start app shell
CMD ["/app/start.sh"]

###### Test-Builder Layer #####

# "testing" stage uses "python-base" stage and adds test dependencies to execute test script
FROM python-base as testing

# Set active directory and copy test dependencies
WORKDIR /app
COPY /tests ./tests

# Set default command to run tests
CMD ["/app/test_runner.sh"]
