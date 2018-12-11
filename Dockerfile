FROM roslab/roslab:kinetic-nvidia

USER root

RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    ros-kinetic-velodyne \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${HOME}/catkin_ws/src/loam-velodyne
COPY . ${HOME}/catkin_ws/src/loam-velodyne/.
RUN cd ${HOME}/catkin_ws \
 && mv src/loam-velodyne/README.ipynb .. \
 && apt-get update \
 && /bin/bash -c "source /opt/ros/kinetic/setup.bash && rosdep update && rosdep install --as-root apt:false --from-paths src --ignore-src -r -y" \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && /bin/bash -c "source /opt/ros/kinetic/setup.bash && catkin_make"

RUN echo "source ~/catkin_ws/devel/setup.bash" >> ${HOME}/.bashrc

RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}
WORKDIR ${HOME}
