
# base image
FROM ubuntu:14.04.1


# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Remain current
RUN apt-get update && apt-get dist-upgrade -y

# Basic dependencies
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  apt-utils \
  automake \
  ant \
  bash \
  binutils \
  perl \
  bioperl \
  build-essential \
  bzip2 \
  c++11 \
  cdbs \
  cmake \
  cron \
  curl \
  dkms \
  dpkg-dev \
  g++ \
  gpp \
  gcc \
  gfortran \
  git \
  git-core \
  libblas-dev \
  libatlas-dev \
  libbz2-dev \
  liblzma-dev \
  libpcre3-dev \
  libreadline-dev \
  make \
  mercurial \
  php5-curl \
  python python-dev python-yaml ncurses-dev zlib1g-dev python-numpy python-pip \
  sudo \
  subversion \
  tabix \
  tree \
  unzip \
  vim \
  wget \
  python-software-properties \
  libc-bin \
  llvm \
  libconfig-dev \
  yum \
  libX11-dev libXpm-dev libXft-dev libXext-dev \
  asciidoc

#---------------------------------JAVA-------------------------------------------------------------------------------------#  
# upgrade java
RUN  apt-get install -y software-properties-common 
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer


ENV JAVA_HOME /usr/lib/jvm/java-8-oracle


#-------------------------------Add user----------------------------------------------------------------------------------#
# Create a pipeline user:pipeman and group:ngsgroup

RUN useradd -m -s /bin/bash pipeman && \
  cd /home/pipeman && \
  echo "#bash config file for user pipeman" >> /home/pipeman/.bashrc

RUN groupadd ngsgroup && \
  usermod -aG ngsgroup pipeman && \
  usermod -aG sudo pipeman

#-----------------------------NGS TOOLS DIRECTORY------------------------------------------------------------------------#  
#make pipeline install dirs
RUN mkdir /usr/local/pipeline && \
  chown pipeman:ngsgroup /usr/local/pipeline && \
  chmod 775 /usr/local/pipeline
  
#-------------------------------PERMISSIONS--------------------------
RUN chmod -R 777 /usr/local/pipeline 
RUN chown -R pipeman:ngsgroup /usr/local/pipeline

#---------------------------------------------------------------------
#------------------------------Add exe----------------------------------
ADD bwa /exe
ADD picard.jar /exe


#Cleanup the temp dir
RUN rm -rvf /tmp/*

#open ports private only
EXPOSE 8080

# Use baseimage-docker's bash.
CMD ["/bin/bash"]

#Clean up APT when done.
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

