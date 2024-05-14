FROM osrf/ros:humble-desktop-full as base

ENV  ROS_DISTRO="humble"
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get -y install \
    wget \
    build-essential \
    cmake \
    vim \
    ros-humble-navigation2 \
    ros-humble-slam-toolbox \
    ros-humble-depthai-ros \
    ros-humble-nav2-bringup \
    ros-humble-teleop-twist-joy\
    ros-humble-robot-state-publisher \
    ros-humble-joint-state-publisher \
    ros-humble-joy \
    ros-humble-rviz2 \
    ros-humble-ros-gz \
    doxygen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# RUN wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && pip3 install set
# RUN apt-get update && apt-get install -y udev
# RUN apt-get update && apt-get install -y doxygen

RUN echo "source /opt/ros/humble/setup.bash"
RUN echo "xhost -local:host" >> /root/.bashrc

RUN git clone https://github.com/reedhedges/AriaCoda
RUN cd AriaCoda \
    && make \
    && make install

COPY ./ ./workspaces 
WORKDIR /workspaces/ros_workspace

# Install required packages
RUN apt-get update && \
    apt-get install -y \
        x11-utils \
        xauth \
        mesa-utils \
        libgl1-mesa-glx \
        libxcb-xinerama0 \
        # ament-cmake \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*



RUN /bin/bash -c "source /opt/ros/humble/setup.bash"

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "bash" ]
