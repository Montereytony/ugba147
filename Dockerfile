#
# These are just reminders/examples:
#
# Build: docker build --rm --tag ds-test .
# Push: docker tag my_image $DOCKER_ID_USER/my_image
# git status
# git commit -m "comments Ubuntu and R to 3.4.2 "
# git push
#

FROM jupyter/datascience-notebook:latest
USER root
RUN ln -s /bin/tar /bin/gtar   && apt-get -y update && apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils \
    software-properties-common byobu curl git htop man unzip vim wget libcairo2-dev libxt-dev  \
    libjpeg-dev libpango1.0-dev libgif-dev build-essential g++ pandoc automake pkg-config \
    libtool software-properties-common gsl-bin libgsl-dev  &&\
    add-apt-repository ppa:webupd8team/java -y && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    wget https://github.com/jgm/pandoc/releases/download/2.1/pandoc-2.1-1-amd64.deb && \
    /usr/bin/dpkg -i pandoc-2.1-1-amd64.deb && \
    rm pandoc-2.1-1-amd64.deb && \
    apt-get clean  && \
    apt -y autoremove

RUN Rscript -e 'install.packages(c("https://cran.r-project.org/src/contrib/ggplot2_2.2.1.tar.gz"),dependencies = TRUE)'
RUN Rscript -e 'install.packages(c("https://cran.r-project.org/src/contrib/Cairo_1.5-9.tar.gz"),dependencies = TRUE)'
RUN Rscript -e 'install.packages(c("https://cran.r-project.org/src/contrib/gdtools_0.1.7.tar.gz"),dependencies = TRUE)'

RUN conda install \
        gcc_linux-64 \
        gfortran_linux-64 \
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
    	python-utils \
        proj4

RUN Rscript -e 'install.packages(c("https://cran.r-project.org/src/contrib/Archive/truncnorm/truncnorm_1.0.0.tar.gz"),dependencies = TRUE)'
RUN Rscript -e 'install.packages(c("https://cran.r-project.org/src/contrib/Rsolnp_1.16.tar.gz"),dependencies = TRUE)'
RUN Rscript -e 'install.packages(c("Rsolnp"),repos = "https://cloud.r-project.org",dependencies = TRUE)'
RUN Rscript -e 'install.packages(c("Rsolnp","LSAmitR", "Rgraphviz", "graph", "rsample", "proxy", "slam", "Rcampdf", "tm.lexicon.GeneralInquirer", "VGAM", "impute", "truncnorm","truncnorm","checkmate", "latticeExtra", "acepack", "htmlTable", "viridis", "brew", "desc", "commonmark", "Hmisc", "roxygen2", "DT", "mockery", "praise", "rex", "fontBitstreamVera", "fontLiberation", "testthat", "covr", "fontquiver", "svglite", "pbdZQM","r-igraph","wordcould","DRR", "webshot","mclust","pracma","ggdendro","reshape","prettyunits","progress","GGally","multiwayvcov","wordcloud2","openxlsx","rio","survey","coda","mvtnorm","sfsmisc","polucor","CDM","TAM","mitools","mice","GPArotation","permute","vegan","pbivnorm","numDeriv","Archive","lavaan","lavaan.survey","sirt","miceadds","RcppRoll","DEoptimR","robustbase","gower","kernlab","CVST","DRR","SQUAREM","lava","prodlim","ddalpha","dimRed","ipred","recipes","withr","caret","neuralnet","irlba","kknn","gtools","gdata","caTools","gplots","ROCR","MLmetrics","dummies","slam","NLP","tm","clipr","ggalt","truncnorm"),repos = "https://cloud.r-project.org",dependencies = TRUE)'

# NB extensions is not working when running it in jupyterhub kubernetes so adding this next line
RUN conda install -c conda-forge jupyter_contrib_nbextensions
RUN jupyter nbextension install --py widgetsnbextension --sys-prefix
RUN jupyter nbextension enable  --py widgetsnbextension --sys-prefix
RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JAVA_LD_LIBRARY_PATH
RUN R CMD javareconf
RUN Rscript -e 'install.packages(c("RWekajars","rpart.plot","zip","gbm","R.methodsS3","R.oo","R.utils","officer","praise","testthat","mockery","githubinstall"),repos = "https://cloud.r-project.org",dependencies = TRUE)'
##RUN Rscript -e 'install.packages(c("ggalt"),repos = "https://cloud.r-project.org",dependencies = TRUE)'
#RUN Rscript -e 'install.packages(c("https://cran.r-project.org/src/contrib/ggplot2_2.2.1.tar.gz"),dependencies = TRUE)'

#
# This should allow users to turn off extension if they do not want them.
#
USER jovyan
RUN jupyter nbextensions_configurator enable
