#
#
# Build: docker build --rm --tag ds-test .
# Push: docker tag my_image $DOCKER_ID_USER/my_image
#
# git status
# git commit -m "comments Ubuntu and R to 3.4.2 "
# git push
#

FROM jupyter/datascience-notebook:latest
USER root
ENV DEBIAN_FRONTEND noninteractive
# Install.
#RUN \
#  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
#  apt-get update && \
#  apt-get -y upgrade && \
#  apt-get install -y build-essential  && \
# apt-get install -y software-properties-common && \
# apt-get install -y apt-utils && \
#  apt-get install -y byobu curl git htop man unzip vim wget && \
#  rm -rf /var/lib/apt/lists/*

# Let's do updates first and install some needed libraries and utilites
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get update -y  && apt-get dist-upgrade -y
RUN apt install build-essential libssl-dev libffi-dev python-dev  lib32ncurses5-dev -y
# gtar was used by pandoc so we need this
RUN ln -s /bin/tar /bin/gtar
RUN /usr/bin/apt-get install unzip
RUN apt-get update -y
RUN apt-get remove r-base-core -y && apt-get install r-base-core -y
RUN /usr/bin/wget https://github.com/jgm/pandoc/releases/download/2.1/pandoc-2.1-1-amd64.deb
RUN /usr/bin/dpkg -i pandoc-2.1-1-amd64.deb
RUN rm pandoc-2.1-1-amd64.deb
RUN Rscript -e 'devtools::install_cran(c("pbdZQM",repos = "http://cran.us.r-project.org"))'

#
# Upgrade R 3.4.2 now
#
#RUN pip uninstall ipykernel
#RUN pip install ipykernel
#RUN conda clean -tipsy
#RUN Rscript -e "install.packages('https://cran.r-project.org/src/contrib/pbdZMQ_0.3-2.tar.gz',repos=NULL)"
#gcc_linux-64 \
#        gfortran_linux-64 \
RUN conda install \
        r-essentials \
        r-htmlwidgets \
        r-gridExtra \
        r-e1071 \
        r-rgl \
        r-xlsxjars \
        r-xlsx \
        r-aer  \
        r-png \
        r-rJava \
        r-devtools \
        r-digest \
        r-evaluate \
        r-memoise  \
        r-withr  \
        r-irdisplay \
        r-r6  \
        r-irkernel \
        r-jsonlite\
        r-lubridate\
        r-magrittr\
        r-rcpp \
        r-repr \
        r-stringi\
        r-stringr\
        r-processx\
        r-tidyverse\
        r-readr  \
        ipython \
        numpy \
        pandas \
    	plotnine \
    	matplotlib \
    	seaborn \
    	phantomjs  \
    	statsmodels \
    	statsmodels \
    	python-utils


RUN Rscript -e 'install.packages(c("r-igraph","wordcould","DRR", "webshot","mclust","pracma","ggdendro","reshape","prettyunits","progress","GGally","multiwayvcov","wordcloud2","openxlsx","rio","survey","coda","mvtnorm","sfsmisc","polucor","CDM","TAM","mitools","mice","GPArotation","permute","vegan","pbivnorm","numDeriv","Archive","lavaan","lavaan.survey","sirt","miceadds","RcppRoll","DEoptimR","robustbase","gower","kernlab","CVST","DRR","SQUAREM","lava","prodlim","ddalpha","dimRed","ipred","recipes","withr","caret","neuralnet","irlba","kknn","gtools","gdata","caTools","gplots","ROCR","MLmetrics","dummies","slam","NLP","tm","clipr"),repos = "https://cloud.r-project.org",dependencies = TRUE)'

# NB extensions is not working when running it in jupyterhub kubernetes so adding this next line
RUN conda install -c conda-forge jupyter_contrib_nbextensions
RUN jupyter nbextension install --py widgetsnbextension --sys-prefix
RUN jupyter nbextension enable  --py widgetsnbextension --sys-prefix

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean \
    apt autoremove


RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JAVA_LD_LIBRARY_PATH
RUN R CMD javareconf
RUN Rscript -e 'install.packages(c("RWekajars","rpart.plot","gbm","zip","R.methodsS3","R.oo","R.utils","officer","praise","testthat","mockery","githubinstall","ggplot2"),repos = "https://cloud.r-project.org",dependencies = TRUE)'

#
# This should allow users to turn off extension if they do not want them.
#
USER jovyan
RUN jupyter nbextensions_configurator enable
